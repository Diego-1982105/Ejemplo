//Represents a bullet fired by the player.
//Keeps track of the bullet's location and is responsible for drawing it to the screen.
class Bullet implements ICharacter{
  PShape avatar;
  
  PVector position;
  PVector velocity;
  
  int lifeTimer;
  
  //Basic costructor
  Bullet(){
    avatar = createShape(ELLIPSE,0,0,2,2);
    avatar.setFill(color(0,0));
    
    position = player1.position.copy();
    velocity = player1.orientation.copy();
    velocity.mult(3);
    
    lifeTimer = 480;
  }
  
  //Updates bullet
  void update(){
    lifeTimer--;
    
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
  }
  
  //Draws bullet to screen
  void draw(){
    pushMatrix();
    translate(position.x,position.y);
    avatar.setStroke(lifeTimer/3+95);
    shape(avatar);
    popMatrix();
  }
  
   //returns the bullet's position
  PVector position(){
    return position;
  }
  
  //returns the bullet's radius. I added a 1 pixel buffer since bullets are small
  int radius(){
    return 2;
  }
}