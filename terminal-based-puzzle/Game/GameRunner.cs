class GameRunner(ISlidingPuzzle puzzle)
{
    private readonly ISlidingPuzzle _puzzle = puzzle; // interact with puzzle through interface

    public void Start() {
        _puzzle.Shuffle();
        while(true) {
            _puzzle.Print();
            if(_puzzle.IsDone()){
                Console.WriteLine($"solved in {_puzzle.GetNumMoves()} moves!");
                break;
            }

            ConsoleKey key = Console.ReadKey(true).Key;
            // exit on escape
            if(key == ConsoleKey.Escape) {
                Console.WriteLine("you pressed ESC, bye!");
                break; 
            }
            _puzzle.Move(key);
        }
    }
}