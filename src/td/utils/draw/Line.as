package td.utils.draw
{
	import starling.display.Quad;
	import starling.display.Sprite;
	
	import td.utils.MathUtils;
	
	public class Line extends Primitive
	{
		private var baseQuad:Quad;
		private var _thickness:Number = 1;
		private var _color:uint = 0x000000;
		
		public function Line(color: uint = 0x000000)
		{
			touchable = false;
			_color = color;
			baseQuad = new Quad(1, _thickness, _color);
			addChild(baseQuad);
		}
		
		public function makeLine(x1: Number, y1: Number, x2: Number, y2: Number) : void {
			makeLineTo(x2-x1, y2-y1);
			x = x1;
			y = y1;
		}
		
		public function makeLineTo(toX:int, toY:int):void
		{
			var len: Number = MathUtils.distance(0, 0, toX, toY);
			baseQuad.rotation = 0;
			baseQuad.width = len;			
			baseQuad.rotation = Math.atan2(toY, toX);
		}
		
		public function set thickness(t:Number):void
		{
			var currentRotation:Number = baseQuad.rotation;
			baseQuad.rotation = 0;
			baseQuad.height = _thickness = t;
			baseQuad.rotation = currentRotation;
		}
		
		public function get thickness():Number
		{
			return _thickness;
		}
		
		public function set color(c:uint):void
		{
			baseQuad.color = _color = c;
		}
		
		public function get color():uint
		{
			return _color;
		}
	}
}