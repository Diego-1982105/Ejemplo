//handleing game states
enum State{
  START,GAME,SCORE,INSTRUCTIONS
}
//States for establishing powerup abilities
enum Powerup{
  NONE,DOUBLE_POINTS,SPEEDY,RAPID_FIRE
}
State gameState;
Powerup power;
int powTimer;

//GUI
PFont font;
int fontSize;
int lineSpacing;

ArrayList<Button> startMenu;
ArrayList<Button> scoreMenu;
Button backButton;
boolean mousePrevious;

//Gameplay
int lives;
int score;
Player player1;
ArrayList<ICharacter> characters;

//timekeeping
int immunityTimer;
int bulletTimer; 

//Generation
final int MAX_ASTEROIDS = 6;
int numAsteroids;

//Sets up the initial values for gameplay.
void setup(){
  size(800,500);
  //GUI
  lineSpacing = 4;
  fontSize = 14;
  font = createFont("Lucida Console",fontSize);
  textFont(font);
  
  mousePrevious = true;
  
  startMenu = new ArrayList<Button>();
  scoreMenu = new ArrayList<Button>();
  
  String message = "Play Game";
  startMenu.add(new Button((width-textWidth(message)-2*Button.PADDING)/2,height/2,message,fontSize,font,0));
  message = "Instructions";
  startMenu.add(new Button((width-textWidth(message)-2*Button.PADDING)/2,(height)/2+fontSize+2*Button.PADDING+2*lineSpacing,message,fontSize,font,2));
  message = "Quit";
  startMenu.add(new Button((width-textWidth(message)-2*Button.PADDING)/2,(height)/2+(fontSize+2*Button.PADDING+2*lineSpacing)*2,message,fontSize,font,1));
  
  message = "New Game";
  scoreMenu.add(new Button((width-textWidth(message)-2*Button.PADDING)/2,height/2,message,fontSize,font,0));
   message = "Main Menu";
  scoreMenu.add(new Button((width-textWidth(message)-2*Button.PADDING)/2,(height)/2+fontSize+2*Button.PADDING+2*lineSpacing,message,fontSize,font,3));
  message = "Quit";
  scoreMenu.add(new Button((width-textWidth(message)-2*Button.PADDING)/2,(height)/2+(fontSize+2*Button.PADDING+2*lineSpacing)*2,message,fontSize,font,1));
  
  message = "Back to Menu";
  backButton = new Button((width-textWidth(message)-2*Button.PADDING)/2,height/2,message,fontSize,font,3);
  
  //Game
  gameState = State.START;
  lives = 0;
  score = 0;
  
  characters = new ArrayList<ICharacter>();
  player1 = new Player();
  characters.add(player1);
  
  numAsteroids = 0;
  for(int i = 0; i < 3; i++){
    characters.add(new Asteroid());
  }
  immunityTimer = 0;
  bulletTimer = 0;
}

//Updates states and draws to screen.
void draw(){
  background(0);
   stroke(255);
   fill(255);
   if(gameState == State.START){
     //print("Start, ");
     String message = "Welcome to Asteroids.";
     text(message,(width-textWidth(message))/2,(height-fontSize-lineSpacing)/2);
     
     for(Button b:startMenu){
       fill(255);
       b.checkButton();
       b.draw();
     }
  } else if(gameState == State.GAME){
   //print("Game, ");
    if(lives <= 0){
      gameState = State.SCORE;
    }
  // print("No Change, ");
    updateGame();
  }else if(gameState == State.SCORE){
    //print("Score, ");
     String message = "Score: " + score;
     text(message,(width-textWidth(message))/2,(height-fontSize-lineSpacing)/2);
     //message = "Press space to play again.";
     //text(message,(width-textWidth(message))/2,(height+fontSize+lineSpacing)/2);
     for(Button b:scoreMenu){
       fill(255);
       b.checkButton();
       b.draw();
     }
  } else if(gameState == State.INSTRUCTIONS){
    String message = "Instructions:\n--Use the mouse to orient the spaceship.\n--Use the up arrow to go forward, and down arrow to go back.\n--Use left and right to dodge to the side.\n--Use space to shoot.";
    text(message,(width-textWidth(message))/2,(height/4-fontSize/2));
    backButton.checkButton();
    backButton.draw();
  }
  mousePrevious = mousePressed;
}

