package td 
{
	import starling.display.Sprite;
	import starling.display.Image;

	public class Island extends Sprite
	{
		public var tileX: int;
		public var tileY: int;
		public var empty: Boolean;
		private var image: Image;
		private var highlightImage: Image;

		
		public function Island(tileX: int, tileY: int) 
		{
			this.tileX = tileX;
			this.tileY = tileX;
			x = tileX * 128;
			y = tileY * 128;
			empty = true;
			image = Context.newImage("island");
			highlightImage = Context.newImage("highlight");
			addChild(image);
		}
		
		public function highlight():void{
			addChild(highlightImage);
		}		
		
		public function cancelHighlight():void{
			removeChild(highlightImage);
		}
	}

}