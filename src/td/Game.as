package td
{  

	import com.greensock.TweenLite;
	import com.greensock.easing.Expo;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.UncaughtErrorEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.utils.Dictionary;
	import td.particles.ParticlesManager;
	import td.screens.MenuScreen;
	import td.screens.LevelScreen;
	import td.screens.ScreenManager;
		
	import starling.core.Starling;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	
	
	import td.Context;
	import td.utils.ErrorDialog;
	
	import com.demonsters.debugger.MonsterDebugger;
	
    public class Game extends Sprite
    {
		/** Good to have around for your testers... */
		public static const APP_VERSION:String = "0.0.1";
		
		/** Here we save whether we're running within DEBUG version of Flash Player */
		public static var DEBUG:Boolean;
		
		/** Flash Loader */
		public static var starter:Object;
		
		/** For load() progress... */
		private var loadProgressBar:Quad;
		
		private var musicLoop:Sound;
		private var soundChannel:SoundChannel;

		
		public function Game()
        {    
			trace("Game created");
			
			CONFIG::debug {
				// MONSTER DEBUGGER ~ lib/MonsterDebugger-Starling.swc
				MonsterDebugger.initialize(this);
				MonsterDebugger.trace(this, "Hello World!");
			}	
			
			CONFIG::debug {		
				trace("IN CONFIG::DEBUG");
				try {
					DEBUG = (new Error().getStackTrace().search(/:[0-9]+]$/m) > -1);
				} catch (error: Error) {
					DEBUG = false;
				}
			}
			CONFIG::release {
				trace("IN CONFIG::RELEASE");
				DEBUG = false;
			}
			
			Context.game = this;
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage); 					
		}
		
		private function onAddedToStage(event:Event):void
        {
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			initialize();
			load();
		}	
		
		/** INIT ALL SINGLETONS THAT DOES NOT REQUIRE ASSETS */
		private function initialize():void
		{
			Context.stage = stage;
			new Assets();
			new ScreenManager();
			new Texts();
			new Values();
			new ParticlesManager();
			
			// SETS LANGUAGE
			Context.texts.setLanguage("cze");
			
			//UNCAUGHT ERROR EVENTS	
			starter.loaderInfo.uncaughtErrorEvents.addEventListener(
				UncaughtErrorEvent.UNCAUGHT_ERROR, function(event:UncaughtErrorEvent):void {	
					ErrorDialog.showError(event.error);
				}
			);
		}

		/** LOAD ALL INITIALLY REQUIRED ASSETS */
		private function load():void
		{
			loadProgressBar = new Quad(Context.assets.stageWidth, 3);
			addChild(loadProgressBar);
			loadProgressBar.width = 0;
			
			musicLoop = new Sound();

			musicLoop.addEventListener(flash.events.Event.COMPLETE, onSoundLoadComplete);

			musicLoop.load(new URLRequest("assets/loop.mp3"));
			
			Context.sounds = new Dictionary();
			([
				"boat",
				"bullet_hit",
				"coin",
				"click",
				"explosion",
				"motorboat",
				"raft",
				"rocket",
				"shot"
			]).forEach(function(s, i, a):void{
				var sound:Sound = new Sound();
				sound.load(new URLRequest("assets/sounds/" + s + ".mp3"));
				Context.sounds[s] = sound;
			});
			
			Context.assets.loadAssets(
				loadProgress, 
				"assets/"+Context.textureFolder+"/sprites.png",
				"assets/"+Context.textureFolder+"/sprites.xml"
			);
		}
		
		
		private function loadProgress(ratio:Number):void
		{
			loadProgressBar.width = stage.stageWidth*ratio;
			loadProgressBar.y = stage.stageHeight >> 1;  
			
			trace("Loading assets, progress:", ratio);
			
			// -> When the ratio equals '1', we are finished.
			if (ratio >= 1.0){
				Starling.juggler.delayCall( startGame, 0.3 );
				TweenLite.to(loadProgressBar, 1, { ease: Expo.easeInOut, alpha: 0 });				
			}
		}
		
		/** ASSETS LOADED -> SHOW FIRST SCREEN */
		private function startGame():void
		{
			
			removeChild(loadProgressBar);//remove preloader
			Context.showScreen(new MenuScreen());
		}
		


		// we wait until the sound finishes loading and then play it, storing the
		// soundchannel so that we can hear when it "completes".
		private function onSoundLoadComplete(e:flash.events.Event):void{
			musicLoop.removeEventListener(flash.events.Event.COMPLETE, onSoundLoadComplete);
			soundChannel = musicLoop.play();
			soundChannel.addEventListener(flash.events.Event.SOUND_COMPLETE, onSoundChannelSoundComplete);
		}

		//  this is called when the sound channel completes.
		private function onSoundChannelSoundComplete(e:flash.events.Event):void{
			e.currentTarget.removeEventListener(flash.events.Event.SOUND_COMPLETE, onSoundChannelSoundComplete);
			soundChannel = musicLoop.play();
		}
      
	}
	
}