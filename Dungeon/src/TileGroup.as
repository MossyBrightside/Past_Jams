package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class TileGroup extends Sprite
	{
		
		private var maskSprite:Sprite = new Sprite();
		private var maskBorder:Sprite = new Sprite();
		public var position:Point = new Point();
		public var maskSource:Bitmap;
		public var tiles:Array = new Array();
		public var lock:Boolean = false;
		
		public function TileGroup(tile:BitmapData, p:Point, tileData:Array):void
		{
			if (stage)
				init();
			else
			{
				addEventListener(Event.ADDED_TO_STAGE, init);
				maskSource = new Bitmap(tile);
				tiles = tileData;
				position = p;
			}
		}
		
		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			if (Dungeon(parent).levelData.locks[position.y][position.x] == 1)
				lock = true
			else
				lock = false;
			
			
			
			
			maskSprite.graphics.lineStyle(3, 0xFF0000);
			maskSprite.graphics.beginFill(0xFF0000);
			maskSprite.graphics.drawRoundRect(0, 0, 96, 96, 5, 5);
			maskSprite.graphics.endFill();
			
			if (lock == true)
				maskBorder.graphics.lineStyle(3, 0x000000);
			else
				maskBorder.graphics.lineStyle(3, 0x008020);
			
			maskBorder.graphics.drawRoundRect(0, 0, 96, 96, 5, 5);
			
			addChild(maskSprite);
			addChild(maskSource);
			
			maskSource.mask = maskSprite;
			addChild(maskBorder);
		}
		
		public function redraw():void
		{
			
			var tileRect:Rectangle = new Rectangle();

			tileRect = new Rectangle(96 * position.x, 96 * position.y, 96, 96);
			
			maskSource.bitmapData.copyPixels(Dungeon(parent).compoundLayer.bitmapData, tileRect, new Point(0, 0));
		}
	}
}