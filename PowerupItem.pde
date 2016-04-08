//Represents powerups that the player can pick up.
//Uses the powerup enum.
class PowerupItem implements ICharacter{
  Powerup type;
  int sizeValue;
  PShape avatar;
  
  PVector position;
  PVector orientation;
  
  //Constructs a powerup of a certain type.
  PowerupItem(Powerup p){
    type = p;
    
    position = new PVector(random(0,width),random(0,height));
    while(PVector.dist(player1.position,position) < radius()+player1.sizeValue){
       position.x = random(0,width);
       position.y = random(0,height);
    }
    
    orientation = PVector.random2D();
    
    sizeValue = 3; //For ease of adjustment
    avatar = createShape();
    avatar.beginShape();
    avatar.noFill();
    avatar.vertex(-1*sizeValue,0);
    avatar.vertex(-2*sizeValue,1.5*sizeValue);
    avatar.vertex(2*sizeValue,0);
    avatar.vertex(-2*sizeValue,-1.5*sizeValue);
    avatar.vertex(-1*sizeValue,0);
    avatar.endShape();
    
    color c = color(255,0,255);
    if(type == Powerup.NONE){
      c = color(0,255,0);
    } else if(type == Powerup.DOUBLE_POINTS){
      c = color(255,255,0);
    } else if(type == Powerup.SPEEDY){
      c = color(0,0,255);
    }
    
    avatar.setStroke(c);
  }
  
  //Method required by interface.
  void update(){
  }
  
  //Draws the powerup.
  void draw(){
    pushMatrix();
    translate(position.x,position.y);
    rotate(orientation.heading());
    shape(avatar);
    popMatrix();
  }
  
  //Gives the powerup's position.
  PVector position(){
    return position;
  }
  
  //Gives the radius of the powerup's bounding circle. I added a 1 pixel buffer for more accurate collisions.
  int radius(){
    return sizeValue+1;
  }
}