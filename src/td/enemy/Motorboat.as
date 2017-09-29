package td.enemy 
{
	import td.Context;

	public class Motorboat extends Enemy
	{
		
		public function Motorboat(tileY: int) 
		{
			speed = 180;
			image = Context.newImage("motorboat");
			health = 9;
			super(tileY);
			dropCoins = 3;
		}
		
	}

}