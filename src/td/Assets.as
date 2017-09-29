package td
{
	import starling.core.Starling;
	import starling.textures.Texture;
	import starling.utils.AssetManager;

	public class Assets
	{
		public var manager:AssetManager;
		
		private var _stageWidth:int;
		private var _stageHeight:int;
		private var _screenRatio:Number;
		
		public function Assets()
		{
			Context.assets = this;
			_stageWidth = Starling.current.stage.stageWidth;
			_stageHeight = Starling.current.stage.stageHeight;
			_screenRatio = stageHeight / stageWidth;
			manager = new AssetManager(Context.textureScaleFactor);
		}	

		/**
		 * Load specified assets, items expects paths to assets.
		 */ 
		public function loadAssets(onProgress:Function,...items):void {
			if( items.length <= 0 ) return;
			
			for each( var item:String in items ){
				manager.enqueue( item );
			}
			manager.loadQueue( onProgress );
		}
		
		/**
		 * Get named texture.
		 */
		public function getTextureFromAtlas(name:String):Texture {
			trace("@texture@ name:"+name);
			return manager.getTexture(name);
		}
		
		public function get screenRatio():Number
		{
			return _screenRatio;
		}
		
		public function get stageHeight():int
		{
			return _stageHeight;
		}
		
		public function get stageWidth():int
		{
			return _stageWidth;
		}
	
	}
	
}