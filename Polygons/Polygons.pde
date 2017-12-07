int adjust = 0;
boolean tap = false;
boolean showText;
int shortSide, longSide;
float moveToCentre = 0;

float bgX, bgY, bgW, bgH;

int r, g, b;

Property[] properties = new Property[4];
Button btnPrev, btnNext;

void setup() {
  
  orientation(PORTRAIT);
  fullScreen();
  smooth(4);
  textAlign(CENTER, CENTER);
  strokeWeight(2);
  shortSide = min(width, height);
  longSide = max(width, height);
  
  tap = true;
  showText = true;
  
  properties[0] = new Property("Vertices", 4, 3, 10, 0);
  properties[1] = new Property("Shapes", 1, 1, 30, 0);
  properties[2] = new Property("Shrink", 0, 0, 100, 0);
  properties[3] = new Property("Rotate", 100, -200, 200, 0);
  
  btnPrev = new Button("<", 0.2 * width, 0.9 * height, 0.05 * shortSide);
  btnNext = new Button(">", 0.8 * width, 0.9 * height, 0.05 * shortSide);
  
  bgX = btnPrev.getX() - btnPrev.getR() * 0.5;
  bgY = btnPrev.getY() - btnPrev.getR() * 1.5;
  bgW = btnNext.getX() - bgX + btnPrev.getR() * 0.5;
  bgH = (btnPrev.getR() * 2) + btnPrev.getR();
  
}

void draw() {
  
  background(0);
  
  // ##############################
  // Calculate colours
  
  r = 55 + floor(200 * noise(frameCount/600f));
  g = 55 + floor(200 * noise((frameCount + 1000)/600f));
  b = 55 + floor(200 * noise((frameCount + 1000000)/600f));
  
  // ##############################
  // Update currently selected variable
  
  if (mousePressed && properties[adjust].isActive()) {
    properties[adjust].update(mouseY);
  }
  
  // ##############################
  // Draw shapes
  
  float radius = 3*shortSide/9;
  
  int points = round(properties[0].getValue());
  int clones = round(properties[1].getValue());
  float shrink = (radius / clones) * (properties[2].getValue() / 100);
  
  float angle = 0;
  float deltaAngle = (properties[3].getValue() / 100) * 2 * PI / (points * clones);
  
  float x, y;
  
  noFill();
  stroke(r, g, b);
  strokeWeight(3);
  
  for (int i = 0; i < clones; i++) {
    float t = 0;
    
    beginShape();
    for (int j = 0; j < points; j++) {
      x = sin(t + angle - frameCount/600f) * radius;
      y = cos(t + angle - frameCount/600f) * radius;
      
      // move between 0.45 and 0.5 of the height depending on the visibility of the controls
      float yoff = (0.45 + (cos(moveToCentre)-1)*-0.5 * 0.05) * height;
      
      vertex(x + width/2, y + yoff);
      
      t += 2 * PI / points;
    }
    endShape(CLOSE);
    
    angle += deltaAngle;
    radius -= shrink;
  }
  
  // ##############################
  // Draw controls
  
  float bgOff = (cos(moveToCentre)-1)*-0.5 * (height - bgY);
  
  // Background
  noStroke();
  fill(255);
  rect(bgX, bgY + bgOff, bgW, bgH);
  ellipse(bgX, bgY + bgH/2 + bgOff, bgH, bgH);
  ellipse(bgX + bgW, bgY + bgH/2 + bgOff, bgH, bgH);
  
  // Variable name
  noStroke();
  fill(0);
  textSize(shortSide/15);
  text(properties[adjust].getName(), width/2, (0.9 * height) + bgOff);

  // Buttons
  btnPrev.draw(bgOff);
  btnNext.draw(bgOff);
  
  // ##############################
  // Increment offset of shapes
  
  // Stops incrementing once cos(moveToCentre) reaches a max or min
  if (abs(cos(moveToCentre)) != 1) {
    moveToCentre += PI/15;
  }
  
}

void mousePressed() {
  
  if (mouseY < 0.8 * height) {
    tap = true;
  } else {
    tap = false;
  }
  
  if (showText) {
    int max = properties.length - 1;
    
    if (btnPrev.isPressed()) {
      tap = false;
      adjust = constrain(adjust - 1, 0, max);
      
    } else if (btnNext.isPressed()) {
      tap = false;
      adjust = constrain(adjust + 1, 0, max);
      
    } else {
      properties[adjust].start(mouseY);
    }
    
    btnPrev.setActive(adjust > 0);
    btnNext.setActive(adjust < max);
  }
  
}

void mouseDragged() {
  
  tap = false;
  
}

void mouseReleased() {
  
  //if (tap && !btnPrev.isPressed() && !btnNext.isPressed()) {
  if (tap) {
    showText = !showText;
    
    // Reverse the direction that the y offset animation is acting in
    moveToCentre *= -1;
    // Increment once to start the incrementing in the draw loop
    moveToCentre += PI/15;
  }
  
  properties[adjust].stop();
  
}