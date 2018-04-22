package
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.utils.getDefinitionByName;
	
	public class Preloader extends MovieClip
	{
		private var gameTitle:GameTitle;
		private var background:Background1;
		private var loading:LoadingSymbol;
		
		public function Preloader()
		{
			if (stage)
			{
				stage.scaleMode = StageScaleMode.NO_SCALE;
				stage.align = StageAlign.TOP_LEFT;
			}
			addEventListener(Event.ENTER_FRAME, checkFrame);
			loaderInfo.addEventListener(ProgressEvent.PROGRESS, progress);
			loaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioError);
			
			background = new Background1();
			background.gotoAndStop(2);
			addChild(background);
			
			gameTitle = new GameTitle();
			addChild(gameTitle);
			gameTitle.x = 210;
			gameTitle.y = 60;
			
			loading = new LoadingSymbol();
			addChild(loading);
			loading.x = 328;
			loading.y = 343;
		
		}
		
		private function ioError(e:IOErrorEvent):void
		{
			trace(e.text);
		}
		
		private function progress(e:ProgressEvent):void
		{
			
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
		
			startup();
		}
		
		private function startup():void
		{
			removeChild(background);
			removeChild(loading);
			removeChild(gameTitle);
			var mainClass:Class = getDefinitionByName("Main") as Class;
			addChild(new mainClass() as DisplayObject);
		}
	
	}

}