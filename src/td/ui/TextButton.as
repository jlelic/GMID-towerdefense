package td.ui
{
	import org.osflash.signals.Signal;
	import starling.events.TouchEvent;
	import starling.text.TextFormat;
	import td.utils.draw.Primitive;
	
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.text.TextField;
	import starling.utils.Color;

	public class TextButton extends Primitive
	{
		private var tf:TextField;
		
		/**
		 * function onClick(event: TouchEvent)
		 */
		public var clicked: Signal = new Signal();
		
		public function TextButton(text: String, fontSize: int, onClick: Function = null)
		{
			setTouchable(true);
			
			if (onClick != null) this.clicked.add(onClick);
			
			tf = new TextField(text.length * 22*2, fontSize * 2, text, new TextFormat("Verdana", fontSize));
			tf.touchable = true;
			
			rectangle(0, 0, tf.textBounds.width + 10, tf.textBounds.height + 10, Color.WHITE, 2, Color.BLACK);
			
			tf.x = width / 2 - tf.width / 2;
			tf.y = height / 2 - tf.height / 2;
			
			addChild(tf);
		}
		
		override public function onClick(event: TouchEvent) : void {
			clicked.dispatch(event);
		}
		
	}
}