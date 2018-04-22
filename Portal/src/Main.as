package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.SharedObject;
	
	import skyboy.serialization.JSON;
	import com.greensock.*;
	
	[Frame(factoryClass="Preloader")]
	
	public class Main extends Sprite
	{
		[Embed(source="../lib/levelData.json",mimeType="application/octet-stream")]
		private var jsonEmbed:Class;
		public var jsonData:Object;
		
		private var menu:Menu;
		private var game:Game;
		
		public var saveData:SharedObject = SharedObject.getLocal("gameData");
		public var levelCount:int;
		public var maxLevels:int = 6;
		
		public function Main():void
		{
			if (stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			jsonData = skyboy.serialization.JSON.decode(new jsonEmbed())["levelData"];
			getSaves();
			
			launchMenu();
		}
		
		private function getSaves():void
		{
			if (saveData.data.levelCount == undefined)
			{
				levelCount = 0;
				saveData.data.levelCount = levelCount;
				saveData.flush();
			}
			else
			{
				levelCount = saveData.data.levelCount;
			}
		}
		
		private function saveGame():void
		{
			saveData.data.levelCount = levelCount;
			saveData.flush();
		}
		
		public function launchLevel(levelIndex:int):void
		{
			game = new Game(levelIndex);
			menu.destroy();
			addChild(game);
		}
		
		public function endGame():void
		{
			game.destroy();
			game = null;
			launchMenu();
		}
		
		public function newLevel():void
		{
			saveGame();
			if (levelCount <= maxLevels)
			{
				game = new Game(levelCount);
				
				addChild(game);
			}
			else
			{
				endGame();
			}
		
		}
		
		public function launchMenu():void
		{
			menu = new Menu();
			addChild(menu);
		}
	}
}