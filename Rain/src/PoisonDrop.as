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
	public class PoisonDrop extends Sprite
	{
		private var graphic:DarkOrb = new DarkOrb();
		private var glowFilter:GlowFilter = new GlowFilter(0x000000, 1, 5, 5, 3, 3, false, false);
		private var maxVel:int = 0;
		
		public function PoisonDrop(vel:int):void
		{
			if (stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
			//maxVel = Math.random() * (vel + 4);
			maxVel = Math.floor(Math.random() * ((vel + 2) - (vel - 1) + 2)) + (vel - 2);
		}
		
		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			if (maxVel == 0)
			{
				maxVel = 1;
			}
			addEventListener(Event.ENTER_FRAME, sunEnter);
			addChild(graphic);
			filters = [glowFilter];

			x = Math.floor(Math.random() * (475 - 25 + 1)) + 25;
			y = 0;
		}
		
		private function sunEnter(e:Event):void
		{
			
			if (Game(parent.parent).paused == false)
			{
				y += maxVel;
			}
			
			if (y >= 515)
			{
				Game(parent.parent).multi = 0;
				Game(parent.parent).changeMulti(0);
				explode();
			}
		}
		
		private function explode():void
		{
			Game(parent.parent).burst(x, y, 0xFF000000);
			destroy();
		}
		
		public function destroy():void
		{
			Game(parent.parent).poisonArray.splice(Game(parent.parent).poisonArray.indexOf(this), 1);
			removeEventListener(Event.ENTER_FRAME, sunEnter);
			parent.removeChild(this);
		}
	}

}