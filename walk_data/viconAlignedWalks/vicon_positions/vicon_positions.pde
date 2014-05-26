import processing.opengl.*;

String file = "Mvp-23.csv";

// Variables to calculate frame alignment to Orient data.
float ViconStartFrame = 394;
/*
  All Vicon start frames:
  [460, 285, 286, 394; ... % M 
  367, 374, 508, 330; ...  % T 
  417, 477, 444, 524; ...  % R 
  455, 380, 301, 314; ...  % S 
  421, 453, 354, 365; ];   % J 

  For file numbers:
  [10, 18, 19, 23; ... % M 
  6,  9, 12, 13; ...    % T 
  11, 14, 15, 20; ...   % R
  5,  7, 10, 14; ...    % S 
  4,  6, 14, 15;];      % J
  
  With Orient frame rates:
  [42.667; ... % M
  42.667; ...  % T
  51.2; ...    % R
  42.667]]]]; ...  % S
  42.667];     % J
*/
float ViconFPS = 100;
float OrientFPS = 42.667;

int drawRate = 10;
int startTimer;

Table vicon_data;

float eyeX, eyeY, eyeZ, centreX, centreY, centreZ;
float cameraXrotation, cameraYrotation, cameraZrotation;

boolean autoPlay = true;
int currentFrame = 0;
int prevFrame = -1;
int numFrames;

void setup() {
  size(1500, 800, OPENGL);
  
  vicon_data = loadTable(file, "header");
  numFrames = vicon_data.getRowCount();

  println(vicon_data.getRowCount() + " total rows in table"); 
  
  startTimer = millis();
}


void draw(){
  
  if ((millis() - startTimer) > drawRate) {
    
    if (currentFrame != prevFrame) {
      // Output Orient data aligned frame number.
      println((ViconStartFrame+currentFrame) * OrientFPS/ViconFPS);
    }
    
    prevFrame = currentFrame;
    
    background(0);
    lights();
    stroke(255,255,255);
    strokeWeight(5);
    
    TableRow row = vicon_data.getRow(currentFrame);
    
    eyeX = row.getFloat("SACR:X")+1500;
    eyeY = row.getFloat("SACR:Y");
    eyeZ = row.getFloat("SACR:Z");
    centreX = row.getFloat("SACR:X");
    centreY = row.getFloat("SACR:Y");
    centreZ = row.getFloat("SACR:Z")-600;
    positionCamera();
      
    line(row.getFloat("RTOE:X"),row.getFloat("RTOE:Y"),row.getFloat("RTOE:Z"),row.getFloat("RHEE:X"),row.getFloat("RHEE:Y"),row.getFloat("RHEE:Z"));
    line(row.getFloat("RHEE:X"),row.getFloat("RHEE:Y"),row.getFloat("RHEE:Z"),row.getFloat("RANK:X"),row.getFloat("RANK:Y"),row.getFloat("RANK:Z"));
    line(row.getFloat("RANK:X"),row.getFloat("RANK:Y"),row.getFloat("RANK:Z"),row.getFloat("RTIB:X"),row.getFloat("RTIB:Y"),row.getFloat("RTIB:Z"));
    line(row.getFloat("RTIB:X"),row.getFloat("RTIB:Y"),row.getFloat("RTIB:Z"),row.getFloat("RKNE:X"),row.getFloat("RKNE:Y"),row.getFloat("RKNE:Z"));
    line(row.getFloat("RKNE:X"),row.getFloat("RKNE:Y"),row.getFloat("RKNE:Z"),row.getFloat("RTHI:X"),row.getFloat("RTHI:Y"),row.getFloat("RTHI:Z"));
    line(row.getFloat("RTHI:X"),row.getFloat("RTHI:Y"),row.getFloat("RTHI:Z"),row.getFloat("RASI:X"),row.getFloat("RASI:Y"),row.getFloat("RASI:Z"));
    line(row.getFloat("RASI:X"),row.getFloat("RASI:Y"),row.getFloat("RASI:Z"),row.getFloat("SACR:X"),row.getFloat("SACR:Y"),row.getFloat("SACR:Z"));
    line(row.getFloat("SACR:X"),row.getFloat("SACR:Y"),row.getFloat("SACR:Z"),row.getFloat("LASI:X"),row.getFloat("LASI:Y"),row.getFloat("LASI:Z"));
    line(row.getFloat("LASI:X"),row.getFloat("LASI:Y"),row.getFloat("LASI:Z"),row.getFloat("LTHI:X"),row.getFloat("LTHI:Y"),row.getFloat("LTHI:Z"));
    line(row.getFloat("LTHI:X"),row.getFloat("LTHI:Y"),row.getFloat("LTHI:Z"),row.getFloat("LKNE:X"),row.getFloat("LKNE:Y"),row.getFloat("LKNE:Z"));
    line(row.getFloat("LKNE:X"),row.getFloat("LKNE:Y"),row.getFloat("LKNE:Z"),row.getFloat("LTIB:X"),row.getFloat("LTIB:Y"),row.getFloat("LTIB:Z"));
    line(row.getFloat("LTIB:X"),row.getFloat("LTIB:Y"),row.getFloat("LTIB:Z"),row.getFloat("LANK:X"),row.getFloat("LANK:Y"),row.getFloat("LANK:Z"));
    line(row.getFloat("LANK:X"),row.getFloat("LANK:Y"),row.getFloat("LANK:Z"),row.getFloat("LHEE:X"),row.getFloat("LHEE:Y"),row.getFloat("LHEE:Z"));
    line(row.getFloat("LHEE:X"),row.getFloat("LHEE:Y"),row.getFloat("LHEE:Z"),row.getFloat("LTOE:X"),row.getFloat("LTOE:Y"),row.getFloat("LTOE:Z"));
    
    if (autoPlay) {
      currentFrame = modulo(currentFrame + 1, numFrames);
    }
    
    startTimer = millis();
  }
  
}

