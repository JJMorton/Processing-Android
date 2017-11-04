public class Property {
  
  private String name;
  private int precision;
  private float prevValue, value, min, max, origin;
  private boolean active;
  
  public Property(String name, float init, float min, float max, int precision) {
    this.name = name;
    this.value = init;
    this.min = min;
    this.max = max;
    this.precision = precision;
    
    prevValue = value;
    
    active = false;
  }
  
  public float getValue() {
    return value;
  }
  
  public String getFormattedValue() {
    return String.format(java.util.Locale.US,"%." + str(precision) + "f", value);
  }
  
  public void start(float pos) {
    active = true;
    origin = pos;
  }
  
  public void stop() {
    active = false;
    prevValue = value;
  }
  
  public boolean isActive() {
    return active;
  }
  
  public void update(float pos) {
    int factor = (int) pow(10, precision);
    this.value = round(constrain(prevValue + (pos - origin) / (1.5 * height / (min - max)), min, max) * factor) / factor;
  }
  
  public String getName() {
    return name;
  }
  
}