package td.enemy 
{
	import td.Context;

	public class Boat extends Enemy
	{
		
		public function Boat(tileY: int) 
		{
			speed = 60;
			image = Context.newImage("boat");
			health = 17;
			super(tileY);
			dropCoins = 2;
		}
		
	}

}