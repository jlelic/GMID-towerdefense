package td.utils.draw
{
	import starling.display.Quad;
	import starling.display.Sprite;
	
	public class Rectangle extends Primitive
	{
		private var baseQuad:Quad;
		private var _thickness:Number = 1;
		private var _color:uint = 0x000000;
		
		public function Rectangle(width: Number, height: Number, color: uint = 0x000000, colorLine: uint = 0x000000, lineThickness: Number = -1)
		{
			touchable = false;
			
			var quad: Quad = new Quad(width, height, color);
			addChild(quad);
			
			if (lineThickness > 0) {
				line(0, 0, width, 0, colorLine, lineThickness);
				line(width, 0, width, height, colorLine, lineThickness);
				line(width, height, 0, height, colorLine, lineThickness);
				line(0, height, 0, 0, colorLine, lineThickness);				
			}
		}		
	}
}