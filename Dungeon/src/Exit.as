package
{
	import flash.display.Sprite;
	import flash.events.Event;

	public class Exit extends Sprite
	{
		
		public function Exit():void
		{
			if (stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			graphics.beginFill(0xFF0000);
			graphics.drawRect( 0, 0, 32, 32);
			graphics.endFill();
			
		}
	}
}