package td.utils.draw
{
	import flash.geom.Point;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.text.TextFormat;

	public class Primitive extends Sprite
	{
		private var _isTouchable: Boolean = false;
		
		public function Primitive()
		{
			touchable = false;
		}
		
		public function setTouchable(state: Boolean) : void {
			if (state == _isTouchable) return;
			if (_isTouchable) {
				// DISABLE!
				this.removeEventListener(TouchEvent.TOUCH, onTouch);
			} else {
				// ENABLE!
				this.addEventListener(TouchEvent.TOUCH, onTouch);
			}
			_isTouchable = state;
			touchable = state;
		}
		
		private function onTouch(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(this, TouchPhase.BEGAN);
			if (touch)
			{				
				onClick(event);
			}
		}
		
		public function onClick(event: TouchEvent) : void {
			var touch:Touch = event.getTouch(this, TouchPhase.BEGAN);
			var localPos:Point = touch.getLocation(this);
			trace("Touched object at position: " + localPos);
		}
		
		public function line(x1: Number, y1: Number, x2: Number, y2: Number, color: uint = 0, thickness: int = 1) : Line {
			var l: Line = new Line(color);			
			l.thickness = thickness;
			l.makeLine(x1, y1, x2, y2);
			addChild(l);
			
			l.touchable = this.touchable;
			return l;
		}
		
		public function rectangle(x1: Number, y1: Number, x2: Number, y2: Number, color: uint = 0, thickness: int = -1, lineColor: uint = 0) : Rectangle {
			var r: Rectangle = new Rectangle(x2 - x1, y2 - y1, color, lineColor, thickness);
			r.x = x1;
			r.y = y1;
			addChild(r);
			
			r.touchable = this.touchable;
			return r;
		}
		
		public function text(x: int, y: int, fontSize: int, text: String, color: uint = 0) : TextField {
			var t: TextField = new TextField(text.length * 20, fontSize * 2, text, new TextFormat("Verdana", fontSize, color));
			t.x = x;
			t.y = y;
			addChild(t);
			
			t.touchable = this.touchable;
			return t;
		}
		
		public function textCenter(x: int, y: int, fontSize: int, text: String, color: uint = 0) : TextField {
			var t: TextField = new TextField(text.length * 20, fontSize * 2, text, new TextFormat("Verdana", fontSize, color));
			t.alignPivot();
			
			t.x = x;
			t.y = y;
			addChild(t);
			
			t.touchable = this.touchable;
			return t;
		}
		
		public function die() : void {
			while (numChildren > 0) {
				try {
					var child: DisplayObject = getChildAt(numChildren-1);
					if (child is Primitive) {
						Primitive(child).die();
					}
					removeChildAt(numChildren-1, true);
				} catch (e:Error) {
					return;
				}
			}
		}
	}
}