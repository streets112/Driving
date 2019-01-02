
int c_white      = color(255, 255, 255);
int c_darkBlue   = color(0, 255, 75);
int c_grey       = color(127, 127, 127);

int centerRadius = 200;
int outerRadius = 500;



Car mycar;

void setup() {
  size(600, 600);


  mycar = new Car();
}



void draw() {
  frameRate(30);
  print(degrees(mycar.wheelAngle), "\n");
  courseUpdate(); 
  mycar.update();
  
  
}
