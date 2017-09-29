package td 
{
	import starling.display.Sprite;
	import starling.display.Image;
	import starling.textures.Texture;

	public class BuildButton extends Sprite
	{
		public var index: int;
		public var cost: int;
		public var towerClass: Class;
		public var enabled: Boolean;
		private var image: Image;
		private var weaponImage: Image;
		static private var textureEnabled: Texture;
		static private var textureDisabled: Texture;
		static private var texturePressed: Texture;

		public function BuildButton(weaponName: String, towerClass: Class, cost: int) 
		{
			if (!textureEnabled){
				textureEnabled = Context.getTexture("button_enabled");
			}
			if (!textureDisabled){
				textureDisabled = Context.getTexture("button_disabled");
			}
			if (!texturePressed){
				texturePressed = Context.getTexture("button_pressed");
			}
			weaponImage = Context.newImage(weaponName);
			image = new Image(textureEnabled);
			image.x = 0;
			image.y = 0;
			image.width = 128;
			image.height = 128;
			addChild(image);
			addChild(weaponImage);
			enabled = true;
			this.towerClass = towerClass;
			this.cost = cost;
		}
		
		public function press() : void{
			image.texture = texturePressed;
			enabled = false;
		}
		
		public function enable() : void{
			image.texture = textureEnabled;
			enabled = true;
		}
		
		public function disable() : void{
			image.texture = textureDisabled;
			enabled = false;
		}
		
		public function calculateAvailability(coins:int): void{
			if (coins >= cost){
				enable();
			} else {
				disable();
			}
		}
	}

}