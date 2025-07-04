class NumberPuzzle : SlidingPuzzle<int> { 
    // constructor calls base constructor and then initialize
    public NumberPuzzle(int size) : base(size) => Initialize();
    
    protected override void Initialize()
    {
        // fill grid with numbers in range (1, size)
        int n = 1;
        for(int i=0; i<grid.Size; i++) {
            for(int j=0; j<grid.Size; j++){
                grid[i,j] = n++;
            }
        }
        // set last one as empty (0 will represent empty, explained in isDone())
        grid[grid.Size-1, grid.Size-1] = 0; 
        empty_row = grid.Size-1;
        empty_col = grid.Size-1;
    }

    public override bool IsDone()
    {
        // checks if everything is in correct place
        int n=1;
        for(int i=0;i<grid.Size;i++){
            for(int j=0;j<grid.Size;j++,n++) {
                if(grid[i,j] != n%(grid.Size*grid.Size)) return false; // since 0 is empty this works, since the very last entry will be 0 but rest will be 1 to size*size-1
            }
        }
        return true;
    }

    public override void Print()
    {
    // will print the string version of each number, except for 0 (which is empty)
        grid.PrintGrid(value => value == 0 ? " " : value.ToString()); // Func checks if value is 0, if true print " ", if not then print value.ToString()
    }
}