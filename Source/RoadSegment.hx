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

  static var palmTreeBitmap:BitmapData;
  var palmTree_left:Bitmap;
  var palmTree_right:Bitmap;

  public function new() {
    if(palmTreeBitmap == null) {
       palmTreeBitmap = Assets.getBitmapData("assets/palm-tree.png");
    }
    palmTree_left = new Bitmap(palmTreeBitmap);
    palmTree_right = new Bitmap(palmTreeBitmap);

  }

  public function drawDecorations(screen:Screen): Void {
    var scale:Float = 1/z;

    palmTree_left.scaleX = palmTree_left.scaleY = scale;
    palmTree_right.scaleX = -scale;
    palmTree_right.scaleY = scale;

    palmTree_left.x = screen.project_x(-200 + x, z) - (palmTree_left.width/2);
    palmTree_left.y = screen.project_y(y, z) - palmTree_left.height;

    palmTree_right.x = screen.project_x(200 + x, z) - (palmTree_right.width/2);
    palmTree_right.y = screen.project_y(y, z) - palmTree_right.height;

    screen.frameBuffer.draw(palmTree_left, palmTree_left.transform.matrix);
    screen.frameBuffer.draw(palmTree_right, palmTree_right.transform.matrix);
  }
}
