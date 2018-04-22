package
{
	import flash.display.Sprite;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class GameMenuButton extends Sprite
	{
		public var buttonText:GameTextfield;
		public var functionString:String;
		public var clickable:Boolean;
		
		public function GameMenuButton(t:String,s:String,c:Boolean):void
		{
			if (stage)
				init();
			else
			{
				addEventListener(Event.ADDED_TO_STAGE, init);
				buttonText = new GameTextfield(t);
				functionString = s;
				clickable = c;
			}
		}
		
		private function init(e:Event = null):void
		{
			addChild(buttonText);
			addEventListener(MouseEvent.ROLL_OVER, rollingOver);
			addEventListener(MouseEvent.ROLL_OUT, rollingOut);
			addEventListener(MouseEvent.CLICK, clickButton);
		}
		
		private function rollingOver(e:MouseEvent):void
		{
			buttonText.textColor = 0xFF0000;
		}
		
		private function rollingOut(e:MouseEvent):void
		{
			buttonText.textColor = 0x000000;
		}
		
		private function clickButton(e:MouseEvent):void
		{
			if (clickable == true)
			{
				[parent](parent)[functionString]();
			}
		}
		
		public function destroy():void
		{
			removeEventListener(MouseEvent.ROLL_OVER, rollingOver);
			removeEventListener(MouseEvent.ROLL_OUT, rollingOut);
			removeEventListener(MouseEvent.CLICK, clickButton);
		}
	}
}