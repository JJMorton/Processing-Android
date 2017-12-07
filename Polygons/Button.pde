public class Button {
  
  private String label;
  private float x, y, r;
  private boolean active;
  
  public Button(String label, float x, float y, float r) {
    this.label = label;
    this.x = x;
    this.y = y;
    this.r = r;
    
    this.active = true;
  }
  
  public void setActive(boolean active) {
    this.active = active;
  }
  
  public void draw(float yoff) {
    if (active) {
      stroke(0);
      fill(255);
      ellipse(x, y + yoff, r*2, r*2);
      
      noStroke();
      fill(0);
      textSize(r);
      textAlign(CENTER, CENTER);
      text(label, x, y + yoff);
    }
  }
  
  public boolean isPressed() {
    return dist(mouseX, mouseY, x, y) <= r;
  }
  
  public float getX() {
    return x;
  }
  
  public float getY() {
    return y;
  }
  
  public float getR() {
    return r;
  }
  
}