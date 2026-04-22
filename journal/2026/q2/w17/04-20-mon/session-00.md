# you asked

In symbolic execution, what’s the relationship between an execution state and an execution path?

---

# gemini response

**[2026-04-20 22:21:22 PDT] Generated using Gemini 3.1 Pro.**

In symbolic execution, an execution path and an execution state are tightly linked concepts that together represent the "journey" and the "memory" of a program being mathematically evaluated. 

Here is how the two concepts relate and interact:

### 1. The Execution State (The Snapshot)
An execution state represents the exact condition of a program at a specific point in time. Unlike concrete execution (where a variable has a fixed value like `x = 5`), a symbolic state maps variables to mathematical symbols and tracks constraints. A typical symbolic state consists of three main components:
* **Program Counter:** Indicates the next instruction the engine will evaluate.
* **Symbolic Store/Memory:** A mapping of the program's variables to their current symbolic expressions (e.g., `x` maps to symbol `α`, `y` maps to `α * 2`).
* **Path Condition (PC):** A cumulative mathematical formula (usually a boolean expression) containing all the constraints that must be true for the program to reach this exact moment in the code.

### 2. The Execution Path (The Journey)
An execution path is the precise sequence of instructions and branch decisions the symbolic execution engine followed from the program's entry point to reach a specific execution state. 

### 3. The Relationship: Paths Construct States
The relationship between paths and states is cause-and-effect, fundamentally organized as a tree structure.

* **Paths dictate the Path Condition:** As the engine navigates down an execution path, it encounters conditional branches (like an `if(x > 10)` statement). If `x` is symbolic, the path splits. The engine creates a new execution state for the "true" path (adding `α > 10` to the Path Condition) and a new state for the "false" path (adding `α <= 10` to the Path Condition). The path taken directly builds the math inside the state.
* **States validate the Path:** A path is only meaningful if it can actually occur. The execution state's Path Condition is sent to an SMT solver (like Z3). If the solver can find inputs that satisfy the state's formula, the execution path is deemed "feasible." If the solver proves the formula is a logical impossibility, the path is "infeasible," and the engine stops exploring that route.
* **Forming the Execution Tree:** Together, paths and states form a Symbolic Execution Tree. The execution paths act as the edges (the directional lines between points), and the execution states act as the nodes. 



In summary, the **execution path** is the sequential route taken through the control-flow graph, and the **execution state** is the mathematical payload that records everything necessary to survive that route.

---

# you asked

As data structures, how would you express them?

---

# gemini response

**[2026-04-20 22:22:47 PDT] Generated using Gemini 3.1 Pro.**

To express these concepts as data structures, we can look at them through the lens of strongly-typed pseudo-code (using Python-style dataclasses for readability). 

At their core, you need base types to represent the symbolic math (the AST of the mathematical formulas you are building) and the program's instructions.

### The Data Structures

```python
from dataclasses import dataclass
from typing import Dict, List, Optional

# --- Base Abstractions ---
class Instruction: 
    """Represents a node in the CFG or a line of code."""
    pass

class SymExpr: 
    """Base class for an AST node representing a symbolic expression (e.g., α * 2)."""
    pass

class SymBool(SymExpr): 
    """A boolean symbolic expression used for constraints (e.g., α > 10)."""
    pass


# --- The Execution State ---
@dataclass
class ExecutionState:
    """The 'Snapshot': The exact mathematical condition of the program."""
    
    # 1. Where are we in the program?
    program_counter: Instruction
    
    # 2. What is the current state of variables? 
    # Maps variable identifiers to their current symbolic expressions.
    memory: Dict[str, SymExpr] 
    
    # 3. What must be true to be here?
    # A list of boolean constraints. The actual path condition is the 
    # logical conjunction (AND) of all elements in this list.
    path_condition: List[SymBool] 


# --- The Execution Path ---
@dataclass
class ExecutionPath:
    """The 'Journey': The route taken to reach a specific state."""
    
    # The chronological sequence of states from the entry point to the current state.
    state_history: List[ExecutionState]
    
    # (Optional but common) The sequence of binary choices made at branch instructions.
    # e.g., [True, False, True] means took the 'if', then the 'else', then the 'if'.
    branch_decisions: List[bool] 
```

