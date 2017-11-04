public class Mass {
  
  protected PVector pos;
  protected float r;
  protected color c;
  
  public Mass(int x, int y, float r) {
    this.pos = new PVector(x, y);
    this.r = r;
    this.c = color(255, 255, 255);
  }
  
  public void show() {
    noStroke();
    fill(c);
    ellipse(pos.x, pos.y, r*2, r*2);
  }
  
  public PVector getPos() {
    return pos;
  }
  
  public float getMass() {
    return 2 * PI * r;
  }
  
  public float getR() {
    return r;
  }
  
  public void setR(float r) {
    this.r = r;
  }
  
}

public class Player extends Mass {
  
  private PVector vel, acc;
  
  public Player(int x, int y, float r, color c) {
    super(x, y, r);
    this.vel = new PVector(-2, -20);
    this.acc = new PVector(0, 0);
    this.c = color(c);
  }
  
  public void applyForce(PVector force) {
    acc.add(force);
  }
  
  public void move() {
    vel.add(acc);
    pos.add(vel);
    
    acc.mult(0);
  }
  
  public void collide(Mass mass) {
    PVector dist = new PVector(pos.x - mass.getPos().x, pos.y - mass.getPos().y);
    if (floor(dist.mag()) < r + mass.getR()) {
      acc.mult(0);
      vel.mult(0);
      dist.normalize();
      dist.mult(r + mass.getR());
      pos = PVector.add(mass.getPos(), dist);
    }
  }
  
  public PVector getGrav(Mass mass) {
    PVector grav;
    PVector dist = new PVector(mass.getPos().x - pos.x, mass.getPos().y - pos.y);
    if (dist.mag() > r + mass.getR()) {
      grav = new PVector(1, 1);
    } else {
      grav = new PVector(0, 0);
    }
    grav.mult((mass.getMass() * this.getMass()) / (float) Math.pow(dist.mag(), 2));
    grav.mult(constG);
    
    grav.rotate(dist.heading() - PI/4);
    
    return grav;
  }
  
}

float constG = 5;
float tempG = constG;

int tempLength = 100;

int adjust = 0;
float adjustOrigin;

ArrayList<Player> players = new ArrayList<Player>();
Mass planet;

void setup() {
  
  orientation(LANDSCAPE);
  fullScreen();
  
  textAlign(CENTER);
  
  for (int i = 0; i < tempLength; i++) {
    players.add(new Player(0, 0, random(4, 7), color(random(100, 255), random(100, 255), random(100, 255))));
  }
  
  planet = new Mass(300, 0, 75);
  
}

void draw() {
  
  background(0);
  
  fill(255);
  stroke(255);
  if (adjust == 1) {
    constG = constrain(tempG + (adjustOrigin - mouseY) / (height / 4), 0F, 10F);
    
    textSize(30);
    text("Strength", width/4, height/2 + 45);
    textSize(90);
    text(String.format(java.util.Locale.US, "%.1f", constG), width/4, height/2);
    
  } else if (adjust == 2) {
    int diff = constrain(tempLength + floor((adjustOrigin - mouseY) / (height / 50)), 1, 500) - players.size();
    if (diff > 0) {
      for (int i = 0; i < diff; i++) {
        players.add(new Player(0, 0, random(4, 7), color(random(100, 255), random(100, 255), random(100, 255))));
      }
    } else if (diff < 0) {
      for (int i = 0; i < abs(diff); i++) {
        players.remove(players.size() - 1);
      }
    }
    
    textSize(30);
    text("Particles", 3*width/4, height/2 + 45);
    textSize(90);
    text(players.size(), 3*width/4, height/2);
  }
  
  for (Player player : players) {
    player.applyForce(player.getGrav(planet));
    player.collide(planet);
    player.move();
  }
  
  PVector trans = PVector.sub(new PVector(width/2, height/2), planet.getPos());
  translate(trans.x, trans.y);
  
  planet.show();
  for (Player player : players) {
    player.show();
    stroke(255);
  }
  
}

void mousePressed() {
  
  PVector trans = PVector.sub(new PVector(width/2, height/2), planet.getPos());
  if (dist((mouseX - trans.x), (mouseY - trans.y), planet.getPos().x, planet.getPos().y) < planet.getR()) {
    players.clear();
    for (int i = 0; i < tempLength; i++) {
      players.add(new Player(0, 0, random(4, 7), color(random(100, 255), random(100, 255), random(100, 255))));
    }
  } else if (mouseX < width/2) {
    adjustOrigin = mouseY;
    adjust = 1;
  } else {
    adjustOrigin = mouseY;
    adjust = 2;
  }
  
}

void mouseReleased() {
  
  tempG = constG;
  tempLength = players.size();
  adjust = 0;
  
}
