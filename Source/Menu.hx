package ;

import openfl.display.BitmapData;
import openfl.media.Sound;
import openfl.Assets;
import openfl.text.TextField;

class Menu {
  public var selected_item(default, set):Int = 0;

  private var selectSound:Sound = Assets.getSound("assets/sound/menu_select.wav");
  private var actionSound:Sound = Assets.getSound("assets/sound/menu_action.wav");

  private var items:Array<MenuItem> = new Array<MenuItem>();
  private var _next_item_y:Int = 100;
  private var fontSize:Int;

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

  public function new(fontSize:Int = 32) {
    this.fontSize = fontSize;
  }

  public function addItem(title:String, action:Void -> Void): Void {
    var newItem = new MenuItem(title, action, fontSize);

    newItem.y = _next_item_y;
    _next_item_y += newItem.textHeight;

    items.push(newItem);
  }

  public function draw(frameBuffer:BitmapData): Void {
    for(item in items) {
      item.draw(frameBuffer);
    }
  }

  public function keyDown(keyCode:Int): Void {
    if (keyCode == 13) {
      actionSound.play();
      items[selected_item].act();
    }

    if ((keyCode == 38) || (keyCode == 87)) {
      selected_item--;
      selectSound.play();
    }

    if ((keyCode == 40) || (keyCode == 83)) {
      selected_item++;
      selectSound.play();
    }
  }

}