### How They Interact in Code

If we were to write a simplified loop for the execution engine, it would manipulate these data structures like this:

1.  **Initialization:** The engine creates an initial `ExecutionState` where the `program_counter` points to the `main()` function, `memory` assigns base symbols (like $\alpha_0, \beta_0$) to inputs, and the `path_condition` is empty (True).
2.  **Stepping:** The engine evaluates the instruction at the `program_counter`. If it's a standard assignment (e.g., `y = x + 1`), it updates the `memory` map in the current `ExecutionState`.
3.  **Branching (Forking the State):** If the `program_counter` hits a symbolic branch (e.g., `if (x > 10)`), the engine takes the current `ExecutionState` and **clones** it:
    * **State A (True Branch):** Appends the `SymBool` for `x > 10` to its `path_condition`.
    * **State B (False Branch):** Appends the `SymBool` for `x <= 10` to its `path_condition`.
4.  **Path Tracking:** The `ExecutionPath` is updated to append State A and State B to their respective historical routes.

### A Note on Implementation and Optimization

While the `ExecutionState` structure above is conceptually accurate, implementing it literally with standard dictionaries and lists leads to severe memory issues due to **Path Explosion**. Cloning the entire `memory` map at every branch decision is incredibly expensive.

In a production engine, you rarely use standard mutable collections. Instead, the data structures are implemented using **persistent (immutable) data structures** or copy-on-write mechanisms. When a state forks, the new state shares the unchanged memory pointers and path condition history with its parent state, only allocating new memory for the specific delta (the newly added constraint or the specifically updated variable).

---

# you asked

How would you express the stepping function?

---

# gemini response

**[2026-04-20 22:25:52 PDT] Generated using Gemini 3.1 Pro.**

The stepping function is the heartbeat of a symbolic execution engine. Its primary job is to take a single `ExecutionState`, evaluate the current instruction, and return a *list* of new `ExecutionState`s. 

It returns a list because a single step can result in multiple future states if the engine hits a symbolic branch. 

When building an AST Virtual Machine evaluator, the stepping function essentially acts as a massive pattern matcher against the instruction types. Here is how you would express it, adding a mock `SMTSolver` to handle the path feasibility checks:

### The Stepping Function

```python
from typing import List

class SMTSolver:
    """Mock interface for a solver like Z3."""
    def is_satisfiable(self, path_condition: List[SymBool]) -> bool:
        # Calls the underlying SMT solver to check if constraints can be met.
        return True # Simplified for pseudo-code

def step(state: ExecutionState, solver: SMTSolver) -> List[ExecutionState]:
    """
    Evaluates the current instruction and returns all feasible resulting states.
    """
    instruction = state.program_counter
    
    # 1. Handle Assignments (e.g., y = x + 1)
    if isinstance(instruction, AssignInstruction):
        # Substitute current memory symbols into the right-hand side expression
        new_expr = evaluate_expression(instruction.rhs, state.memory)
        
        # Copy memory (conceptually) and update the target variable
        new_memory = state.memory.copy()
        new_memory[instruction.target_var] = new_expr
        
        # Advance PC, keep path condition identical
        next_state = ExecutionState(
            program_counter=instruction.next_instruction,
            memory=new_memory,
            path_condition=state.path_condition.copy() 
        )
        return [next_state]

    # 2. Handle Symbolic Branches (e.g., if (x > 10) goto A else goto B)
    elif isinstance(instruction, BranchInstruction):
        # Evaluate the boolean condition using current memory
        branch_cond = evaluate_boolean(instruction.condition, state.memory)
        
        feasible_next_states = []
        
        # --- Evaluate the TRUE branch ---
        true_pc = state.path_condition + [branch_cond]
        if solver.is_satisfiable(true_pc):
            feasible_next_states.append(ExecutionState(
                program_counter=instruction.true_target,
                memory=state.memory.copy(),
                path_condition=true_pc
            ))
            
        # --- Evaluate the FALSE branch ---
        # Assuming SymNot is an AST node that negates a boolean expression
        false_pc = state.path_condition + [SymNot(branch_cond)]
        if solver.is_satisfiable(false_pc):
            feasible_next_states.append(ExecutionState(
                program_counter=instruction.false_target,
                memory=state.memory.copy(),
                path_condition=false_pc
            ))
            
        return feasible_next_states

    # 3. Handle Program Exit / Halt
    elif isinstance(instruction, HaltInstruction):
        # The path has finished successfully. 
        # Usually, the engine moves this state to a "completed paths" list.
        return [] 
        
    else:
        raise NotImplementedError(f"Instruction type {type(instruction)} not supported.")
```

