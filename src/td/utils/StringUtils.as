package td.utils
{
	import mx.formatters.NumberBaseRoundType;
	import mx.formatters.NumberFormatter;
	
	public class StringUtils
	{
		public static function countSubstrings(source:String, substring:String) : int {
			var searched: String = escapeRegexChars(substring)
			var count: int = 0;
			do {
				var index: int = source.search(substring);
				if (index < 0) break;
				++count;
				source = source.substr(index+substring.length);
			} while (true);
			
			return count;
		}
		
		public static function escapeRegexChars(s:String):String
		{
			var newString:String = 
				s.replace(
					new RegExp("([{}\(\)\^$&.\*\?\/\+\|\[\\\\]|\]|\-)","g"),
					"\\$1"
				);
			return newString;
		}
		
		public static function beginsWith(source:String,substring:String) : Boolean
		{
			if (source.search(escapeRegexChars(substring)) == 0) return true;
			else return false;
		}
		
		public static function endsWith(source:String, substring:String) : Boolean {
			if (source == null || substring == null) return false;
			return source.search(escapeRegexChars(substring)) == source.length - substring.length;
		}
		
		public static function beginsWithIgnoreCase(source:String,substring:String):Boolean{
			if (source == null || substring == null) return false;
			var re:RegExp = new RegExp("^" + escapeRegexChars(substring), "i");
			return source.search(re) == 0;
		}
		
		public static function endsWithIgnoreCase(source:String,substring:String):Boolean{
			if (source == null || substring == null) return false;
			var re:RegExp = new RegExp(escapeRegexChars(substring) + "$", "i");
			return source.search(re) == 0;
		}
				
		public static function equalsIgnoreCase(first: String, second: String) : Boolean {
			if (first == null) {
				if (second == null) return true;
				return false;
			}
			if (second == null) return false;
			var re:RegExp = new RegExp("^" + escapeRegexChars(first) + "$", "i");
			return second.match(re) != null;
		}
		
		/**
		 * Formats 9999999 -> 9.999.999
		 */
		public static function withDots(num: int) : String {
			return withDotsStr(String(num));
		}
		
		/**
		 *  formats 9999999 -> 9.999.999
		 */
		public static function withDotsStr(num: String) : String {
			var result: String = "";
			while (num.length > 3) {
				result = "." + result + num.substring(num.length-3, num.length);
				num = num.substring(0, num.length - 3);
			}
			result = num + result;
			return result;
		}
		
		/**
		 * 1 -> 001 ... digits == 3
		 */
		public static function withZeros(num: int, digits:int) : String {
			return withZerosStr(String(num), digits);
		}
		
		/**
		 * 1 -> 001 ... digits == 3
		 */
		public static function withZerosStr(num: String, digits:int) : String {
			while (num.length < digits) num = "0" + num;
			return num;
		}
		
		/**
		 * Seconds into -> Y/secStr
		 * 
		 * Examples:
		 * 
		 * timeS(67) -> "67s"
		 * timeS(67," secs.") -> "67 secs."
		 */
		public static function timeS(secs: Number, secStr: String = "s") : String {
			
			secs = Math.round(secs);
			
			return String(int(secs)) + secStr;
		}
		
		/**
		 * Seconds into -> 'X'/minStr/separator/'YY'/secStr/
		 * 
		 * Examples: 
		 * 
		 * timeMS(125) -> "2m 05s".
		 * timeMS(125,"","",":") -> "2:05"
		 */
		public static function timeMS(secs: Number, minStr: String = "m", secStr: String = "s", separator: String = " ") : String {
			
			secs = Math.round(secs);
			
			var min: int = Math.floor(secs / 60);
			var sec: int = secs - 60 * min;
			
			return min + minStr + separator + withZeros(sec,2) + secStr;
		}
		
		/**
		 * Seconds into -> 'X'/minStr/separator/'YY'/secStr/
		 * 
		 * Examples: 
		 * 
		 * timeHMS(3725) -> "1h 02m 05s".
		 * timeHMS(125,"","","",":") -> "1:02:05"
		 */
		public static function timeHMS(secs: Number, hourStr: String ="h", minStr: String = "m", secStr: String = "s", separator: String = " ") : String {
			
			secs = Math.round(secs);
			
			var hour: int = Math.floor(secs / 3600);
			secs %= 3600;
			var min: int = Math.floor(secs / 60);
			var sec: int = secs % 60;
			
			return hour + hourStr + separator + withZeros(min,2) + minStr + separator + withZeros(sec,2) + secStr;
		}
		
		
		
		
		
		public static function check2Slashes(value: String) : String {
			var result: String = "";
			var slash: Boolean = false;
			var start: int = value.indexOf("://");
			if (start < 0) start = 0;
			else {
				start += 3;
				result = value.substring(0, start);
			}
			for (var i: int = start; i < value.length; ++i) {
				if (value.charAt(i) == "/") {
					if (slash) continue;
					slash = true;
				} else {
					slash = false;
				}
				result += value.charAt(i);
			}
			return result;
		}
		
		private static var idResolver:Function;
		
		/**
		 * replaceVariableReferences("Ahoj ${20|asdasd}") -> calls aidResolver(20) -> that returns (for example) "Mary" -> whole function returns "Ahoj Mary"
		 * 
		 * @param aidResolver has notation function aidResolver(id:int):String and should return value of variable, name of Person, or any other string that can be represented in macro, see implemented cases for more info.
		 **/
		public static function replaceVariableReferences(source:String, aidResolver:Function):String
		{
			idResolver = aidResolver
			var re:RegExp = /\${[VPS]*\d+\|[^{}]+}/;
			var tmp:String;
			while(tmp != source){
				tmp = source;
				source = source.replace(re,replaceReference);
			}
			return source;
		}
		
		private static function replaceReference(matched:String,charIndex:int,original:String):*
		{
			var numWithPrefix:String = (matched.split("${")[1] as String).split("|")[0];
			
			var id:int;
			if(numWithPrefix.charAt(0) == 'V' || numWithPrefix.charAt(0) == 'P'){
				id = int(numWithPrefix.substr(1));
			}else // no prefix == old syntax, or wrong syntax..
			{
				id = int(numWithPrefix);
			}
			return idResolver(id);
		}
		
		private static const idAllowed: String = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_"; 
		
		public static const idNumber: String = "0123456789";
		
		public static function idify(str: String) : String  {
			return idifyExt(str, "", "_");
		}
		
		public static function idifyExt(str: String, allowedExtraChars: String , replaceChar: String) : String {
			if (str == null) return replaceChar;
			if (str.length == 0) return replaceChar;
			
			var result: String = "";
			
			if (idNumber.indexOf(str.substring(0,1)) >= 0) {
				result += replaceChar;
			}
			
			for (var i: int = 0; i < str.length; ++i) {
				var c: String = str.substring(i,i+1);
				if (idAllowed.indexOf(c) >= 0 || allowedExtraChars.indexOf(c) >= 0) {
					result += c;
				} else {
					result += replaceChar;
				}
			}
			
			return result;
		}
		
		public static function date2HHMMSS(time: Date, separ: String = ":") : String {
			return withZeros(int(time.hours),2) + separ + withZeros(int(time.minutes),2) + separ + withZeros(int(time.seconds),2);
		}
		
		public static function date2HHMMSSMS(time: Date, separ: String = ":", millisSepar: String = ".") : String {
			return withZeros(int(time.hours),2) + separ + withZeros(int(time.minutes),2) + separ + withZeros(int(time.seconds),2) + millisSepar + withZeros(int(time.milliseconds), 3);
		}
		
		public static function stripFileName(pathWithFile: String) : String {
			if (pathWithFile == null) return null;
			var index: int = pathWithFile.length; 
			for (; index >= 0; --index) {
				if (pathWithFile.charAt(index) == '/') break;
				if (pathWithFile.charAt(index) == '\\') break;
			}
			if (index < 0) return pathWithFile;
			return pathWithFile.substring(0, index);
		}
		
		/**
		 * a/./b -> a/b
		 * a/b/./ -> a/b/
		 * ./ -> ""
		 * / -> /
		 */
		public static function pathStripThisDir(str: String, shouldTerminateWithSlash: Boolean = false) : String {
			if (str == "/") {
				return "/";
			}
			if (str == "." || str == "./") {
				return "." + (shouldTerminateWithSlash ? "/" : "");
			}
			
			var i: int = 0;
			while ((i = str.indexOf("/./")) >= 0) {
				if (i == 0) str = str.substring(3);
				else str = str.substring(0, i) + str.substring(i+2);
			}
			while ((i = str.indexOf("./")) >= 0) {
				if (i == 0) str = str.substring(2);
				else str = str.substring(0, i) + str.substring(i+1);
			}
			
			if (str == "/.") {
				return "/";
			}
			
			if (str.substring(str.length-2) == "/.") str = str.substring(0, str.length-2);
			
			if (str == "/") {
				return "." + (shouldTerminateWithSlash ? "/" : "");
			}
			
			if (shouldTerminateWithSlash) {
				if (str.charAt(str.length-1) != "/") {
					return str + "/";
				}
			} else {
				if (str.charAt(str.length-1) == "/") {
					return str.substring(0, str.length-1);
				}
			}
			
			return str;
		}
		
		/*  
		*  Author:  Manish Jethani (manish.jethani@gmail.com)
		*  Date:    April 3, 2006
		*  Version: 0.1
		*
		*  Copyright (c) 2006 Manish Jethani
		*
		*  Permission is hereby granted, free of charge, to any person obtaining a
		*  copy of this software and associated documentation files (the "Software"),
		*  to deal in the Software without restriction, including without limitation
		*  the rights to use, copy, modify, merge, publish, distribute, sublicense,
		*  and/or sell copies of the Software, and to permit persons to whom the
		*  Software is furnished to do so, subject to the following conditions:
		*
		*  The above copyright notice and this permission notice shall be included in
		*  all copies or substantial portions of the Software.
		*
		*  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
		*  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
		*  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
		*  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
		*  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
		*  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
		*  DEALINGS IN THE SOFTWARE.  
		*
		*  sprintf(3) implementation in ActionScript 3.0.
		*
		*  http://www.die.net/doc/linux/man/man3/sprintf.3.html
		*
		*  The following flags are supported: '#', '0', '-', '+'
		*
		*  Field widths are fully supported.  '*' is not supported.
		*
		*  Precision is supported except one difference from the standard: for an
		*  explicit precision of 0 and a result string of "0", the output is "0"
		*  instead of an empty string.
		*
		*  Length modifiers are not supported.
		*
		*  The following conversion specifiers are supported: 'd', 'i', 'o', 'u', 'x',
		*  'X', 'f', 'F', 'c', 's', '%'
		*
		*  Report bugs to manish.jethani@gmail.com
		*/
		public static function sprintf(format:String, ... args):String
		{
			var result:String = "";
			
			var length:int = format.length;
			for (var i:int = 0; i < length; i++)
			{
				var c:String = format.charAt(i);
				
				if (c == "%")
				{
					var pastFieldWidth:Boolean = false;
					var pastFlags:Boolean = false;
					
					var flagAlternateForm:Boolean = false;
					var flagZeroPad:Boolean = false;
					var flagLeftJustify:Boolean = false;
					var flagSpace:Boolean = false;
					var flagSign:Boolean = false;
					
					var fieldWidth:String = "";
					var precision:String = "";
					
					c = format.charAt(++i);
					
					while (c != "d"
						&& c != "i"
						&& c != "o"
						&& c != "u"
						&& c != "x"
						&& c != "X"
						&& c != "f"
						&& c != "F"
						&& c != "c"
						&& c != "s"
						&& c != "%")
					{
						if (!pastFlags)
						{
							if (!flagAlternateForm && c == "#")
								flagAlternateForm = true;
							else if (!flagZeroPad && c == "0")
								flagZeroPad = true;
							else if (!flagLeftJustify && c == "-")
								flagLeftJustify = true;
							else if (!flagSpace && c == " ")
								flagSpace = true;
							else if (!flagSign && c == "+")
								flagSign = true;
							else
								pastFlags = true;
						}
						
						if (!pastFieldWidth && c == ".")
						{
							pastFlags = true;
							pastFieldWidth = true;
							
							c = format.charAt(++i);
							continue;
						}
						
						if (pastFlags)
						{
							if (!pastFieldWidth)
								fieldWidth += c;
							else
								precision += c;
						}
						
						c = format.charAt(++i);
					}
					
					switch (c)
					{
						case "d":
						case "i":
							var next:* = args.shift();
							var str:String = String(Math.abs(int(next)));
							
							if (precision != "")
								str = leftPad(str, int(precision), "0");
							
							if (int(next) < 0)
								str = "-" + str;
							else if (flagSign && int(next) >= 0)
								str = "+" + str;
							
							if (fieldWidth != "")
							{
								if (flagLeftJustify)
									str = rightPad(str, int(fieldWidth));
								else if (flagZeroPad && precision == "")
									str = leftPad(str, int(fieldWidth), "0");
								else
									str = leftPad(str, int(fieldWidth));
							}
							
							result += str;
							break;
						
						case "o":
							var next:* = args.shift();
							var str:String = uint(next).toString(8);
							
							if (flagAlternateForm && str != "0")
								str = "0" + str;
							
							if (precision != "")
								str = leftPad(str, int(precision), "0");
							
							if (fieldWidth != "")
							{
								if (flagLeftJustify)
									str = rightPad(str, int(fieldWidth));
								else if (flagZeroPad && precision == "")
									str = leftPad(str, int(fieldWidth), "0");
								else
									str = leftPad(str, int(fieldWidth));
							}
							
							result += str;
							break;
						
						case "u":
							var next:* = args.shift();
							var str:String = uint(next).toString(10);
							
							if (precision != "")
								str = leftPad(str, int(precision), "0");
							
							if (fieldWidth != "")
							{
								if (flagLeftJustify)
									str = rightPad(str, int(fieldWidth));
								else if (flagZeroPad && precision == "")
									str = leftPad(str, int(fieldWidth), "0");
								else
									str = leftPad(str, int(fieldWidth));
							}
							
							result += str;
							break;
						
						case "X":
							var capitalise:Boolean = true;
						case "x":
							var next:* = args.shift();
							var str:String = uint(next).toString(16);
							
							if (precision != "")
								str = leftPad(str, int(precision), "0");
							
							var prepend:Boolean = flagAlternateForm && uint(next) != 0;
							
							if (fieldWidth != "" && !flagLeftJustify
								&& flagZeroPad && precision == "")
								str = leftPad(str, prepend
									? int(fieldWidth) - 2 : int(fieldWidth), "0");
							
							if (prepend)
								str = "0x" + str;
							
							if (fieldWidth != "")
							{
								if (flagLeftJustify)
									str = rightPad(str, int(fieldWidth));
								else
									str = leftPad(str, int(fieldWidth));
							}
							
							if (capitalise)
								str = str.toUpperCase();
							
							result += str;
							break;
						
						case "f":
						case "F":
							var next:* = args.shift();
							var str:String = Math.abs(Number(next)).toFixed(
								precision != "" ?  int(precision) : 6);
							
							if (int(next) < 0)
								str = "-" + str;
							else if (flagSign && int(next) >= 0)
								str = "+" + str;
							
							if (flagAlternateForm && str.indexOf(".") == -1)
								str += ".";
							
							if (fieldWidth != "")
							{
								if (flagLeftJustify)
									str = rightPad(str, int(fieldWidth));
								else if (flagZeroPad && precision == "")
									str = leftPad(str, int(fieldWidth), "0");
								else
									str = leftPad(str, int(fieldWidth));
							}
							
							result += str;
							break;
						
						case "c":
							var next:* = args.shift();
							var str:String = String.fromCharCode(int(next));
							
							if (fieldWidth != "")
							{
								if (flagLeftJustify)
									str = rightPad(str, int(fieldWidth));
								else
									str = leftPad(str, int(fieldWidth));
							}
							
							result += str;
							break;
						
						case "s":
							var next:* = args.shift();
							var str:String = String(next);
							
							if (precision != "")
								str = str.substring(0, int(precision));
							
							if (fieldWidth != "")
							{
								if (flagLeftJustify)
									str = rightPad(str, int(fieldWidth));
								else
									str = leftPad(str, int(fieldWidth));
							}
							
							result += str;
							break;
						
						case "%":
							result += "%";
					}
				}
				else
				{
					result += c;
				}
			}
			
			return result;
		}
		
		// Private function of spritf
		private static function leftPad(source:String, targetLength:int, padChar:String = " "):String
		{
			if (source.length < targetLength)
			{
				var padding:String = "";
				
				while (padding.length + source.length < targetLength)
					padding += padChar;
				
				return padding + source;
			}
			
			return source;
		}
		
		// Private function of spritf
		private static function rightPad(source:String, targetLength:int, padChar:String = " "):String
		{
			while (source.length < targetLength)
				source += padChar;
			
			return source;
		}
		
	}
}