//An interface for characters that can be drawn on the screen and can collide with other objects.
interface ICharacter{

  void update(); //updates character
  
  void draw(); //draws character to screen
  
  PVector position(); //where the character is located
  
  int radius(); //the radius or closest value to radius for the character
}