### The Engine Loop (Putting it in Motion)

To actually execute a program, an engine wraps this `step` function in a worklist loop (often called the path explorer or scheduler). 

The engine maintains a queue of active states. It pops a state, calls `step()`, and pushes the resulting states back onto the queue:

```python
def run_symbolic_execution(initial_state: ExecutionState, solver: SMTSolver):
    active_states = [initial_state]
    completed_states = []
    
    while active_states:
        # Search strategy: Pop from the front (BFS), back (DFS), or use heuristics.
        current_state = active_states.pop(0) 
        
        # Step the state forward
        new_states = step(current_state, solver)
        
        if not new_states and isinstance(current_state.program_counter, HaltInstruction):
            completed_states.append(current_state)
        else:
            active_states.extend(new_states)
            
    return completed_states
```

### Key Engineering Considerations

1.  **Solver Bottleneck:** The `solver.is_satisfiable()` calls inside the branch handler are the most expensive operations in symbolic execution. In practice, you do not query the solver directly on every branch. You would wrap the SMT solver in a caching layer to reuse previous proofs or use constraint simplification passes before invoking the solver.
2.  **The State Space:** The `active_states.extend(new_states)` line is where path explosion occurs. If a program has a loop dependent on a symbolic variable, the engine will continually spawn new states until it runs out of memory, which is why search heuristics (which state to `.pop()` next) are critical.

---

# you asked

How do I get all the execution paths then?

---

# gemini response

**[2026-04-20 22:27:21 PDT] Generated using Gemini 3.1 Pro.**

To capture the actual execution paths, we have to bridge the gap between the `ExecutionState` (the current snapshot) and the `ExecutionPath` (the historical journey). 

In the previous example, the engine loop only collected `completed_states`. To extract the full path that led to each completed state, you need to modify how states are linked during the `step` function. 

There are two primary ways to do this: the "Fat State" approach (carrying the whole history forward) and the "Tree Pointer" approach (backtracking). 

### Approach 1: The "Fat State" (Naive)
You could theoretically add an `ExecutionPath` object directly inside the `ExecutionState`, and append to it on every single step. However, copying a growing list of historical states at every single instruction is incredibly slow and will quickly cause out-of-memory errors. 

### Approach 2: The Tree Pointer (Standard)
The standard engineering practice is to treat the execution space like a linked list or a tree node. You give every `ExecutionState` a `parent` pointer. 

When a path finishes (hits a `HaltInstruction`), you simply walk backwards from that terminal leaf node up to the root, collecting the states to form the `ExecutionPath`.

Here is how you update the data structures and the engine to implement this:

#### 1. Update the Execution State
Add a reference to the state that immediately preceded it.

```python
from dataclasses import dataclass
from typing import Dict, List, Optional

@dataclass
class ExecutionState:
    program_counter: Instruction
    memory: Dict[str, SymExpr]
    path_condition: List[SymBool]
    
    # NEW: The link back up the execution tree
    parent: Optional['ExecutionState'] = None 
```

