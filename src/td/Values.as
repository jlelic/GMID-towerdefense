package td 
{
	import starling.display.Sprite;
	/**
	 * ...
	 * @author Jakub Gemrot
	 */
	public class Values extends Sprite
	{
		
		public var v : * = {		
			tweens : {
				menu : {
					duration : 10
				}
			}			
		};
		
		public function Values() 
		{
			Context.values = this;
			Context.v = this.v;
			Context.game.addChild(this);
		}
		
		public function setValue(key: String, value: * ) : void {
			
			var keys: Array = key.split(".");
			
			var v: * = this.v;
			
			for (var i: int = 0; i < keys.length-1; ++i) {
				if (keys[i] in v) {
					v = v[keys[i]];					
				} else {
					v[keys[i]] = {};
				}
			}
			
			v[keys.length - 1] = value;			
		}
		
		public function getValue(key: String) : * {
			var keys: Array = key.split(".");
			
			var v: * = this.v;
			
			for (var i: int = 0; i < keys.length; ++i) {
				if (keys[i] in v) {
					v = v[keys[i]];					
				} else {
					return null;
				}
			}
			
			return v;
		}
		
	}

}