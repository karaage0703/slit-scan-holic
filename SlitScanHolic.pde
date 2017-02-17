/**
 * Slit Scan Holic  
 * by karaage0703  
 * 
 * Load a Video and compose slit scaned photo
 */

import processing.video.*;
boolean redraw = false;
boolean create_image = false;

PImage output_img;
int video_frame = 0;
int video_speed = 1;
int row = 0;

Movie video;

void setup() {
  size(640, 480);
  output_img = loadImage("title.png");
  video = new Movie(this, "dummy.mp4");

  selectInput("Select a file to process:", "fileSelected");
}

void fileSelected(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    println("User selected " + selection.getAbsolutePath());
    video = new Movie(this, selection.getAbsolutePath());
    video.loop();

    redraw = true;
  }
}


void movieEvent(Movie m) {
  m.read();
}

void slitscanprocess(){
  if(video.available() == true){
    if(create_image == false){
      output_img = createImage(video.width, video.height, RGB);
      for (int y = 0; y < video.height; y++){
        for (int x = 0; x < video.width; x++){
        int pixel_index = y*video.width + x;
        output_img.pixels[pixel_index] = color(0,0,0);
        }
      }
      create_image = true;
    }

    setFrame(video_frame);
    video_frame += video_speed;
    video.loadPixels();

    for (int x = 0; x < video.width; x++){
      int pixel_index = row*video.width + x;
      output_img.pixels[pixel_index] = video.pixels[pixel_index];
    }
    output_img.updatePixels();

    row++;
    if(row >= video.height){
      redraw = false;
      output_img.save("slitscan.jpg");
    }
  }
}
  
 
void draw() {
  if(redraw == true){
    slitscanprocess();
  }  

  image(output_img, 0, 0, width, height);

  if(redraw == true){
    text((int)((float)(row) * 100/ (float)(video.height)) + "%", 10, 30);
//    text((row + " / " + video.height), 10, 50);
  }
}

int getFrame() {    
  return ceil(video.time() * 30) - 1;
}

void setFrame(int n) {
//  video.play();
    
  // The duration of a single frame:
  float frameDuration = 1.0 / video.frameRate;
    
  // We move to the middle of the frame by adding 0.5:
  float where = (n + 0.5) * frameDuration; 
    
  // Taking into account border effects:
  float diff = video.duration() - where;
  if (diff < 0) {
    where += diff - 0.25 * frameDuration;
  }
    
  video.jump(where);
//  video.pause();  
}  

int getLength() {
  return int(video.duration() * video.frameRate);
}