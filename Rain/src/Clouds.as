package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Point;
	import org.flashdevelop.utils.FlashConnect;
	
	public class Clouds extends Sprite
	{
		private var cloudData:BitmapData;
		private var cloud:Bitmap;
		private var colorMatrix:ColorMatrixFilter;
		private var color:int;
		private var offsets:Array;
		private var seed:int;
		
		public function Clouds():void
		{
			if (stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void
		{
			//FlashConnect.trace("Derp");
			removeEventListener(Event.ADDED_TO_STAGE, init);
			cloudData = new BitmapData(500, 200,true,0xFF0000);
			cloud = new Bitmap(cloudData);
			
			colorMatrix = new ColorMatrixFilter([0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 1,0,0,0,0]);
			seed = int(Math.random() * 10000);
			offsets = new Array();
			for (var i:int = 0; i <= 5; i++)
			{
				offsets.push(new Point());
			}
			addEventListener(Event.ENTER_FRAME, cloudEnterframe);
			
			addChild(cloud);
		}
		
		private function cloudEnterframe(e:Event):void
		{
			for (var i:int = 0; i <= 5; i++)
			{
				offsets[i].x += 1;
				offsets[i].y += 0.2;
			}
			cloudData.perlinNoise(150, 150, 5, seed, false, true, 1, true, offsets);
			cloudData.applyFilter(cloudData, cloudData.rect, new Point(),colorMatrix);
		}
	}

}