package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import flash.filters.GlowFilter;
	import flash.filters.GradientGlowFilter;
	import com.greensock.TweenMax;
	
	import org.flashdevelop.utils.FlashConnect;
	
	/**
	 * ...
	 * @author Jacob Strickland
	 */
	public class SunDrop extends Sprite
	{
		private var clickArea:LightOrb = new LightOrb();
		private var glowFilter:GlowFilter = new GlowFilter(0xAAAAAA, 1, 5, 5, 3, 3, false, false);
		private var maxVel:int = 0;
		
		public function SunDrop(vel:int):void
		{
			if (stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
				maxVel =	Math.floor(Math.random() * ((vel + 2) - (vel-2) + 1)) + (vel-2);
		}
		
		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			if (maxVel <= 0)
			{
				maxVel = 1;
			}
			filters = [glowFilter];
			
			x = Math.floor(Math.random() * (475 - 25 + 1)) + 25;
			y = 0;
			
			addChild(clickArea);
			clickArea.addEventListener(MouseEvent.CLICK, explode);
			
			addEventListener(Event.ENTER_FRAME, sunEnter);
		}
		
		private function sunEnter(e:Event):void
		{
			if (Game(parent.parent).paused == false)
			{
				y += maxVel;
			}
			if (y >= 620)
			{
				if (Game(parent.parent).multi >= 1)
				{
					Game(parent.parent).changeMulti(-Game(parent.parent).multi);
				}
				destroy();
			}
		}
		
		private function explode(e:MouseEvent):void
		{
			Game(parent.parent).changeMulti(1);
			Game(parent.parent).changeScore(100,x,y,0xFFFFFF);
			if (Game(parent.parent).paused == false)
			{
				Game(parent.parent).burst(stage.mouseX, stage.mouseY, 0xFFAAAAAA);
				destroy();
			}
		}
		
		public function destroy():void
		{
			clickArea.removeEventListener(MouseEvent.CLICK, explode);
			removeEventListener(Event.ENTER_FRAME, sunEnter);
			Game(parent.parent).sunArray.splice(Game(parent.parent).sunArray.indexOf(this), 1);
			parent.removeChild(this);
		}
	
	}

}