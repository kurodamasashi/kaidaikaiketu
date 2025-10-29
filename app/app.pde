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
int changeBack = 100; 

boolean gameOver = false;

int level = 1;             // 現在のレベル
boolean showLevelUp = false;
int levelUpTimer = 0;

// パーティクルリスト
ArrayList<Particle> particles = new ArrayList<Particle>();

PImage hero;

void setup() {
  size(500, 500);
  ballX = width / 2;
  ballY = height / 3;
  paddleY = height - 40;
  hero = loadImage("hero.png");
  textAlign(CENTER, CENTER);
}

void draw() {
  if (score <= changeBack){
    background(30);
  }
  else{
    background(30);
    image(hero, 0, 0, 500, 500);
  }
  
  if (!gameOver) {
    // --- ボール移動 ---
    ballX += ballSpeedX;
    ballY += ballSpeedY;
    
    // --- 壁で反射 ---.
    if (ballX < ballSize/2 || ballX > width - ballSize/2) {
      ballSpeedX *= -1;
    }
    
    // --- 天井で反射 ---
    if (ballY < ballSize/2) {
      ballSpeedY *= -1;
    }
    
    // --- パドル位置（マウス操作） ---
    paddleX = mouseX - paddleWidth / 2;
    paddleX = constrain(paddleX, 0, width - paddleWidth);
    
    // --- パドルとの当たり判定 ---
  if (ballY + ballSize/2 >= paddleY && 
      ballY + ballSize/2 <= paddleY + 20 && // 上面15px以内のみ判定
      ballX > paddleX && ballX < paddleX + paddleWidth &&
      ballSpeedY > 0) {
      
      // パドルのどこに当たったかを計算
      float hitPos = (ballX - (paddleX + paddleWidth/2)) / (paddleWidth/2);
      hitPos = constrain(hitPos, -0.9, 0.9); // ← 角度を制限
      
      ballSpeedY *= -1;
      ballSpeedY *= 1.1; // スピードアップ
      ballSpeedX = hitPos * abs(ballSpeedY);  // 左右の当たり位置で反射角調整
      ballSpeedX *= 1.1;
      
      // 速度上限を設定（極端に速くならないように）
      ballSpeedX = constrain(ballSpeedX, -15, 15);
      ballSpeedY = constrain(ballSpeedY, -15, 15);
      
      // 速度が上がるほど加点が大きくなる
      int point = (int)(abs(ballSpeedY) * 2);
      score += point;
      
      // --- パーティクル発生 ---
      for (int i = 0; i < 10; i++) {
        particles.add(new Particle(ballX, paddleY));
      }
      
      // --- レベルアップ判定 ---
      int newLevel = 1 + (int)(abs(ballSpeedY) / 3);
      if (newLevel > level) {
        level = newLevel;
        showLevelUp = true;
        levelUpTimer = 60; // 約1秒表示
      }
    }
    
    // --- ゲームオーバー判定 ---
    if (ballY - ballSize/2 > height) {
      gameOver = true;
    }
    
    // --- パーティクル更新 ---
    for (int i = particles.size() - 1; i >= 0; i--) {
      Particle p = particles.get(i);
      p.update();
      p.display();
      if (p.life <= 0) {
        particles.remove(i);
      }
    }
    
    // --- 描画 ---
    fill(255, 100, 100);
    ellipse(ballX, ballY, ballSize, ballSize);
    
    fill(100, 200, 255);
    rect(paddleX, paddleY, paddleWidth, paddleHeight);
    
    if (score <= changeBack){
      fill(255);
    }
    else{
      fill(178,34,34);
    }
    textSize(20);
    text("Score: " + score, width/2, 30);
    
  } else {
    // --- ゲームオーバー画面 ---
    if (score <= changeBack){
      fill(255);
    }
    else{
      fill(0);
    }
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

// --- パーティクルクラス ---
class Particle {
  float x, y;
  float vx, vy;
  float life;
  color c;
  
  Particle(float x, float y) {
    this.x = x;
    this.y = y;
    vx = random(-2, 2);
    vy = random(-5, -1);
    life = 40;
    c = color(random(150, 255), random(150, 255), random(100, 255));
  }
  
  void update() {
    x += vx;
    y += vy;
    vy += 0.2; // 重力
    life--;
  }
  
  void display() {
    fill(c, map(life, 0, 40, 0, 255));
    ellipse(x, y, 6, 6);
  }
}
