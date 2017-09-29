package td 
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Power4;
	import starling.display.Image;
	import starling.display.Sprite;

	public class Coin extends Sprite
	{
		
		private var image : Image;
		private var tween : TweenLite;
		
		public function Coin(x: Number, y: Number)
		{
			this.x = x;
			this.y = y;
			image = Context.newImage("coin");
			addChild(image);
			tween = TweenLite.to(this, 8, {y: 1600, ease: Power4});
		}
		
	}

}