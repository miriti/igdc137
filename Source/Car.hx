package;

import openfl.display.BitmapData;
import openfl.display.Bitmap;
import openfl.Assets;

class Car {
  public var x:Float = 0.0;
  public var y:Float = 0.0;
  public var z:Float = 0.0;

  public var speed:Float = 0.0;

  private static var bitmap:Bitmap = null;

  public function new() {

    if(bitmap == null) {
      bitmap = new Bitmap(Assets.getBitmapData("assets/ferrari.png"));
    }
  }

  public function update(): Void {}

  public function draw(screen:Screen): Void {
    var pos2d = screen.project(x, y, z);
    var scale = 1/z;

    bitmap.scaleX = bitmap.scaleY = scale;
    bitmap.x = pos2d[0] - (bitmap.width / 2);
    bitmap.y = pos2d[1] - bitmap.height * scale;

    screen.frameBuffer.draw(bitmap, bitmap.transform.matrix);
  }
}
