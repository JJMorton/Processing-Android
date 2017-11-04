int adjust = 0;
float adjustOrigin;

int r, g, b;

Property[] properties = new Property[3];

void setup() {
  
  orientation(LANDSCAPE);
  fullScreen();
  smooth(4);
  textAlign(CENTER, CENTER);
  strokeWeight(2);
  
  properties[0] = new Property("Vertices", 4, 3, 10, 0);
  properties[1] = new Property("Shapes", 1, 1, 30, 0);
  properties[2] = new Property("Shrink", 0, 0, 100, 0);
  
}

void draw() {
  
  background(0);
  
  r = 55 + floor(200 * noise(frameCount/600f));
  g = 55 + floor(200 * noise((frameCount + 1000)/600f));
  b = 55 + floor(200 * noise((frameCount + 1000000)/600f));
  
  noStroke();
  strokeWeight(2);
  
  fill(255, 200);
  textSize(height/20);
  text(properties[adjust].getName(), width/2, 7*height/8);
  
  if (mousePressed && properties[adjust].isActive()) {
    properties[adjust].update(mouseY);
  }
  
  float radius = 3*height/9;
  
  int points = round(properties[0].getValue());
  int clones = round(properties[1].getValue());
  float shrink = (radius / clones) * (properties[2].getValue() / 100);
  
  float angle = 0;
  float deltaAngle = 2 * PI / (points * clones);
  
  float x, y;
  
  noFill();
  stroke(r, g, b);
  
  for (int i = 0; i < clones; i++) {
    float hTime = 0;
    float vTime = 0;
    
    beginShape();
    for (int j = 0; j < points; j++) {
      x = sin(hTime + angle - frameCount/600f) * radius;
      y = cos(vTime + angle - frameCount/600f) * radius;
      vertex(x + width/2, y + height/2);
      
      hTime += 2 * PI / points;
      vTime += 2 * PI / points;
    }
    endShape(CLOSE);
    
    angle += deltaAngle;
    radius -= shrink;
  }
  
  fill(255);
  noStroke();
  textSize(height/10);
  text("<", width/8, height/2);
  text(">", 7*width/8, height/2);
  
}

void mousePressed() {
  
  if (mouseX < width/4) {
    adjust -= 1;
    if (adjust < 0) {
      adjust = properties.length - 1;
    }
  } else if (mouseX > 3*width/4) {
    adjust += 1;
    if (adjust > properties.length - 1) {
      adjust = 0;
    }
  } else {
    properties[adjust].start(mouseY);
  }
  
}

void mouseReleased() {
  
  properties[adjust].stop();
  
}