// Positions camera facing the sacral point (the lower back in the Vicon data).  Also applies rotations and offsets with respect to the sacral point.
void positionCamera() {
  float[] eye = {eyeX, eyeY, eyeZ};
  eye[0] -= centreX;
  eye[1] -= centreY;
  eye[2] -= centreZ;
  eye = rotatePointAboutXAxis(eye, cameraXrotation);
  eye = rotatePointAboutYAxis(eye, cameraYrotation);
  eye = rotatePointAboutZAxis(eye, cameraZrotation);
  eye[0] += centreX;
  eye[1] += centreY;
  eye[2] += centreZ;
  camera(eye[0], eye[1], eye[2], centreX, centreY, centreZ, 0, 0, -1); 
}

// TODO: Add keypress to step through frames.  Display frame number.

// Keypress handler for camera rotations.  Camera is configured to always point at the sacral point of the vicon data (the lower back).
void keyPressed() {
  // Rotations about axis centred on sacral point (lower back).
  if (key == 'q') {
    cameraXrotation += 0.4;
  } else if (key =='w') {
    cameraXrotation -= 0.4;
  } else if (key =='a') {
    cameraYrotation += 0.2;
  } else if (key =='s') {
    cameraYrotation -= 0.2;
  } else if (key =='z') {
    cameraZrotation += 0.2;
  } else if (key =='x') {
    cameraZrotation -= 0.2;
  // Keys to step through frames or autoplay.
  } else if (key =='p') {
    autoPlay = false;
  } else if (key =='[') {
    autoPlay = false;
    currentFrame = modulo(currentFrame - 1, numFrames);
  } else if (key ==']') {
    autoPlay = false;
    currentFrame = modulo(currentFrame + 1, numFrames);
  } else if (key =='r') {
    autoPlay = true;
  }
}

// Matricies for rotating points around axes at the origin
float[] rotatePointAboutXAxis(float[] P, float radians) {
  float[][] Xrotate = {
  {1.0, 0.0, 0.0},
  {0.0, cos(radians), -sin(radians)},
  {0.0, sin(radians), cos(radians)}
  };
  return rotateAboutAxis(Xrotate, P);
}

float[] rotatePointAboutYAxis(float[] P, float radians) {
  float[][] Yrotate = {
  {cos(radians), 0.0, sin(radians)},
  {0.0, 1.0, 0.0},
  {-sin(radians), 0, cos(radians)}
  };
  return rotateAboutAxis(Yrotate, P);
}

float[] rotatePointAboutZAxis(float[] P, float radians) {
  float[][] Zrotate = {
  {cos(radians), -sin(radians), 0.0},
  {sin(radians), cos(radians), 0.0},
  {0.0, 0, 1.0}
  };
  return rotateAboutAxis(Zrotate, P);
}

// Matrix multiplication function
float[] rotateAboutAxis(float[][] rotationMatrix, float[] P) {
  float[] R = new float[3];
  for (int r=0; r < R.length; r++) {
     for (int i=0; i < P.length; i++) {
       R[r] += rotationMatrix[r][i] * P[i];
     }
  }
  return R;
}

int modulo(int a, int b) { 
 a = a % b; 
 if(a < 0) a+=b; 
 return(a); 
}
