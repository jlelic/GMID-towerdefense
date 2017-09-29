package td.projectile 
{
	import starling.display.Image;
	import starling.display.Sprite;
	import td.enemy.Enemy;
	import td.Context;

	public class Projectile extends Sprite
	{
		public var damage: int;
		public var speed: int;
		public var target: Enemy;
		public var active: Boolean;
		public var toBeDestroyed: Boolean;
		protected var image: Image;	
		
		public function Projectile(target: Enemy, x: Number, y:Number) 
		{
			toBeDestroyed = false;
			this.target = target;
			addChild(image);
			this.x = x;
			this.y = y;
			alignPivot();
		}
		
		protected function checkOutOfRange() :void{
			if (x <-128 || y <-128 || x > 1600 || y > 1600) {
				toBeDestroyed = true;
			}
		}
		
		public function update(deltaTime: Number, enemies: Vector.<Enemy>) : void{
			if (!target.active){
				toBeDestroyed = true;
				return
			}

			checkOutOfRange();
			
			var dx: Number = target.x + 64 - x;
			var dy: Number = target.y + 64 - y;

			if (Math.abs(dx) + Math.abs(dy) < 10){
				target.health -= damage;
				active = false;
				toBeDestroyed = true;
				Context.playSound("explosion");
				return;
			}
			
			var angle:Number = Math.atan(dy / dx);
			rotation = angle + Math.PI / 2;
			if (dx < 0){
				rotation += Math.PI;
			}
			x += Math.sin(rotation)*speed*deltaTime;
			y -= Math.cos(rotation)*speed*deltaTime;
		}
		
	}

}