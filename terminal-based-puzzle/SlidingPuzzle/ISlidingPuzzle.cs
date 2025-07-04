interface ISlidingPuzzle {
    void Shuffle(); // need a shuffle func
    void Move(ConsoleKey key); // need a move function
    bool IsDone(); // need a check if done
    void Print(); // need to be able to print
    int GetNumMoves();
}
