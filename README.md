[![Review Assignment Due Date](https://classroom.github.com/assets/deadline-readme-button-22041afd0340ce965d47ae6ef1cefeee28c7c493a6346c4f15d667ab976d596c.svg)](https://classroom.github.com/a/Mfyqb_T6)
# NeXtCS Project 01
### thinker0: bryan li
---

### Overview
Your mission is create either:
- Life-like cellular automata [life](https://en.wikipedia.org/wiki/Conway%27s_Game_of_Life), [life-like](https://en.wikipedia.org/wiki/Life-like_cellular_automaton), [demo](https://www.netlogoweb.org/launch#https://www.netlogoweb.org/assets/modelslib/Sample%20Models/Computer%20Science/Cellular%20Automata/Life.nlogo).
- Breakout/Arkanoid [demo 0](https://elgoog.im/breakout/)  [demo 1](https://www.crazygames.com/game/atari-breakout)
- Space Invaders/Galaga

This project will be completed in phases.  
The first phase will be to work on this document. 
* Use markdown formatting.
* For more markdown help
  - [click here](https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet) or
  - [here](https://docs.github.com/en/get-started/writing-on-github/getting-started-with-writing-and-formatting-on-github/basic-writing-and-formatting-syntax)


---

## Phase 0: Selection, Analysis & Plan

#### Selected Project: breakout

### Necessary Features
What are the core features that your program should have? These should be things that __must__ be implemented in order to make the program useable/playable, not extra features that could be added to make the program more interesting/fun.

Some core features that my program should have are 
    
    A user controlled paddle.
    A grid of bricks.
    A ball that bounces off the paddle, bricks, and side walls.
    Bricks that disappear or are damaged when hit by the ball.
    Loss of "life" if the ball gets past the paddle.
    A set number (more than one) of "lives".
    The ability to play/pause the game.
    The ability to reset the game.
    Some continuation of the game if all the bricks have been destroyed.



### Extra Features
What are some features that are not essential to the program, but you would like to see (provided you have time after completing the necessary features. Theses can be customizations that are not part of the core requirements.

i would like to have a score mechanism where destroying different colored blocks gives a different amount of points.

### Array Usage
How will you be using arrays in this project?

1D Array:
- YOUR ANSER HERE

2D Array:

ball position


### Controls
How will your program be controlled? List all keyboard commands and mouse interactions.

Keyboard Commands:

a moves paddle left

d moves paddle right

p plays/pauses game

r resets game

Mouse Control:
- Mouse movement: when dragged, paddle follows mouse
- Mouse pressed: doesn't do anything lol


### Classes
What classes will you be creating for this project? Include the instance variables and methods that you believe you will need. You will be required to create at least 2 different classes. If you are going to use classes similar to those we've made for previous assignments, you will have to add new features to them.

Ball class
- Instance variables:
    PVector center;
    
    int xspeed;
    
    int yspeed;
    
    int bsize;
- METHODS
  collisionCheck(Paddle paddle)
  
  display()
  
  move()

Paddle class
- Instance variables:
    PVector center;
    
    int psize;
    
- METHODS
  move()
  
  display()
  
  collisionCheck(Ball ball)

  
Brick class
- Instance variables:
    int center;
    
    int bsize;

    
    
- METHODS
  display()

  hit()

  ### code:

  class Ball 
{
    //instance variables
    PVector center;
    int xspeed;
    int yspeed;
    int bsize;
    color c;

    //default constructor
    Ball(PVector p, int s) 
    {
  bsize = s;
  center = new PVector(p.x, p.y);
    }


    boolean collisionCheck(Ball other) 
    {
  return ( this.center.dist(other.center)
     <= (this.bsize/2 + other.bsize/2) );
    }//collisionCheck


    void setColor(color newC) 
    {
  c = newC;
    }//setColor


    //visual behavior
    void display() 
    {
  fill(c);
  circle(center.x, center.y, bsize);
    }//display


    //movement behavior
    void move() 
    {
  if (center.x > width - bsize/2 ||
      center.x < bsize/2) {
      xspeed*= -1;
  }
  if (center.y > height - bsize/2 ||
      center.y < bsize/2) {
      yspeed*= -1;
  }
  center.x+= xspeed;
  center.y+= yspeed;
    }//move

}//Ball

Ball[][] grid;
Ball projectile;
Ball paddle; // new paddle object
int rows = 3;
int cols = 5;
int ballSize = 40;
int pSize = 25;
int paddleWidth = 80;
int paddleHeight = 20;

void setup() {
  size(600, 400);
  grid = new Ball[rows][cols];
  fill(0);
  makeBalls(grid);

  // create paddle at bottom center
  paddle = new Ball(new PVector(width/2, height - 30), paddleWidth);
  paddle.yspeed = 0;
  paddle.xspeed = 0;

  newProjectile(pSize);
}

void draw() {
  background(255);

  drawGrid(grid);

  // draw paddle (Ball shape but flattened)
  fill(0);
  rectMode(CENTER);
  rect(paddle.center.x, paddle.center.y, paddleWidth, paddleHeight);

  projectile.move();
  projectile.display();

  processCollisions(projectile, grid);
}

void keyPressed() {

  // move paddle left/right with A and D
  if (key == 'a') {
    paddle.center.x -= 15;
  }
  if (key == 'd') {
    paddle.center.x += 15;
  }

  // launch projectile upward
  if (key == ' ') {
    projectile.yspeed = -3;
  }
}

void makeBalls(Ball[][] g) {
  float startX = 200;
  float startY = 100;
  for (int r = 0; r < rows; r++) {
    for (int c = 0; c < cols; c++) {
      float x = startX + c * ballSize;
      float y = startY + r * ballSize;
      Ball b = new Ball(new PVector(x, y), ballSize);
      g[r][c] = b;
    }
  }
}

void newProjectile(int psize) {
  // projectile starts sitting on top of the paddle
  float x = paddle.center.x;
  float y = paddle.center.y - 25;

  projectile = new Ball(new PVector(x, y), psize);
  projectile.xspeed = 0;
  projectile.yspeed = 0;
}

void drawGrid(Ball[][] g) {
  for (int r = 0; r < rows; r++) {
    for (int c = 0; c < cols; c++) {
      if (g[r][c] != null) {
        g[r][c].display();
      }
    }
  }
}

void processCollisions(Ball p, Ball[][] g) {
  for (int r = 0; r < rows; r++) {
    for (int c = 0; c < cols; c++) {
      Ball b = g[r][c];
      if (b != null && p.collisionCheck(b)) {
        g[r][c] = null;
        newProjectile(pSize); // reset projectile after hit
        return;
      }
    }
  }
}

