# NeXtCS Project 01
### Period: 10
### Name0: bryan li
#### Selected Game: breakout
---

### How To Play
The goal of the game is to keep the ball from falling by using the paddle and break all the bricks on the screen. Move the paddle left by pressing A and right by pressing D. Press space to launch the ball at the start of the game or after losing a life. When the ball hits a brick, the brick disappears and you earn points based on its color. If the ball falls below the paddle, you lose a life. The game ends when you lose all 3 lives, and you can reset and play again.


---

### Features
List all the game features you were able to implelment.

Moving paddle controlled by A (left) and D (right)

Ball that bounces off walls, the paddle, and bricks

Bricks with random colors, each color awarding different points

White = 10 points

Red = 20 points

Green = 50 points

Score

3 lives

Game over screen when lives reach zero

Ball stays stuck to the paddle at the start of game or new life

Ability to reset and keep playing

Ability to pause/play the game

Infinite gameplay (new set of bricks appears after clearing all bricks)

---

### Changes
What changed about your game after the design phase? Separate changes that occured after the feedback round and changes that occured during programming.

I made paddle movement from mouse control to keyboard control (A and D) because mouse control felt too clunky. I also created a separate Paddle class instead of keeping the paddle as a ball because my paddle was weird and kept getting stuck. Since I made a new Paddle class, I had to change my Ball class to work with the Paddle class. I also fixed my collision checks so the ball wouldn't phase through the paddle or the bricks.
