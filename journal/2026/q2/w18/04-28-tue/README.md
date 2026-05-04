# 2026-04-28 (Tuesday)

Algorithmic check-in: how to write iterative DFS that maintains a stack containing exactly the path from root to the current node — binary tree solution (post-order with `prev` pointer) and N-ary tree solution (`(node, child_index)` tuples).

## Sessions

- **session-00**: Daily log (Gemini). Asked about iterative DFS where the stack always equals the root-to-current-node path. Binary tree answer: mirror iterative post-order — push going deep left, peek for unexplored right, only pop when both subtrees done; uses `prev` pointer to distinguish first descent from backtrack-from-right. User pushed back: "this is binary-tree only — what about N-ary?" Gemini revised: stack stores `(node, child_index)` tuples; on pop, if `child_idx < len(children)`, push parent back with `child_idx+1` then push current child with index 0; if exhausted, just don't re-push. Path = `[node for node, _ in stack]`. Use cases: LCA (compare two stacks), path-sum problems

## Agent index

- ITERATIVE-DFS-PATH-STACK: stack-as-root-to-current-path (mirrors recursive call stack) requires post-order traversal logic. Binary tree: push-deep-left + peek-for-unvisited-right + `prev` pointer, only pop when both subtrees done. N-ary tree: store `(node, child_index)` tuples on stack — pop, if children remain, re-push `(node, idx+1)` then push `(child, 0)`; if exhausted, don't re-push. The `(node, idx)` tuple prevents siblings from polluting stack. Use cases: LCA (compare two paths), path-sum, anything needing "ancestors of current node" (s00)
