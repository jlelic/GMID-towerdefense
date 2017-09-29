package td.tower 
{
	import starling.display.Sprite;
	import starling.display.Image;
	import td.Island;
	import td.enemy.Enemy;
	import td.projectile.Projectile;

	public class Tower extends Sprite
	{
		protected var image: Image;
		protected var toNextFire: Number;
		protected var fireRate: Number;
		protected var range: int;

		public function Tower(island: Island)
		{
			x = island.x;
			y = island.y;
			addChild(image);
			toNextFire = 1;
		}

		public function update(deltaTime:Number, screen: Sprite, enemies: Vector.<Enemy>, projectiles: Vector.<Projectile>) : void {
			toNextFire -= deltaTime;
			if (toNextFire <= 0) {
				if(fire(screen, enemies, projectiles)){
					toNextFire = fireRate;
				}
			}
		}		
		
		protected function fire(screen: Sprite, enemies: Vector.<Enemy>, projectiles: Vector.<Projectile>) : Boolean {
			throw "Tower doesn't implement fire function!";
		}		
		
		protected function findClosestEnemy(enemies: Vector.<Enemy>): Enemy{
			var closestEnemy:Enemy = null;
			var closestDistanceSquared: Number = 999999;
			
			enemies.forEach(function(enemy: Enemy, index:int, vector:Vector.<Enemy>) : void {
				if (!enemy.active) {
					return;
				}
				var dx:Number = enemy.x - x;
				var dy:Number = enemy.y - y;
				var distanceSquared:Number = dx * dx + dy * dy;
				if (distanceSquared < closestDistanceSquared && distanceSquared < range*range){
					closestDistanceSquared = distanceSquared;
					closestEnemy = enemy;
				}
			});
			
			return closestEnemy;
		}
	}

}