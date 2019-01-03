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
  float LwheelAngle = 0;
  float RwheelAngle = 0;
  int maxWheelAngle = 89;
  float wheelTurn = 2;
  float speed = 1;


  // car physical parameters
  float carLength =100;
  float carWidth =100;
  float carCenterToCornerAngle = atan((carWidth/2)/carLength);
  float carCenterToCornerDist = pythag(carWidth/2, carLength);



  float carCornerDist = pythag(carWidth/2, carLength/2);

  // car extents
  float fr_Xpos, fr_Ypos, rr_Xpos, rr_Ypos, rl_Xpos, rl_Ypos, fl_Xpos, fl_Ypos;


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
    carAngle = PI/6;
  }


  float otherWheelAngle(float CurrentWheelAngle) {
    float A = carLength/tan(CurrentWheelAngle);
    float B = A+carWidth;
    return atan( carLength/ B ) ;
  }


  void update() {
    if (!crashed) {
      carCenterToCornerAngle = atan((carWidth/2)/carLength);
      carCenterToCornerDist = pythag(carWidth/2, carLength);



      carCornerDist = pythag(carWidth/2, carLength/2);

      if (turnLeft) {
        if (LwheelAngle>=radians(-maxWheelAngle)+radians(wheelTurn)) {

          LwheelAngle+=radians(-wheelTurn);

          RwheelAngle= -otherWheelAngle(-LwheelAngle);
        } else {
          LwheelAngle = radians(-maxWheelAngle);
        }
      }
      if (turnRight) {
        if (RwheelAngle<=radians(maxWheelAngle)-radians(wheelTurn)) {

          RwheelAngle+=radians(wheelTurn);
          LwheelAngle= otherWheelAngle(RwheelAngle);
        } else {
          RwheelAngle = radians(maxWheelAngle);
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
    if (LwheelAngle<radians(-3)) {
      Rmag = abs(carLength * 1/tan(LwheelAngle));  // distance to wheel only, not center of car

      return -1;
    } else if (RwheelAngle>radians(3)) {
      Rmag = carLength * 1/tan(RwheelAngle);

      return 1;
    } else { 
      Rmag = 0;
      return 0;
    }
  }

  void centerOfRotation() {
    // find where the point of rotation is on the global frame
    if (Gdirect==-1) {
      XcenRot = Xpos + (Rmag+carWidth/2)*cos(carAngle);
      YcenRot = Ypos + (Rmag+carWidth/2)*sin(carAngle);
    } else if (Gdirect==1) {
      XcenRot = Xpos - (Rmag+carWidth/2)*cos(carAngle);
      YcenRot = Ypos - (Rmag+carWidth/2)*sin(carAngle);
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
        rect(-Rmag-carWidth/2, carLength/2, carWidth, carLength);
        popMatrix();
        noFill();
        ellipse(XcenRot, YcenRot, Rmag*2, Rmag*2);
        text(Rmag, XcenRot, YcenRot);
        ellipse(XcenRot, YcenRot, pythag(XcenRot-fr_Xpos, YcenRot-fr_Ypos)*2, pythag(XcenRot-fr_Xpos, YcenRot-fr_Ypos)*2);
        ellipse(XcenRot, YcenRot, pythag(XcenRot-fl_Xpos, YcenRot-fl_Ypos)*2, pythag(XcenRot-fl_Xpos, YcenRot-fl_Ypos)*2);
        point(XcenRot, YcenRot);
      }
      if (Gdirect==1) {
        rectMode(CENTER);
        rect(Rmag+carWidth/2, carLength/2, carWidth, carLength);
        popMatrix();
        noFill();
        ellipse(XcenRot, YcenRot, (Rmag)*2, (Rmag)*2);
        text(Rmag, XcenRot, YcenRot);
        ellipse(XcenRot, YcenRot, pythag(XcenRot-fr_Xpos, YcenRot-fr_Ypos)*2, pythag(XcenRot-fr_Xpos, YcenRot-fr_Ypos)*2);
        ellipse(XcenRot, YcenRot, pythag(XcenRot-fl_Xpos, YcenRot-fl_Ypos)*2, pythag(XcenRot-fl_Xpos, YcenRot-fl_Ypos)*2);
        point(XcenRot, YcenRot);
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
    float boogy = Xpos-XcenRot;
    String message1 = Xpos + "\n" + Ypos;
    String message2 = Gdirect + "\n" + degrees(carAngle%TWO_PI) + "\nLeft" + degrees(LwheelAngle)+"\nRight" + degrees(RwheelAngle) + "\n" + Xpos + "\n" + Ypos + "\n" + boogy + "\n" + YcenRot;
    text(message2, Xpos+5, Ypos+20);
    text(message2, 5, 20);
  }




  void calcNextFrame() {
    // if going straight
    if (Gdirect==0) {
      Xpos -= speed * sin(carAngle);
      Ypos += speed * cos(carAngle);

      // use turning algorithm
    } else {
      float angleCarAlongArc = speed/Rmag;
      if (Gdirect==-1) {
        carAngle-=angleCarAlongArc;
        Xpos = XcenRot - (Rmag+carWidth/2)*cos(carAngle);
        Ypos = YcenRot - (Rmag+carWidth/2)*sin(carAngle);
      } else {
        carAngle += angleCarAlongArc;
        Xpos = XcenRot + (Rmag+carWidth/2)*cos(carAngle);
        Ypos = YcenRot + (Rmag+carWidth/2)*sin(carAngle);
      }
    }
  }


  void carExtents() {

    // position of front right corner
    fr_Xpos = Xpos-carCenterToCornerDist*cos(carAngle-HALF_PI+carCenterToCornerAngle);
    fr_Ypos = Ypos-carCenterToCornerDist*sin(carAngle-HALF_PI+carCenterToCornerAngle);

    // position of rear right corner
    rr_Xpos = Xpos+0.5*carWidth*cos(PI+carAngle);
    rr_Ypos = Ypos+0.5*carWidth*sin(PI+carAngle);
    // position of rear left corner
    rl_Xpos = Xpos-0.5*carWidth*cos(PI+carAngle);
    rl_Ypos = Ypos-0.5*carWidth*sin(PI+carAngle);


    // position of front left corner
    fl_Xpos = Xpos+carCenterToCornerDist*cos(carAngle+HALF_PI-carCenterToCornerAngle);
    fl_Ypos = Ypos+carCenterToCornerDist*sin(carAngle+HALF_PI-carCenterToCornerAngle);

    strokeWeight(2);
    stroke(255, 0, 0);
    ellipse(mycar.fr_Xpos, mycar.fr_Ypos, 3, 3);
    stroke(125, 125, 0);
    ellipse(mycar.fl_Xpos, mycar.fl_Ypos, 3, 3);
    stroke(255, 0, 255);
    ellipse(mycar.rr_Xpos, mycar.rr_Ypos, 3, 3);
    stroke(0, 0, 0);
    ellipse(mycar.rl_Xpos, mycar.rl_Ypos, 3, 3);

}
