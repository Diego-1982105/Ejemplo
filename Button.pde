//Simple GUI element that can be clicked on.
class Button{
  //Event stuff (I hope).
  
  //GUI and location
  static final int PADDING = 5;
  PVector position;
  PVector dimensions;
  PShape icon;
  PFont font;
  int fontSize;
  String label;
  int idNumber;
  
  //Constructor figures out button's location, message, and font type.
  Button(float x,float y,String message,int fSize,PFont buttonFont,int id){
    position = new PVector(x,y);
    fontSize = fSize;
    font = buttonFont;
    textFont(font);
    
    label = message;
    idNumber = id;
    
    dimensions = new PVector(textWidth(label)+2*PADDING,fontSize+2*PADDING);
    
    icon = createShape(RECT,0,0,dimensions.x,dimensions.y);
    icon.setFill(color(0,0));
  }
  
  //Checks if the mouse is on the button and the left mouse button is pressed.
  void checkButton(){
    icon.setStroke(255);
    //println("Is " + mouseY + " between " + position.y + " and " + (position.y+textWidth(label)) + "?");
    if(mouseX >= position.x && mouseX <= (position.x+dimensions.x) && (mouseY >= position.y && mouseY <= (position.y+dimensions.y))){
      //print("Y position is lined up!");
      icon.setStroke(color(0,255,0));
      fill(color(0,255,0));
      if(mousePressed && mouseButton == LEFT && !mousePrevious){
        buttonPressed(idNumber);
      }
    }else{
      icon.setStroke(255);
      fill(255);
    }
  }
  
  //draws the button
  void draw(){
    pushMatrix();
    translate(position.x,position.y);
    shape(icon);
    translate(PADDING,4*PADDING);
    text(label,0,0);
    popMatrix();
  }
}