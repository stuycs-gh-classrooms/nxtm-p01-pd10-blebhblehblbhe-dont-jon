// ----------------------
// GLOBALS
// ----------------------
Ball ball;
Paddle paddle;

int rows = 5;
int cols = 10;
int brickW = 50;
int brickH = 20;
boolean[][] bricks;

// ----------------------
void setup() {
  size(500, 500);

  paddle = new Paddle();
  ball = new Ball(paddle);

  bricks = new boolean[rows][cols];
  for (int r = 0; r < rows; r++) {
    for (int c = 0; c < cols; c++) {
      bricks[r][c] = true; 
    }
  }
}

// ----------------------
void draw() {
  background(0);

  // paddle movement
  paddle.update();
  paddle.show();

  // draw bricks + check collision
  drawBricks();

  // ball update + show
  ball.update();
  ball.show();
}

// ----------------------
void keyPressed() {
  // launch ball
  if (key == ' ') {
    ball.stuckToPaddle = false;
  }
}

// ======================================================
// PADDLE CLASS
// ======================================================
class Paddle {
  float w = 80;
  float h = 15;
  float x;
  float y;

  Paddle() {
    y = height - 40;
    x = width/2 - w/2;
  }

  void update() {
    // paddle follows mouse
    x = mouseX - w/2;

    // keep inside screen
    x = constrain(x, 0, width - w);
  }

  void show() {
    fill(255);
    rect(x, y, w, h);
  }
}

// ======================================================
// BALL CLASS
// ======================================================
class Ball {
  float x, y;
  float r = 10;
  float vx = 4;
  float vy = -4;

  boolean stuckToPaddle = true;   // makes ball follow paddle at start
  Paddle p;

  Ball(Paddle p_) {
    p = p_;
    x = p.x + p.w/2;
    y = p.y - r;
  }

  void update() {
    if (stuckToPaddle) {
      // follow paddle
      x = p.x + p.w/2;
      y = p.y - r;
      return;
    }

    x += vx;
    y += vy;

    // bounce walls
    if (x < r || x > width - r) vx *= -1;
    if (y < r) vy *= -1;

    // bounce on paddle
    if (y + r >= p.y && y + r <= p.y + p.h && x > p.x && x < p.x + p.w) {
      vy *= -1;
      y = p.y - r;
    }

    // fall below screen -> reset
    if (y > height) {
      stuckToPaddle = true;
    }

    // brick collision
    checkBrickHit();
  }

  void show() {
    fill(255, 150, 0);
    ellipse(x, y, r*2, r*2);
  }

  // check brick collision
  void checkBrickHit() {
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        if (bricks[r][c]) {
          float bx = c * brickW;
          float by = r * brickH;

          if (x + this.r > bx && x - this.r < bx + brickW && 
              y + this.r > by && y - this.r < by + brickH) {

            bricks[r][c] = false;
            vy *= -1;   // bounce
            return;
          }
        }
      }
    }
  }
}

// ======================================================
// DRAW BRICKS
// ======================================================
void drawBricks() {
  for (int r = 0; r < rows; r++) {
    for (int c = 0; c < cols; c++) {
      if (bricks[r][c]) {
        fill(200, 50, 50);
        rect(c * brickW, r * brickH, brickW, brickH);
      }
    }
  }
}
