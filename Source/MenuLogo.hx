package;

import openfl.display.BitmapData;
import openfl.display.Bitmap;
import openfl.display.Sprite;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;
import openfl.Assets;

class MenuLogo extends Sprite {
  var container:Sprite;

  var items:Array<Sprite> = new Array<Sprite>();
  var rotation_phase:Float = 0;
  var zoom_phase:Float = Math.PI*2;
  var effect_phase:Float = 0;
  var effect_zoom_phase:Float = 0;

  public function new(logoText:String) {

    super();

    var colors:Array<UInt> = [0x310242, 0x77106b, 0xa21487, 0xf556f2];
    var font = Assets.getFont("assets/font/StillTime.ttf");
    var textFormat = new TextFormat(font.fontName, 72);
    textFormat.align = TextFormatAlign.CENTER;

    for(i in 0...colors.length) {
      var color = colors[i];

      textFormat.color = color;

      var t = new TextField();
      t.text = logoText;
      t.setTextFormat(textFormat);
      t.width = 320;

      t.x = -160;
      t.y = -t.textHeight/2;

      var item = new Sprite();
      item.addChild(t);

      addChild(item);

      items.push(item);
    }
  }

  public function update(): Void {
    rotation = Math.sin(rotation_phase) * 10;

    for(i in 0...items.length) {
      var item = items[i];

      item.x = Math.sin(effect_phase)*(i * (Math.sin(effect_zoom_phase) * 3));
      item.y = Math.sin(effect_phase)*(i * (Math.sin(effect_zoom_phase) * 3));
    }

    rotation_phase += Math.PI/720;
    effect_phase += Math.PI/320;
    effect_zoom_phase += Math.PI/320;
  }
}
