package td.level 
{
	import starling.display.Sprite;
	import td.Context;
	import td.Island;
	import td.Coin;
	import td.level.LevelEvent;
	import td.enemy.Raft;
	import td.enemy.Boat;
	import td.enemy.Motorboat;
	import td.enemy.Enemy;
	import td.screens.MenuScreen;
	import td.tower.Tower;
	import td.tower.RocketBase;
	import td.projectile.Projectile;
	import td.projectile.Rocket;
	import starling.events.TouchEvent;
	import starling.text.TextField;
	import starling.text.TextFormat;
	import starling.utils.Color;
	import flash.utils.setTimeout;
	
	public class Level 
	{
		
		public var coins: int;
		public var lives: int;
		private var screen: Sprite;
		private var coinsScreen: Sprite;
		private var islands: Vector.<Island>;
		private var enemies: Vector.<Enemy>;
		private var towers: Vector.<Tower>;
		private var projectiles: Vector.<Projectile>;
		private var activeCoins: Vector.<td.Coin>;
		private var updateUi: Function;
		private var events: *;
		private var eventNum: int;
		private var waitFor: Number;
		private var eventsFinished: Boolean;
		private var levelFinished: Boolean;

		public function Level(screen: Sprite, coinsScreen: Sprite, events: *, onIslandTouched: Function, updateUi: Function) 
		{
			islands = new Vector.<Island>();			
			enemies = new Vector.<Enemy>();
			projectiles = new Vector.<Projectile>();
			towers = new Vector.<Tower>();
			activeCoins = new Vector.<td.Coin>();
			this.screen = screen;
			this.coinsScreen = coinsScreen;
			this.updateUi = updateUi;
			this.events = events;
			loadConfig(onIslandTouched);
			eventNum = 1;
			waitFor = 0;
			eventsFinished = false;
			levelFinished = false;
		}
		
		public function buildTower(island:Island, towerClass: Class) : Tower {
			var newTower : Tower = new towerClass(island);
			island.empty = false;
			towers.push(newTower);
			return newTower;
		}
		
		public function collectCoin(coin: Coin) : void {
			activeCoins.removeAt(activeCoins.indexOf(coin));
			coinsScreen.removeChild(coin);
			coins += 25;
			updateUi();
			Context.playSound("coin");
			coin.removeEventListeners();
			coin.dispose();
		}
		
		public function draw():void{
			islands.forEach(function(island: Island, index:int, vector:Vector.<Island>) : void {
				screen.addChild(island);
			});
			enemies.forEach(function(enemy: Enemy, index:int, vector:Vector.<Enemy>) : void {
				screen.addChild(enemy);
			});
			projectiles.forEach(function(projectile: Projectile, index:int, vector:Vector.<Projectile>) : void {
				screen.addChild(projectile);
			});
		}	
		
		public function highlightEmptyIslands():void{
			islands.forEach(function(island: Island, index:int, vector:Vector.<Island>) : void {
				if (island.empty){
					island.highlight();
				}
			});
		}
		
		public function cancelHighlightIslands():void{
			islands.forEach(function(island: Island, index:int, vector:Vector.<Island>) : void {
				island.cancelHighlight();
			});
		}
		
		public function update(deltaTime: Number) : void{
			var enemy : Enemy;

			if(!eventsFinished){
				if (waitFor >= 0) {
					waitFor -= deltaTime;
				} else {
					trace(events[eventNum]);
					var e : Array = events[eventNum];
					if (e[0] == LevelEvent.WAIT){
						waitFor = e[1];
					} else {
						var enemyClass:Class;
						switch(e[0]){
							case LevelEvent.BOAT:
								enemyClass = Boat;
								break;
							case LevelEvent.MOTORBOAT:
								enemyClass = Motorboat;
								break;
							case LevelEvent.RAFT:
								enemyClass = Raft;
								break;
						}
						enemy= new enemyClass(e[1]);
						enemies.push(enemy);
						screen.addChild(enemy);
					}
					eventNum++;
					if (eventNum >= events.length){
						eventsFinished = true;
					}
				}
			}

			for (var i:int = 0; i < projectiles.length; i++) {
				var projectile : Projectile = projectiles[i];
				projectile.update(deltaTime, enemies);
				if (projectile.toBeDestroyed){
					projectiles.removeAt(i);
					screen.removeChild(projectile);
					i++;
				}				
			}
			
			var newCoins : Vector.<Coin> = new Vector.<Coin>();
			for (i = 0; i < enemies.length; i++) {
				enemy = enemies[i]
				if (enemy.health <= 0){
					if (enemy.active){
						enemy.destroyEnemy(newCoins);
					}
				} else {
					enemy.update(deltaTime);
				}
				if (enemy.x < -128 || enemy.toBeDestroyed){
					if(!enemy.toBeDestroyed){
						lives--;
						updateUi();
						if (lives <= 0 && !levelFinished) {
							levelFinished = true;
							showMessage("LEVEL FAILED");
						}
					}
					enemies.removeAt(i);
					screen.removeChild(enemy);
					i++;
				}
			};
			newCoins.forEach(function(coin: Coin, index:int, vector:Vector.<Coin>) : void {
				activeCoins.push(coin);
				coinsScreen.addChild(coin);
				coin.addEventListener(TouchEvent.TOUCH, function(e:TouchEvent):void{
					if(e.touches[0].phase == "ended") {
						collectCoin(coin);
					}
				});
			});
			
			towers.forEach(function(tower: Tower, index:int, vector:Vector.<Tower>) : void {
				tower.update(deltaTime, screen, enemies, projectiles);
			});
			
			if (eventsFinished && !enemies.length && !levelFinished){
				levelFinished = true;
				showMessage("LEVEL COMPLETED");
			}
		}
		
		private function loadConfig(onIslandTouched: Function) : void{
			var levelConfig: LevelConfig = events[0];
			coins = levelConfig.startingCoins;
			lives = levelConfig.lives;
			
			for (var i : int; i < levelConfig.islands.length; i++){
				var pos: Array = levelConfig.islands[i];
				var island: Island = new Island(pos[0], pos[1]);
				islands.push(island);
				if (pos[2]){
					island.empty = false;
				}
			}
			
			islands.forEach(function(island: Island, index:int, vector:Vector.<Island>) : void {
				island.addEventListener(TouchEvent.TOUCH, function(e: TouchEvent): void{
					onIslandTouched(island, e);
				});
			});
		}
		
		private function showMessage(text: String) : void{
			var textField :TextField = new TextField(600, 256, text, new TextFormat("Arial",68,Color.WHITE));
			textField.x = 256;
			textField.y = 64;
			coinsScreen.addChild(textField);
			setTimeout(function():void{
				Context.showScreen(new MenuScreen());
			}, 5000)
		}
	}

}