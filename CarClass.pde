class Car { //<>// //<>// //<>// //<>// //<>// //<>// //<>//



  // important car parameters
  // turning information
  float XcenRot;
  float YcenRot;
  float RtoRightWheel;
  float RtoLeftWheel;
  float Rmag;
  float carAngle = 0;

  // cartesian parameters
  float XposRel;
  float YposRel;
  float Xpos;
  float Ypos;


  // wheel parameters
  float wheelAngle = 0;
  int maxWheelAngle = 60;
  float wheelTurn = 2;
  float speed = 1;


  // car physical parameters
  float carLength =50;
  float carWidth =20;


  float A = carLength/tan(maxWheelAngle);
  float B = A+carWidth;
  float carCornerAngle = atan2(  carLength, B) ;

  float carCornerDist = pythag(carWidth/2, carLength/2);



  // relative direction of car -1 left, 0 straight, 1 right turn
  int Gdirect = 0;

  // flags for turning criteria
  boolean turnLeft = false;
  boolean turnRight = false;

  // flags for acceleration or braking
  boolean accel = false;
  boolean brake = false;

  // flag for reset
  boolean crashed = false;


  Car() {
    Xpos = width/2 + 130;
    Ypos = height/2 + 160;

    speed = 0;
    carAngle = PI;
    wheelAngle = 0;
  }





  void update() {
    if (!crashed) {
      if (turnLeft) {

        if (wheelAngle>=radians(-maxWheelAngle)) {

          wheelAngle+=radians(-wheelTurn);
        } else {
          wheelAngle = radians(-maxWheelAngle);
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

      Gdirect = LeftRightStraight();
      centerOfRotation();
    }
  }







  float pythag(float a, float b) {
    // performs pythag on 2 numbers to get hypotenuse
    return sqrt(pow(a, 2)+pow(b, 2));
  }

  int LeftRightStraight() {
    // this function tells if you are going turning left -1, right 1, or straight 0
    if (wheelAngle<radians(-3)) {
      Rmag = carLength * 1/tan(wheelAngle);  // distance to wheel only, not center of car
      return -1;
    } else if (wheelAngle>radians(3)) {
      Rmag = carLength * 1/tan(wheelAngle);
      return 1;
    } else { 
      Rmag = 0;
      return 0;
    }
  }

  void centerOfRotation() {
    // find where the point of rotation is on the global frame
    if (Gdirect==-1||Gdirect==1) {
      XcenRot = Xpos - (Rmag-carWidth/2)*cos(carAngle);
      YcenRot = Ypos - (Rmag-carWidth/2)*sin(carAngle);
    } else {
      XcenRot = 9999999;
      YcenRot = 9999999;
    }
  }



  void drawCar() {

    stroke(0);
    strokeWeight(.5);
    noFill();  
    rectMode(CENTER);

    fill(127);
    // if the car is turning
    if (Gdirect!=0) {
      fill(127);
      pushMatrix();
      translate(XcenRot, YcenRot);
      rotate(carAngle);

      if (Gdirect==-1) {
        rectMode(CENTER);
        rect(Rmag-carWidth/2, carLength/2, carWidth, carLength);
        popMatrix();
        noFill();
        ellipse(XcenRot, YcenRot, Rmag*2, Rmag*2);
      }
      if (Gdirect==1) {
        rectMode(CENTER);
        rect(Rmag-carWidth/2, carLength/2, carWidth, carLength);
        popMatrix();
        noFill();
        ellipse(XcenRot, YcenRot, (Rmag-carWidth)*2, (Rmag-carWidth)*2);
      }
    } else {
      // the car is traveling straight, simplifying the transformations
      pushMatrix();
      translate(Xpos, Ypos);
      rotate(carAngle);

      rect(0, carLength/2, carWidth, carLength);
      popMatrix();
    }

    // draw a direction indicator
    strokeWeight(1);
    stroke(0);
    pushMatrix();
    translate(Xpos, Ypos);
    rotate(carAngle+HALF_PI);
    line(carLength, 0, carLength+30, 0);
    popMatrix();


    textSize(20);
    String message1 = Xpos + "\n" + Ypos;
    String message2 = Gdirect + "\n" + degrees(carAngle%TWO_PI) + "\n" + degrees(wheelAngle) + "\n" + Xpos + "\n" + Ypos + "\n" + XcenRot + "\n" + YcenRot;
    text(message2, Xpos+5, Ypos+20);
    text(message2, 5, 20);
  }




  void calcNextFrame() {
    // if going straight
    if (Gdirect==0) {
      Xpos -= speed * sin(carAngle);
      Ypos += speed * cos(carAngle);
    } else {
      float angleCarAlongArc = speed/Rmag;
      if (Gdirect==-1) {
        carAngle+=angleCarAlongArc;
      } else {
        carAngle += angleCarAlongArc;
      }

      Xpos = XcenRot + (Rmag-carWidth/2)*cos(carAngle);
      Ypos = YcenRot + (Rmag-carWidth/2)*sin(carAngle);

    }
  }
}
