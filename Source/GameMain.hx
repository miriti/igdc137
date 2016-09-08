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

  var car_pos = {
    x: 0.0,
    z: 1.25,
    y: 0.0
  }

  public static inline var ROAD_HWIDTH:Float = 160;

  var segments:Array<RoadSegment> = new Array<RoadSegment>();

  public function new() {
    super();

    ferrari.x = (Screen.FRAME_WIDTH - ferrari.bitmapData.width) / 2;
    ferrari.y = Screen.FRAME_HEIGHT - ferrari.bitmapData.height;

    var phase:Float = 0;

    for(i in 0...500) {
      segments.push({
        x: Math.sin(phase) * 200,
        y: Math.sin(phase) * 300,
        z: 1 + i*0.5
        });

        phase += Math.PI / 32;
      }
    }

    function scrollRoad() : Void {
      var dx = segments[0].x - segments[1].x;
      var dy = segments[0].y - segments[1].y;
      var dz = segments[0].z - segments[1].z;

      segments.shift();

      for(s in segments) {
        s.x += dx;
        s.y += dy;
        s.z += dz;
      }
    }

    override function render() : Void {
      super.render();

      frameBuffer.draw(background);

      var n_seg = Std.int(Math.min(30, segments.length-1));

      var hor_y = 240;
      var hor_z:Float = 0;

      for(i in 0...n_seg) {
        var p_y = project_y(segments[i].y, segments[i].z);

        if(p_y < hor_y) {
          hor_y = p_y;
          hor_z = segments[i].z;
        }
      }

      while(n_seg >= 1) {
        var segment = segments[n_seg];
        var next_segment = segments[n_seg-1];

        if(segment.z == hor_z) {
          frameBuffer.fillRect(new Rectangle(0, hor_y, Screen.FRAME_WIDTH, Screen.FRAME_HEIGHT-hor_y), 0xff18183d);
        }

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
        scrollRoad();
      }

      car_pos.y = segments[0].y + (segments[1].y - segments[0].y)*0.5;

      ferrari.x = project_x(car_pos.x, car_pos.z) - (ferrari.bitmapData.width / 2 );
      ferrari.y = project_y(car_pos.y, car_pos.z) - ferrari.bitmapData.height;

      ferrari.draw(frameBuffer);
    }

  }
