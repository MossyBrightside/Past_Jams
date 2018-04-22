package
{
	import com.greensock.easing.Linear;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import com.chargedweb.utils.ResourceMonitorUtil;
	import com.greensock.TweenMax;
	import com.greensock.plugins.*;
	import net.hires.debug.Stats;
	//import org.flashdevelop.utils.FlashConnect;
	
	[Frame(factoryClass = "Preloader")]
	

    [SWF(width="500", height="600", backgroundColor="#555555", frameRate="30")]


	
	public class Main extends Sprite
	{
		private var game:Game;
		private var menu:Menu = new Menu();
		private var gameBorder:GameBorder = new GameBorder();
		private var isPermitted:Boolean;
		private var opening:Opening = new Opening();
		private var openingAnim:*;
		private var stats:Stats = new Stats();
		
		public function Main():void
		{
			if (stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void
		{
			alpha = 0;
			removeEventListener(Event.ADDED_TO_STAGE, init);
			TweenPlugin.activate([FramePlugin]);
			stage.addEventListener(MouseEvent.RIGHT_CLICK, doNothing);
			addChild(stats);
			stats.x = 15;
			stats.y = 15;
			addChild(menu);
			//game = new Game();
			//game.paused = false;
			//addChild(game);

		}
		
		private function doNothing(e:MouseEvent):void
		{
		
		}
		
		public function startTransition():void
		{
			stage.addEventListener(Event.ENTER_FRAME, openingEnterframe);
			addChild(opening);
			opening.gotoAndPlay(2);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, cancelIntro);
		}
		
		private function openingEnterframe(e:Event):void
		{
			if (opening.currentFrame == 250)
			{
				removeChild(menu);
				menu = null;
				game = new Game();
				addChild(game);
				game.pause();
				setChildIndex(opening, this.numChildren - 1);
			}
			if (opening.currentFrame == 410)
			{
				removeChild(opening);
				game.unpause();
				stage.removeEventListener(Event.ENTER_FRAME, openingEnterframe);
			}
		}
		
		private function cancelIntro(e:KeyboardEvent):void
		{
			removeChild(menu);
			menu = null;
			game = new Game();
			addChild(game);
			game.pause();
			setChildIndex(opening, this.numChildren - 1);
			opening.gotoAndPlay(368);
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, cancelIntro);
		}
		
		public function startMenu():void
		{
			opening.gotoAndStop(1);
			menu = new Menu();
			menu.alpha = 0;
			
			var transition:Transition = new Transition(game, menu);
			
			addChild(menu);
			addChild(transition);
		}
	}

}