class ColorPuzzle : SlidingPuzzle<ConsoleColor> {
    // list of colors to use
    private readonly ConsoleColor[] color_list = [ConsoleColor.Red, ConsoleColor.Blue, ConsoleColor.Yellow, ConsoleColor.Green, ConsoleColor.Magenta];
    private readonly List<ConsoleColor> Seen = [];
    private ConsoleColor last_seen = ConsoleColor.Black; // dummy color

    // constructor calls base constructor and then initialize
    public ColorPuzzle(int size) : base(size) => Initialize();

    protected override void Initialize()
    {
        for(int i=0; i<grid.Size; i++) {
            for(int j=0; j<grid.Size; j++){
                int r = rand.Next(5); // 5 colors
                grid[i,j] = color_list[r];
            }
        }
        // set last one as empty (white will represent empty)
        grid[grid.Size-1, grid.Size-1] = ConsoleColor.White; 
        empty_row = grid.Size-1;
        empty_col = grid.Size-1;
    }

    public override bool IsDone()
    {
        // if "empty" (white) is not on last spot just exit imemdiately
        if(grid[grid.Size-1, grid.Size-1] != ConsoleColor.White) { return false; }

        Seen.Clear(); // reset Seen
        for(int i=0;i<grid.Size;i++){
            for(int j=0;j<grid.Size;j++) {
                //skip over last slot (white)
                if(i==grid.Size-1 && j==grid.Size-1) { continue; }

                ConsoleColor current_color = grid[i,j];
                // if current color is not the same as previous (chagned color) but the current color is in the list Seen, then it is not valid
                if(current_color != last_seen && Seen.Contains(current_color)) { return false; }
                Seen.Add(current_color);
                last_seen = current_color;
            }
        }
        return true;
    }

    public override void Print()
    {
        // the passed in function to PrintGrid() changes color to current element and then prints that color tile (or empty for white )
        grid.PrintGrid(value => {
            Console.ForegroundColor = value; // change color to current grid element
            return value == ConsoleColor.White ? " " : "▮";
            // Func in PrintGrid checks if value is White, if true then print " " else print a block
        });
        Console.ResetColor();
    }
}
