package td.screens 
{
	import adobe.utils.CustomActions;
	import flash.geom.Rectangle;
	import starling.display.ButtonState;
	import starling.events.EnterFrameEvent;
	import starling.text.TextField;
	import starling.text.TextFormat;
	import starling.textures.Texture;
	import td.BuildButton;
	import td.Context;
	import td.Island;
	import td.level.Level;
	import td.level.LevelEvents;
	import td.tower.MachineGun;
	import td.tower.RocketBase;
	
	import starling.utils.Color;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.TouchEvent;
	
	import com.greensock.TweenLite;
	import com.greensock.easing.Elastic;

	/**
	 * ...
	 * @author Jozef Lelič
	 */
	public class LevelScreen extends Sprite
	{
		private var gameScreen: Sprite;
		private var gameMenuScreen: Sprite;
		private var coinsScreen: Sprite;
		
		private var waterImg: Image;
		private var boatImg: Image;
		private var level: Level;
		private var gameState: GameState;
		private var pressedButton: BuildButton;
		private var coinsText: TextField;
		private var livesText: TextField;
		private var levelId: int;
		private var buttons: Vector.<BuildButton>;
		private var cancelButton : Image;
		
		public function LevelScreen(levelId: int) 
		{
			this.levelId = levelId;
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(e: * = null) : void {
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			gameScreen = new Sprite();
			gameScreen.pivotX = 0;
			gameScreen.pivotY = 0;
			gameScreen.x = Context.assets.stageWidth - 1024-256;
			gameScreen.y = 0;
			gameScreen.width = 1024+256;
			gameScreen.height = 1024;
			addChild(gameScreen);	
			
			coinsScreen = new Sprite();
			coinsScreen.pivotX = 0;
			coinsScreen.pivotY = 0;
			coinsScreen.x = Context.assets.stageWidth - 1024-256;
			coinsScreen.y = 0;
			coinsScreen.width = 1024+256;
			coinsScreen.height = 1024;
			addChild(coinsScreen);

			waterImg = Context.newImage("water");
			waterImg.width = 1024 + 256;
			gameScreen.addChild(waterImg);
			level = new Level(gameScreen, coinsScreen, td.level.LevelEvents.events[levelId], onIslandTouched, updateUi);
			level.draw();

			gameMenuScreen = new Sprite();
			gameMenuScreen.x = 0;
			gameMenuScreen.y = 0;
			gameMenuScreen.width = Context.assets.stageWidth - 1024-256;
			gameMenuScreen.height = 1024;
			var brown : Image = Context.newImage("brown");
			brown.x = 0;
			brown.y = 0;
			brown.width = Context.assets.stageWidth - 1024-256;
			brown.height = 1024;
			var texture : Image = Context.newImage("background");
			texture.tileGrid = new Rectangle();
			texture.width = Context.assets.stageWidth - 1024-256;
			texture.height = 1024;
			gameMenuScreen.addChild(brown);
			gameMenuScreen.addChild(texture);
			addChild(gameMenuScreen);	
			
			coinsText = new TextField(240, 128, "", new TextFormat("Arial",40,Color.WHITE));
			coinsText.x = 0;
			coinsText.y = 64;
			gameMenuScreen.addChild(coinsText);
			
			livesText = new TextField(240, 128, "", new TextFormat("Arial",40,Color.WHITE));
			livesText.x = 0;
			livesText.y = 64+128;
			gameMenuScreen.addChild(livesText);
			

			
			gameState = GameState.IDLE;
			
			
			addEventListener(Event.ENTER_FRAME, iterate);
			buttons = new Vector.<BuildButton>();
			createButtons();
			updateUi();
		}
		
		private function createButtons():void{
			([
				["machine_gun", MachineGun, 100],
				["rocket_base", RocketBase, 225]
			]).forEach(function(b,i,_) : void{
				var cancelButton : BuildButton = new BuildButton(b[0], b[1], b[2]);
				cancelButton.x = 64;
				cancelButton.y = 256+128+192*i;
				cancelButton.addEventListener(TouchEvent.TOUCH, function(e:TouchEvent):void{
					onBuildButton(cancelButton, e);
				});
				gameMenuScreen.addChild(cancelButton);
				buttons.push(cancelButton);
			});
			cancelButton = Context.newImage("button_cancel");
			cancelButton.x = 64;
			cancelButton.y = 256+128+192*2;
			cancelButton.addEventListener(TouchEvent.TOUCH, function(e:TouchEvent):void{
				if (e.touches[0].phase == "ended"){
					Context.playSound("click");
					level.cancelHighlightIslands();
					gameState = GameState.IDLE;
					pressedButton.enable();
					pressedButton = null;
					gameMenuScreen.removeChild(cancelButton);
				}
			});
		}
		
		private function onIslandTouched(island: Island, e: TouchEvent) : void{
			if (gameState != GameState.BUILDING){
				return;
			}
			if (e.touches[0].phase == "ended"){
				if (island.empty){
					Context.playSound("click");
					gameScreen.addChild(level.buildTower(island, pressedButton.towerClass));
					level.cancelHighlightIslands();
					level.coins -= pressedButton.cost;
					gameState = GameState.IDLE;
					pressedButton.enable();
					pressedButton = null;
					updateUi();
					gameMenuScreen.removeChild(cancelButton);
				}
			}
		}

		private function onBuildButton(button: BuildButton, e: TouchEvent) : void{
			if (gameState != GameState.IDLE || !button.enabled){
				return;
			}
			if(e.touches[0].phase == "ended"){
				Context.playSound("click");
				button.press();
				gameMenuScreen.addChild(cancelButton);
				level.highlightEmptyIslands();
				gameState = GameState.BUILDING;
				pressedButton = button;
			}
		}
		
		private function updateUi():void {
			coinsText.text = "COINS: " + level.coins;
			livesText.text = "LIVES: " + level.lives;
			for (var i: int; i < buttons.length; i++){
				buttons[i].calculateAvailability(level.coins);
			}
		}
		
		private function iterate(e: EnterFrameEvent) : void{
			level.update(e.passedTime);
		}
	}
}

final class GameState 
{ 
	public static const IDLE:GameState = new GameState(); 
	public static const BUILDING:GameState = new GameState();
}