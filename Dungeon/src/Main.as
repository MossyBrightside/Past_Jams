package
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import com.greensock.TweenMax;
	
	/**
	 * ...
	 * @author
	 */
	[Frame(factoryClass="Preloader")]
	
	public class Main extends Sprite
	{
		private var dungeon:Dungeon;
		private var menu:Menu;
		private var endMenu:LevelEndMenu;
		private var blackout:Bitmap = Library.blackout;
		
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
			
			Library.serializeJson();
			Library.getSave();
			Library.prepareFont();
			launchMenu();
		}
		
		public function launchGame(l:int):void
		{
			removeChild(menu);
			menu = null;
			
			if (l >= Library.jsonData.length)
				l = Library.jsonData.length-1;
				
			dungeon = new Dungeon(l);
			addChild(dungeon);
			addChild(blackout);
			TweenMax.to(blackout, .5, {alpha: 0, onComplete: removeChild, onCompleteParams: [blackout]});
		}
		
		
		
		public function relaunchMenu():void
		{
			removeChild(endMenu);
			endMenu = null;
			
			menu = new Menu();
			
			addChild(menu);
			blackout.alpha = 1;
			addChild(blackout);
			TweenMax.to(blackout, .5, {alpha: 0, onComplete: removeChild, onCompleteParams: [blackout]});
		}
		
		public function launchNext():void
		{
			removeChild(endMenu);
			endMenu = null;
			
			dungeon = new Dungeon(Library.currentLevel + 1);
			
			addChild(dungeon);
			addChild(blackout);
			blackout.alpha = 1;
			TweenMax.to(blackout, .5, {alpha: 0, onComplete: removeChild, onCompleteParams: [blackout]});
		}
		
		public function returnToMenu():void
		{
			addChild(blackout);
			blackout.alpha = 1;
			removeChild(dungeon);
			dungeon = null;
			menu = new Menu();
			
			addChild(menu);
			TweenMax.to(blackout, .5, {alpha: 0, onComplete: removeChild, onCompleteParams: [blackout]});
		}
		
		public function resetLevel():void
		{
			addChild(blackout);
			blackout.alpha = 1;
			removeChild(dungeon);
			dungeon = null;
			dungeon = new Dungeon(Library.currentLevel);
			
			addChild(dungeon);
			TweenMax.to(blackout, .5, {alpha: 0, onComplete: removeChild, onCompleteParams: [blackout]});
		}
		
		
		public function endLevel():void
		{
			addChild(blackout);
			blackout.alpha = 1;
			removeChild(dungeon);
			dungeon = null;
			endMenu = new LevelEndMenu();
			addChild(endMenu);
			TweenMax.to(blackout, .5, {alpha: 0, onComplete: removeChild, onCompleteParams: [blackout]});
		
		}
		
		public function launchMenu():void
		{
			menu = new Menu();
			addChild(menu);
		}
	
	}

}