#### 2. Update the Stepping Function
When `step()` creates a new state, it must now explicitly link it back to the state it just evaluated.

```python
def step(state: ExecutionState, solver: SMTSolver) -> List[ExecutionState]:
    instruction = state.program_counter
    
    if isinstance(instruction, AssignInstruction):
        # ... (evaluate assignment logic) ...
        return [ExecutionState(
            program_counter=instruction.next_instruction,
            memory=new_memory,
            path_condition=state.path_condition.copy(),
            parent=state # LINK TO PARENT
        )]
        
    elif isinstance(instruction, BranchInstruction):
        # ... (evaluate branches and solver checks) ...
        feasible_next_states = []
        
        if true_branch_is_feasible:
            feasible_next_states.append(ExecutionState(
                program_counter=instruction.true_target,
                memory=state.memory.copy(),
                path_condition=true_pc,
                parent=state # LINK TO PARENT
            ))
            
        # ... (repeat for false branch) ...
        return feasible_next_states
```

#### 3. The Path Reconstruction Function
Create a function that traverses the parent pointers backwards to rebuild the chronological path.

```python
def reconstruct_path(terminal_state: ExecutionState) -> ExecutionPath:
    """Walks backwards from a halt state to the root to build the path."""
    history = []
    current_node = terminal_state
    
    while current_node is not None:
        # Insert at the beginning so the final list is chronological
        history.insert(0, current_node) 
        current_node = current_node.parent
        
    return ExecutionPath(state_history=history)
```



#### 4. Update the Engine Loop
Now, modify the main loop. Instead of just saving the terminal states, it reconstructs and saves the paths.

```python
def run_symbolic_execution(initial_state: ExecutionState, solver: SMTSolver) -> List[ExecutionPath]:
    active_states = [initial_state]
    completed_paths = [] # Changed from completed_states
    
    while active_states:
        current_state = active_states.pop(0) 
        new_states = step(current_state, solver)
        
        # If no new states were generated and we halted normally
        if not new_states and isinstance(current_state.program_counter, HaltInstruction):
            
            # 1. Reconstruct the journey
            final_path = reconstruct_path(current_state)
            
            # 2. Save the fully extracted path
            completed_paths.append(final_path)
            
        else:
            active_states.extend(new_states)
            
    return completed_paths
```

### Why this matters for the SMT Solver
By keeping the paths as reconstructed linear lists of states, you gain a massive advantage when generating tests or proving theorems. The final state's `path_condition` contains the cumulative math formula. You can feed that final formula to the SMT solver one last time and ask it for a concrete "model" (e.g., `x = 15, y = 2`). Those concrete numbers are the exact inputs required to force the program to traverse that specific `ExecutionPath` from start to finish.

---

# you asked

Should I define special terminal state? Or should it just be execution state? The main thing is that for my analysis, the intermediate execution state has more variables, while the terminal state only has the output variables.

---

# gemini response

**[2026-04-20 22:32:09 PDT] Generated using Gemini 3.1 Pro.**

Yes, you should absolutely define a distinct `TerminalState` (or an equivalent "Summarized State"). 

Given your requirement—that the analysis phase only cares about output variables—separating the two concepts is a standard and highly recommended architectural pattern in symbolic execution engines. 

Keeping them as a single uniform `ExecutionState` is a common early-stage design trap that leads to massive memory leaks and muddy engine logic. Here is why separating them is the better approach:

### 1. Massive Memory Savings (The "Projection" Benefit)
During an execution path, your `memory` map fills up with intermediate variables, loop counters, and temporary symbolic expressions. If your terminal state is just a regular `ExecutionState`, you are holding onto the entire historical memory map of every single completed path. 

By defining a `TerminalState` that explicitly filters out everything except the output variables, you allow the language's garbage collector to destroy all those intermediate symbolic AST nodes. In formal verification, this is conceptually similar to "projecting" the final state only onto the variables you care about, which is critical for surviving path explosion.

