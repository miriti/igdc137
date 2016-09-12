package;

import openfl.display.Sprite;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.Assets;
import openfl.Lib;
import motion.Actuate;

class Intro extends Sprite {

  var igdcLogo:Bitmap;

  public function new() {
    super();

    igdcLogo = new Bitmap(Assets.getBitmapData("assets/igdc_logo.png"));
    igdcLogo.scaleX = igdcLogo.scaleY = 2;
    igdcLogo.x = (Lib.current.stage.stageWidth - igdcLogo.width) / 2;
    igdcLogo.alpha = 0;
    addChild(igdcLogo);

    Actuate.tween(igdcLogo, 3, {alpha: 1}).delay(0.3).onComplete(function() {
      Actuate.tween(igdcLogo, 1, {alpha: 0}).delay(1).onComplete(function() {
        removeChild(igdcLogo);
        addChild(new Main());
      });
    });
  }

}