//updates the game while in game mode
void updateGame(){
  if(immunityTimer > 0){
    immunityTimer--;
  }
  
  if(powTimer > 0){
    powTimer--;
  } else{
    power = Powerup.NONE;
  }
  
  if(score > 6 && numAsteroids < MAX_ASTEROIDS && random(100) > 98){
    characters.add(new Asteroid());
  }
  
  //GUI stuff
  String data = "Lives: " + lives;
  text(data,lineSpacing,10+lineSpacing);
  data = "Score: " + score;
  text(data,lineSpacing,(10+fontSize+2*lineSpacing));
  if(power != Powerup.NONE){
    data = power.toString();
    text(data,width-lineSpacing-textWidth(data),10+lineSpacing);
  }
  //lives -= 1;
 
  //characterscollisions
  int i = 0;
  ICharacter character1;
  ICharacter character2;
  //Loops through and checks all game objects.
  while(i < characters.size()){
    //print("Item #" + i + ", ");
    character1 = characters.get(i);
    character1.update();
    
    if(character1 instanceof Bullet){
      Bullet bullet = (Bullet)character1;
      if(bullet.lifeTimer < 0){
        characters.remove(i);
        i--;
        break;
      }
    }
    
    int j = i+1;
    while(j < characters.size()){   //Collision detection.
      //print("Item #" + i +"/" + j + ", ");
      character2 = characters.get(j);
      
      if(PVector.dist(character1.position(),character2.position()) < (character1.radius()+character2.radius())){
        //print("Collision: (" + i + "," + j + ") ");
        if(character1 instanceof Asteroid){ //Found instanceof online, I miss C#'s is and as functions.
          Asteroid asteroid = (Asteroid)character1;
          if(character2 instanceof Bullet){ 
                Bullet bullet = (Bullet)character2;
                
                //print("Collision: (" + i + "," + j + ") ");
                if(asteroid.sizeLevel > 1){
                  characters.add(new Asteroid(asteroid));
                  characters.add(new Asteroid(asteroid));
                }
                earnPoints();
                
                characters.remove(i);
                i--;
                numAsteroids--;
                j--;
                characters.remove(j);
                j--;
                break;
          }
        }
        if(character1 instanceof Bullet){
          Bullet bullet = (Bullet)character1;
          if(character2 instanceof Asteroid){ 
                Asteroid asteroid = (Asteroid)character2;
                
                //print("Collision: (" + i + "," + j + ") ");
                if(asteroid.sizeLevel > 1){
                  characters.add(new Asteroid(asteroid));
                  characters.add(new Asteroid(asteroid));
                }
                earnPoints();
                
                characters.remove(i);
                i--;
                j--;
                characters.remove(j);
                j--;
                numAsteroids--;
                break;
          } else if(character2 instanceof PowerupItem){ 
                //print("Collision: (" + i + "," + j + ") ");characters.remove(j);
                characters.remove(i);
                i--;
                j--;
                characters.remove(j);
                j--;
                break;
             }
        }
        if(character1 instanceof Player){
             if(character2 instanceof Asteroid  && immunityTimer <= 0){ 
                Asteroid asteroid = (Asteroid)character2;
                
                //print("Collision: (" + i + "," + j + ") ");
                if(asteroid.sizeLevel > 1){
                  characters.add(new Asteroid(asteroid));
                  characters.add(new Asteroid(asteroid));
                }
                lives--;
                immunityTimer = 100;
                
                characters.remove(j);
                j--;
                numAsteroids--;
                break;
             } else if(character2 instanceof PowerupItem){ 
                PowerupItem powerup = (PowerupItem)character2;
                
                //print("Collision: (" + i + "," + j + ") ");characters.remove(j);
                if(powerup.type == Powerup.NONE){ //The value of NONE is being used to represent extra-life powerups, so I don't need to add an EXTRA_LIFE value
                  lives++;
                }else{
                  power = powerup.type;
                  powTimer = 500;
                }
                
                characters.remove(j);
                j--;
                break;
             }
          }
          if(character1 instanceof PowerupItem){ 
                if(character2 instanceof Bullet){ 
                  characters.remove(i);
                  i--;
                  j--;
                  characters.remove(j);
                  j--;
               }
             }
      }
      
      j++;
    }
    
    character1.draw();
    i++;
  }
  
  if(bulletTimer > 0){
    bulletTimer--;
  }
}

//Resets lives and other data for a new game of Asteroids
void newGame(){
  characters = new ArrayList<ICharacter>();
  player1 = new Player();
  characters.add(player1);
  for(int i = 0; i < 3; i++){
    characters.add(new Asteroid());
  }
  numAsteroids = 3;
  immunityTimer = 0;
  bulletTimer = 0;
}

//Increments score and handles whether a power-up appears.
void earnPoints(){
  if(power == Powerup.DOUBLE_POINTS){
    score += 2;
  } else{
    score++;
  }
  if(score % 15 == 0 || (score % 15 == 1 && power == Powerup.DOUBLE_POINTS)){
    switch((int)(random(-1,4))){
      case 0: characters.add(new PowerupItem(Powerup.NONE));
      break;
      case 1: characters.add(new PowerupItem(Powerup.DOUBLE_POINTS));
      break;
      case 2: characters.add(new PowerupItem(Powerup.SPEEDY));
      break;
      case 3: characters.add(new PowerupItem(Powerup.RAPID_FIRE));
      break;
    }
  }
}

//Runs when a button is pressed.
void buttonPressed(int id){
  if(id == 0){
      lives = 3;
      score = 0;
      newGame();
      gameState = State.GAME;
    }else if(id == 1){
      exit();
    }else if(id == 2){
     gameState = State.INSTRUCTIONS;
   } else if(id == 3){
     gameState = State.START;
   }
}

//Identifies when a key is pressed.
void keyPressed(){
  if(gameState == State.GAME){
    if((key == ' ') && bulletTimer <= 0){
      characters.add(new Bullet());
      if(power == Powerup.RAPID_FIRE){
        bulletTimer = 10;
      } else{
        bulletTimer = 30;
      }
    }
  }
}