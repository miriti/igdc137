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

  var playerCar:Car;
  var cars:Array<Car> = new Array<Car>();

  public static inline var ROAD_HWIDTH:Float = 160;

  var segments:Array<RoadSegment> = new Array<RoadSegment>();

  public function new() {
    super();

    playerCar = new Car();
    playerCar.z = 1;

    for(i in 0...3) {
      var new_ai_car = new AICar(this);
      new_ai_car.x = -100;
      new_ai_car.z = 2 + i;
      cars.push(new_ai_car);
    }

    cars.push(playerCar);

    var phase_x:Float = 0;
    var phase_y:Float = 0;

    for(i in 0...500) {
      segments.push({
        x: Math.sin(phase_x) * 200,
        y: 0, //Math.sin(phase_y) * 300,
        z: 1 + i*0.5
      });

      phase_x += Math.PI / 32;
      phase_y += Math.PI / 32;
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

    cars.sort(function(a, b) {
      return Std.int(b.z - a.z);
    });

    while(n_seg >= 1) {
      var segment = segments[n_seg];
      var next_segment = segments[n_seg-1];

      var p1 = project(segment.x - ROAD_HWIDTH, segment.y, segment.z);
      var p2 = project(segment.x + ROAD_HWIDTH, segment.y, segment.z);
      var p3 = project(next_segment.x - ROAD_HWIDTH, next_segment.y, next_segment.z);
      var p4 = project(next_segment.x + ROAD_HWIDTH, next_segment.y, next_segment.z);

      frameBuffer.fillRect(new Rectangle(0, p1[1], Screen.FRAME_WIDTH, Screen.FRAME_HEIGHT-p3[1]), 0xff18183d);

      fillRoadPoly(p1[1], p3[1], p1[0], p2[0], p3[0], p4[0], roadTexture, z_shift);

      for (car in cars) {
        if((car.z <= segment.z) && (car.z > next_segment.z)) {
          if(segment.y == next_segment.y) {
            car.y = segment.y;
          } else {
            car.y = next_segment.y + (segment.y - next_segment.y) * ((segment.z - car.z) / (segment.y - next_segment.y));
          }
        }
      }

      n_seg--;
    }

    for(car in cars) {
      car.update();
      car.draw(this);
    }

    z_shift -= 0.1;

    while(z_shift < 0) {
      z_shift = 1 + z_shift;
      scrollRoad();
    }
  }
}
