
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
    mycar.Xpos = width/2; //<>//
    mycar.Ypos = height/2 ;
    mycar.speed = 0;
    mycar.carAngle = radians(180);
    mycar.wheelAngle = 0;
    mycar.crashed = false;
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
