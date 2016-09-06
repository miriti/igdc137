package;

import openfl.display.BitmapData;
import openfl.geom.Matrix;

class PSprite  {

  public var x(default, set):Float = 0;
  public var y(default, set):Float = 0;

  private var matrix:Matrix = new Matrix();
  private var bitmapData:BitmapData;

  function set_x(value:Float):Float {
    matrix.tx = value;
    return x = value;
  }

  function set_y(value:Float) : Float {
    matrix.ty = value;
    return y = value;
  }

  public function new(bitmapData:BitmapData) {
    super();

    this.bitmapData = bitmapData;
  }

  public function draw(surface:BitmapData): Void {
    surface.draw(bitmapData, matrix);
  }

}
