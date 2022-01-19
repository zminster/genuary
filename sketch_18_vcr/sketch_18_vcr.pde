// Prompt: "VHS"
// Sketch: Live Type VHS-Style Display
// Type to make letters appear
// Delete key to clear
// Enter to skip lines

// Editorial Note: Oh DEAR the box blur was slow using the kernel "window-slide" method I teach in class
// ...until I realized that we're just multiplying everything by 1/<blur dim> and then accumulating so we end up multiplying the same numbers by 1/<blur dim>
// over and over and over again -- we can cache that (see blurPass() function) because cache rules everything around me

PFont vcr_osd;
String current_message = "";  // master String that contains everything we should be displaying
int[] band_positions;         // see explanation below

float[][] blur_buffer;
final int BLUR_DIM = 5;
final float INVERSE_BLUR_DIM = 1/25.;


void setup() {
  fullScreen();
  strokeWeight(3);

  // Editorial note: font not included in repo (unknown licensing)
  // available here: https://www.dafont.com/vcr-osd-mono.font
  vcr_osd = createFont("VCR_OSD_MONO_1.001.ttf", 124);
  textFont(vcr_osd);

  blur_buffer = new float[width][height];

  // VHS tapes always had those "clustered bands" of noise...
  int clusteredBands = floor(random(3, 6));
  band_positions = new int[clusteredBands];
  for (int band = 0; band < clusteredBands; band++) {
    band_positions[band] = floor(random(height));
  }
}

void draw() {
  background(45);
  vhsNoise();
  textAlign(CENTER, CENTER);
  fill(random(200, 255));
  text(current_message, width/2, height/2);
  blurPass();
}

// deal with updating text
void keyPressed() {
  if (key == DELETE)
    current_message = "";
  else if (key == BACKSPACE) {
    if (current_message.length() > 0)
      current_message = current_message.substring(0, current_message.length() -1);
  } else if (key == ENTER || key == RETURN)
    current_message += '\n';
  else if (key > 31 && key < 256) // only allow valid ASCII printable keys
    current_message += key;
}

// simple "snow" drawer with grey/white lines (like a VHS...do kids even know what that is now)
void vhsNoise() {
  // first we apply the "random" noise underneath
  // lots of lines, various greyscale, various rectangular across widths
  // (blur pass will make it look better)
  // just gonna do this a bunch
  int noiseNum = floor(random(1500, 2000));
  float randLen, randX, randY;

  for (int i = 0; i < noiseNum; i++) {
    stroke(random(100, 255));
    randX = random(width);
    randY = random(height);
    randLen = random(15, 40);
    line(randX, randY, randX + randLen, randY);
  }

  // add & iterate the clustered bands
  for (int band = 0; band < band_positions.length; band++) {
    // generate a lot of stuff in this band
    noiseNum = floor(random(100, 200));
    for (int i = 0; i < noiseNum; i++) {
      stroke(random(175, 255));
      randX = random(width);
      randY = band_positions[band] + random(-40, 40);
      randLen = random(15, 40);
      line(randX, randY, randX + randLen, randY);
    }
    band_positions[band]+=5;
    if (band_positions[band] >= height)  // reset bands at top when they reach the bottom
      band_positions[band] = 0;
  }
}

// the whole snow thing really needs to be blurrrrrry
// so we're gonna do a mad dope box blur (not that dope tbh)
// (requires square blur kernel, any dim)
// (grayscale only because we're rad)
void blurPass() {
  int kernelOffset = BLUR_DIM/2;
  loadPixels();

  // first: just compute the cheapo blur values and stick em in the buffer (see editorial note)
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      blur_buffer[x][y] = red(pixels[y * width + x]) * INVERSE_BLUR_DIM; // red bc it's grayscale anyway
    }
  }

  // second: collect em all from the buffer
  for (int x = kernelOffset; x < width-kernelOffset; x++) {
    for (int y = kernelOffset; y < height-kernelOffset; y++) {
      float blurSum = 0;  // collect em all
      for (int kx = 0; kx < BLUR_DIM; kx++) {
        for (int ky = 0; ky < BLUR_DIM; ky++) {
          blurSum += blur_buffer[x + kx - kernelOffset][y + ky - kernelOffset];
        }
      }
      pixels[y * width + x] = color(blurSum);
    }
  }
  updatePixels();
}
