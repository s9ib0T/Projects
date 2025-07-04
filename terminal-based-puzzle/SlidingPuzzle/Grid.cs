class Grid<T>(int size)
{
    // fields
    private readonly T[,] _grid = new T[size, size];
    public int Size { get; } = size;

    // get/set are public, set is used to fill the grid when a game mode starts
    public T this[int r, int c] {
        get => _grid[r,c];
        set => _grid[r,c] = value; 
    }

    // swap places of two indices
    public void Swap(int r1, int c1, int r2, int c2) {
        (_grid[r1, c1], _grid[r2, c2]) = (_grid[r2, c2], _grid[r1, c1]);
    }
    // print row by row
    public void PrintGrid(Func<T, string> format) { // Func<T, string> allows us to define how elements should be converted to string
    // the function passed in (format) will be used when printing each grid element and wil be defined by the different puzzle classes (since they have different print needs)
        Console.Clear(); // clear console
        for(int i=0; i<Size; i++){
            for(int j=0; j<Size; j++){
                Console.Write(format(_grid[i,j])+ " "); // print row
            }
            Console.WriteLine(""); // go down a row
        }
    }
}
