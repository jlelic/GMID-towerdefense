package td.utils
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.system.Capabilities;
	import flash.utils.Dictionary;
	import flash.utils.describeType;
	import flash.utils.getTimer;
	
	import kefik.utils.collection.KDictionary;
	import kefik.utils.error.ErrorDetails;
	
	/**
	 * kefik.utils.Utils were split into two parts ... regular Utils that does not have any FLEX imports and kefik.utils.UtilsFlex
	 */
	public class Utils
	{
		/**
		 * Time millis passed since virtual machine started.
		 */
		public static function time() : int {
			return getTimer();
		}
		
		/**
		 * Checks whether two dictionaries holds the same data.
		 * 1) data are first checked by !=
		 * 2) then if "equalsFunction" specified, it is used
		 * 3) if not specified, then data1.equals(data2) and data2.equals(data1) methods are tried (does not need to exist...)
		 */
		public static function dictionaryEquals(d1: Dictionary, d2: Dictionary, equalsFunction: Function = null) : Boolean {
			for (var key1: * in d1) {
				if (!(key1 in d2)) return false;
				var data1: * = d1[key1];
				var data2: * = d2[key1];
				
				if (data1 != data2) {
					if (equalsFunction != null) {
						if (equalsFunction(data1, data2)) continue;
						return false;
					}
					try {
						if (data1.equals(data2)) continue;
						return false;
					} catch (e:Error) {						
					}
					try {
						if (data2.equals(data1)) continue;
						return false;
					} catch (e:Error) {					
					}
					return false;
				}
			}
			for (var key2: * in d2) {
				if (!(key2 in d1)) return false;
				// no need to perform another equals as we already done that in previous for cycle
				// this is meant to check whether there are any keys in d2 that are not within d1
			}
			return true;
		}
		
		public static function dictionaryRetainKeys(dict: Dictionary, keys: Dictionary) : Array {
			var toDelete: Array = [];
			var key: *;
			for each (key in keys) {
				if (!(key in keys)) toDelete.push(key);
			}
			for each (key in toDelete) {
				delete dict[key];
			}
			return toDelete;
		}
	
		public static function objectToDictionary(obj: Object) : Dictionary {
			var result: Dictionary = new Dictionary();
			for (var key: * in obj) {
				result[key] = obj[key];
			}
			return result;
		}
		
		public static function dictionaryToObject(dict: Dictionary) : Object {
			var result: * = new Object();
			for (var key: * in dict) {
				result[key] = dict[key];
			}
			return result;
		}
				
		public static function dictionaryAddAll(addInto: Dictionary, allItemsFrom: Dictionary) : void {
			if (addInto == null || allItemsFrom == null) return;
			for (var key:* in allItemsFrom) {
				addInto[key] = allItemsFrom[key];
			}
		}
		
		public static function arrayContains(value: *, array: Array) : Boolean {
			if (array == null) return false;
			for (var i: int = 0; i < array.length; ++i) {
				if (array[i] == value) return true;
			}
			return false;
		}
		
		public static function arrayAddAll(addInto: Array, allItemsFrom: Array) : void {
			if (addInto == null || allItemsFrom == null) return;
			for each (var o: * in allItemsFrom) {
				addInto[addInto.length] = o;
			}
		}
		
		public static function arrayPopFirst(array: Array) : * {
			return array.shift();
		}
		
		public static function stringReplaceAll(str: String, find: String, replace: String) : String {			
			// TODO... do it more effectively :)
			while (str.indexOf(find) >= 0) {
				str = str.replace(find, replace);
			}
			return str;					
		}
		
		public static function copyArray(array: Array) : Array {
			if (array == null) return null;
			return array.slice();
		}
		
		public static function copyDictionary(dict: Dictionary) : Dictionary {
			if (dict == null) return null;
			var result: Dictionary = new Dictionary();
			for (var key: * in dict) {
				result[key] = dict[key];
			}
			return result;
		}
		
		public static function copyIntoDictionary(source: Dictionary, copyInto: Dictionary) : void {
			if (source == null) return;
			for (var key: * in source) {
				copyInto[key] = source[key];
			}
		}
		
		/**
		 * Checks whether the dictionaryis empty or not... O(1)
		 */
		public static function isDictionaryEmpty(dict: Dictionary) : Boolean {
			for each (var o: Object in dict) {
				return false;
			}
			return true;
		}
		
		/**
		 * Obtains some key from the dictionary.
		 */
		public static function dictionaryGetSomeKey(dict: Dictionary) : * {
			for (var o: * in dict) {
				return o;
			}
			return null;
		}
		
		/**
		 * Obtains some item (value) from the dictionary.
		 */
		public static function dictionaryGetSomeValue(dict: Dictionary) : * {
			for each (var o: * in dict) {
				return o;
			}
			return null;
		}
		
		/**
		 * Returns dictionary size ... O(n).
		 */
		public static function getDictionarySize(dict: Dictionary) : int {
			var size: int = 0;
			for each (var o: Object in dict) {
				++size;
			}
			return size;
		}
		
		/**
		 * Returns array as String, separate items are "new-lined".
		 */
		public static function getArrayString (array : Array):String {
			var result : String= "";
			var first: Boolean = true;
			for (var key:Object in array) {
				if (first) first = false;
				else result += "\n";
				result += array[key];
			}
			return result;
		}
		
		public static function getDictionaryAsString(dict: Dictionary) : String {
			if (dict == null || Utils.isDictionaryEmpty(dict)) return "{}";
			var result: String = "{";
			var first: Boolean = true;
			for (var key: * in dict) {
				if (first) first = false;
				else result += "---";
				result += "\n" + key + " -> " + dict[key]
			}
			result += "\n}";
			return result
		}
		
		/**
		 * Return dictionary keys as Array.
		 */		
		public static function dictionaryKeysToArray(dict: Dictionary) : Array {
			if (dict == null) return null;
			var result: Array = new Array();
			for (var key: * in dict) {
				result[result.length] = key;
			}
			return result;
		}
		
		/**
		 * Return dictionary values as Array.
		 */		
		public static function dictionaryValuesToArray(dict: Dictionary) : Array {
			if (dict == null) return null;
			var result: Array = new Array();
			for (var key: * in dict) {
				result[result.length] = dict[key];
			}
			return result;
		}
		
		
		/**
		 * Removes all key/value pairs from the dictionary.
		 */
		public static function dictionaryClear(dict:Dictionary):void
		{
			if (dict == null) return;
			var stillSomething: Boolean = true;
			while (stillSomething) {
				stillSomething = false;
				for (var key: * in dict) {
					delete dict[key];
					stillSomething = true;
					break;
				}	
			}
		}
		
		/**
		 * Inserts 'item' into 'array' just before 'index', i.e., index == 0 -> insert as first, index == array.length -> insert as last
		 * 
		 * WARNING: O(n) !!!
		 */
		public static function addItemAtIndex(array: Array, index: int, item: *) : void {
			if (index >= array.length || array.length == 0) {
				array.push(item);
				return;
			}
			if (index <= 0) {
				array.unshift(item);
				return;
			}
			
			var last: * = array[array.length-1];
			
			for (var i: int = array.length - 1; i > index ; --i) {
				array[i] = array[i-1];
			}
			
			array[index] = item;
			
			array.push(last);
		}
		
		/**
		 * Deletes item at "index" from the array.
		 */ 
		public static function deleteItemAtIndex(array: Array, index: int) : void {			
			if (index >= 0 && index < array.length) {
				if (index == array.length-1) {
					array.pop();
					return;
				}
				if (index == 0) {
					array.shift();
					return;
				}
				
				delete array[index];
				for (var i: int = index+1; i < array.length; ++i) {
					array[i-1] = array[i];
				}
				array.length -= 1;
			}
		}
		
		public static const OS_WINDOWS: int = 1;
		public static const OS_LINUX: int   = 2;
		public static const OS_MAC: int     = 3;
		public static const OS_IPHONE: int  = 4;
		public static const OS_WIN_MOBILE: int  = 5;
		
		public static function getOS() : int {
			// FOR MORE OPERATING SYSTEMS SEE Capabilitites.os DOCUMENTATION
			if (Capabilities.os == "Windows Mobile") {
				return OS_WIN_MOBILE;
			}
			var os:String = Capabilities.os.substr(0, 3);
			if (os == "Win") {
				return OS_WINDOWS;
			} else 
			if (os == "Mac") {
				return OS_MAC;
			} else
			if (os == "iPh") {
				return OS_IPHONE;
			} else
			if (os == "Lin") {
				return OS_LINUX;
			}
			return OS_LINUX; // DEFAULT GUESS
		}
		
		
		
		
		private static var addedToStageCallbacks : Dictionary = new Dictionary(); 
		
		public static function onAddedToStage(cmp: EventDispatcher, callback: Function) : void {
			var array: Array = addedToStageCallbacks[cmp] as Array;
			if (array == null) {
				array = new Array();
				addedToStageCallbacks[cmp] = array;
				cmp.addEventListener(Event.ADDED_TO_STAGE, onAddedToStageHandler);
			}
			array[array.length] = callback;
		}
		
		private static function onAddedToStageHandler(event: Event = null) : void {
			var array: Array = addedToStageCallbacks[event.target] as Array;
			if (array != null) {
				for (var i: int = 0; i < array.length; ++i) {
					(array[i] as Function)(event);
				}
				delete addedToStageCallbacks[event.target];
			}
			(event.target as EventDispatcher).removeEventListener(Event.ADDED_TO_STAGE, onAddedToStageHandler);
		}
		
		//
		// DICTIONARIES
		//
		
		public static function removeKeys(deleteKeysFrom: Dictionary, thatAreNotFoundHere: Dictionary) : void {
			var key: Object;
			var toDelete: Array = new Array();
			for (key in deleteKeysFrom) {
				if (!(key in thatAreNotFoundHere)) {
					toDelete.push(key);
				}
			}
			for (key in toDelete) {
				delete deleteKeysFrom[key];
			}
		}
		
		public static function isSimpleType(value:Object):Boolean
		{
			var type:String = typeof(value);
			switch (type)
			{
				case "number":
				case "string":
				case "boolean":
				{
					return true;
				}
					
				case "object":
				{
					return (value is Date) || (value is Array);
				}
			}
			
			return false;
		}
		
		/**
		 * Iterates over all dynamic properties and fields (regular class variables) and recursively
		 * replace all Dictionaries with simple Object representation 
		 * 
		 */
		
		public static function replaceDictionaryInObject(source : Object) : Object {
			
			var a:XML;
			
			if ((isSimpleType(source))&&(!(source is Array))) {
				return source;
			}
			
			if (source is Array) {
				var resultArray : Array = new Array ();
				for (var arrayKey : String in source) {
					resultArray[arrayKey] = replaceDictionaryInObject(source[arrayKey]);
				}
				return resultArray;
			}
						
			var result : Object = new Object ();
			
			for (var key : String in source) {
				
				var value : Object = source[key];
				result[key] = replaceDictionaryInObject(value);
				
			}
			
			var description:XML = describeType(source);
			
			for each (a in description.variable) 
			{
				result[a.@name] = replaceDictionaryInObject(source[a.@name]);
				
			}
			
			for each (a in description.accessor) 
			{
				var access : String = a.@access;
				if(access != "writeonly") {
					result[a.@name] = replaceDictionaryInObject(source[a.@name]);
				}
			}

			
			return result;
			
		}
		
		
		public static function printObject(source : Object) : String {
			
			var a:XML;
			
			var resultString : String = "";
			var atLeastOne : Boolean = false;
			
			if ((isSimpleType(source))&&(!(source is Array))) {
				return source.toString();
			}
			
			if (source is Array) {
				var resultArray : Array = new Array ();
				for (var arrayKey : String in source) {
					
					atLeastOne = true;
					resultString=resultString+ "["+arrayKey+"="+printObject(source[arrayKey])+"],";
				}
				if (atLeastOne) {
					resultString = "["+resultString.slice( 0, -1 )+"]\n";
					//resultString= resultString+"\n";
				}
				return resultString;
			}
			
			//var result : Object = new Object ();
			
			for (var key : String in source) {
				
				var value : Object = source[key];
				//result[key] = printObject(value);
				
				resultString=resultString+ "["+key+"="+printObject(value)+"],";
				atLeastOne = true;
			}
			
			var description:XML = describeType(source);
			
			for each (a in description.variable) 
			{
				resultString=resultString+ "["+a.@name+"="+printObject(source[a.@name])+"],";
				//result[a.@name] = printObject(source[a.@name]);
				atLeastOne = true;
			}
			
			for each (a in description.accessor) 
			{
				var access : String = a.@access;
				if(access != "writeonly") {
					resultString=resultString+ "["+a.@name+"="+printObject(source[a.@name])+"],";
					//result[a.@name] = printObject(source[a.@name]);
					atLeastOne = true;
				}
			}
			if (atLeastOne) {
				resultString = "["+resultString.slice( 0, -1 )+"]\n";
				//resultString=resultString+"\n";
			}
			
			return resultString;
			
		}
		
		/**
		 * Returns number of seconds that is needed to change 'from' into 'to' if speed is 'speedPerSec'.
		 * 
		 * @Deprecated use MathUtils.linearTimeToTarget
		 */
		public static function getTimeToReach(from: Number, to:Number, speedPerSec: Number) : Number {
			return MathUtils.linearTimeToTarget(from, to, speedPerSec);
		}
		
		/**
		 * Returns current stack-trace (excluding this method).
		 * 
		 * RETURNS NULL for NON-DEBUG PLAYERS!
		 */
		
		private var isDebug:Boolean = false;
		
		public static function getStackTrace(trimWhitespaces: Boolean = false) : String {
			if( isDebug ) return null;
			var result: String = new Error("BOGUS").getStackTrace();
			if (result == null) {
				isDebug = true;
				return null;
			}
			var index: int = result.indexOf("\n");
			index += 1 + result.substring(index+1).indexOf("\n")
			result = result.substring(index+1);
			
			if (!trimWhitespaces) return result;			
			return trimLines(result);
		}
		
		public static function getErrorStackTrace(error: Error, trimWhitespaces: Boolean = false) : String {
			var stacktrace: String = error.getStackTrace();			
			if (stacktrace != null) {
				var index: int = stacktrace.indexOf("\n");
				stacktrace = stacktrace.substring(index+1);
				stacktrace = trimLines(stacktrace);
			} else {
				stacktrace = "N/A";
			}
			return stacktrace;
		}
		
		public static function trimLines(lines: String) : String {
			var result: String = "";
			var first: Boolean = true;
			
			while (lines.length > 0) {
				if (first) first = false;
				else result += "\n";
				
				var index: int = lines.indexOf("\n");
				if (index < 0) {
					result += trimString(lines);
					break;
				}
				
				var line: String = lines.substring(0, index);
				if (index < lines.length) {
					lines = lines.substring(index+1);
				} else {
					lines = "";
				}
				
				result += trimString(line);
			}
			
			return result;
		}
		
		public static function trimString(line:String):String
		{
			if (line == null) return null;
			if (line.length == 0) return line;			
			
			while (line.length > 0) {
				var begin: String = line.substring(0, 1);
				if (begin == " " || begin == "\t") {
					if (line.length > 1) {
						line = line.substring(1);
					} else {
						line = "";
					}
				} else {
					break;
				}
			}
			
			while (line.length > 0) {
				var end: String = line.substring(line.length-1, line.length);
				if (end == " " || end == "\t") {
					if (line.length > 1) {
						line = line.substring(0, line.length-1);
					} else {
						line = "";
					}					
				} else {
					break;
				}
			}
			
			return line;
		}
		
		public static function getErrorAsString(error: Error) : String {
			if (error == null) return "null";
			if (error is ErrorDetails) {
				return (error as ErrorDetails).getErrorReport();
			}
			if (error.getStackTrace() == null) {
				error = new Error(error.message + " [missing stack-trace, supplying caller's one]");
			}
			return error.message + " | StackTrace:\n" + error.getStackTrace();
		}
		
		public static function deleteItemFromArray(item: *, array: Array) : Boolean {
			if (array == null) return false;
			for (var i: int = 0; i < array.length; ++i) {
				if (array[i] == item) {
					deleteItemAtIndex(array, i);
					return true;
				}
			}
			return false;
		}
		
		/**
		 * Prepend 'indent' number of whitespaces ' ' before each line of 'source'.
		 */
		public static function indentLines(source: String, indent: int) : String {
			if (indent <= 0) return source;
			if (source == null) return null;
			
			var indentStr: String = "";
			for (var i: int = 0; i < indent; ++i) {
				indentStr += " ";				
			}
			
			var result: String = "";

			var first: Boolean = true;
			while (source.length > 0) {
				if (first) first = false;
				else result += "\n";
				var newLineIndex: int = source.indexOf("\n");
				if (newLineIndex < 0) newLineIndex = source.length;
				var line: String = source.substring(0, newLineIndex);
				result += indentStr + line;
				if (newLineIndex >= source.length) {
					source = "";
				} else {
					source = source.substring(newLineIndex+1);
				}
			}
				
			return result;
		}
		
		public static function errorAsString(error:Error, indent:int = 0):String
		{
			if (error == null) return Utils.indentLines("Error[null]", indent);
			
			var result: String = "";
			result += error.toString();
			result += "\nStacktrace:\n";
			
			result += indentLines(getErrorStackTrace(error, true), 4);
			
			return indentLines(result, indent);
		}
		
		public static function errorEventAsString(error:ErrorEvent, indent:int = 0):String
		{
			if (error == null) return Utils.indentLines("ErrorEvent[null]", indent);
			
			var result: String = "";
			result += error.toString();
			
			return indentLines(result, indent);
		}
		
		public static function throwError(error: Error) : String {
			throw error;
			return "ERROR";
		}
		
		private static var isDebug: Boolean;
		private static var isDebugDecided: Boolean = false;
		
		public static function isDebugBuild() : Boolean
		{
			if (isDebugDecided) return isDebug;
			var stackTrace:String = getStackTrace();
			if (stackTrace == null) {
				isDebug = false;
			} else {
				isDebug = new Error().getStackTrace().search(/:[0-9]+]$/m) > -1;
			}
			isDebugDecided = true;
			return isDebug;
		}
		
		public static function isReleaseBuild() : Boolean
		{
			return !isDebugBuild();
		}
		
		private static var traceContent:String;
		/** recursively goes through children and traces them to console */
		public static function traceChildren(parent:DisplayObjectContainer, depth:String = "-"):String {
			var depth1:String = depth + "-";
			for (var i:int = 0; i < parent.numChildren; i++) 
			{	
				var chl:DisplayObject = parent.getChildAt(i);
				var log:String = depth+" :"+chl+" "+chl.name + " visible:"+chl.visible + " pos:[" +  chl.x + "," + chl.y + "] alpha:" + chl.alpha + " scale:"+chl.scaleX;
				trace( log );
				traceContent += log+ "\n";
				if( parent.getChildAt(i) is DisplayObjectContainer &&  DisplayObjectContainer(parent.getChildAt(i)).numChildren > 0 ){
					traceChildren( DisplayObjectContainer(parent.getChildAt(i)), depth1 );
				}
			}
			return traceContent;
		}
		
		
		/**
		 * 
		 * @param parent 
		 * @param func calback ( DisplayObject, Object, int ) OR callback ( DisplayObject, int ) - without travel object; 
		 * @param travelObject custom object to be passed to func
		 * @param depth
		 * 
		 */
		public static function forAllChildren( parent:DisplayObjectContainer, func:Function, travelObject:Object = null, depth:int = 0):void {
			//var depth1:String = depth + "-";
			for (var i:int = 0; i < parent.numChildren; i++) 
			{
				if( travelObject ){
					func( parent.getChildAt(i), travelObject, depth )
				}else{
					func( parent.getChildAt(i), depth )
				}
				//trace(depth+" :"+parent.getChildAt(i), parent.getChildAt(i).name );
				if( parent.getChildAt(i) is DisplayObjectContainer &&  DisplayObjectContainer(parent.getChildAt(i)).numChildren > 0 ){
					forAllChildren( DisplayObjectContainer(parent.getChildAt(i)), func, travelObject, depth++ );
				}
			}
		}
		
		public static function getRectangleSprite( width:Number, height:Number, color:uint = 0, alpha:Number = 1):Sprite {
			var s:Sprite = new Sprite();
			s.graphics.beginFill(color,alpha);
			s.graphics.drawRect(0,0,width,height);
			return s;
		}
		
		public static function makeHTTP(url: String) : String {
			var result: String = trimString(url);
			// searching for HTTPS://
			if (result.length < 8) return url;
			var begin: String = result.substring(0, 8).toLowerCase();
			if (begin == "https://") {
				return "http://" + result.substring(8);
			}
			return url;
		}
		
		public static function makeHTTPS(url: String) : String {
			var result: String = trimString(url);
			// searching for HTTP://
			if (result.length < 7) return url;
			var begin: String = result.substring(0, 7).toLowerCase();
			if (begin == "http://") {
				return "http://" + result.substring(7);
			}
			return url;
		}
		
		public static function num2Str(num: Number, fractions: int = 3) : String {
			var result: String = String(num);
			var index: int = result.indexOf(".");
			if (index >= 0) {
				result = result.substring(0, index+1) + result.substring(index+1, index+4 < result.length ? index+4 : result.length);
			}
			return result;
		}
		
	}
}