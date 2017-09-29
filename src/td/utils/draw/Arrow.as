package td.utils.draw
{
	import starling.display.Quad;
	import starling.display.Sprite;
	import td.utils.MathUtils;
	import td.utils.draw.Line;
	public class Arrow extends Primitive
	{
		private var lines: Array = [];
		private var _thickness:Number = 2;
		private var _color:uint = 0x000000;
		
		public function Arrow(color: uint = 0x000000)
		{
			touchable = false;
			_color = color;
			for (var i: int = 0; i < 3; ++i) {
				var line: Line = new Line();
				line.thickness = _thickness;
				line.color = _color;
				addChild(line);
				lines.push(line);
			}
		}
		
		public function arrow(x1: Number, y1: Number, x2: Number, y2: Number) : void {
			this.x = x1;
			this.y = y1;
			arrowTo(x2-x1, y2-y1);
		}
		
		public function arrowTo(toX:int, toY:int):void
		{
			var len: Number = MathUtils.distance(0, 0, toX, toY); 
			
			pivotX = 0;
			pivotY = 0;
			
			var line1: Line = lines[0];
			line1.makeLineTo(len, 0);
			
			var line2: Line = lines[1];
			line2.makeLineTo(-10, -10);
			line2.x = len;
			
			var line3: Line = lines[2];
			line3.makeLineTo(-10, 10);
			line3.x = len;
			
			rotation = Math.atan2(toY, toX);
		}
		
		public function set thickness(t:Number):void
		{
			_thickness = t;
			for (var i: int = 0; i < 3; ++i) {
				var line: Line = new Line();
				line.thickness = t;
			}
			
			var line3: Line = lines[2];
			
//			var currentRotation:Number = baseQuad.rotation;
//			baseQuad.rotation = 0;
//			baseQuad.height = _thickness = t;
//			baseQuad.rotation = currentRotation;
		}
		
		public function get thickness():Number
		{
			return _thickness;
		}
		
		public function set color(c:uint):void
		{
			_color = c;
			for (var i: int = 0; i < 3; ++i) {
				var line: Line = new Line();
				line.color = c;
			}
		}
		
		public function get color():uint
		{
			return _color;
		}
	}
}