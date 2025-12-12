// ----------------------
// GLOBALS
// ----------------------
Ball ball;
Paddle paddle;

int rows = 5;
int cols = 10;

int brickW = 50;
int brickH = 20;

boolean gameStart = false;
boolean paused = false;
boolean gameOver = false;

int lives = 3;
int score = 0;

int[][] bricks;   // 0 = gone, 1 = white(10), 2 = red(20), 3 = green(50)

// ----------------------
void setup() {
  size(500, 500);

  paddle = new Paddle();
  ball = new Ball(paddle);

  generateBricks();
}

// ----------------------
void draw() {
  background(0);

  if (gameOver) {
    drawGameOver();
    return;
  }

  drawHUD();

  if (paused) {
    paddle.show();
    ball.show();
    drawBricks();
    return;
  }

  paddle.update();
  paddle.show();

  drawBricks();

  ball.update();
  ball.show();
}

// ----------------------
void keyPressed() {

  if (key == 'a') paddle.left = true;
  if (key == 'd') paddle.right = true;

  if (key == 'r') resetGame();
  
  if (key == ' ') ball.stuckToPaddle = false;


  if (key == 'p' || key == 'P') paused = !paused;
}

void keyReleased() {
  if (key == 'a') paddle.left = false;
  if (key == 'd') paddle.right = false;
}

// ======================================================
//  PADDLE CLASS
// ======================================================
class Paddle {
  float w = 80;
  float h = 15;
  float x;
  float y;
  float speed = 6;

  boolean left = false;
  boolean right = false;

  Paddle() {
    y = height - 40;
    x = width/2 - w/2;
  }

  void update() {
    if (left) x -= speed;
    if (right) x += speed;
    x = constrain(x, 0, width - w); // keep paddle in game
  }

  void show() {
    fill(255);
    rect(x, y, w, h);
  }
}

// ======================================================
//  BALL CLASS
// ======================================================
class Ball {
  float x;
  float y;
  float r = 10;
  float vx = 4;
  float vy = -4;

  boolean stuckToPaddle = true;
  Paddle p;

  Ball(Paddle p_) {
    p = p_;
    x = p.x + p.w/2;
    y = p.y - r;
  }

  void resetBall() {
    stuckToPaddle = true;
    x = p.x + p.w/2;
    y = p.y - r;
    vx = 4;
    vy = -4;
  }

  void update() {

    if (stuckToPaddle) {
      x = p.x + p.w/2;
      y = p.y - r;
      return;
    }

    x += vx;
    y += vy;

    // bounce walls
    if (x < r || x > width - r) vx *= -1;
    if (y < r) vy *= -1;

    // paddle collision
    if (y + r >= p.y && y + r <= p.y + p.h &&
      x > p.x && x < p.x + p.w) {
      vy *= -1;
      y = p.y - r;
    }

    // ball fell
    if (y > height) {
      lives--;
      if (lives <= 0) {
        gameOver = true;
      } else {
        resetBall();
      }
    }

    checkBrickHit();
  }

  void show() {
    fill(255);
    ellipse(x, y, r*2, r*2);
  }

  // brick collision + score
  void checkBrickHit() {
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {

        int type = bricks[r][c];
        if (type == 0) continue;

        float bx = c * brickW;
        float by = r * brickH;

        if (x + this.r > bx && x - this.r < bx + brickW &&
          y + this.r > by && y - this.r < by + brickH) {

          // update score
          if (type == 1) score += 10;
          if (type == 2) score += 20;
          if (type == 3) score += 50;

          bricks[r][c] = 0;
          vy *= -1;
          return;
        }
      }
    }

    // check if board is clear
    if (allBricksGone()) generateBricks();
  }
}

// ======================================================
// BRICK LOGIC
// ======================================================
void generateBricks() {
  bricks = new int[rows][cols];
  for (int r = 0; r < rows; r++) {
    for (int c = 0; c < cols; c++) {
      int randType = int(random(1, 4)); // 1 white, 2 red, 3 green
      bricks[r][c] = randType;
    }
  }
}

boolean allBricksGone() {
  for (int r = 0; r < rows; r++)
    for (int c = 0; c < cols; c++)
      if (bricks[r][c] != 0) return false;
  return true;
}

void drawBricks() {
  for (int r = 0; r < rows; r++) {
    for (int c = 0; c < cols; c++) {

      int type = bricks[r][c];
      if (type == 0) continue;

      if (type == 1) fill(255);         // white
      else if (type == 2) fill(255, 0, 0); // red
      else if (type == 3) fill(0, 255, 0); // green

      rect(c * brickW, r * brickH, brickW, brickH);
    }
  }
}

// ======================================================
// HUD + GAME OVER
// ======================================================
void drawHUD() {
  fill(255);
  textSize(16);
  text("Score: " + score, 10, height - 10);
  text("Lives: " + lives, width - 100, height - 10);
}

void drawGameOver() {
  background(0);
  fill(255, 0, 0);
  textSize(40);
  textAlign(CENTER);
  text("GAME OVER", width/2, height/2 - 20);

  fill(255);
  textSize(20);
  text("Final Score: " + score, width/2, height/2 + 20);
  text("Press r to restart", width/2, height/2 + 60);
}

void resetGame() {
  score = 0;
  lives = 3;
  gameOver = false;
  generateBricks();
  ball.resetBall();
}
