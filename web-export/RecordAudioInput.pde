import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;

import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;
import ddf.minim.*;

Minim minim;
AudioInput song;
AudioRecorder recorder;
  FFT fft;
  float threshold;
  float[] angle;
float[] y, x;
 

void setup()
{
  size(800, 600, P3D);
  
  minim = new Minim(this);

  song = minim.getLineIn();
  recorder = minim.createRecorder(song, "myrecording.wav");
  
  textFont(createFont("Arial", 12));
    fft = new FFT(song.bufferSize(), song.sampleRate());
  y = new float[fft.specSize()];
  x = new float[fft.specSize()];
  angle = new float[fft.specSize()];
  frameRate(240);
}

void draw()
{
  background(0);
  stroke(255);
  
  fft.forward(song.mix);
 
    strokeWeight(1.3);
    stroke(#FFF700);
  
    pushMatrix();
    translate(200, 0); 
  

  //closing the transform tool
    popMatrix();
 
  //changing the line color
    stroke(#FF0000);
  
  //the waveform is drawn by connecting neighbor values with a line. 
  //The values in the buffers are between -1 and 1. 
  //If we don't scale them up our waveform will look like a straight line.
  //Thus each of the values is multiplied by 50 
    for(int i = 200; i < song.left.size() - 1; i++)
    {
      line(i, 50 + song.left.get(i)*50, i+1, 50 + song.left.get(i+1)*50);
      line(i, 150 + song.right.get(i)*50, i+1, 150 + song.right.get(i+1)*50);
      line(i, 250 + song.mix.get(i)*50, i+1, 250 + song.mix.get(i+1)*50);
    }
  
  //blue rectangle on the left
    noStroke();
    fill(#0024FF);
    rect(0, 0, 200, height*2/4);
  
  //text
    textSize(24);
    fill(255);
    text("left amplitude", 0, 50); 
    text("right amplitude", 0, 150); 
    text("mixed amplitude", 0, 250); 
    fill(0);
    rect(0,height/2,width,height/2);
     funcabc();
}
void funcabc() {
  noStroke();
  pushMatrix();
  translate(width*2/4, height*3/4);
  for (int i = 0; i < fft.specSize() ; i++) {
    y[i] = y[i] + fft.getBand(i)/100;
    x[i] = x[i] + fft.getFreq(i)/100;
    angle[i] = angle[i] + fft.getFreq(i)/2000;
    rotateX(sin(angle[i]/2));
    rotateY(cos(angle[i]/2));
    //    stroke(fft.getFreq(i)*2,0,fft.getBand(i)*2);
    fill(fft.getFreq(i)*2, 0, fft.getBand(i)*2);
    pushMatrix();
    translate((x[i]+50)%width/3, (y[i]+50)%height/3);
    box(fft.getBand(i)/20+fft.getFreq(i)/15);
    popMatrix();
  }
  popMatrix();
  pushMatrix();
  translate(width/2, height/2, 0);
  for (int i = 0; i < fft.specSize() ; i++) {
    y[i] = y[i] + fft.getBand(i)/1000;
    x[i] = x[i] + fft.getFreq(i)/1000;
    angle[i] = angle[i] + fft.getFreq(i)/100000;
    rotateX(sin(angle[i]/2));
    rotateY(cos(angle[i]/2));
    //    stroke(fft.getFreq(i)*2,0,fft.getBand(i)*2);
    fill(0, 255-fft.getFreq(i)*2, 255-fft.getBand(i)*2);
    pushMatrix();
    translate((x[i]+250)%width, (y[i]+250)%height);
    box(fft.getBand(i)/20+fft.getFreq(i)/15);
    popMatrix();
  }
  popMatrix();
}
 
void stop()
{
  // always close Minim audio classes when you finish with them

  minim.stop();
 
  super.stop();
}


