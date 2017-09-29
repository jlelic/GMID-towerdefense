package
{
	import com.adobe.tvsdk.mediacore.DRMOperationCompleteListener;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.ProgressEvent;
	import starling.core.Starling;
	import flash.geom.Rectangle;
	import td.Game;
	
	import td.Context;
	import td.ContextFlash;
	
	import com.furusystems.dconsole2.DConsole;
	import com.demonsters.debugger.MonsterDebugger;
	
	/**
	 * Entry point of the application.
	 */
	[SWF(frameRate="60", backgroundColor="#0")]
	public class Main extends Sprite 
	{
		
		private var _starling:Starling;
		
		public function Main() 
		{
			this.loaderInfo.addEventListener(ProgressEvent.PROGRESS, loaderInfo_progressHandler);
			this.loaderInfo.addEventListener(Event.COMPLETE, loaderInfo_completeHandler);
		}
		
		protected function loaderInfo_progressHandler(event:ProgressEvent):void
		{
			//this example draws a basic progress bar
			this.graphics.clear();
			this.graphics.beginFill(0x686868);
			var gY:int = (this.stage.stageHeight - 12) / 2;
			var gWidth:int = this.stage.stageWidth * event.bytesLoaded / event.bytesTotal;
			this.graphics.drawRect(0, gY, gWidth, 12);
			this.graphics.endFill();
		}
		
		protected function loaderInfo_completeHandler(event:Event):void
		{
			// unregister event handlers...
			this.loaderInfo.removeEventListener(ProgressEvent.PROGRESS, loaderInfo_progressHandler);
			this.loaderInfo.removeEventListener(Event.COMPLETE, loaderInfo_completeHandler);
			
			//get rid of the progress bar
			this.graphics.clear();			
			
			// default line style
			this.graphics.lineStyle(1, 0xFFFFFF);
			ContextFlash.stageFlash = stage;
			trace(stage.stageWidth);
			trace(stage.stageHeight);
			var stageWidth:int  = Math.max(stage.stageWidth, stage.stageHeight);
			var stageHeight:int = Math.min(stage.stageWidth, stage.stageHeight);
			trace("------");
			stage.setOrientation("rotatedRight");
			trace(stage.stageWidth);
			trace(stage.stageHeight);

			
			//this should remain here, because, this value might change after inicializing starling, keep this
			
			this.graphics.drawRect(0, 0, stageWidth-1, stageHeight-1);
			
			// Scaling of the graphics...
			stage.scaleMode = "noScale"; // StageScaleMode.NO_SCALE ... See: http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/display/StageScaleMode.html
			
			// How "x,y" coords of sprites are treated...
			stage.align = "TL"; // StageAlign.TOP_LEFT ... See: http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/display/StageAlign.html
			
			// (true - useful on mobile devices)
			Starling.multitouchEnabled = false; 
			
			var scale : Number;
			var scales: Array = [
				0.25,
				0.41667,
				0.46875,
				0.5,
				0.83333,
				0.9375,
				1
			]
			for (var i: int; i < scales.length-1; i++){
				scale = scales[i]
				if (stageHeight <= scale*1024){
					break;
				}
			}
			Context.textureScaleFactor = scale;
			Context.textureFolder = i.toString();
			
			Game.starter = this;
			_starling = new Starling( Game, this.stage, new Rectangle(0, 0, stageWidth,  stageHeight));
			_starling.simulateMultitouch = false;
			_starling.enableErrorChecking = false;
			_starling.stage.stageHeight = 1024;
			_starling.stage.stageWidth = stageWidth*(1024/stageHeight);
			_starling.start();
			CONFIG::debug {
				// DOOMSDAY CONSOLE ~ lib/DConsole2.3.swc
				stage.addChild(DConsole.view); // Ctrl+Shift+Enter to show/hide				
			}
		}
				
	}
	
}