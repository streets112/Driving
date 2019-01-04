
void keyPressed() {
  if ((key==CODED)&&(keyCode == LEFT)) {
    mycar.turnLeft = true;
  }
  if ((key==CODED)&&(keyCode == RIGHT)) {
    mycar.turnRight = true;
  }
  if ((key==CODED)&&(keyCode == UP)) {
    mycar.accel = true;
  }
  if ((key==CODED)&&(keyCode == DOWN)) {
    mycar.brake = true;
  }
  if (key=='R' || key == 'r'){
    mycar.Xpos = width/2-150;
    mycar.Ypos = height/2 ;
    mycar.speed = 0;
    mycar.carAngle = radians(180);
    mycar.LwheelAngle = 0;
    mycar.RwheelAngle = 0;
    mycar.crashed = false;
  }
  if (key=='q' || key == 'Q'){
    if( mycar.carLength<=200){
      mycar.carLength++;
    }
  }
  if (key=='a' || key == 'A'){
    if( mycar.carLength >= 5){
      mycar.carLength--;
      }
  }
  if (key=='w' || key == 'W'){
    if( mycar.carWidth<=150){
      mycar.carWidth++;
    }
  }
  if (key=='s' || key == 'S'){
    if (mycar.carWidth >=5){
      mycar.carWidth--;
    }
  }
}

void keyReleased() {
  if ((key==CODED)&&(keyCode == LEFT)) {
    mycar.turnLeft = false;
}
  if ((key==CODED)&&(keyCode == RIGHT)) {
    mycar.turnRight = false;
  }
  if ((key==CODED)&&(keyCode == UP)) {
    mycar.accel = false;
  }
  if ((key==CODED)&&(keyCode == DOWN)) {
    mycar.brake = false;
  }
}
