// --- ゲーム変数 ---
float ballX, ballY;        // ボールの位置
float ballSpeedX = 3;      // ボールのX速度
float ballSpeedY = 3;      // ボールのY速度
float ballSize = 20;       // ボールの直径

float paddleX;             // パドルのX位置
float paddleY;             // パドルのY位置
float paddleWidth = 80;    // パドルの幅（少し狭く）
float paddleHeight = 15;   // パドルの高さ

int score = 0;             // スコア
boolean gameOver = false;

void setup() {
  size(500, 500);
  ballX = width / 2;
  ballY = height / 3;
  paddleY = height - 40;
  textAlign(CENTER, CENTER);
}

void draw() {
  background(30);
  
  if (!gameOver) {
    // --- ボール移動 ---
    ballX += ballSpeedX;
    ballY += ballSpeedY;
    
    // --- 壁で反射 ---
    if (ballX < ballSize/2 || ballX > width - ballSize/2) {
      ballSpeedX *= -1;
    }
    if (ballY < ballSize/2) {
      ballSpeedY *= -1;
    }
    
    // --- パドル位置（マウス操作） ---
    paddleX = mouseX - paddleWidth / 2;
    paddleX = constrain(paddleX, 0, width - paddleWidth);
    
    // --- パドルとの当たり判定 ---
    if (ballY + ballSize/2 >= paddleY && 
        ballX > paddleX && ballX < paddleX + paddleWidth && 
        ballSpeedY > 0) {
      ballSpeedY *= -1;
      
      // 速度アップ
      ballSpeedY *= 1.05;
      ballSpeedX *= 1.05;
      
      // 速度が上がるほど加点が大きくなる
      int point = (int)(abs(ballSpeedY) * 2);
      score += point;
    }
    
    // --- ゲームオーバー判定 ---
    if (ballY - ballSize/2 > height) {
      gameOver = true;
    }
    
    // --- 描画 ---
    fill(255, 100, 100);
    ellipse(ballX, ballY, ballSize, ballSize);
    
    fill(100, 200, 255);
    rect(paddleX, paddleY, paddleWidth, paddleHeight);
    
    fill(255);
    textSize(20);
    text("Score: " + score, width/2, 30);
    
  } else {
    // --- ゲームオーバー画面 ---
    fill(255);
    textSize(30);
    text("GAME OVER", width/2, height/2 - 30);
    textSize(20);
    text("Score: " + score, width/2, height/2 + 10);
    text("Click to Restart", width/2, height/2 + 40);
    
    if (mousePressed) {
      resetGame();
    }
  }
}

void resetGame() {
  ballX = width / 2;
  ballY = height / 3;
  ballSpeedX = 3;
  ballSpeedY = 3;
  score = 0;
  gameOver = false;
}
