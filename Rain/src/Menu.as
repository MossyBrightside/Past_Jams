package
{
	import flash.display.Sprite;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.flashdevelop.utils.FlashConnect;
	import com.greensock.TweenMax;
	
	public class Menu extends Sprite
	{

		private var playButton:PlayButton = new PlayButton();
		private var menuBackground:MenuBackground = new MenuBackground();
		
		private var achievementsButton:AchievementsButton = new AchievementsButton();
		private var instructionsButton:InstructionsButton = new InstructionsButton();
		private var instructionsMenu:InstructionsMenu = new InstructionsMenu();
		
		
		
		public function Menu():void
		{
			if (stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			addChild(menuBackground);
			addButtons()
		}
		
		public function addButtons():void
		{
			playButton.x = 222;
			playButton.y = 325;
			addChild(playButton);
			playButton.addEventListener(MouseEvent.CLICK, destroy);
			
			instructionsButton.x = 172;
			instructionsButton.y = 366;
			addChild(instructionsButton);
			instructionsButton.addEventListener(MouseEvent.CLICK, addInstructionsMenu);
			
			
			achievementsButton.x = 170;
			achievementsButton.y = 410;
			//addChild(achievementsButton);
		}
		
		private function addInstructionsMenu(e:MouseEvent):void
		{
			instructionsMenu.x = 85;
			instructionsMenu.y = 177;
			instructionsMenu.alpha = 0;
			addChild(instructionsMenu);
			TweenMax.to(instructionsMenu, 1, { alpha:1 } );
			instructionsMenu.menuButton.addEventListener(MouseEvent.CLICK, destroyInstructions);
		}
		
		private function destroyInstructions(e:MouseEvent):void
		{
			TweenMax.to(instructionsMenu, 1, { alpha:0,onComplete:completeRemove } );
			instructionsMenu.menuButton.removeEventListener(MouseEvent.CLICK, destroyInstructions);
		}
		
		private function completeRemove():void
		{
			removeChild(instructionsMenu);
		}
		
		private function destroy(e:MouseEvent):void
		{
			instructionsButton.removeEventListener(MouseEvent.CLICK, addInstructionsMenu);
			playButton.removeEventListener(MouseEvent.CLICK, destroy);
			Main(parent).startTransition();
		}
	}

}