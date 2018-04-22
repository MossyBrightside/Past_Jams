package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	public class Logo extends Sprite
	{
		
		private var logoText:GameTextfield;
		private var url:URLRequest = new URLRequest("http://www.bastardlydungeon.com");
		
		public function Logo():void
		{
			if (stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			addEventListener(MouseEvent.CLICK, launchSite);
			Library.textFormat.size = 25;
			logoText = new GameTextfield("BastardlyDungeon.com");
			addChild(logoText);
			
			logoText.addEventListener(MouseEvent.CLICK, launchSite);
			logoText.addEventListener(MouseEvent.MOUSE_OVER, mouseOver);
			logoText.addEventListener(MouseEvent.MOUSE_OUT, mouseOut);
		}
		
		private function mouseOver(e:MouseEvent):void
		{
			logoText.textColor = 0xFF0000;
		}
		
		private function mouseOut(e:MouseEvent):void
		{
			logoText.textColor = 0x000000;
		}
		
		private function launchSite(e:MouseEvent):void
		{
			navigateToURL(url, "_blank");
		}
		
		public function destroy():void
		{
			logoText.removeEventListener(MouseEvent.CLICK, launchSite);
			logoText.removeEventListener(MouseEvent.MOUSE_OVER, mouseOver);
			logoText.removeEventListener(MouseEvent.MOUSE_OUT, mouseOut);
			removeChild(logoText);
			logoText = null;
		}
	}
}