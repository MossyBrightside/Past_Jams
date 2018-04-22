package
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author
	 */
	public class Player extends Sprite
	{
		public function Player():void
		{
			if (stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			graphics.beginFill(0x00FF00)
			graphics.drawRect( -7.5 +15, -7.5+15, 15, 15);
			graphics.endFill();
		}
	
	}

}