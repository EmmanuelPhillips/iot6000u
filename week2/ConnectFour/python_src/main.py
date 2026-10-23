import tkinter as tk
 
from ui import ConnectFourApp
 
 
def main():
    root = tk.Tk()
    ConnectFourApp(root)
    root.mainloop()
 
 
if __name__ == "__main__":
    main()