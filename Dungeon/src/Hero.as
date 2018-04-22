package
{
	import flash.display.Sprite;
	import flash.events.Event;

	public class Hero extends Sprite
	{
		
		public function Hero():void
		{
			if (stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			graphics.beginFill(0x000000);
			graphics.drawRect( -12, -12, 24, 24);
			graphics.beginFill(0xFF0000);
			graphics.endFill();
			
		}
	}
}