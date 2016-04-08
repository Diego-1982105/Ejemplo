//keeps track of the location and other key variables of an asteroid enemy.
//Also responsible for drawing said enamies on the screen.
class Asteroid implements ICharacter{
  final int MAX_SIZE = 16;
  
  //Shape and health(more or less)
  int sizeLevel;
  int radius;
  PShape avatar;
  
  //movement
  PVector position;
  PVector orientation;
  
  PVector velocity;
  PVector acceleration;
  
  //Base constructor
  Asteroid(){
    numAsteroids++;
    sizeLevel = 3;
    radius = MAX_SIZE;
    
    position = new PVector(random(0,width),random(0,height));
    while(PVector.dist(player1.position,position) < radius+player1.sizeValue){
       position.x = random(0,width);
       position.y = random(0,height);
    }
    orientation = PVector.random2D();
    velocity = new PVector(0,0);
    acceleration = new PVector(0,0);
    
    createAsteroid();
  }
  
  //Parameterized constructor that takes a size. For creating children asteroids.
  Asteroid(Asteroid a){
    numAsteroids++;
    sizeLevel = a.sizeLevel-1;
    radius = MAX_SIZE/(4-sizeLevel);
    
    position = a.position.copy();
    orientation = a.orientation.copy();
    orientation.rotate(random(-QUARTER_PI,QUARTER_PI));
    velocity = a.velocity.copy();
    velocity.rotate(random(-HALF_PI,HALF_PI));
    acceleration = new PVector(0,0);
    
    position.add(velocity);
    
    createAsteroid();
  }
  
  /*Creates the asteroid shape. 
  Done seperatly from the constructors so I don't have to code it twice*/
  void createAsteroid(){
    avatar = createShape();
    
    int numVerticies = (int)(random(5,9));
    
    int x = 0;
    int y = 0;
    avatar.beginShape();
    avatar.noFill();
    for(int i = 0; i < numVerticies; i++){
      x = (int)(cos(TWO_PI*i/numVerticies)*(radius+(random(-2,2))));
      y = (int)(sin(TWO_PI*i/numVerticies)*(radius+(random(-2,2))));
      avatar.vertex(x,y);
    }
    avatar.vertex(avatar.getVertex(0).x,avatar.getVertex(0).y);
    avatar.endShape();
    
    avatar.setStroke(255);
    avatar.setStrokeWeight(2);
  }
  
  //Updats the asteriod's location and position on the screen.
  void update(){
    acceleration = PVector.sub(player1.position,position); 
    acceleration.limit(0.01);
    
    velocity.add(acceleration);
    velocity.limit(4-sizeLevel);
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
    
    orientation.rotate(QUARTER_PI/(12*sizeLevel));
  }
  
  //Draws the asteroid.
  void draw(){
    pushMatrix();
    translate(position.x,position.y);
    rotate(orientation.heading());
    shape(avatar);
    popMatrix();
  }
  
  //returns the asteroid's position
  PVector position(){
    return position;
  }
  
  //returns the asteroid's radius
  int radius(){
    if(sizeLevel > 1){
      return radius;
    }
    return radius+1; //Sizelevel 1 asteroids are small I decided to give them a buffer like other small items (i.e. bullets and powerup items).
  }
}