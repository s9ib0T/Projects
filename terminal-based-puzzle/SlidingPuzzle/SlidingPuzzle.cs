abstract class SlidingPuzzle<T>(int size) : ISlidingPuzzle {
    protected Grid<T> grid = new(size);
    protected int empty_row;
    protected int empty_col;
    private int _num_moves = 0;
    protected Random rand = new();
    // possible moves (used to shuffle grid)
    private readonly ConsoleKey[] _moves = [ConsoleKey.LeftArrow, ConsoleKey.UpArrow, ConsoleKey.RightArrow, ConsoleKey.DownArrow];

    protected abstract void Initialize();
    public abstract bool IsDone();
    public abstract void Print();
    public int GetNumMoves() => _num_moves;

    public void Shuffle() => ShuffleGrid();

    public void Move(ConsoleKey key){
        int new_row = empty_row, new_col = empty_col;
        switch(key) {
            case ConsoleKey.UpArrow: 
                new_row--; 
                break;
            case ConsoleKey.DownArrow: 
                new_row++; 
                break;
            case ConsoleKey.LeftArrow: 
                new_col--; 
                break;
            case ConsoleKey.RightArrow: 
                new_col++; 
                break;
        }
        if(new_row>=0 && new_row<grid.Size && new_col>=0 && new_col<grid.Size){
            grid.Swap(empty_row, empty_col, new_row, new_col); 
            // new empty slot
            empty_row = new_row;
            empty_col = new_col;
            _num_moves++;
        }
    }
    // random moving
    private void ShuffleGrid() {
        for(int i=0; i<size; i++) {
            // select random move from (left, up, right, down)
            Move(_moves[rand.Next(4)]); 
        }
        // if, by some chance, we end up with a fully solved board, move once (left or up, since right/down are invalid from that position) so it requires at least one move
        if (empty_col == size-1 && empty_row == size-1) {
                Move(_moves[rand.Next(2)]); 
            }
        _num_moves=0; // reset num_moves since shuffle resets grid
    }
}
