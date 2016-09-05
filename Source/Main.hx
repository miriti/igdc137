package;

import openfl.events.Event;
import openfl.events.KeyboardEvent;
import openfl.display.Sprite;
import openfl.display.FPS;
import openfl.display.BitmapData;
import openfl.display.Bitmap;
import openfl.display.StageQuality;
import openfl.geom.Rectangle;
import openfl.Assets;
import openfl.Lib;

class Main extends Sprite {

	var roadTexture:BitmapData;
	var bitmapData:BitmapData;
	var bitmap:Bitmap;
	var cameraY:Int = 120;
	var cameraX:Int = 0;
	var scaling:Float = 1.0;
	var cx:Int = Std.int(320 / 2);
	var cy:Int = Std.int(240 / 2);

	var z_shift:Float = 0;

	var move:Float = 0;

	public function new () {
		super ();

		Lib.current.stage.quality = StageQuality.LOW;

		roadTexture = Assets.getBitmapData("assets/road.png");

		bitmapData = new BitmapData(320, 240, false, 0xffffffff);

		var fullRect = new Rectangle(0, 0, 320, 240);

		bitmap = new Bitmap(bitmapData);
		bitmap.scaleX = bitmap.scaleY = 2;
		addChild(bitmap);

		var fps = new FPS();
		addChild(fps);

		addEventListener(Event.ENTER_FRAME, onEnterFrame);

		Lib.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, function(e:KeyboardEvent):Void {
			if(e.keyCode == 37) {
				cameraX -= 2;
			}

			if(e.keyCode == 39) {
				cameraX += 2;
			}
		});
	}

	function project_x(world_x:Float, world_z:Float): Int {
		return cx + Std.int(((world_x + cameraX)*scaling) / world_z);
	}

	function project_y(world_y:Float, world_z:Float) : Int {
		return cy + Std.int(((world_y + cameraY) * scaling) / world_z);
	}

	function project(world_x:Float, world_y:Float, world_z:Float) : Array<Int> {
		if(world_z == 0) {
			world_z = 1;
		}
		return [
			cx + Std.int(((world_x - cameraX) * scaling) / world_z),
			cy + Std.int(((world_y + cameraY) * scaling) / world_z)
		];
	}

	function fillRoadPoly(yStart:Int, yEnd:Int, x1:Int, x2:Int, x3:Int, x4:Int, texture:BitmapData, v:Float = 0.0) {
		if(v > 1) v = 1;
		if(v < 0) v = 0;

		for(scanLine in yStart...yEnd) {
			if(scanLine >= 320) return;
			var process:Float = (scanLine - yStart) / (yEnd - yStart);

			var xStart = Std.int(x1 + (x3 - x1) * process);
			var xEnd = Std.int(x2 + (x4 - x2) * process);

			for(f_x in xStart...xEnd) {
				var texture_x:Int = Std.int(texture.width * ((f_x - xStart) / (xEnd - xStart)));
				var texture_y:Int = Std.int(texture.height * v) + Std.int(texture.height * process);

				if(texture_y >= texture.height) {
					texture_y = texture_y - texture.height;
				}

				var texturePixel = texture.getPixel(texture_x, texture_y);

				bitmapData.setPixel32(f_x, scanLine, texturePixel);
			}
		}
	}

	function drawPolygon(verts:Array<Vertex>, texture:BitmapData, color:UInt) : Void {
		if(verts.length == 4) {
			for(v in verts) {

			}
		} else {
			throw "A polygon should contain 4 vertices";
		}
	}

	function onEnterFrame(e:Event) : Void {
		var segment_count = 25;

		bitmapData.fillRect(new Rectangle(0, 0, 320, 240), 0x228dcb);
		bitmapData.fillRect(new Rectangle(0, project_y(0, segment_count), 320, 120), 0x008833);

		for(segment in 1...segment_count) {
			var p1 = project(-160, 0, (segment_count - segment) * 0.5 + 0.5);
			var p2 = project(160, 0, (segment_count - segment) * 0.5 + 0.5);
			var p3 = project(-160, 0, (segment_count - segment) * 0.5);
			var p4 = project(160, 0, (segment_count - segment) * 0.5);

			fillRoadPoly(p1[1], p3[1], p1[0], p2[0], p3[0], p4[0], roadTexture, z_shift);
		}

		z_shift -= 0.05;

		while(z_shift < 0) {
			z_shift = 1 + z_shift;
		}
	}


}
