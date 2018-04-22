package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import com.greensock.TweenMax;
	
	public class Menu extends Sprite
	{
		private var background:Bitmap = new Bitmap(new BitmapData(480, 480));
		
		private var levelSelect:GameMenuButton;
		private var play:GameMenuButton;
		private var levelSelectMenu:Sprite = new Sprite();
		private var backButton:GameMenuButton;
		private var openMenu:Boolean = false;
		private var levelArray:Array = new Array();
		
		private var logoText:Logo;
		
		private var blackout:Bitmap = Library.blackout;
		
		public var levelNumber:int = 0;
		
		private var instructionText:GameTextfield;;
		
		public function Menu():void
		{
			if (stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void
		{
			
			if (Library.gameSave.data.highestLevel == undefined)
			{
				levelNumber = 0;
				
				Library.gameSave.data.highestLevel = -1;
				Library.gameSave.flush();
			}
			else if (Library.gameSave.data.highestLevel >= Library.jsonData.length)
			{
				levelNumber = Library.jsonData.length;
			}
			else
			{
				if (Library.gameSave.data.highestLevel + 1 >= Library.jsonData.length)
				{
					levelNumber = Library.gameSave.data.highestLevel;
				}
				else
				{
					levelNumber = Library.gameSave.data.highestLevel + 1;
				}
				
			}
			removeEventListener(Event.ADDED_TO_STAGE, init);
			Library.textFormat.size = 30;
			background = Library.menuImage;
			background.x = 22.5;
			background.y = 22.5;
			addChild(background);
			play = new GameMenuButton("Play", "launchLevel",true);
			addChild(play);
			play.x = 235;
			play.y = 180;
			
			levelSelect = new GameMenuButton("Level\nSelect", "levelSelectLaunch",true);
			addChild(levelSelect);
			levelSelect.x = 222;
			levelSelect.y = 230;
			
			Library.textFormat.size = 18;
			backButton = new GameMenuButton("Close", "removeLevelSelect",true);
			backButton.x = 240;
			backButton.y = 400;
			
			Library.textFormat.size = 19;
			instructionText  = new GameTextfield("R to reset while in game, M to return to menu")
			addChild(instructionText);
			instructionText.x = 53;
			instructionText.y = 450;
			
			logoText = new Logo();
			addChild(logoText);
			logoText.x = 144;
			logoText.y = 345;
			

			levelSelectMenu.graphics.lineStyle(5, 0x000000);
			levelSelectMenu.graphics.beginBitmapFill(Library.levelSelectIMG.bitmapData);
			levelSelectMenu.graphics.drawRoundRect(0, 0, 6 * 32, 9 * 32, 5, 5);
			
			levelSelectMenu.x = 166;
			levelSelectMenu.y = 166;
			
			Library.textFormat.size = 20;
			generateLevels();
		}
		
		private function generateLevels():void
		{
			var l:int = Library.jsonData.length;
			var b:LevelSelectMenuButton;
			Library.textFormat.size = 15;
			for (var i:int = 0; i < l; i++)
			{
				if (Library.gameSave.data.highestLevel+1 < i)
				{
					b = new LevelSelectMenuButton((i+1) + ": " + "Locked", "launchLevel", false,i);
				}
				else
				{
					b = new LevelSelectMenuButton((i+1) + ": " + Library.jsonData[i].title, "launchLevel",true,i);
				}
				
				levelSelectMenu.addChild(b);
				b.x = 32;
				b.y = 35 + (i * 20);
				levelArray.push(b);
			}
		}
		
		public function launchLevel():void
		{
			addChild(blackout);
			blackout.alpha = 0;
			TweenMax.to(blackout, .5, {alpha: 1, onComplete: destroy});
			
		}
		
		public function levelSelectLaunch():void
		{
			openMenu = true;
			addChild(levelSelectMenu);
			addChild(backButton);
		}
		
		public function removeLevelSelect():void
		{
			openMenu = false;
			removeChild(levelSelectMenu);
			removeChild(backButton);
		}
		
		public function destroy():void
		{
			var l:int = levelArray.length;
			for (var i:int = 0; i < l; i++)
			{
				levelSelectMenu.removeChild(levelArray[i]);
				levelArray[i].destroy();
				levelArray[i] = null;
			}
			removeChild(background);
			background = null;
			
			removeChild(levelSelect);
			levelSelect.destroy();
			levelSelect = null;
			
			removeChild(play);
			play.destroy();
			play = null;
			
			removeChild(instructionText);
			instructionText = null;
			
			removeChild(logoText);
			logoText.destroy();
			logoText = null;
			if (openMenu == true)
			{
				removeChild(levelSelectMenu);
				levelSelectMenu = null;
				
				removeChild(backButton);
				backButton.destroy();
				backButton = null;
			}
			
			removeChild(blackout);
			blackout = null;
			
			Main(parent).launchGame(levelNumber);
		}
	}
}