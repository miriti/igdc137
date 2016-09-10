package;

import openfl.display.DisplayObject;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.Assets;

class RoadSegment {
  public var x: Float;
  public var y: Float;
  public var z: Float;

  public var decorations:Array<DisplayObject> = new Array<DisplayObject>();

  var palmTree:BitmapData = Assets.getBitmapData("assets/palm-tree.png");
  var palmLeft:Bitmap;

  public function new() {
    palmLeft = new Bitmap(palmTree);
  }

  public function drawDecorations(screen:Screen, z_shift): Void {
    var scale:Float = 1/(z+z_shift);
    palmLeft.scaleX = palmLeft.scaleY = scale;

    palmLeft.x = screen.project_x(-180, z + z_shift) - (palmLeft.width/2);
    palmLeft.y = screen.project_y(y, z + z_shift) - palmLeft.height;

    screen.frameBuffer.draw(palmLeft, palmLeft.transform.matrix);
  }
}
