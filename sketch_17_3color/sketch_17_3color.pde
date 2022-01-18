// Prompt: "3 colors"
// Sketch: Triadic Color Generator
// Select a color on the screen
// Check out the color triad
// Press spacebar to reset

boolean displayingTriadic;
color selected;

void setup() {
  size(500, 500);
  colorMode(HSB, width);
  noStroke();
  displayingTriadic = false;
  selected = color(0);
}

void draw() {
  if (!displayingTriadic) {
    drawColorSpace();
  } else {
    drawTriadic();
  }
}

void drawColorSpace() {
  for (int x = 0; x < width; x++) {      // hue dimension
    for (int y = 0; y < height; y++) {   // saturation/brightness dimension
      color here = color(x, max(y * 2, 100), y);
      set(x, y, here);
    }
  }
}

void drawTriadic() {
  // calculate triad
  // given color circle's total "degrees" = width, we need to move "1/3 of the way" away twice
  // editorial note: gotta mod by width or overflow looks bad!
  color triadic1 = color((hue(selected) + width/3.0) % width, saturation(selected), brightness(selected));
  color triadic2 = color((hue(selected) + 2*width/3.0) % width, saturation(selected), brightness(selected));
  
  // rects ought to do it!
  fill(selected);
  rect(0, 0, width/3, height);
  fill(triadic1);
  rect(width/3, 0, width/3, height);
  fill(triadic2);
  rect(2*width/3, 0, width/3, height);
}

void mouseClicked() {
  selected = get(mouseX, mouseY);
  displayingTriadic = true;
}

void keyPressed() {
  if (key == ' ') {
    displayingTriadic = false;
  }
}
