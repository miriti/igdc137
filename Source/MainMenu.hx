package ;

import openfl.display.BitmapData;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;
import openfl.media.Sound;
import openfl.Assets;
import openfl.system.System;

class MainMenu extends Screen {
  var bg:BitmapData = Assets.getBitmapData('assets/bg.png');
  var logo:MenuLogo = new MenuLogo("Road Vice'85");

  var menu_main:Menu = new Menu();
  var options_menu:Menu = new Menu(22);
  var currentMenu:Menu;

  public function new() {
    super();

    logo.x = 160;
    logo.y = 50;

    /**
     * Main Menu
     */
    menu_main.addItem("New Game", function() {
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
      logo.update();
      frameBuffer.draw(logo, logo.transform.matrix);

      currentMenu.draw(frameBuffer);
  }

  override public function keyDown(keyCode:Int):Void {
    currentMenu.keyDown(keyCode);
  }

}
