package td.utils.draw
{
	import starling.display.DisplayObject;
	import starling.display.Sprite;

	public class Circle extends Primitive
	{
		public function Circle()
		{
			
		}
		
		/**
		 * @param vertices 
		 */
		public function drawCircle(radius: Number, color: uint = 0, vertices: int = -1, thickness: Number = 2) : void {
			try {
				while (true) {
					removeChildAt(0);
				}
			} catch (e:Error) {				
			}
			
			if (vertices < 0) {
				vertices = radius * Math.PI * 2 / 10;
				if (vertices < 16) vertices = 16;
			}
			var angle: Number = 0;
			var angleStep: Number = 2*Math.PI/vertices;
			var x1: Number = Math.cos(angle) * radius;
			var y1: Number = Math.sin(angle) * radius;
			for (var i:int = 0; i < vertices; ++i) {
				angle += angleStep;
				
				var x2: Number = Math.cos(angle) * radius;
				var y2: Number = Math.sin(angle) * radius;
					
				var line: Line = new Line(color);
				line.thickness = thickness;
				line.line(x1, y1, x2, y2);
				addChild(line);
				
				x1 = x2;
				y1 = y2;
			}			
		}
		
		public function die() : void {
			
		}
		
	}
	
}