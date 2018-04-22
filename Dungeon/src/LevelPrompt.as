package
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import flash.text.TextField;
	
	public class LevelPrompt extends Sprite
	{
		
		private var levelNumber:GameTextfield;
		private var levelTitle:GameTextfield;
		private var levelText:GameTextfield;
		private var closeText:GameTextfield;
		
		public function LevelPrompt(i:int, t:String, d:String):void
		{
			if (stage)
				init();
			else
			{
				addEventListener(Event.ADDED_TO_STAGE, init);
				Library.textFormat.size = 25;
				levelNumber = new GameTextfield("Level " + i.toString());
				levelTitle = new GameTextfield(t);
				Library.textFormat.size = 20;
				levelText = new GameTextfield(d);
				
				closeText = new GameTextfield("(space to close)");
			}
		}
		
		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			x = 64+7.5;
			y = 64 + 7.5;
			
			this.focusRect = true;
			graphics.lineStyle(5, 0x000000);
			graphics.beginBitmapFill(Library.prompt.bitmapData);
			graphics.drawRoundRect(0, 0, 384, 288, 5, 5);
			graphics.endFill();
			addTexts();
		}
		
		private function addTexts():void
		{
			
			addChild(levelNumber);
			
			levelNumber.x = (this.width / 2) - (levelNumber.width / 2);
			levelNumber.y = 3;
			
			levelNumber.textColor = 0xFFFFFF;
			addChild(levelTitle);
			levelTitle.x = (this.width / 2) - (levelTitle.width / 2);
			levelTitle.y = 30;
			
			addChild(levelText);
			levelText.x = (this.width / 2) - (levelText.width / 2);
			levelText.y = 70;
			
			
			addChild(closeText);
			closeText.x = (this.width / 2) - (closeText.width / 2);
			closeText.y = 230;
			
		}
		
		public function destroy():void
		{
			
		}
	}
}