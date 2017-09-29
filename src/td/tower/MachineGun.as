package td.tower 
{
	import com.greensock.TweenLite;
	import starling.display.Sprite;
	import td.Island;
	import td.Context;
	import td.enemy.Enemy;
	import td.projectile.Bullet;
	import td.projectile.Rocket;
	import td.projectile.Projectile;
	import com.greensock.easing.Power4;

	
	public class MachineGun extends Tower
	{
		private var clip : int;
		public function MachineGun(island: Island) 
		{
			image = Context.newImage("machine_gun");
			super(island);
			fireRate = 0.2;
			range = 600;
			clip = 3;
		}
		
		override protected function fire(screen: Sprite, enemies: Vector.<Enemy>, projectiles: Vector.<Projectile>) : Boolean {
			Context.playSound("shot");
			var bullet1: Bullet = new Bullet(x+96, y, Math.PI/2);			
			var bullet2: Bullet= new Bullet(x+96, y, Math.PI/2);
			TweenLite.to(bullet1, 0.3, {y: y-48, ease: Power4});
			TweenLite.to(bullet2, 0.3, {y: y+192, ease: Power4});
			projectiles.push(bullet1);
			screen.addChild(bullet1);			
			projectiles.push(bullet2);
			screen.addChild(bullet2);
			clip--;
			if (clip <= 0){
				clip = 3
				fireRate = 1.8;
			} else {
				fireRate = 0.2;
			}
			return true;
		}
	}

}