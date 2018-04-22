package
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import com.greensock.*;
	
	/**
	 * ...
	 * @author ...
	 */
	public class Transition extends Sprite
	{
		private var par:*;
		private var refOne:DisplayObject;
		private var refTwo:DisplayObject;
		
		public function Transition(refOne:DisplayObject, refTwo:DisplayObject):void
		{
			this.refOne = refOne;
			this.refTwo = refTwo;
			if (stage)
				init(null);
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			par = parent;
			
			alpha = 0;
			graphics.beginFill(0x000000, 1);
			graphics.drawRect(0, 0, 500, 600);
			graphics.endFill();
			TweenMax.to(this, 1, {alpha: 1, onComplete: fadeOut});
		}
		
		private function fadeOut():void
		{
			par.removeChild(refOne);
			refTwo.alpha = 1;
			TweenMax.to(this, 1, {alpha: 0, onComplete: destroy});
		}
		
		private function destroy():void
		{
			parent.removeChild(this);
		}
	}
//13x 10y
}