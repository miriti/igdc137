package;

import openfl.events.Event;
import openfl.events.KeyboardEvent;
import openfl.display.Sprite;
import openfl.display.FPS;
import openfl.display.Bitmap;
import openfl.Lib;

class Main extends Sprite {
	public static var instance:Main;

	var currentScreen(default, set): Screen;

	var bitmap:Bitmap;

	public function set_currentScreen(screen:Screen):Screen {
		bitmap.bitmapData = screen.frameBuffer;
		return currentScreen = screen;
	}

	public function new () {
		super ();

		instance = this;

		bitmap = new Bitmap();
		bitmap.scaleX = bitmap.scaleY = 2;
		addChild(bitmap);

		var fps = new FPS(0, 0, 0xf556f2);
		addChild(fps);

		addEventListener(Event.ENTER_FRAME, onEnterFrame);

		Lib.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		Lib.current.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);

		currentScreen = new GameMain();
	}

	function onKeyDown(e:KeyboardEvent) : Void {
		if (currentScreen != null) {
			currentScreen.keyDown(e.keyCode);
		}
	}

	function onKeyUp(e:KeyboardEvent) : Void {
		if (currentScreen != null) {
			currentScreen.keyUp(e.keyCode);
		}
	}

	function onEnterFrame(e:Event) : Void {
		if (currentScreen != null) {
			currentScreen.update(1/120);
			currentScreen.render();
			currentScreen.end();
		}
	}


}
