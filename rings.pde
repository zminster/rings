// global parameters
final float STARTING_DIAMETER = 5;
final float DIAMETER_GROWTH_RATE = 10;
final int   RING_CREATE_RATE = 1;  // rings created every "N" frames

class ExpandingRing {
  float d;
  color c;
  
  ExpandingRing(color _c) {
    c = _c;
    d = STARTING_DIAMETER;
  }
  
  void iterate() {
    d += DIAMETER_GROWTH_RATE;
    fill(c);
    ellipse(width / 2, height / 2, d, d);
  }  
}

ArrayList<ExpandingRing> rings;
color a, b;    // gradient will be between colors a & b
float t;       // t parameter controls gradient fraction
float delta_t; // delta_t is current rate of change of t

void setup() {
  ellipseMode(CENTER);
  rings = new ArrayList<ExpandingRing>();
  size(800,600);
  a = color(random(255),random(255),random(255));
  b = color(random(255),random(255),random(255));
  t = 0;
  delta_t = 0.01;
  noStroke();
}

// generates a color linearly between a and b: t% of a and (1-t)% of b
color colorFrac(color a, color b, float t) {
  float r = red(a) * t + red(b) * (1 - t);
  float g = green(a) * t + green(b) * (1 - t);
  float bl = blue(a) * t + blue(b) * (1 - t);
  return color(r,g,bl);
}

void draw() {
  // maintain linear gradient parameter t
  t += delta_t;
  if (t > 1 || t < 0)
    delta_t *= -1;
  
  // add ring every RING_CREATE_RATE frames
  if (frameCount % RING_CREATE_RATE == 0) {
    rings.add(new ExpandingRing(colorFrac(a,b,t)));
  }
  
  // temporary list to mark rings for deletion
  ArrayList<ExpandingRing> markedForDeletion = new ArrayList<ExpandingRing>();
  
  for (ExpandingRing r : rings) {
    r.iterate();
    if (r.d > width + width / 2)        // if diameter exceeds threshold
      markedForDeletion.add(r);   // mark for deletion
  }
  
  // remove all ExpandingRing objects marked for deletion
  // (avoids concurrent modification error on rings list)
  for (ExpandingRing r : markedForDeletion) {
    rings.remove(r);  // garbage collector will remove these later on
  }
}