### 2. Type Safety in the Engine Loop
Conceptually, an `ExecutionState` is something that is "steppable"—it has a program counter pointing to the next instruction. A halted program does not have a next instruction. 

If you use a uniform class, you usually have to set the `program_counter` to `None` or a dummy value upon halting, which forces you to write `if state.program_counter is not None:` checks throughout your engine. A distinct `TerminalState` removes this ambiguity at the type-system level.

### 3. A Clean Contract for Analysis
Your analysis engine likely doesn't care about the control-flow graph, the program counters, or the parent pointers used to backtrack. It just wants the final math formula (the path condition) and the final output symbols. A `TerminalState` acts as a clean Data Transfer Object (DTO) that decouples your execution engine from your analysis engine.



### How to Express It in Code

You can implement this by having the `step` function (or the engine loop) handle the "projection" when it detects a program termination. 

```python
from dataclasses import dataclass
from typing import Dict, List

# --- The Execution State (Internal Engine Use) ---
@dataclass
class ExecutionState:
    program_counter: Instruction
    memory: Dict[str, SymExpr]       # FAT: Contains ALL variables
    path_condition: List[SymBool]
    parent: 'ExecutionState' = None

# --- The Terminal State (For Analysis) ---
@dataclass
class TerminalState:
    output_variables: Dict[str, SymExpr] # THIN: Only outputs
    path_condition: List[SymBool]        # The final cumulative constraints
    path: ExecutionPath                  # The reconstructed journey
```

And inside your stepping or loop logic, you explicitly perform the extraction:

```python
def extract_terminal_state(final_state: ExecutionState, output_keys: List[str]) -> TerminalState:
    """Projects an ExecutionState into a TerminalState."""
    
    # 1. Filter memory to ONLY keep variables the analysis cares about
    filtered_memory = {
        key: final_state.memory[key] 
        for key in output_keys 
        if key in final_state.memory
    }
    
    # 2. Reconstruct the journey
    final_path = reconstruct_path(final_state)
    
    # 3. Return the clean DTO
    return TerminalState(
        output_variables=filtered_memory,
        path_condition=final_state.path_condition,
        path=final_path
    )
```

By defining a special terminal state, you establish a hard boundary: `ExecutionState` is strictly for *building* the execution tree, and `TerminalState` is strictly the *payload* yielded to your analysis tools.

---

# you asked

I’m also considering defining UndefinedState as a special type, as there are some intentional undefined behaviors, and I want to use this type to represent it.

---

# gemini response

**[2026-04-20 22:35:42 PDT] Generated using Gemini 3.1 Pro.**

Defining an `UndefinedState` (often called an `ErrorState`, `BugState`, or `ViolationState` in the literature) is an excellent architectural decision. In fact, if the ultimate goal of your engine is formal verification or bug finding, this state is arguably the most valuable part of the entire system.

When you are modeling domain-specific languages or network protocols, undefined behaviors—like reading an uninitialized bitvector, dividing by zero, or attempting to extract an invalid packet header—are exactly the edge cases you want the engine to formally catch and isolate.

Here is why elevating `UndefinedState` to its own explicit type is the right move, and how it fits into the architecture:

### 1. It acts as an explicit "Halt" signal
Undefined behavior is usually fatal to the formal semantics of a program. If you read an uninitialized variable, any subsequent mathematical evaluation on that path becomes meaningless (or computationally explosive). 

By yielding an `UndefinedState` from your `step()` function, you signal to the engine loop to immediately prune that branch. It prevents the engine from wasting cycles exploring the downstream consequences of garbage data.

### 2. It captures the "Proof of Failure"
Just like a `TerminalState` captures the math required to finish a program successfully, an `UndefinedState` captures the precise conditions required to trigger the bug. 

If you feed the `path_condition` of an `UndefinedState` to your SMT solver, the resulting model gives you the exact inputs needed to reproduce the undefined behavior. It is the holy grail of automated test generation.



### How to express it alongside the others

You can structure this as a third distinct state type. Notice how it shares the `path_condition` and `path` with `TerminalState`, but adds context about the failure:

