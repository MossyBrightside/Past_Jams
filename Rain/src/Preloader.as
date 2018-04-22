package
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.utils.getDefinitionByName;
	import org.flashdevelop.utils.FlashConnect;
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	
	/**
	 * ...
	 * @author Jacob Strickland
	 */
	public class Preloader extends MovieClip
	{
		
		private var container:Sprite = new Sprite();
		
		private var menuBackground:MenuBackground = new MenuBackground();
		private var lifebar:Lifebar = new Lifebar();
		private var playButton:PlayButton = new PlayButton();
		private var bar:Sprite = new Sprite();
		private var border:MainBorder = new MainBorder();
		private var isPermitted:Boolean;
		
		public function Preloader()
		{
			if (stage)
			{
				stage.scaleMode = StageScaleMode.NO_SCALE;
				stage.align = StageAlign.TOP_LEFT;
				FusionLock.registerStage(stage);
				FusionLock.allowSites(["bastardlydungeon.com","kongregate.com","fastswf.com"]);
				FusionLock.allowLocalPlay();
				isPermitted = FusionLock.checkURL();
			}
			addEventListener(Event.ENTER_FRAME, checkFrame);
			loaderInfo.addEventListener(ProgressEvent.PROGRESS, progress);
			loaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioError);
			
			// TODO show loader
			container.addChild(menuBackground);
			
			bar.x = 53;
			bar.y = 415;
			bar.graphics.beginFill(0xAAAAAA);
			bar.graphics.drawRect(0, 0, 400, 25);
			bar.graphics.endFill();
			container.addChild(bar);
			
			lifebar.x = 50;
			lifebar.y = 410;
			container.addChild(lifebar);
			
			playButton.x = 220;
			playButton.y = 445;
			playButton.alpha = 0;
			container.addChild(playButton);
			addChild(container);
		}
		
		private function ioError(e:IOErrorEvent):void
		{
			trace(e.text);
		}
		
		private function progress(e:ProgressEvent):void
		{
			bar.width = (e.bytesLoaded / e.bytesTotal * 100) * 4;
		}
		
		private function checkFrame(e:Event):void
		{
			if (currentFrame == totalFrames)
			{
				stop();
				loadingFinished();
			}
		}
		
		private function loadingFinished():void
		{
			removeEventListener(Event.ENTER_FRAME, checkFrame);
			loaderInfo.removeEventListener(ProgressEvent.PROGRESS, progress);
			loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioError);
			
			// TODO hide loader
			TweenMax.to(playButton, 1, {alpha: 1, ease: Linear.easeNone, y: playButton.y + 10});
			playButton.addEventListener(MouseEvent.CLICK, startup);
		}
		
		private function startup(e:MouseEvent):void
		{
			
			if (isPermitted == true)
			{
				playButton.removeEventListener(MouseEvent.CLICK, startup);
				var main:Main = new Main();
				
				var transition:Transition = new Transition(container, main);
				addChild(main);
				addChild(transition);
				addChild(border);
			}
			else {
				FusionLock.redirect(isPermitted);
			}
		}
	
	}

}