package;

import openfl.display.BitmapData;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;
import openfl.media.Sound;
import openfl.Assets;

class MenuItem {
  public var menu:Menu;
  public var y(default, set):Float;
  public var selected(default, set):Bool;

  public var textHeight(get, never):Int;

  var title(default, set): String;
  var action: Void -> Void;
  var textField: TextField;
  var shadeTextField: TextField;

  var itemTextFormat: TextFormat;
  var shadeTextFormat: TextFormat;
  var selectedTextFormat: TextFormat;
  
  function set_title(value:String): String {
    textField.text = value;
    shadeTextField.text = value;
    return title = value;
  }

  function get_textHeight(): Int {
    return Std.int(textField.textHeight);
  }

  function set_y(value:Float):Float {
    textField.y = value;
    shadeTextField.y = value + 2;
    return y = value;
  }

  function set_selected(value:Bool):Bool {
    if (value) {
      textField.setTextFormat(selectedTextFormat);
    } else {
      textField.setTextFormat(itemTextFormat);
    }

    return selected = value;
  }

  public function new(title:String, action: Void -> Void, fontSize:Int) {
    this.action = action;
    
    var fontName = Assets.getFont("assets/font/stormfaze.ttf").fontName;

    itemTextFormat = new TextFormat(fontName, fontSize, 0xa21487);
    shadeTextFormat = new TextFormat(fontName, fontSize, 0x310242);
    selectedTextFormat = new TextFormat(fontName, fontSize, 0xf556f2);

    selectedTextFormat.align = shadeTextFormat.align = itemTextFormat.align = TextFormatAlign.CENTER;

    textField = new TextField();
    textField.setTextFormat(itemTextFormat);

    shadeTextField = new TextField();
    shadeTextField.setTextFormat(shadeTextFormat);
    
    this.title = title;

    textField.width = shadeTextField.width = Screen.FRAME_WIDTH;
  }

  public function draw(surface:BitmapData): Void {
    surface.draw(shadeTextField, shadeTextField.transform.matrix);
    surface.draw(textField, textField.transform.matrix);
  }

  public function act():Void {
    action();
  }
  
  public function keyDown(keyCode:Int):Void {
    
  }
}
