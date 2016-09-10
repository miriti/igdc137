package;

import openfl.display.Sprite;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.Assets;

class RpmHud extends Sprite {

  public var value(default, set):Float;
  public var speed(default, set):Int;
  public var gear(default, set):Int;
  
  var gaugeBitmap:Bitmap = new Bitmap();
  var bitmaps:Array<BitmapData> = new Array<BitmapData>();
  var speedText:TextField;
  var gearText:TextField;
  
  function set_value(newValue:Float):Float {
    newValue = Math.max(0, Math.min(1, newValue));
    gaugeBitmap.bitmapData = bitmaps[Std.int((bitmaps.length - 1) * newValue)];
    return value = newValue;
  }
  
  function set_speed(newValue:Int):Int {
    speedText.text = Std.string(newValue);
    return speed = newValue;
  }
  
  function set_gear(newGear:Int):Int {
    gearText.text  = newGear == 0 ? "N" : Std.string(newGear);
    return gear = newGear;
  }
  
  public function new() {
    super();
    
    for(i in 0...11) {
      bitmaps.push(Assets.getBitmapData("assets/rpm/"+i+".png"));
    }
    
    addChild(gaugeBitmap);
    
    var font = Assets.getFont("assets/font/Crysta.ttf").fontName;
    
    speedText = new TextField();
    speedText.text = "0";
    speedText.setTextFormat(new TextFormat(font, 20, 0xffffff));
    speedText.height = speedText.textHeight;
    speedText.x = 30;
    speedText.y = 15;
    
    addChild(speedText);
    
    gearText = new TextField();
    gearText.text = "N";
    gearText.setTextFormat(new TextFormat(font, 16, 0xffffff));
    gearText.height = speedText.textHeight;
    gearText.x = 80;
    gearText.y = 18;
    
    addChild(gearText);
    
    value = 0;
  }
  
}
