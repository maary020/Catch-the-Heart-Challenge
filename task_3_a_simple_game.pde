/*
 * Welcome to the Catch-the-Heart Challenge ❤
 * Your mission: Catch the red heart with your yellow paddle.  
 * Miss it, and the game breaks your heart (literally)!
 
 * How to Play?
 * Move your mouse to control the paddle.
 * ❤️Catch the heart to score points.
 
 * Pro Tip: Keep your reflexes sharp—the heart gets faster and harder to catch 
 with every bounce!
 */

int heartX, heartY;    // Heart position
float heartSpeedX = 3;   // Horizontal speed of the heart
float heartSpeedY = 2;   // Vertical speed of the heart
float gravity = 0.1;     // Acceleration (gravity)
int heartSize = 20;    // Heart size (used for heart shape)
int paddleX;     // Paddle position (horizontal)
int paddleWidth = 100;  // Paddle width
int paddleHeight = 10;  // Paddle height
int score = 0;    // Current score
int highScore = 0;    // High score
boolean gameOver = false;  // Game over state

void setup() {
  size(640, 480);   // Size of the drawing area 640x480
  resetGame();   // Initializing the game state
}

void draw() {
  background(0);     // Black background

  // DBrick pattern for the game area
  drawBricks();

  if (gameOver) {
    // Displaying Game Over screen
    displayGameOver();
    return;  // Stop the game loop if the game is over
  }

  // Update heart position
  updateHeartPosition();

  // The heart-shaped ball
  drawHeart(heartX, heartY);

  // Update paddle position and constrain it to the game area
  paddleX = mouseX - paddleWidth / 2;  // Center paddle on mouse
  paddleX = constrain(paddleX, 0, width - 160 - paddleWidth);  // Constrain to game area (480px width)

  // Draw the paddle
  fill(255, 255, 0);  // Yellow paddle
  rect(paddleX, height - paddleHeight, paddleWidth, paddleHeight);

  // Drawing the right-side panel with score and high score
  drawPanel();
}

void resetGame() {
  // Reseting heart to the top with random horizontal position
  heartX = int(random(heartSize / 2, width - 160 - heartSize / 2));  // Game area is 480px width, avoid score panel
  heartY = heartSize / 2;
  heartSpeedX = 3;  // Reset horizontal speed
  heartSpeedY = 2;  // Reset vertical speed
  gravity = 0.1;    // Reset gravity
  score = 0;        // Reset score
  gameOver = false;
}

void updateHeartPosition() {
  // Updating heart position based on its speed
  heartX += heartSpeedX;
  heartY += heartSpeedY;
  heartSpeedY += gravity;  // Apply gravity

  // Checking if the heart hits the paddle
  if (heartY >= height - paddleHeight - heartSize / 2 &&
      heartX > paddleX && heartX < paddleX + paddleWidth) {
    heartSpeedY *= -1;     // Bounce the heart back upward
    heartSpeedY *= 1.1;    // Slightly increase speed
    gravity *= 1.05;       // Increasing gravity for more challenge
    score++;               // Increasing score
    if (score > highScore) {
      highScore = score;   // Updating high score
    }
  }

  // Checking if the heart falls off the screen (missed)
  if (heartY > height) {
    gameOver = true;
  }

  // Checking if the heart hits the left or right wall (within game area of 480px)
  if (heartX <= 0 || heartX >= width - 160 - heartSize) {
    heartSpeedX *= -1;  // Bounce horizontally
  }
}

void drawBricks() {
  // Brick pattern for the background
  stroke(150);  // Gray bricks
  int brickHeight = 40;
  int brickWidth = 80;
  int numRows = height / brickHeight;
  int numCols = width / brickWidth;

  // Drawing the alternating brick colors in the game area
  for (int row = 0; row < numRows; row++) {
    for (int col = 0; col < numCols; col++) {
      fill((col + row) % 2 == 0 ? 50 : 70);  // Alternating brick shades
      rect(col * brickWidth, row * brickHeight, brickWidth, brickHeight);
    }
  }
}

void drawPanel() {
  // Draw the right-side panel background
  fill(30);
  rect(width - 160, 0, 160, height);  // Right side panel

  // Displaying score and high score in the panel
  fill(255);
  textSize(16);
  textAlign(LEFT, TOP);
  text("Game Statistics", width - 150, 20);
  text("Score: " + score, width - 150, 60);
  text("High Score: " + highScore, width - 150, 90);
}

void displayGameOver() {
  // Display Game Over message
  fill(255);
  textSize(32);
  textAlign(CENTER, CENTER);
  text("Game Over!", width / 2, height / 4);  // Centered in the 640x480 canvas
  textSize(16);
  text("Final Score: " + score, width / 2, height / 4 + 40);
  text("High Score: " + highScore, width / 2, height / 4 + 70);
}

void drawHeart(int x, int y) {
  // Function to draw a red heart-shaped ball
  fill(255, 0, 0);  // Red heart
  beginShape();
  vertex(x, y);  // Tip of the heart
  bezierVertex(x - 10, y - 10, x - 20, y + 10, x, y + 20);  // Left side curve
  bezierVertex(x + 20, y + 10, x + 10, y - 10, x, y);        // Right side curve
  endShape(CLOSE);
}