```python
from dataclasses import dataclass
from typing import List

# ... (ExecutionState and TerminalState from before) ...

@dataclass
class UndefinedState:
    """Represents a path that halted prematurely due to undefined behavior."""
    
    # What rule was violated? (e.g., "Division by zero", "Invalid header read")
    reason: str 
    
    # The exact instruction where the UB occurred
    faulting_instruction: Instruction 
    
    # The cumulative constraints required to trigger this UB
    path_condition: List[SymBool]     
    
    # The journey taken to reach the fault
    path: ExecutionPath               
```

### Modifying the Engine Loop

With this in place, your engine loop essentially becomes a triage center. As the `step()` function yields new states, the loop categorizes them based on their strong types:

1.  **If `ExecutionState`:** Push it back onto the active worklist to keep exploring.
2.  **If `TerminalState`:** Append it to the `successful_paths` list (to verify correct outputs).
3.  **If `UndefinedState`:** Append it to a `discovered_bugs` list and alert the user.

This tripartite design gives you an incredibly clean AST Virtual Machine that strictly separates ongoing computation, successful termination, and formal violations. 

What specific kinds of undefined behaviors are you planning to capture in your engine's semantics?

---

# you asked

I’m considering having the stepper taking an input execution path, and output an extended execution path. Execution state will be execution path’s field. Is this a good idea?

---

# gemini response

**[2026-04-20 22:38:45 PDT] Generated using Gemini 3.1 Pro.**

Conceptually, it is a very intuitive idea, because it makes path extraction trivial. However, from a systems engineering perspective, it is a dangerous anti-pattern for a symbolic execution engine. I strongly advise against it.

Making the `ExecutionPath` the primary unit of stepping usually leads to an immediate performance bottleneck and rapid memory exhaustion. Here is a breakdown of why keeping `ExecutionState` as the stepper's input is the standard architecture.

### 1. The O(N) Memory Duplication Problem
If your `step()` function takes an `ExecutionPath` (which contains a list of historical states) and outputs a new `ExecutionPath`, you are forced to clone that entire history list every time the program branches. 

When building an AST Virtual Machine in a language like Python, list copying and object duplication are not free. If you are at instruction 500, a single branch requires copying a list of 500 historical states. If that branch splits again, both children copy 501 states. Because symbolic execution trees grow exponentially, you are turning a fundamental O(1) step operation into an O(N) operation where N is the depth of the path. The engine will quickly choke on its own garbage collection.



### 2. Violation of Semantic Locality
Ask yourself: *Does the stepper actually need to know what happened 40 instructions ago to evaluate `y = x + 1` right now?*

Mathematically, it does not. The evaluation of a single instruction is a purely local operation. It only requires:
* The current instruction (`PC`)
* The current memory map
* The current path condition

By passing the entire `ExecutionPath` into the stepper, you are breaking data encapsulation. You are handing the evaluator a massive amount of historical data that it has no logical business reading or mutating. 

### 3. The Power of Structural Sharing
By treating the execution space as a tree (where each `ExecutionState` just holds an O(1) pointer to its `parent`), you get structural sharing for free. 

The history still exists, but it exists implicitly in the graph of states rather than explicitly duplicated inside every path object. The engine only allocates memory for the exact *delta* of the current step, leaving the historical tree intact until you are ready to traverse it backward during the projection to your `TerminalState` or `UndefinedState`.

Are you considering passing the full path into the stepper because you need to implement a specific search heuristic or detect infinite loops based on historical branch decisions?

---

# you asked

Okay. So your suggestion would be that stepper works on execution state, execution state point to parent, executor outputs an execution tree, and execution paths can be extracted from the execution tree?

---

# gemini response

**[2026-04-20 22:52:48 PDT] Generated using Gemini 3.1 Pro.**

Yes, exactly. You have hit the nail on the head. That is the canonical, battle-tested architecture for a symbolic execution engine. 

