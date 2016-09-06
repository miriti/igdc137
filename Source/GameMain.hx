package ;

import openfl.geom.Rectangle;
import openfl.geom.Matrix;
import openfl.display.BitmapData;
import openfl.Assets;

typedef RoadSegment = {
  x: Float,
  y: Float,
  z: Float
};

class GameMain extends Screen {
  var roadTexture:BitmapData;
  var background:BitmapData;
  var background_transform:Matrix;
  var z_shift:Float = 0;

  var segments:Array<RoadSegment> = new Array<RoadSegment>();

  public function new() {
    super();

    roadTexture = Assets.getBitmapData("assets/road.png");
    background = Assets.getBitmapData("assets/bg.png");

    for(i in 0...60) {
      segments.push({
        x: 0,
        y: -(i*i),
        z: i*0.5
        });
      }
    }

    override function render() : Void {
      super.render();

      frameBuffer.draw(background);
      frameBuffer.fillRect(new Rectangle(0, 120, 320, 120), 0xff0a0026);

      var n_seg = segments.length-1;

      while(n_seg >= 1) {
        var segment = segments[n_seg];
        var p1 = project(segment.x - 160, segment.y, segment.z + 0.5);
        var p2 = project(segment.x + 160, segment.y, segment.z + 0.5);
        var p3 = project(segment.x - 160, segment.y, segment.z);
        var p4 = project(segment.x + 160, segment.y, segment.z);

        fillRoadPoly(p1[1], p3[1], p1[0], p2[0], p3[0], p4[0], roadTexture, z_shift);

        n_seg--;
      }

      z_shift -= 0.05;

      while(z_shift < 0) {
        z_shift = 1 + z_shift;
      }
    }

  }
