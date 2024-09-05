from turtle import Turtle
import random


class Appie(Turtle):

    def __init__(self) -> None:
        super().__init__()
        self.shape('circle')
        self.penup()
        self.shapesize(stretch_len=0.5, stretch_wid=0.5)
        self.color('red')
        self.speed('fastest')
        rand_x, rand_y = random.randint(-280, 280), random.randint(-280, 280)
        self.goto(rand_x, rand_y)


    def refresh(self):
        rand_x, rand_y = random.randint(-280, 280), random.randint(-280, 280)
        self.goto(rand_x, rand_y)