package;

import openfl.display.BitmapData;
import openfl.display.Bitmap;
import openfl.media.Sound;
import openfl.media.SoundChannel;
import openfl.Assets;

class Car {
  var engineSound:Sound = Assets.getSound('assets/sound/engine-loop-1-normalized.wav');
  var _engineSoundChannel:SoundChannel;
  
  public var x:Float = 0.0;
  public var y:Float = 0.0;
  public var z:Float = 0.0;

  public var throttle: Float = 0; // 0 ... 1
  public var rpm: Float = 1800;
  public var rpm_idle: Float = 1800; //
  public var rpm_max: Float = 8000;
  public var rpm_inc: Array<Float> = [0.0, 4000.0, 2500.0, 1400, 1100, 900, 600];
  public var gear: Int = 0; // 0 = N
  public var gear_max: Int = 6;
  public var gear_speed: Array<Float> = [0.0, 25, 40, 70, 100, 160, 240];
  public var speed: Float = 0.0;
  public var engine_braking: Float = 500;

  private static var bitmap:Bitmap = null;
  
  var game:Game;

  public function new(game: Game) {
    
    this.game = game;

    if(bitmap == null) {
      bitmap = new Bitmap(Assets.getBitmapData("assets/ferrari.png"));
    }
  }

  public function playEngineSound():Void {
    _engineSoundChannel = engineSound.play();
  }

  public function update(): Void {
    if(throttle == 0) {
      rpm -= engine_braking / 120;
      rpm = Math.max(rpm, rpm_idle);
    } else {
      rpm += (rpm_inc[gear] * throttle) / 120;
      rpm = Math.min(rpm, rpm_max);
    }
    
    speed = gear_speed[gear] * (rpm / rpm_max);
  }
  
  public function gotoGear(new_gear:Int) {
    gear = Std.int(Math.min(new_gear, gear_max));
    
    rpm = (speed / gear_speed[new_gear]) * rpm_max;
    rpm = Math.min(rpm, rpm_max);
  }

  public function draw(screen:Screen): Void {
    var pos2d = screen.project(x, y, z);
    var scale = 1/z;

    bitmap.scaleX = bitmap.scaleY = scale;
    bitmap.x = pos2d[0] - (bitmap.width / 2);
    bitmap.y = pos2d[1] - bitmap.height * scale;

    screen.frameBuffer.draw(bitmap, bitmap.transform.matrix);
  }
}
