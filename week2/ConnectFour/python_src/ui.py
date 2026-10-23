import tkinter as tk
from tkinter import ttk

from players import HumanPlayer, MinMaxPlayer
from state import COLS, ROWS, State

CELL = 80
PAD = 10
BOARD_COLOR = "#2b4a9b"
EMPTY_COLOR = "#e8e8e8"
PLAYER_COLORS = {1: "#d62828", 2: "#f2c300"}

# difficulty name -> how many moves ahead the AI looks
DIFFICULTIES = {"Easy": 5, "Medium": 6, "Hard": 7}
FIRST_OPTIONS = ["Human", "Computer"]


class ConnectFourApp:
    def __init__(self, root):
        self.root = root
        root.title("Connect Four")
        root.resizable(False, False)

        self.human = HumanPlayer()
        self.ai = MinMaxPlayer(DIFFICULTIES["Medium"])
        self.human_number = 1
        self.game_active = False
        self.ai_thinking = False
        self.state = State()

        # top bar: difficulty, who goes first, new game
        bar = ttk.Frame(root, padding=8)
        bar.pack(fill="x")

        ttk.Label(bar, text="Difficulty:").pack(side="left")
        self.difficulty_var = tk.StringVar(value="Medium")
        diff_box = ttk.Combobox(
            bar,
            textvariable=self.difficulty_var,
            values=list(DIFFICULTIES),
            state="readonly",
            width=8,
        )
        diff_box.pack(side="left", padx=(4, 12))
        diff_box.bind("<<ComboboxSelected>>", self.on_difficulty_change)

        ttk.Label(bar, text="First:").pack(side="left")
        self.first_var = tk.StringVar(value="Human")
        first_box = ttk.Combobox(
            bar,
            textvariable=self.first_var,
            values=FIRST_OPTIONS,
            state="readonly",
            width=9,
        )
        first_box.pack(side="left", padx=(4, 12))

        ttk.Button(bar, text="New game", command=self.new_game).pack(side="left")

        # board
        width = COLS * CELL + 2 * PAD
        height = ROWS * CELL + 2 * PAD
        self.canvas = tk.Canvas(
            root, width=width, height=height, bg=BOARD_COLOR, highlightthickness=0
        )
        self.canvas.pack()
        self.canvas.bind("<Button-1>", self.on_click)

        # status line
        self.status_var = tk.StringVar()
        ttk.Label(root, textvariable=self.status_var, padding=8).pack()

        self.new_game()

    # ---------- game flow ----------

    def new_game(self):
        self.state = State()
        self.game_active = True
        self.ai_thinking = False
        self.human_number = 1 if self.first_var.get() == "Human" else 2
        self.draw()
        if self.human_number == 2:
            self.start_ai_turn()
        else:
            self.set_status("Your turn")

    def on_difficulty_change(self, event=None):
        self.ai.ply = DIFFICULTIES[self.difficulty_var.get()]

    def on_click(self, event):
        if not self.game_active or self.ai_thinking:
            return
        if self.state.next_player != self.human_number:
            return
        col = (event.x - PAD) // CELL
        if not (0 <= col < COLS):
            return
        if self.state.cols[col] == ROWS:
            return  # column is full

        self.human.set_move(col)
        self.human.go(self.state)
        self.draw()
        if self.check_end():
            return
        self.start_ai_turn()

    def start_ai_turn(self):
        self.ai_thinking = True
        self.set_status("Computer is thinking...")
        # short delay so the window redraws before the search blocks it
        self.root.after(50, self.ai_turn)

    def ai_turn(self):
        self.ai.go(self.state)
        self.ai_thinking = False
        self.draw()
        if not self.check_end():
            self.set_status("Your turn")

    def check_end(self):
        """Returns True if the game has ended."""
        if self.state.game_over():
            self.game_active = False
            if self.state.winner == self.human_number:
                self.set_status("You win! Press New game to play again")
            else:
                self.set_status("Computer wins. Press New game to play again")
            return True
        if self.state.match_drawn():
            self.game_active = False
            self.set_status("Draw. Press New game to play again")
            return True
        return False

    # ---------- drawing ----------

    def draw(self):
        self.canvas.delete("all")
        for r in range(ROWS):
            for c in range(COLS):
                x0 = PAD + c * CELL + 6
                y0 = PAD + r * CELL + 6
                x1 = PAD + (c + 1) * CELL - 6
                y1 = PAD + (r + 1) * CELL - 6
                owner = self.state.locations[r][c]
                color = PLAYER_COLORS.get(owner, EMPTY_COLOR)
                self.canvas.create_oval(x0, y0, x1, y1, fill=color, outline="")

    def set_status(self, text):
        self.status_var.set(text)
