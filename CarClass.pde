//<>// //<>// //<>// //<>// //<>// //<>// //<>//


class Car {

  // gross car dimensions
  float carWidth =10;
  float carHeight = 60;
  float carCornerAngle = atan(carWidth/carHeight);
  float carCornerDist = pythag(carWidth/2, carHeight/2);
  int maxWheelAngle = 90;
  float wheelTurn = 5;

  // car color
  color c;

  // location of center of car
  float posx;
  float posy;

  // straight line velocity of car
  float speed;

  // angle at which car is travelling relative to global
  float angle=1;
  float fr_posx, fr_posy, rr_posx, rr_posy, rl_posx, rl_posy, fl_posx, fl_posy;

  // angle at which the wheels will influence the car angle at next position
  float wheelAngle = 0;

  // flags for turning criteria
  boolean turnLeft = false;
  boolean turnRight = false;

  // flags for acceleration or braking
  boolean accel = false;
  boolean brake = false;

  // flag for reset
  boolean crashed = false;

  // global position of center of rotation for turning
  float xCoord, yCoord;

  // location of center of car to center of rotation of car relative to car
  float distanceToRotation;
  float angleToRotation;
  float angle_CarAlongCoR;

  // debug messages
  float message1, message2;


  Car() {
    c = color(255, 0, 0);
    posx = width/2-200;
    posy = height/2 ;
    speed = 1;
    angle = 0;
  }



  void displayCar() {
    stroke(0);
    fill(c);
    rectMode(CENTER);


    pushMatrix();
    translate(posx, posy);
    rotate(angle);
    rect(0, 0, carHeight, carWidth);
    popMatrix();

    carExtents();
  }

  void carExtents() {

    // position of front right corner
    fr_posx = posx+carCornerDist*cos(angle+carCornerAngle);
    fr_posy = posy+carCornerDist*sin(angle+carCornerAngle);

    // position of rear right corner
    rr_posx = posx+carCornerDist*cos(PI+angle-carCornerAngle);
    rr_posy = posy+carCornerDist*sin(PI+angle-carCornerAngle);
    // position of rear left corner
    rl_posx = posx+carCornerDist*cos(PI+angle+carCornerAngle);
    rl_posy = posy+carCornerDist*sin(PI+angle+carCornerAngle);


    // position of front left corner
    fl_posx = posx+carCornerDist*cos(angle-carCornerAngle);
    fl_posy = posy+carCornerDist*sin(angle-carCornerAngle);
    strokeWeight(2);
    stroke(255, 0, 0);
    ellipse(mycar.fr_posx, mycar.fr_posy, 3, 3);
    stroke(255, 255, 0);
    ellipse(mycar.fl_posx, mycar.fl_posy, 3, 3);
    stroke(255, 0, 255);
    ellipse(mycar.rr_posx, mycar.rr_posy, 3, 3);
    stroke(0, 0, 0);
    ellipse(mycar.rl_posx, mycar.rl_posy, 3, 3);
  }

  float pythag(float a, float b) {
    return sqrt(pow(a, 2)+pow(b, 2));
  }



  void update() {
    if (!crashed) {
      if (turnLeft) {
        if (wheelAngle>=radians(-maxWheelAngle+degrees(atan2(carWidth, carHeight)))+radians(wheelTurn)) {
          wheelAngle+=radians(-wheelTurn);
        } else {
          wheelAngle = radians(-maxWheelAngle+degrees(atan2(carWidth, carHeight)));
        }
      }
      if (turnRight) {
        if (wheelAngle<=radians(maxWheelAngle)-radians(wheelTurn)) {
          wheelAngle+=radians(wheelTurn);
        } else {
          wheelAngle = radians(maxWheelAngle);
        }
      }
      if (accel) {
        speed+=.5;
      }
      if (brake) {
        if (speed>=-5) {
          speed-=.5;
        } else
        {
          speed = -5;
        }
      }
      centerOfRotation();
    }
  }

  void centerOfRotation() {

    if (abs(wheelAngle)<radians(3)) {
      distanceToRotation = 0;
      driveStraight();
      return;
    }

    distanceToRotation = pythag(carWidth/2 + carHeight * 1/tan(wheelAngle), carHeight/2);
    angleToRotation = atan2(carWidth/2 + carHeight * 1/tan(wheelAngle), carHeight/2);


    yCoord = posy + distanceToRotation*sin(PI-angleToRotation+angle);
    xCoord = posx + distanceToRotation*cos(PI-angleToRotation+angle);
    fill(0, 0, 0, 0);
    strokeWeight(1);

    ellipse(xCoord, yCoord, carHeight * 2/tan(wheelAngle), carHeight * 2/tan(wheelAngle));
    ellipse(xCoord, yCoord, carHeight * 2/tan(wheelAngle)+2*carWidth, carHeight * 2/tan(wheelAngle)+2*carWidth);
    stroke(0);    
    ellipse(xCoord, yCoord, 2*pythag(carHeight * 1/tan(wheelAngle), carHeight), 2*pythag(carHeight * 1/tan(wheelAngle), carHeight) );
    stroke(0);    
    ellipse(xCoord, yCoord, distanceToRotation*2, distanceToRotation*2);
    lineAngle(fr_posx, fr_posy, -wheelAngle-angle, 30);
    //  print(xCoord, "\t", yCoord);
    driveAlongArc();
  }



  void driveAlongArc() {

    // just use straight line speed if wheel angle small
    if (distanceToRotation==0) {


      posx += speed*cos(angle);
      posy += speed*sin(angle);
    } else {

      angle_CarAlongCoR = speed/distanceToRotation;
      // move reference point to center of rotation


      // using speed as arc length, and center of rotation as center of rotation, distanceToRotation as radius
      // get relative difference of just the effect of turning

      //float nonArcTravel = 2*distanceToRotation*sin(angle_CarAlongCoR/2);


      //posx += nonArcTravel*cos(angle+angle_CarAlongCoR);
      //posy += nonArcTravel*sin(angle+angle_CarAlongCoR);


print("bugga boo\n");
      if (wheelAngle>radians(3)) {
        float angleInCircle = atan2(posx-xCoord,posy-yCoord);
        print("xCoord", xCoord, "yCoord", yCoord, degrees(angleInCircle), "angl"); //<>//
        print("\t", posx, "\t");
        posx = xCoord + distanceToRotation * cos(angleInCircle + angle_CarAlongCoR);
        posy = yCoord + distanceToRotation * sin(angleInCircle + angle_CarAlongCoR);
        print(posx); //<>//
        
        angle += angle_CarAlongCoR;
        // update car to new angle caused by turn
      } else if (wheelAngle<0) {
        angle -= angle_CarAlongCoR;
        // update car to new angle caused by turn
      }
    }
    ellipse(xCoord, yCoord, 5, 5);
    displayCar();
    strokeWeight(1);
    stroke(0);
    pushMatrix();
    translate(posx, posy);
    rotate(angle);
    line(carHeight, 0, carHeight+30, 0);
    popMatrix();
  }

  void driveStraight() {
    posx = posx+speed*cos(angle);
    posy = posy+speed*sin(angle);
    displayCar();
    strokeWeight(1);
    stroke(0);
    pushMatrix();
    translate(posx, posy);
    rotate(angle);
    line(carHeight, 0, carHeight+30, 0);
    popMatrix();
  }


  void lineAngle(float x, float y, float angle, float length)
  {
    line(x, y, x+cos(angle)*length, y-sin(angle)*length);
  }
}