Particularly for a Python-based AST Virtual Machine, keeping the stepper strictly focused on localized state manipulation ensures that your object allocations remain low and your garbage collector doesn't bottleneck the entire run. 

Here is a summary of that finalized architectural flow:

### 1. The Stepper (The Local Evaluator)
* **Input:** A single `ExecutionState`.
* **Action:** Looks only at the current AST node/instruction and the current memory. It evaluates the logic and creates new `ExecutionState` objects for the immediate next steps.
* **Linking:** It sets the `parent` property of those new states to the input state.
* **Output:** A list of 1-to-N new `ExecutionState` objects.

### 2. The Executor (The Tree Manager)
* **Input:** The initial entry-point state.
* **Action:** Runs a worklist loop (DFS, BFS, or custom heuristic). It feeds states to the Stepper and receives new states back. 
* **Output:** It organically builds an **Execution Tree** in memory, where the edges are simply the `parent` pointers linking the nodes together. 



### 3. The Extractor (The Analyzer)
* **Trigger:** The Executor detects that a state has hit a termination condition (either a normal halt or an intentional undefined behavior). 
* **Action:** It walks the `parent` pointers backward from that leaf node to the root.
* **Output:** It projects that extracted journey into a clean `TerminalState` or `UndefinedState`, which contains the fully assembled `ExecutionPath` and the final cumulative constraints for your SMT solver.

By dividing the responsibilities this way, your stepper remains computationally cheap, your memory footprint stays as small as mathematically possible via structural sharing, and your analysis tools get perfectly clean data objects to work with.

---

# you asked

For the extractor, should I out put terminal states? Or execution paths?

---

# gemini response

**[2026-04-20 22:55:20 PDT] Generated using Gemini 3.1 Pro.**

You should output the **`TerminalState`** (and the **`UndefinedState`**), and treat the `ExecutionPath` as a property *inside* those states. 

Think of it this way: the `TerminalState` is the **payload**, and the `ExecutionPath` is the **receipt**. 

When the Extractor hands data over to your analysis phase, the analysis engine usually cares about the payload first. It wants to know: "Did this path succeed or fail?" and "What are the final output variables?" Only if it needs to generate a test case, or show the user a stack trace for a bug, will it crack open the receipt to look at the chronological journey.

Here is a breakdown of why outputting the wrapper states is the better architectural contract:

### 1. Easier Triage for the Analyzer
If your Extractor only outputs a list of `ExecutionPath` objects, your analyzer has to inspect the last node of every single path to figure out what happened. 

By outputting the strongly-typed wrapper states, your analysis phase can immediately use pattern matching to separate successes from failures:

```python
results = extract_completed_runs(executor)

for result in results:
    if isinstance(result, TerminalState):
        # Verify the final output variables against your formal specification
        verify_outputs(result.output_variables, result.path_condition)
        
    elif isinstance(result, UndefinedState):
        # Extract the bug report and use the 'receipt' to show the trace
        print(f"BUG FOUND: {result.reason} at {result.faulting_instruction}")
        print_trace(result.path) # Here is where the path becomes useful
```

### 2. Preserving the "Projected" Memory
As discussed earlier, an intermediate `ExecutionState` (which makes up the nodes of your `ExecutionPath`) contains a "fat" memory map full of temporary variables. 

If you only output the `ExecutionPath`, the analyzer still has to sift through the final state's memory map to find the actual output variables. By outputting a `TerminalState`, the Extractor does that filtering/projection work for you. The analyzer receives a clean dictionary of just the variables it cares about.

### 3. Clear Data Encapsulation
By nesting the path inside the state, you create a perfect Data Transfer Object (DTO) for your verification tools. 



```python
@dataclass
class TerminalState:
    output_variables: Dict[str, SymExpr] 
    path_condition: List[SymBool]        
    
    # The chronological receipt is tucked away neatly here
    path: ExecutionPath                  
```

In short, outputting the states gives your analysis tools immediate, context-rich answers, while still providing the historical path data whenever it is needed for test generation or debugging.