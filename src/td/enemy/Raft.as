package td.enemy 
{
	import td.Context;

	public class Raft extends Enemy
	{
		
		public function Raft(tileY: int) 
		{
			speed = 40;
			image = Context.newImage("raft");
			health = 7;
			super(tileY);
			dropCoins = 1;
			Context.playSound("raft");
		}
		
	}

}