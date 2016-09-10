package ;

import openfl.geom.Rectangle;
import openfl.geom.Matrix;
import openfl.display.BitmapData;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.Assets;

typedef RoadSegment = {
  x: Float,
  y: Float,
  z: Float
};

class Game extends Screen {
  public static var instance:Game;

  var roadTexture:BitmapData = Assets.getBitmapData("assets/road.png");
  var background:BitmapData = Assets.getBitmapData("assets/bg.png");
  var ferrari:PSprite = new PSprite(Assets.getBitmapData("assets/ferrari.png"));

  var background_transform:Matrix;
  var z_shift:Float = 0;

  var playerCar:PlayerCar;
  var cars:Array<Car> = new Array<Car>();
  
  var rpm_hud:TextField;

  public static inline var ROAD_HWIDTH:Float = 160;

  var segments:Array<RoadSegment> = new Array<RoadSegment>();

  public function new() {
    super();

    instance = this;

    playerCar = new PlayerCar(this);
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

    for(i in 0...5000) {
      segments.push({
        x: Math.sin(phase_x) * 200,
        y: 0, //Math.sin(phase_y) * 300,
        z: 1 + i*0.5
      });

      phase_x += Math.PI / 32;
      phase_y += Math.PI / 32;
    }
    
    rpm_hud = new TextField();
    rpm_hud.setTextFormat(new TextFormat("_sans", 20, 0xffffff));
    rpm_hud.text = "0 rpm";
    rpm_hud.x = 0;
    rpm_hud.y = 320 - rpm_hud.textHeight;
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

    playerCar.update();
    
    z_shift -= (playerCar.speed * (10/36)) / 120;
    
    while(z_shift < 0) {
      z_shift = 1 + z_shift;
      scrollRoad();
    }

    for(car in cars) {
      //car.update();
      car.draw(this);
    }
    
    rpm_hud.text = [
      "gear: " + playerCar.gear,
      playerCar.rpm + " rpm",
      playerCar.speed + " km/h"
      ].join("\n");
      
    frameBuffer.draw(rpm_hud); //, rpm_hud.transform.matrix);
  }

  override public function keyDown(keyCode:Int): Void {
    if(keyCode == Input.KEY_ESCAPE) {
      Main.instance.currentScreen = new PauseMenu();
    }
    
    if(keyCode == Input.keyBindings["gear_plus"]) {
      playerCar.gotoGear(playerCar.gear + 1);
    }

    if(keyCode == Input.keyBindings["gear_minus"]) {
      playerCar.gotoGear(playerCar.gear - 1);
    }

    if( keyCode == Input.keyBindings["accelerate"] ) {
      playerCar.throttle = 1;
    }
  }

  override public function keyUp(keyCode:Int): Void {
    if( keyCode == Input.keyBindings["accelerate"] ) {
      playerCar.throttle = 0;
    }
  }
}
