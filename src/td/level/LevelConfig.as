package td.level 
{

	public class LevelConfig 
	{
		public var islands: Array;
		public var startingCoins: int;
		public var lives: int;
		
		public function LevelConfig(lives: int, startingCoins: int, islands: Array) 
		{
			this.lives = lives;
			this.islands = islands;
			this.startingCoins = startingCoins;
		}
		
	}

}