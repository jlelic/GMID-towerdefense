package td.utils
{
	public class MathUtils {
		
		public static const ZERO: Number = 0.000001;
				
		public static function isZero(x: Number, ZERO: Number = 0.000001) : Boolean {
			return Math.abs(x) < ZERO;
		}
		
		public static function isLessOrEqual(x: Number, y: Number, ZERO: Number = 0.000001) : Boolean {
			return x < y || isZero(x - y); 
		}
		
		public static function isGreaterOrEqual(x: Number, y: Number, ZERO: Number = 0.000001) : Boolean {
			return x > y || isZero(x - y);
		}
		
		public static function isLessOrEqualZero(x: Number, ZERO: Number = 0.000001) : Boolean {
			return x < 0 || isZero(x); 
		}
		
		public static function isGreaterOrEqualZero(x: Number, ZERO: Number = 0.000001) : Boolean {
			return x > 0 || isZero(x);
		}
		
		public static function length(x: Number, y: Number) : Number {
			return Math.sqrt(x*x + y*y);
		}
		
		public static function distance2(x1: Number, y1: Number, x2: Number, y2: Number) : Number {
			return Math.sqrt(Math.pow(x1-x2, 2) + Math.pow(y1-y2, 2));
		} 

		public static function shuffle(arr: Array) : Array {
			var arr2:Array = [];
			while (arr.length > 0) {
				arr2.push(arr.splice(Math.round(Math.random() * (arr.length - 1)), 1)[0]);
			}
			return arr2;
		}
		
		public static function random() : Number {
			return Math.random();			
		}

		public static function randomInt(from: int, to: int) : int {
			if (from >= to) return from;
			var generated: int = Math.round(randomScaled(from-0.499, to+0.499)) as int;
			if (generated < from) return from;
			if (generated > to) return to;
			return generated;
		}
		
		public static function randomScaled(from: Number, to:Number) : Number {
			return from + (to - from) * Math.random();			
		}
		
		public static function linear(current: Number, target: Number, timeLeft: Number, timeDelta: Number) : Number {			
			if (timeLeft < timeDelta) {
				return target;	
			} else {
				return current + (target - current) * timeDelta / timeLeft;
			}
		} 
		
		public static function linearTimeToTarget(current: Number, target: Number, speed: Number) : Number {
			return Math.abs(target - current) / speed;
		}
		
		public static function clamp(value: Number, min: Number, max: Number) : Number {
			return value < min ? min : (value > max ? max : value);
		}
		
		public static function clampInt(value: int, min: int, max: int) : int{
			return value < min ? min : (value > max ? max : value);
		}
		
		public static function clampMin(value: Number, min: Number) : Number {
			return value < min ? min : value;
		}
		
		public static function clampMax(value: Number, max: Number) : Number {
			return value > max ? max : value;
		}
		
		public static function roundFraction(value: Number, digits: int = 4) : Number {
			value = Math.round(value * Math.pow(10, digits)) / Math.pow(10, digits); 
			return value;
		}
		
		public static function sign(value: Number) : Number {
			if (value < 0) return -1;
			if (value > 0) return 1;
			return 0;
		}
		
		public static function signInt(value: int) : int {
			if (value < 0) return -1;
			if (value > 0) return 1;
			return 0;
		}
		
		public static function highest(values: Array) : Number {
			if (values == null || values.length == 0) return 0;
			var result: Number = values[0];
			for (var i: int = 1; i < values.length; ++i) {
				result = higher(result, values[i]);
			}
			return result;
		}
		
		public static function lowest(values: Array) : Number {
			if (values == null || values.length == 0) return 0;
			var result: Number = values[0];
			for (var i: int = 1; i < values.length; ++i) {
				result = lower(result, values[i]);
			}
			return result;
		}
		
		public static function higher(value1: Number, value2: Number) : Number {
			return value1 > value2 ? value1 : value2;
		}
		
		public static function lower(value1: Number, value2: Number) : Number {
			return value1 < value2 ? value1 : value2;
		}
		
		public static function distance(x1: Number, y1: Number, x2: Number, y2: Number) : Number {
			return Math.sqrt((x1-x2) * (x1-x2) + (y1-y2)*(y1-y2));
		}
		
	}	
}