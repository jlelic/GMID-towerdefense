package td.tower 
{
	import starling.display.Sprite;
	import td.Island;
	import td.Context;
	import td.enemy.Enemy;
	import td.projectile.Rocket;
	import td.projectile.Projectile;

	
	public class RocketBase extends Tower
	{
		
		public function RocketBase(island: Island) 
		{
			image = Context.newImage("rocket_base");
			super(island);
			fireRate = 3.2;
			range = 1900;
		}
		
		override protected function fire(screen: Sprite, enemies: Vector.<Enemy>, projectiles: Vector.<Projectile>) : Boolean {
			var target: Enemy = findClosestEnemy(enemies);
			if (!target){
				return false;
			}
			var rocket: Rocket = new Rocket(target, x, y);
			
			projectiles.push(rocket);
			screen.addChild(rocket);
			
			return true;
		}
	}

}