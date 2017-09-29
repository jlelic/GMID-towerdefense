package td 
{
	import td.level.LevelConfig;
	import td.level.LevelEvent;

	public class LevelEvents
	{
		static public var events: Array = [
			[
				new LevelConfig(
					100,
					[1,1],
					[0,1],
					[3,1],
					[2,3],
					[3,3],
					[0,3],
					[1,5],
					[0,5],
					[3,5]
				),
				[LevelEvent.WAIT, 5],
				[LevelEvent.BOAT, 0],
				[LevelEvent.BOAT, 3],
				[LevelEvent.BOAT, 4],
				[LevelEvent.WAIT, 5],
				[LevelEvent.BOAT, 0],
				[LevelEvent.BOAT, 3],
				[LevelEvent.BOAT, 4]
			}
			]
		];
	}
}
