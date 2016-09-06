package ;

import openfl.display.BitmapData;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.Assets;

class MainMenu extends Screen {

    var bg:BitmapData = Assets.getBitmapData('assets/menu_bg.png');

    var text:TextField;

  public function new() {
    super();

    var textFormat:TextFormat = new TextFormat(Assets.getFont("assets/font/StillTime.ttf").fontName);
    text = new TextField();
    text.setTextFormat(textFormat);
    text.text = "New Game";
  }

  override public function render() : Void {
      frameBuffer.draw(bg);
      frameBuffer.draw(text);
  }

}
