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
  var roadTexture:BitmapData = Assets.getBitmapData("assets/road.png");
  var background:BitmapData = Assets.getBitmapData("assets/bg.png");
  var ferrari:PSprite = new PSprite(Assets.getBitmapData("assets/ferrari.png"));

  var background_transform:Matrix;
  var z_shift:Float = 0;

  public static inline var ROAD_HWIDTH:Float = 200;

  var segments:Array<RoadSegment> = new Array<RoadSegment>();

  public function new() {
    super();

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

      var min_y:Float = 0;
      var h_z:Float = 0;

      for(s in segments ){
          if(s.y < min_y) {
              min_y = s.y;
              h_z = s.z;
          }
      }

      frameBuffer.fillRect(new Rectangle(0, project_y(min_y, h_z), 320, 240), 0xff0a0026);

      var n_seg = segments.length-1;

      while(n_seg >= 1) {
        var segment = segments[n_seg];
        var next_segment = segments[n_seg-1];

        var p1 = project(segment.x - ROAD_HWIDTH, segment.y, segment.z);
        var p2 = project(segment.x + ROAD_HWIDTH, segment.y, segment.z);
        var p3 = project(next_segment.x - ROAD_HWIDTH, next_segment.y, next_segment.z);
        var p4 = project(next_segment.x + ROAD_HWIDTH, next_segment.y, next_segment.z);

        fillRoadPoly(p1[1], p3[1], p1[0], p2[0], p3[0], p4[0], roadTexture, z_shift);

        n_seg--;
      }

      z_shift -= 0.1;

      while(z_shift < 0) {
        z_shift = 1 + z_shift;
      }

      ferrari.draw(frameBuffer);
    }

  }
