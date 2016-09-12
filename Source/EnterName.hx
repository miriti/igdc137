package;

import openfl.display.Bitmap;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;
import openfl.Assets;

class EnterName extends Screen {
  
  var background:Bitmap = new Bitmap(Assets.getBitmapData("assets/bg.png"));
  var enteredName(default, set):String;
  var txtName:TextField;
  var txtShade:TextField;
  var enterYourName:MenuLogo = new MenuLogo("Your name:");

  function set_enteredName(val:String): String {
    if(val.length > 12) {
      val = val.substr(0, 12);
    }
    txtShade.text = txtName.text = val;
    return enteredName = val;
  }

  public function new() {
    super();
    
    enterYourName.x = Screen.FRAME_WIDTH/2;
    enterYourName.y = 50;
    
    var fontName = Assets.getFont("assets/font/stormfaze.ttf").fontName;
    
    var format = new TextFormat(fontName, 32, 0xf556f2);
    var shadeFormat = new TextFormat(fontName, 32, 0x310242);
    shadeFormat.align = format.align = TextFormatAlign.CENTER;
    
    txtName = new TextField();
    txtName.setTextFormat(format);
    txtName.width = Screen.FRAME_WIDTH;
    txtName.y = 100;
    
    txtShade = new TextField();
    txtShade.setTextFormat(shadeFormat);
    txtShade.width = Screen.FRAME_WIDTH;
    txtShade.x = 2;
    txtShade.y = 102;
    
    enteredName = Names.igdc[Std.int(Math.random() * (Names.igdc.length-1))];
  }
  
  override public function render() : Void {
    frameBuffer.draw(background, background.transform.matrix);
    enterYourName.update();
    frameBuffer.draw(enterYourName, enterYourName.transform.matrix);
    frameBuffer.draw(txtShade, txtShade.transform.matrix);
    frameBuffer.draw(txtName, txtName.transform.matrix);
  }
  
  override public function keyDown(keyCode:Int): Void {
    if(keyCode == Input.KEY_ESCAPE) {
      Main.instance.currentScreen = new MainMenu();
    }
    
    if(keyCode == Input.KEY_BACKSPACE) {
      enteredName = enteredName.substr(0, -1);
    }
    
    if((keyCode >= Input.KEY_A) && (keyCode <= Input.KEY_Z)) {
      enteredName += String.fromCharCode(keyCode);
    }
    
    if(keyCode == Input.KEY_ENTER) {
      if(enteredName.length > 2) {
        Main.instance.currentScreen = new Game(enteredName);
      }
    }
  }
  
}
