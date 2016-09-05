package;

import openfl.display.BitmapData;
import openfl.geom.Rectangle;

class Screen  {
    public static inline var FRAME_WIDTH:Int = 320;
    public static inline var FRAME_HEIGHT:Int = 240;
    public static inline var CLEAR_COLOR:UInt = 0xffffffff;
    
    public var frameBuffer: BitmapData = null;
    public var cameraY:Int = 120;
	public var cameraX:Int = 0;
	var scaling:Float = 1.0;
	var cx:Int = Std.int(FRAME_WIDTH / 2);
	var cy:Int = Std.int(FRAME_HEIGHT / 2);
    
    private var clearRect:Rectangle = new Rectangle(0, 0, FRAME_WIDTH, FRAME_HEIGHT);
    
    public function new() {
        frameBuffer = new BitmapData(FRAME_WIDTH, FRAME_HEIGHT, false, CLEAR_COLOR);
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
                
                frameBuffer.setPixel32(f_x, scanLine, texturePixel);
            }
        }
    }
    
    public function keyDown(keyCode:Int) : Void {
        
    }
    
    public function keyUp(keyCode:Int) : Void {
        
    }
    
    public function update(delta:Float) : Void {
        
    }
    
    public function render() : Void {
        
    }
}
