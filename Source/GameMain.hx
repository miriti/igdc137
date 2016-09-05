package ;

import openfl.display.BitmapData;
import openfl.Assets;

class GameMain extends Screen {
    
    var roadTexture:BitmapData;
    var z_shift:Float = 0;
    
    public function new() {
        super();
        
        roadTexture = Assets.getBitmapData("assets/road.png");
    }
    
    override function render() : Void {
        super.render();
        
        var segment_count = 25;
        
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
