package;

import openfl.display.BitmapData;
import openfl.Assets;
import openfl.system.System;

class PauseMenu extends Screen {
  var bg:BitmapData = Assets.getBitmapData('assets/bg.png');
  var logo:MenuLogo = new MenuLogo("Paused");

  var menu:Menu = new Menu(28);
  var optionsMenu:OptionsMenu;
  var currentMenu:Menu;

  public function new() {
    super();

    logo.x = 160;
    logo.y = 50;
    
    optionsMenu = new OptionsMenu(function() {
      currentMenu = menu;
    });

    menu.addItem("Resume", function() {
      Main.instance.currentScreen = Game.instance;
    });

    menu.addItem("Main Menu", function() {
      Main.instance.currentScreen = new MainMenu();
    });
    
    menu.addItem("Options", function() {
      currentMenu = optionsMenu;
    });

    menu.addItem("Quit", function() {
      System.exit(0);
    });

    menu.selected_item = 0;
    
    currentMenu = menu;
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
