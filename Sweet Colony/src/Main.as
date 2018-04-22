package
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import bd.controls.KeyInput;
	import mx.core.ButtonAsset;
	import com.greensock.*;
	import com.greensock.easing.*;
	
	[Frame(factoryClass = "Preloader")]
	public class Main extends Sprite
	{
		private var gameTitle:GameTitle;
		private var background:Background1;
		private var playButton:_PlayButton = new _PlayButton();
		private var optionsButton:_OptionsButton = new _OptionsButton();
		private var creditsButton:_CreditsButton = new _CreditsButton();
		private var container:MovieClip;
		
		public function Main()
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void
		{
			container = new MovieClip();
			stage.addChild(container);
			removeEventListener(Event.ADDED_TO_STAGE, init);
			background = new Background1();
			background.gotoAndStop(2);
			container.addChild(background);
			
			gameTitle = new GameTitle();
			container.addChild(gameTitle);
			gameTitle.x = 210;
			gameTitle.y = 60;
			
			playButton.x = 278+50;
			playButton.y = 343;
			container.addChild(playButton);
			
			optionsButton.x = 246+50;
			optionsButton.y = 424;
			container.addChild(optionsButton);
			
			creditsButton.x = 250+50;
			creditsButton.y = 511;
			container.addChild(creditsButton);
			
			
			playButton.addEventListener(MouseEvent.CLICK, launchGame);
		}
		
		
		private function launchGame(e:MouseEvent):void
		{
			startGame();
			stage.addChild(container);
			TweenMax.to(container, .5, {alpha:0,onComplete:destroyFunctions});
			
		}
		
		
		
		
		private function destroyFunctions():void
		{
			playButton.removeEventListener(MouseEvent.CLICK, launchGame);
			container.alpha = 1;
			stage.removeChild(container);
		}
		private function startGame():void
		{	
			var level:Level = new Level();
			stage.addChild(level);
		}
	}
}