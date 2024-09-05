from turtle import Turtle
import random
UP, DOWN, LEFT, RIGHT = 90, 270, 180, 0
DISTANCE = 20
STARTING_POSITIONS = [(0,0), (-20,0), (-40,0)]

class Snake:
    
    def __init__(self) -> None:
        self.snake = []
        self.create_snake()
        self.head = self.snake[0]

    def create_snake(self):
        for position in STARTING_POSITIONS:
            self.add_snek(position)
            
    def add_snek(self, position):
        s = Turtle('square')
        s.color('white')
        s.penup()
        s.goto(position)
        self.snake.append(s)

    def extend(self):
        self.add_snek(self.snake[-1].position())

    def move(self):
        for i in range(len(self.snake)-1, 0, -1):
            new_x = self.snake[i - 1].xcor()
            new_y = self.snake[i - 1].ycor()
            self.snake[i].goto(new_x, new_y)
        self.head.forward(DISTANCE)
        return
    
    def up(self):
        if self.head.heading() != DOWN:
            self.head.setheading(UP)
    def down(self):
        if self.head.heading() != UP:
            self.head.setheading(DOWN)
    def left(self):
        if self.head.heading() != RIGHT:
            self.head.setheading(LEFT)
    def right(self):
        if self.head.heading() != LEFT:
            self.head.setheading(RIGHT)


    def spawn_appie():
        return [random.randint(0,601), random.randint(0,601)]
