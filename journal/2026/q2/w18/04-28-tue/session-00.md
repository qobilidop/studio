# you asked

Can I write DFS of a tree in an iterative way such that I can maintain a stack composed of nodes from root to the current node?

---

# gemini response

**[2026-04-28 10:25:48 PM PDT] Model: Gemini 3.1 Pro**

Yes, absolutely. While a standard iterative DFS (where you pop a node and immediately push its right and left children) maintains a stack of the "frontier" or pending nodes, you can tweak the traversal logic so that the stack strictly maintains the ancestors of the current node—representing the exact path from the root. 

To achieve this, you essentially need to mirror the logic of an **iterative Post-Order traversal**. 

### How It Works

In a standard recursive DFS, the call stack implicitly stores the path from the root to the current node. To replicate this iteratively, your explicit stack must mimic that call stack. 

You do this by:
1. **Going deep left:** Pushing nodes to the stack as you traverse down the left side of the tree.
2. **Checking the right:** When you can't go left anymore, you peek at the top of the stack. If that node has an unexplored right child, you pivot to the right and repeat step 1.
3. **Backtracking:** If the node at the top of the stack has no right child (or you've already visited it), you process it and pop it off the stack. 

By only popping a node when both its left and right subtrees have been fully explored, the stack will always represent the exact path from the root down to the node currently being evaluated.



### Code Implementation (Python)

Here is how you can implement this. We use a `prev` pointer to keep track of the last visited node so we know whether we are travelling down the tree, coming up from a left branch, or coming up from a right branch.

```python
class TreeNode:
    def __init__(self, val=0, left=None, right=None):
        self.val = val
        self.left = left
        self.right = right

def dfs_path_stack(root):
    if not root:
        return

    stack = []
    curr = root
    prev = None

    while stack or curr:
        # 1. Dive as deep left as possible
        if curr:
            stack.append(curr)
            
            # ---> AT THIS EXACT MOMENT <---
            # 'stack' contains the path from root to 'curr'
            path = [node.val for node in stack]
            print(f"Current Path to {curr.val}: {path}")
            
            curr = curr.left
            
        else:
            # 2. Reached a leaf's left null, look at the parent on top of stack
            peek_node = stack[-1]

            # 3. If a right child exists and we didn't just come back from it, go right
            if peek_node.right and peek_node.right != prev:
                curr = peek_node.right
                
            # 4. Otherwise, we are done with both left and right subtrees of this node
            else:
                prev = stack.pop()
                # If you needed to process the node in post-order, do it here.
```

### Why Use This?

Maintaining a strict root-to-node path stack is highly useful for specific types of tree problems that standard iterative DFS struggles with, such as:
* **Finding the Lowest Common Ancestor (LCA):** You can pause the traversal when you hit a target node, record the stack (which is the path), do the same for the second target, and simply compare the two path arrays.
* **Path Sums:** If you need to evaluate the sequence of nodes that lead to a specific leaf or target value, the stack provides the exact sequence instantly without needing an external array to track backtracking.

---

# you asked

This seems to be a binary tree solution? What about an N-nary tree?

---

# gemini response

**[2026-04-28 10:46:51 PM PDT] Model: Gemini 3.1 Pro**

You are absolutely right—that previous solution was specific to binary trees, relying on the predictable structure of just a `left` and `right` child. 

For an N-ary tree, a node can have an arbitrary number of children. The challenge here is that we can't just check `peek_node.right`. We need a way to remember exactly *which* child we are currently visiting so we know where to pick up when we backtrack to a parent.

To strictly maintain the root-to-current-node path in our stack for an N-ary tree, we need to store a little bit of extra state. Instead of just storing the node, our stack will store pairs consisting of the **`(node, next_child_index)`**.



### How It Works

1. **The Tuple:** Every item on the stack is `(node, child_index)`. The `child_index` tells us which of this node's children we need to process next.
2. **Going Deep:** We pop the top item. If the `child_index` is less than the number of children, we push the parent *back* onto the stack with `child_index + 1`. Then, we push that child onto the stack with an index of `0`. 
3. **The Path:** At the moment a new child is pushed onto the stack, the stack contains the exact chain of ancestors plus the child itself.
4. **Backtracking:** If we pop a node and its `child_index` equals the number of its children, we are done with its entire subtree. We simply do not push it back onto the stack.

### Code Implementation (Python)

```python
class Node:
    def __init__(self, val=None, children=None):
        self.val = val
        self.children = children if children is not None else []

def dfs_nary_path_stack(root):
    if not root:
        return

    # Stack stores tuples: (node, index_of_next_child_to_visit)
    stack = [(root, 0)]
    
    # The root is our first current node
    print(f"Current Path to {root.val}: {[root.val]}")

    while stack:
        curr_node, child_idx = stack.pop()

        # Check if there are still children to visit for this node
        if child_idx < len(curr_node.children):
            
            # 1. Put the parent back on the stack, incrementing the child index
            stack.append((curr_node, child_idx + 1))
            
            # 2. Get the actual child node we are visiting right now
            next_child = curr_node.children[child_idx]
            
            # 3. Push the child onto the stack to process its own subtrees (starting at index 0)
            stack.append((next_child, 0))
            
            # ---> AT THIS EXACT MOMENT <---
            # 'stack' strictly contains the path from root to 'next_child'
            path = [node.val for node, _ in stack]
            print(f"Current Path to {next_child.val}: {path}")
            
        else:
            # We have exhausted all children of 'curr_node'.
            # By not pushing it back onto the stack, we essentially backtrack up the tree.
            # (If you need to do any Post-Order processing, you do it right here)
            pass 
```

By storing the iterator index directly alongside the node, you prevent siblings from polluting the stack. The only things on the stack are the active node and its direct, unbroken lineage back to the root.