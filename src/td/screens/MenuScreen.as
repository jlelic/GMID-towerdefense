package td.screens 
{
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import td.particles.ParticlesExample;
	import td.ui.TextButton;
	
	import td.Context;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.TouchEvent;
	
	import com.greensock.TweenLite;
	import com.greensock.easing.Elastic;
	
	public class MenuScreen extends Sprite
	{
		private var background: Sprite;
		
		private var backgroundImg: Image;
		
		private var particles: ParticlesExample;
	
		
		public function MenuScreen() 
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage); 
		}
		
		private function onAddedToStage(e: * = null) : void {
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage); 
			
			background = new Sprite();
			background.width = Context.assets.stageWidth;
			background.height = Context.assets.stageHeight;
			addChild(background);		

			var brown : Image = Context.newImage("brown");
			brown.width = Context.assets.stageWidth;
			brown.height = Context.assets.stageHeight;
			background.addChild(brown);
			
			backgroundImg = Context.newImage("background");
			backgroundImg.tileGrid = new Rectangle();
			backgroundImg.width = Context.assets.stageWidth;
			backgroundImg.height = Context.assets.stageHeight;
			background.addChild(backgroundImg);
			
			
			([0, 1, 2, 3, 4]).forEach(function(i, index, x) : void{
				var button : TextButton = new TextButton("Level "+index, 80, onPlay(index));
				button.width = 700;
				button.height = 180;
				button.x = Context.assets.stageWidth / 2 - button.width / 2;
				button.y = 48 + 200 * index;
				addChild(button);
			})

			
			// USE MONSTER DEBUGGER TO FIND CORRECT X,Y,SCALE
			// TO FIT PARTICLES ONTO THE PLANE IN THE UPPER-RIGHT PART
			// OF BACKGROUND IMAGE
			//particles = new ParticlesExample();
			//particles.x = 487;
			//particles.y = 40;
			//particles.scale = 0.4;
			
			// TRY TO ATTACH PARTICLES ONTO DIFFERENT CONTAINER
			//addChild(particles);
			//background.addChild(particles);
			
			//particles.start();
			
			// background.scale = 0;
			// TweenLite.to(background, Context.v.tweens.menu.duration, {ease: Elastic.easeOut.config(1.2, 0.3), scale: 1 });
			
		}
		
		private function onPlay(levelId: int) : Function {
			return function(event: TouchEvent = null):void{
				Context.showScreen(new LevelScreen(levelId));
			}
		}
		
	}

}