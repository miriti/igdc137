package ;

import openfl.display.BitmapData;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;
import openfl.Assets;
import openfl.system.System;

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

class MainMenu extends Screen {
  var bg:BitmapData = Assets.getBitmapData('assets/bg.png');
  var logo:MenuLogo = new MenuLogo();

  var menu_main:Menu = new Menu();
  var options_menu:Menu = new Menu(22);
  var currentMenu:Menu;

  public function new() {
    super();

    /**
     * Main Menu
     */
    menu_main.addItem("Start", function() {
      Main.instance.currentScreen = new Game();
    });

    menu_main.addItem("Options", function() {
      currentMenu = options_menu;
      options_menu.selected_item = 0;
    });

    #if ((!html)&&(!flash))
    menu_main.addItem("Quit", function() {
      System.exit(0);
    });
    #end

    /**
     * Options Menu
     */
    options_menu.addItem("Transmission: auto", function() {});
    options_menu.addItem("Accelerate: W", function() {});
    options_menu.addItem("Brake: S", function() {});

    options_menu.addItem("< Back", function() {
      currentMenu = menu_main;
    });

    options_menu.selected_item = menu_main.selected_item = 0;

    currentMenu = menu_main;
  }

  override public function render() : Void {
      frameBuffer.draw(bg);
      logo.draw(frameBuffer);

      currentMenu.draw(frameBuffer);
  }

  override public function keyDown(keyCode:Int):Void {
    currentMenu.keyDown(keyCode);
  }

}
