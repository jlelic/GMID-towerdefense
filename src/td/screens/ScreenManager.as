package td.screens 
{
	import starling.display.Sprite;
	import td.Context;
	import td.ContextFlash;
	
	import flash.system.Capabilities;
	
	/**
	 * ScreenManager entry point; manages screens.
	 * @author Jakub Gemrot
	 */
	public class ScreenManager 
	{
		
		private var currentScreen: Sprite;
		
		public var stageWidth: Number;
		public var stageHeight: Number;
		
		public var screenResolutionX: Number;
		public var screenResolutionY: Number;
		public var screenDPI: Number;
		
		public function ScreenManager() 
		{
			Context.screenManager = this;
			
			stageWidth = Context.stage.stageWidth;
			stageHeight = Context.stage.stageHeight;
			
			screenDPI = Capabilities.screenDPI;
			screenResolutionX = Capabilities.screenResolutionX;
			screenResolutionY = Capabilities.screenResolutionY;
		}
		
		public function showScreen( screen:Sprite ):void {
			if( currentScreen ){
				Context.game.removeChild(currentScreen,true);
			}
			currentScreen = screen;
			Context.game.addChild(screen);
		}
		
	}

}