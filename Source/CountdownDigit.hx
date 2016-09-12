package;

import openfl.display.Sprite;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.Assets;

class CountdownDigit extends Sprite {
  var text:TextField;
  var shadeText:TextField;

  public function new(num:String) {
    super();

    var fontName = Assets.getFont('assets/font/StillTime.ttf').fontName;
    var fontSize = 72;

    text = new TextField();
    text.text = num;
    text.setTextFormat(new TextFormat(fontName, fontSize, 0xf556f2));

    shadeText = new TextField();
    shadeText.text = Std.string(num);
    shadeText.setTextFormat(new TextFormat(fontName, fontSize, 0x0a0026));

    text.x = -text.textWidth / 2;
    text.y = -text.textHeight / 2;

    shadeText.x = text.x + 2;
    shadeText.y = text.y + 2;

    addChild(shadeText);
    addChild(text);
  }

}
