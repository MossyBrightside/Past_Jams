package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import flash.filters.GlowFilter;
	import flash.filters.GradientGlowFilter;
	
	/**
	 * ...
	 * @author Jacob Strickland
	 */
	public class LightBullet extends Sprite
	{
		private var xDir:Number = 0;
		private var yDir:Number = 0;
		private var angle:Number = 0;
		private var glowFilter:GlowFilter = new GlowFilter(0xAAAAAA, 1, 12, 12, 3, 3, false, false);
		
		public function LightBullet(xSpeed:int, ySpeed:int):void
		{
			if (stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
			xDir = xSpeed;
			yDir = ySpeed;
		}
		
		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			addEventListener(Event.ENTER_FRAME, bulletEnter);
			
			filters = [glowFilter];
			graphics.beginFill(0xAAAAAA);
			graphics.drawCircle(0, 0, 5);
			graphics.endFill();
			x = 250;
			y = 500;
			
			angle = Math.round(180 - ((Math.atan2(xDir - x, yDir - y)) * 180 / Math.PI));
			angle = ((angle - 90) * Math.PI / 180);
			xDir = Math.cos(angle) * 10;
			yDir = Math.sin(angle) * 10;
		}
		
		private function bulletEnter(e:Event):void
		{
			if (Game(parent).paused == false)
			{
				x += xDir;
				y += yDir;
			}
			
			if (y <= -15)
			{
				destroy();
			}
		}
		
		public function returnLight():void
		{
			Game(parent).burst(x, y, 0xFFAAAAAA);
			destroy();
		}
		
		public function destroy():void
		{
			Game(parent).bulletArray.splice(Game(parent).bulletArray.indexOf(this), 1);
			removeEventListener(Event.ENTER_FRAME, bulletEnter);
			parent.removeChild(this);
		}
	}

}