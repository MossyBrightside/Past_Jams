package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import com.greensock.TweenMax;
	
	public class LevelEndMenu extends Sprite
	{
		private var background:Bitmap = Library.levelSelectIMG;
		private var menuText:GameTextfield;
		private var menuButton:GameMenuButton;
		private var nextLevelButton:GameMenuButton;
		private var blackout:Bitmap = new Bitmap(new BitmapData(525, 525));
		
		public function LevelEndMenu():void
		{
			if (stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void
		{
			blackout.bitmapData = Library.blackout.bitmapData;
			x = 166;
			y = 134;
			
			graphics.lineStyle(5, 0x000000);
			graphics.beginBitmapFill(background.bitmapData);
			graphics.drawRoundRect(0, 0, 6 * 32, 9 * 32, 5, 5);
			
			Library.textFormat.size = 25;
			menuText = new GameTextfield("Menu");
			addChild(menuText);
			menuText.x = (this.width / 2) - (menuText.width / 2);
			menuText.y = 38;
			
			menuButton = new GameMenuButton("Return to\nMenu", "returnMenu", true);
			menuButton.x = 38;
			menuButton.y = 175;
			addChild(menuButton);
			
			nextLevelButton = new GameMenuButton("Next\nLevel", "nextLevel", true);
			nextLevelButton.x = 68;
			
			nextLevelButton.y = 100;
			addChild(nextLevelButton);
			
			if (Library.currentLevel + 1 >= Library.jsonData.length)
			{
				addChild(nextLevelButton);
				nextLevelButton.clickable = false;
				nextLevelButton.alpha = 0;
			}
			else
				addChild(nextLevelButton);
		}
		
		public function returnMenu():void
		{
			addChild(blackout);
			blackout.alpha = 0;
			blackout.x = blackout.x - this.x;
			blackout.y = blackout.y - this.y;
			TweenMax.to(blackout, .5, {alpha: 1, onComplete: destroy, onCompleteParams: [0]});
		}
		
		public function nextLevel():void
		{
			addChild(blackout);
			blackout.alpha = 0;
			blackout.x = blackout.x - this.x;
			blackout.y = blackout.y - this.y;
			TweenMax.to(blackout, .5, {alpha: 1, onComplete: destroy, onCompleteParams: [1]});
		}
		
		public function destroy(c:int):void
		{
			if (c == 0)
			{
				Main(parent).relaunchMenu();
			}
			else if (c == 1)
			{
				Main(parent).launchNext();
			}
			removeChild(menuText);
			menuText = null;
			removeChild(menuButton);
			menuButton.destroy();
			menuButton = null;
			removeChild(nextLevelButton);
			nextLevelButton.destroy();
			nextLevelButton = null;
		}
	}
}