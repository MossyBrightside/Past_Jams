package 
{

	import starling.events.Event;
	import starling.display.Sprite;
	import starling.events.Event;
	
	/**
	 * ...
	 * @author 
	 */
	public class StarlingGame extends Sprite
	{
		public function StarlingGame()
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStage);
		}
		private function addedToStage(e:Event)
		{
			trace("Starling framework initialized!");
		}
	}
	
}