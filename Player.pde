//Represents the player avatar and has functions for controloing its movements with the mouse keys, updating its movements, and being drawn to the screen.
class Player implements ICharacter{
  int sizeValue; //For ease of size adjustment and for use in collision detection.
   PShape avatar;
  
  //movement
  PVector position;
  PVector orientation;
  
  PVector velocity;
  PVector acceleration;
  
  //Basic constuctor
  Player(){
    position = new PVector(width/2,height/2);
    orientation = new PVector(1,0);
    orientation.limit(1);
    velocity = new PVector(0,0);
    velocity.limit(3);
    acceleration = new PVector(0,0);
    
    sizeValue = 5; //For ease of adjustment
    avatar = createShape();
    avatar.beginShape();
    avatar.noFill();
    avatar.vertex(-1*sizeValue,0);
    avatar.vertex(-2*sizeValue,1.5*sizeValue);
    avatar.vertex(2*sizeValue,0);
    avatar.vertex(-2*sizeValue,-1.5*sizeValue);
    avatar.vertex(-1*sizeValue,0);
    avatar.endShape();
    
    avatar.setStroke(255);

  }
  
  //Updates the player's location and oreintation.
  void update(){
    //acceleration, velocity, and position
    boolean  noForce = true;
    if(keyPressed){
      PVector direction = orientation.copy();
      if(keyCode == LEFT){
        acceleration = direction.rotate(-1*HALF_PI);
        noForce = false;
      }else if(keyCode == RIGHT){
        acceleration = direction.rotate(HALF_PI);
        noForce = false;
      }else if(keyCode == UP){
        acceleration = direction;
        noForce = false;
      }else if(keyCode == DOWN){
        acceleration = direction.rotate(PI);
        noForce = false;
      }
    }
    if(noForce){
      acceleration = PVector.mult(velocity,-1);
      acceleration.normalize();
    }
    if(power == Powerup.SPEEDY){
      acceleration.div(8);
      velocity.add(acceleration);
      velocity.limit(3.5);
    }else{
      acceleration.div(15);
      velocity.add(acceleration);
      velocity.limit(3);
    }
    position.add(velocity);
    if(position.x < 0){
      position.x = width;
    } else if(position.x > width){
      position.x = 0;
    }
    if(position.y < 0){
      position.y = height;
    } else if(position.y > height){
      position.y = 0;
    }
    
    //orientation
    PVector mVector = new PVector(mouseX,mouseY);
    orientation = PVector.sub(mVector,position);
    orientation.normalize();
  }
  
  //Draws the player on the screen.
  void draw(){
    pushMatrix();
    translate(position.x,position.y);
    rotate(orientation.heading());
    color outline = color(255,255-(immunityTimer*2),255-(immunityTimer*2));
    avatar.setStroke(outline);
    shape(avatar);
    popMatrix();
  }
  
  //returns the players's position
  PVector position(){
    return position;
  }
  
  //returns the the distence between the ships center and its tail or tip.
  int radius(){
    return sizeValue;
  }
}