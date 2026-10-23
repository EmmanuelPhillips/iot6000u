ROWS = 6
COLS = 7
 
 
class State:
    def __init__(self, out=False):
        self.next_player = 1
        self.locations = [[0] * COLS for _ in range(ROWS)]
        self.cols = [0] * COLS
        self.move_x = 0
        self.move_y = 0
        self.winner = 0
        self.movelist = ""
        self.value = 0
        self.depth = 0
        self.action = -1
        self.out = out
        self.successors = []
 
    def parse_move(self, move_list):
        for ch in move_list:
            self.move(int(ch))
 
    def move(self, pos):
        if self.cols[pos] == ROWS:
            if self.out:
                print("Column full")
            return
        self.move_y = pos
        self.movelist += str(pos)
        self.move_x = (ROWS - 1) - self.cols[pos]
        self.cols[pos] += 1
        self.locations[self.move_x][self.move_y] = self.next_player
        self.next_player = 3 - self.next_player
 
    def copy(self):
        s = State(self.out)
        s.next_player = self.next_player
        s.locations = [row[:] for row in self.locations]
        s.cols = self.cols[:]
        s.move_x = self.move_x
        s.move_y = self.move_y
        s.winner = self.winner
        s.movelist = self.movelist
        s.value = self.value
        s.depth = self.depth
        s.action = self.action
        return s
 
    def game_over(self):
        player = 3 - self.next_player
        if self.locations[self.move_x][self.move_y] != player:
            return False
        for dr, dc in ((0, 1), (1, 0), (1, 1), (1, -1)):
            count = 1
            count += self._count_direction(dr, dc, player)
            count += self._count_direction(-dr, -dc, player)
            if count >= 4:
                self.winner = player
                return True
        return False
 
    def _count_direction(self, dr, dc, player):
        r = self.move_x + dr
        c = self.move_y + dc
        n = 0
        while 0 <= r < ROWS and 0 <= c < COLS and self.locations[r][c] == player:
            n += 1
            r += dr
            c += dc
        return n
 
    def match_drawn(self):
        return all(self.locations[0][c] != 0 for c in range(COLS))
 
    def __str__(self):
        ret = "   0 1 2 3 4 5 6\n"
        for i in range(ROWS):
            ret += str(i) + ": " + " ".join(str(x) for x in self.locations[i]) + " \n"
        return ret