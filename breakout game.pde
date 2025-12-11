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

class Paddle {

}

class Score {

}

class Brick {

}

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

  // collision check for paddle
  if (p.center.y + p.bsize/2 >= paddle.center.y - paddleHeight/2 &&      // vertically touching
      p.center.y - p.bsize/2 <= paddle.center.y + paddleHeight/2 &&
      p.center.x >= paddle.center.x - paddleWidth/2 &&                   // horizontally touching
      p.center.x <= paddle.center.x + paddleWidth/2) 
  {
    p.yspeed = -abs(p.yspeed);   // always bounce upward
  }

  // collision check for bricks
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


