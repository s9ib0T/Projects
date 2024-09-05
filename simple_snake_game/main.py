import os
os.system('cls')
from turtle import Screen
import time
from snake import Snake
from appie import Appie
from scoreboard import Scoreboard

screen = Screen()
screen.setup(width=600, height=600)
screen.bgcolor('black')
screen.title('Sssssnake')
screen.tracer(0)

snake = Snake()
appie = Appie()
scoreboard = Scoreboard()

screen.listen()
screen.onkey(snake.up, 'Up')
screen.onkey(snake.down, 'Down')
screen.onkey(snake.left, 'Left')
screen.onkey(snake.right, 'Right')

score = 0
game_is_on = True
while game_is_on:
    
    screen.update()
    time.sleep(.1)

    snake.move()

    # Collision with food
    if snake.head.distance(appie) < 15:
        scoreboard.increase_score()
        snake.extend()
        appie.refresh()

    # Collision with wall
    if snake.head.xcor() > 290 or snake.head.xcor() < -290 or snake.head.ycor() < -290 or snake.head.ycor() > 290:
        game_is_on = False
        scoreboard.game_over()

    # Collision with self
    for snek in snake.snake[1:]:
        if snake.head.distance(snek) < 10:
            game_is_on = False
            scoreboard.game_over()


screen.exitonclick()