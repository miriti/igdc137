package ;

import openfl.geom.Rectangle;
import openfl.geom.Matrix;
import openfl.display.BitmapData;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.Assets;
import motion.Actuate;

class Game extends Screen {
  public static var instance:Game;

  var roadTexture:BitmapData = Assets.getBitmapData("assets/road.png");
  var background:BitmapData = Assets.getBitmapData("assets/bg.png");

  var background_transform:Matrix;

  var playerCar:PlayerCar;
  var cars:Array<Car> = new Array<Car>();

  var rpmHud:RpmHud;

  public static inline var ROAD_HWIDTH:Float = 160;

  var segments:Array<RoadSegment> = new Array<RoadSegment>();

  var gameStarted:Bool = false;

  var countdownDigits:Array<CountdownDigit> = new Array<CountdownDigit>();

  var counts = ['3', '2', '1', "GO!"];
  
  var road_shift = {
    x: 0,
    y: 0,
    z: 0
  }

  public function new(playerName: String) {
    super();

    instance = this;

    var phase_x:Float = 0;
    var phase_y:Float = 0;

    for(i in 0...5000) {
      var segment = new RoadSegment();

      segment.x = Math.sin(phase_x) * 200;
      segment.y = Math.sin(phase_y) * 300;
      segment.z = 1 + i * 0.5;

      segments.push(segment);

      phase_x += Math.PI / 32;
      phase_y += Math.PI / 32;
    }

    playerCar = new PlayerCar(this, playerName);
    playerCar.z = 1;
    
    var names:Array<String> = Names.igdc;
    
    names.filter(function(n:String): Bool {
      return (n != playerName);
    });
    
    names.sort(function(a:String, b:String): Int {
      return Math.random() > 0.5 ? -1 : 1;
    });

    for(i in 0...3) {
      var new_ai_car = new AICar(this, names.pop());
      new_ai_car.x = -100 + segments[i+2].x;
      new_ai_car.z = 2 + i;
      cars.push(new_ai_car);
    }

    cars.push(playerCar);

    rpmHud = new RpmHud();
    rpmHud.x = Screen.FRAME_WIDTH - 97;
    rpmHud.y = Screen.FRAME_HEIGHT - 33;

    Actuate.timer(0.5).onComplete(function() {
      nextDigit();
    });
  }

  function nextDigit() : Void {
    var digit = new CountdownDigit(counts.shift());
    digit.x = Screen.FRAME_WIDTH / 2;
    digit.y = -100;
    countdownDigits.push(digit);

    Actuate.tween(digit, 0.2, {
        y: Screen.FRAME_HEIGHT / 2
      }).onComplete(function() {
      Actuate.tween(digit, 0.5, {
        y: Screen.FRAME_HEIGHT + 100
        }).delay(0.3).onComplete(function() {
          if(counts.length > 0) {
            nextDigit();
          } else {
            gameStarted = true;
            playerCar.gotoGear(1);
          }
        });
      });
  }

  function scrollRoad(amount:Float) : Void {
    return ;
    // TODO: Move road shift
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

      fillRoadPoly(p1[1], p3[1], p1[0], p2[0], p3[0], p4[0], roadTexture);

      next_segment.drawDecorations(this);

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
    
    scrollRoad(((playerCar.speed * (10/36)) / 120) * 0.5);

    for(car in cars) {
      //car.update();
      car.draw(this);
    }

    rpmHud.value = playerCar.rpm / playerCar.rpm_max;
    rpmHud.speed = Std.int(playerCar.speed);
    frameBuffer.draw(rpmHud, rpmHud.transform.matrix);

    for(digit in countdownDigits) {
      frameBuffer.draw(digit, digit.transform.matrix);
    }
  }

  override public function keyDown(keyCode:Int): Void {
    if(keyCode == Input.KEY_ESCAPE) {
      Main.instance.currentScreen = new PauseMenu();
    }

    if(gameStarted) {
      if(keyCode == Input.keyBindings["gear_plus"]) {
        playerCar.gotoGear(playerCar.gear + 1);
        rpmHud.gear = playerCar.gear;
      }

      if(keyCode == Input.keyBindings["gear_minus"]) {
        playerCar.gotoGear(playerCar.gear - 1);
        rpmHud.gear = playerCar.gear;
      }
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
