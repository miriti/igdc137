package ;

import openfl.display.BitmapData;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;
import openfl.Assets;

class MenuLogo {
  var texts:Array<TextField> = new Array<TextField>();
  var phases:Array<Float> = new Array<Float>();

  public function new() {
    var colors:Array<UInt> = [0x310242, 0x77106b, 0xa21487, 0xf556f2];
    var i = 0;

    for(color in colors) {
      var f = new TextFormat(Assets.getFont("assets/font/StillTime.ttf").fontName, 72, color);
      f.align = TextFormatAlign.CENTER;

      var t = new TextField();
      t.text = "Road Vice'85";
      t.width = 320;
      t.x = i * -2;
      t.y = i * -2;
      t.setTextFormat(f);

      texts.push(t);

      i++;
    }
  }

  public function draw(surface:BitmapData) {
    var i = 0;
    do {
      var t = texts[i];
      surface.draw(t, t.transform.matrix);
    } while (i++ < texts.length-1);
  }
}

class MenuItem {
  public var y(default, set):Float;
  public var selected(default, set):Bool;

  var title: String;
  var action: Void -> Void;
  var textField: TextField;
  var shadeTextField: TextField;

  var itemTextFormat: TextFormat = new TextFormat(Assets.getFont("assets/font/stormfaze.ttf").fontName, 32, 0xa21487);
  var shadeTextFormat: TextFormat = new TextFormat(Assets.getFont("assets/font/stormfaze.ttf").fontName, 32, 0x310242);
  var selectedTextFormat: TextFormat = new TextFormat(Assets.getFont("assets/font/stormfaze.ttf").fontName, 32, 0xf556f2);

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

  public function new(title:String, action: Void -> Void) {
    this.title = title;
    this.action = action;

    selectedTextFormat.align = shadeTextFormat.align = itemTextFormat.align = TextFormatAlign.CENTER;

    textField = new TextField();
    textField.text = title;
    textField.setTextFormat(itemTextFormat);

    shadeTextField = new TextField();
    shadeTextField.text = title;
    shadeTextField.setTextFormat(shadeTextFormat);

    textField.width = shadeTextField.width = Screen.FRAME_WIDTH;
  }

  public function draw(surface:BitmapData): Void {
    surface.draw(shadeTextField, shadeTextField.transform.matrix);
    surface.draw(textField, textField.transform.matrix);
  }
}

class MainMenu extends Screen {
  var bg:BitmapData = Assets.getBitmapData('assets/bg.png');
  var logo:MenuLogo = new MenuLogo();

  var items:Array<MenuItem> = new Array<MenuItem>();

  var selected_item(default, set):Int = 0;

  function set_selected_item(value:Int):Int {
    selected_item = value;

    if(value < 0) {
      selected_item = items.length-1;
    }

    if(value > items.length-1) {
      selected_item = 0;
    }

    for(item in items) {
      item.selected = false;
    }

    items[selected_item].selected = true;

    return selected_item;
  }

  public function new() {
    super();

    items.push(new MenuItem("Start", function() {}));
    items.push(new MenuItem("Options", function() {}));

    #if ((!html)&&(!flash))
    items.push(new MenuItem("Quit", function() {}));
    #end

    items[0].selected = true;

    var ty = 100;
    for(item in items) {
      item.y = ty;

      ty+=40;
    }

  }

  override public function render() : Void {
      frameBuffer.draw(bg);
      logo.draw(frameBuffer);

      for(item in items) {
        item.draw(frameBuffer);
      }
  }

  override public function keyDown(keyCode:Int):Void {

    if (keyCode == 13) {
      // TODO: Execute action
    }

    if ((keyCode == 38) || (keyCode == 87)) {
      selected_item--;
    }

    if ((keyCode == 40) || (keyCode == 83)) {
      selected_item++;
    }
  }

}
