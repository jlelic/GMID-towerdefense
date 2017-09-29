package td.enemy 
{
	import td.Context;
	import td.Coin;
	
	import com.greensock.TweenLite;
	import com.greensock.easing.RoughEase;
	import com.greensock.easing.Power0;

	import flash.utils.setTimeout;
	
	import starling.display.Image;
	import starling.display.Sprite;

	public class Enemy extends Sprite
	{
		public var health: int;
		public var active: Boolean;
		public var toBeDestroyed: Boolean;
		protected var speed: int;
		protected var image: Image;
		protected var dropCoins: int;
		
		public function Enemy(tileY: int) 
		{
			x = 1024+256;
			y = tileY * 128;
			active = true;
			toBeDestroyed = false;
			image.alpha = 1;
			image.x = 0;
			image.y = 0;
			addChild(image);
		}
		
		public function destroy():void{
			active = false;
		}
		
		public function update(deltaTime: Number): void{
			if(active){
				x -= speed * deltaTime;
			}
		}
		
		public function destroyEnemy(coins: Vector.<Coin>) : void{
			active = false;
			trace(coins);
			for (var i :int; i < dropCoins; i++){
				coins.push(new Coin(x, y+i*30));
			}
			
			TweenLite.to(
				image,
				1,
				{
					ease: Power0.easeNone,
					alpha: 0,
					scale: 0.1,
					onComplete: function():void{
						toBeDestroyed = true;
					}
				}
			);
		}
	}

}