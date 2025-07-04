using System;

class Program {
    static void Main() {
        Console.WriteLine("\nChoose puzzle type:\n - 1: number puzzle\n - 2: color puzzle");
        var choice = Console.ReadKey().KeyChar;

        
        ISlidingPuzzle puzzle = choice switch
        {
            '1' => new NumberPuzzle(3),
            '2' => new ColorPuzzle(3),
            _ => throw new ArgumentException("invalid input!"),
        };
        new GameRunner(puzzle).Start();
    }
}

