package td.projectile 
{
	import td.enemy.Enemy;
	import starling.display.Image;
	import td.Context;
	
	public class Rocket extends Projectile
	{
		
		public function Rocket(enemy: Enemy, x: Number, y:Number) 
		{
			image = Context.newImage("rocket");
			speed = 350;
			damage = 8;
			super(enemy, x, y);
		}
	}

}