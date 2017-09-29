package td.utils
{
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.errors.AbstractClassError;
	import starling.text.TextField;
	
	import td.Context;
	
	public class ErrorDialog extends Sprite
	{
		private var _text:String;
		public function ErrorDialog(text:String, setW:Number, setH:Number)
		{
			this._text = text;
			var back:Quad = new Quad(setW, setH, 0xFFCC00);
			back.alpha = 0.6;
			addChild(back);
			var t:TextField = new TextField(setW, setH, text );
			addChild(t);
		}
		
		public static function showError(text: String) : ErrorDialog {
			var error:ErrorDialog = new ErrorDialog( text, Context.stage.stageWidth, Context.stage.stageHeight*0.7 );
			error.y = Context.stage.stageHeight*0.15;
			Context.stage.addChild(error);
			
			return error;
		}
	}
}