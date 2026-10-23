# Connect Four

## My understanding of how minimax and alpha-beta pruning work here.
- `Inside MinMaxPlayer.java` there is configuration for the AI.
- there is a depth level whcih tells you how many moves ahead the AI looks. It finds every legal possible move and gives them a heuristic value (unless one of those moves is a win or draw due to the game state).
- after searching all legal moves to a depth of 4 for both players. the algorithm will pass the moves back up the tree from the leftmost leaf node. each time its a players turn the player will try to minimise the overall score, and the ai will try to maximise the score.
- if there is no possible way for the algorithm to get a higher score after working along, it will prune the rest, saving some time
- once at the root node, it finds the first child whose score matches the best score, and uses that childs column, dropping the coing in that column.
- then the human starts his turn. once the human drops their coin, it starts again.

## Writing in python
see `python_src\` for the code rewritten.

## Modification (difficulty levels)
There are two ways in which you can add difficulty levels:
1. change the depth that the ai looks at, considering more paths to minimax
2. have teh ai take not the max move, but the second max or even third max move.

I think the former will be easier to implement than the latter, but a combination of both may be the most impressive solution.