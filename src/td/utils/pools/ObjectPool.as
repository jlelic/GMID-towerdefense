package td.utils.pools
{
	import flash.utils.Dictionary;
	
	import td.utils.StringUtils;
	import td.utils.Utils;

	public class ObjectPool
	{
		CONFIG::debug {
		private static const TRACK_ALIVE_INSTANCES: Boolean = false;
		}
		private static const HISTORY_MERGE_COUNT: int = 10;
		
		private static var POOLS: Array = [];
		private static var POOLS_BY_CATEGORY: Dictionary = new Dictionary();
		
		protected var name: String;
		protected var category: String;
		
		protected var _factoryMethod:Function;
		
		protected var _pool: Array = new Array();
		
		protected var _maxSize:int = 25;
		
		protected var _created: int = 0;
		protected var _given: Number = 0;
		protected var _returned: Number = 0;
		
		protected var _usingHistoryMerged: Array = [];
		protected var _usingHistory: Array = [];
		
		protected var _lastUsingSummary: Number = 0;
		
		CONFIG::debug {
		protected var _alive: Dictionary = new Dictionary();
		}
		
		public function ObjectPool(name: String, category: String, createObjectFactory: Function)
		{
			this.name = name;
			_factoryMethod = createObjectFactory;
			POOLS.push(this);
			POOLS.sort(function(a:*, b:*) : int { return (a as ObjectPool).name > (b as ObjectPool).name ? 1 : ((a as ObjectPool).name < (b as ObjectPool).name ? -1 : 0); });
			setCategory(category);
		}
		
		public function setCategory(category: String) : void {
			if (category == null || category.length == 0) category = "Others";
			if (this.category != null) {
				if (this.category in POOLS_BY_CATEGORY) {
					Utils.deleteItemFromArray(this, POOLS_BY_CATEGORY[this.category] as Array);
					if ((POOLS_BY_CATEGORY[this.category] as Array).length == 0) delete POOLS_BY_CATEGORY[this.category];
				}
			}
			this.category = category;
			if (!(this.category in POOLS_BY_CATEGORY)) POOLS_BY_CATEGORY[this.category] = new Array();
			(POOLS_BY_CATEGORY[this.category] as Array).push(this);
			(POOLS_BY_CATEGORY[this.category] as Array).sort(function(a:*, b:*) : int { return (a as ObjectPool).name > (b as ObjectPool).name ? 1 : ((a as ObjectPool).name < (b as ObjectPool).name ? -1 : 0); });
		}
		
		public function get() : * {
			var instance: * = null;
			++_given;
			if (_pool.length == 0) {
				++_created;
				instance = _factoryMethod();
			} else {
				instance = _pool.pop();
			}
			
			CONFIG::debug {
				if (TRACK_ALIVE_INSTANCES) {
					_alive[instance] = true;
				}
			}
			
			return instance;
		}
		
		public function back(object: *) : void {
			if (object == null) {
				return;
			}
			
			++_returned;
			
			if (_pool.lastIndexOf(object)>=0) {
				throw new Error("The object: " + object + " was already back()ed!");
				return;
			}
			
			CONFIG::debug {
				if (TRACK_ALIVE_INSTANCES) {
					delete _alive[object];
				}
			}
			
			if( poolSize >= _maxSize ){
				return;
			}
			
			_pool.push(object);
		}
		
		public function setFactoryMethod(createObjectFactory: Function) : void {
			_factoryMethod = createObjectFactory;
		}
		
		public function clear() : void {
			_pool = new Array();
		}
		
		public function kill() : void {
			_pool = null;
			_factoryMethod = null;
		}
		
		public function get poolSize():int
		{
			return _pool.length;
		}

		public function get maxSize():int
		{
			return _maxSize;
		}

		public function set maxSize(value:int):void
		{
			_maxSize = value;
		}
		
		public function get constructed() : int {
			return _created;
		}
		
		public function get given() : Number {
			return _given;
		}
		
		public function get returned() : Number {
			return _returned;
		}
		
		public function getSummary(longestName: int = -1) : String {
			if (longestName <= 0) longestName = name.length;
			
			var result: String;
			var using: Number = given - returned;
			var delta: Number = using - _lastUsingSummary;
			
			var usingHistoryString: String = "";
			for each (var history: Array in _usingHistoryMerged) {
				if (usingHistoryString != "") usingHistoryString += " -> ";
				usingHistoryString += StringUtils.sprintf("<%3d|%3.1f|%3d>", history[0], history[1], history[2]);
			}
			var first: Boolean = true;
			for each (var i2: int in _usingHistory) {
				if (usingHistoryString != "") usingHistoryString += " -> ";
				usingHistoryString += StringUtils.sprintf("%3d", i2);
			}
			if (usingHistoryString != "") usingHistoryString += " -> ";
			usingHistoryString += using;
			
			result = StringUtils.sprintf("%-" + longestName + "s[cap=%3d]: InPool[%2d] Created[%4d] Given[%4d] Returned[%4d] --- USING: %3d (" + (delta >= 0 ? "+" : "") + "%2d) --- HISTORY: %s", name, maxSize, poolSize, constructed, given, returned, using, delta, usingHistoryString);
			
			_lastUsingSummary = using;
			
			_usingHistory.push(_lastUsingSummary);
			if (_usingHistory.length >= HISTORY_MERGE_COUNT) {
				
				var min: int = 99999999;
				var avg: Number = 0;
				var max: int = 0;
				for each (var i3: int in _usingHistory) {
					if (min > i3) min = i3;
					if (max < i3) max = i3;
					avg += i3;
				}
				avg /= _usingHistory.length;
				
				_usingHistoryMerged.push([min, avg, max]);
				_usingHistory = [];
			}
			
			return result;
		}
		
		public function getSummaryAliveInstances(longestName: int = -1) : String {
			CONFIG::debug {
				if (longestName <= 0) longestName = name.length;
				
				if (!TRACK_ALIVE_INSTANCES) return "";
				if (Utils.isDictionaryEmpty(_alive)) return "";
				
				var result: String = "";
				for (var key: * in _alive) {
					if (result != "") result += "\n";
					result += "    " + String(key);
				}
				
				result = name + ":" + "\n" + result;
				
				return result;
			}
			return "";
		}
		
		public static function tracePoolsSummary() : void {
			CONFIG::debug {
				trace("========== OBJECT POOLS SUMMARY ==========");
				
				var categories: Array = Utils.dictionaryKeysToArray(POOLS_BY_CATEGORY);
				categories.sort();
				
				var longest: int = 0;
				for each (var cat: String in categories) {
					if (cat.length > longest) longest = cat.length;
				}
				
				for each (var category: String in categories) {
					trace(StringUtils.sprintf("---------- %-" + longest + "s ----------", category));
					var pool: ObjectPool;
					var longestPoolName: int = 0;				
					for each (pool in POOLS_BY_CATEGORY[category]) {
						if (pool.name.length > longestPoolName) longestPoolName = pool.name.length;
					}
					for each (pool in POOLS_BY_CATEGORY[category]) {
						trace(pool.getSummary(longestPoolName));
					}
				}
				
				trace("==========================================");
			}
		}
		
		
		public static function tracePoolsAliveInstances() : void {
			CONFIG::debug {
				if (!TRACK_ALIVE_INSTANCES) return;
				trace("========== OBJECT POOLS ALIVE INSTANCES ==========");
				
				var categories: Array = Utils.dictionaryKeysToArray(POOLS_BY_CATEGORY);
				categories.sort();
				
				var longest: int = 0;
				for each (var cat: String in categories) {
					if (cat.length > longest) longest = cat.length;
				}
				
				for each (var category: String in categories) {
					trace(StringUtils.sprintf("---------- %-" + longest + "s ----------", category));
					var pool: ObjectPool;
					var longestPoolName: int = 0;				
					for each (pool in POOLS_BY_CATEGORY[category]) {
						if (pool.name.length > longestPoolName) longestPoolName = pool.name.length;
					}
					for each (pool in POOLS_BY_CATEGORY[category]) {
						var sum: String = pool.getSummaryAliveInstances(longestPoolName);
						if (sum != "") {
							trace(sum);
						}
					}
				}
				
				trace("==========================================");
			}
		}

	}
	
}