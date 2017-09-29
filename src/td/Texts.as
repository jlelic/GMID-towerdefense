package td 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author Jakub Gemrot
	 */
	public class Texts 
	{		
		/**
		 * Note that XML must have single root! There cannot be multiple root tags within the XML document.
		 */
		[Embed(source="../assets/i18n.xml", mimeType="application/octet-stream")]
		private var I18N: Class;
	
		/**
		 * How to work with XMLs:
		 * http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/XML.html
		 */
		private var xml: XML;
		
		private var lang: XML;
		
		public function Texts() 
		{
			Context.texts = this;
			
			var byteArray:ByteArray = new I18N() as ByteArray;
			xml = new XML(byteArray.readUTFBytes(byteArray.length)); // synchronous read!
			byteArray.clear();
			
			trace("Texts: I18N.xml LOADED\n" + xml.toXMLString());
			
			setLanguage();
		}
		
		public function setLanguage(language: String = "cze") : void {
			// xml.child("TEXT") => returns list of direct xml children called "TEXT"
			if (xml.child(language).length() > 0) {
				trace("Texts: setting language " + language);
				lang = xml.child(language)[0];
			} else {
				trace("Texts: missing language " + language);			
				lang = null;
			}
			
			
		}
		
		public function text(id: String) : String {
			if (lang == null) {
				trace("Texts.text(" + id + ") -> Language not set! -> !L!" + id + "!");
				return "!L" + id + "!";
			}
			if (lang.child(id).length() > 0 && lang.child(id)[0].attribute("value").length() > 0) {
				var text: * = lang.child(id)[0].attribute("value")[0];				
				trace("Texts.text(" + id + ") -> " + text);
				return text.toString();
			}
			
			trace("Texts.text(" + id + ") -> MISSING! -> !M!" + id + "!");
			return "!M!" + id + "!";
		}
		
	}

}