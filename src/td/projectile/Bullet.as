package td.projectile 
{
	import td.enemy.Enemy;
	import starling.display.Image;
	import td.Context;
	
	public class Bullet extends Projectile
	{
		
		public function Bullet(x: Number, y:Number, angle: Number) 
		{
			image = Context.newImage("bullet");
			speed = 500;
			damage = 1;
			super(null, x, y);
			rotation = angle;
		}
		
		override public function update(deltaTime: Number, enemies: Vector.<Enemy>) : void{
			checkOutOfRange();

			x += Math.sin(rotation)*speed*deltaTime;
			y -= Math.cos(rotation) * speed * deltaTime;
			
			for (var i:int; i < enemies.length; i++){
				if (!enemies[i].active){
					continue;
				}
				
				var dx: Number = enemies[i].x + 64 - x;
				var dy: Number = enemies[i].y + 64 - y;

				if (Math.abs(dx) + Math.abs(dy) < 50){
					enemies[i].health -= damage;
					active = false;
					toBeDestroyed = true;
					return;
				}
			}
		}
	}
}