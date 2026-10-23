import random
 
WIN_SCORE = 10000
LOSE_SCORE = -10000
ALPHA_START = -50000
BETA_START = 50000
 
DIRECTIONS = [(0, -1), (0, 1), (1, 0), (1, -1), (1, 1), (-1, -1), (-1, 1)]
 
MY_POINTS = {3: 16, 2: 4, 1: 2}
OPPO_POINTS = {3: 8, 2: 4, 1: 2}
 
 
class HumanPlayer:
    def __init__(self):
        self.moved_column = -1
 
    def set_move(self, column):
        self.moved_column = column
 
    def go(self, state):
        state.move(self.moved_column)
        return self.moved_column
 
 
class MinMaxPlayer:
    def __init__(self, ply=4):
        self.ply = ply
 
    def go(self, state):
        root = state.copy()
        root.depth = 0
        self.create_successors(root)
        m = self.minimax_decision(root)
        state.move(m)
        return m
 
    def minimax_decision(self, s):
        alpha = ALPHA_START
        beta = BETA_START
        if s.next_player == 1:
            v = self.max_value(s, alpha, beta)
        else:
            v = self.min_value(s, alpha, beta)
        for cell in s.successors:
            if cell.value == v:
                return cell.action
 
        return random.randint(0, 6)
 
    def max_value(self, state, alpha, beta):
        if self.is_ply_end(state):
            return self.utility(state)
        for cell in state.successors:
            alpha = max(alpha, self.min_value(cell, alpha, beta))
            if beta <= alpha:
                break
        state.value = alpha
        return state.value
 
    def min_value(self, state, alpha, beta):
        if self.is_ply_end(state):
            return self.utility(state)
        for cell in state.successors:
            beta = min(beta, self.max_value(cell, alpha, beta))
            if beta <= alpha:
                break
        state.value = beta
        return state.value
 
    def is_ply_end(self, state):
        return state.depth == self.ply or state.game_over()
 
    def utility(self, state):
        me = 1
        oppo = 3 - me
        if state.game_over():
            if state.winner == me:
                state.value = WIN_SCORE
                return state.value
            if state.winner == oppo:
                state.value = LOSE_SCORE
                return state.value
            if state.winner == 0:
                state.value = 0
                return state.value
        row = state.move_x
        col = state.move_y
        h = 0
        for dr, dc in DIRECTIONS:
            for n, pts in MY_POINTS.items():
                if self._line(state, row, col, dr, dc, n, me):
                    h += pts
            for n, pts in OPPO_POINTS.items():
                if self._line(state, row, col, dr, dc, n, oppo):
                    h -= pts
        state.value = h
        return h
 
    @staticmethod
    def _line(state, row, col, dr, dc, n, player):
        for k in range(1, n + 1):
            r = row + dr * k
            c = col + dc * k
            if not (0 <= r < 6 and 0 <= c < 7):
                return False
            if state.locations[r][c] != player:
                return False
        return True
 
    def create_successors(self, state):
        successors = []
        for i in range(7):
            if state.cols[i] != 6:
                child = state.copy()
                child.move(i)
                child.depth = state.depth + 1
                child.action = i
                child.value = 0
                successors.append(child)
                if child.depth < self.ply:
                    self.create_successors(child)
        state.successors = successors