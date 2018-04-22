package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.display.Sprite;
	import com.greensock.TweenMax;
	
	/**
	 * ...
	 * @author Jacob Strickland
	 */
	public class HealthBar extends Sprite
	{
		private var updatedHealth:int = 0;
		private var bar:Sprite = new Sprite();
		
		private var lifeBar:Lifebar = new Lifebar();
		
		public function HealthBar():void
		{
			if (stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			x = 50;
			y = 522;
			
			bar.graphics.beginFill(0xAAAAAA);
			bar.graphics.drawRect(0, 0, 400, 25);
			bar.graphics.endFill();
			bar.scaleX *= Game(parent).health * .01;
			addChild(bar);
			
			addChild(lifeBar);
			lifeBar.x -= 5;
			lifeBar.y -= 5;
		}
		
		public function updateBar(health:int):void
		{
			updatedHealth = health;
			TweenMax.to(bar, .5, {width: (health * 4), onComplete: updateComplete});
		}
		
		public function updateBarUpgrade(health:int):void
		{
			updatedHealth = health;
			TweenMax.to(bar, .75, {width: (health * 4)});
		}
		
		private function updateComplete():void
		{
			if (updatedHealth >= 100)
			{
				Game(parent).upgrade();
			}
			if (updatedHealth <= 0)
			{
				Game(parent).gameOver();
			}
		}
	}
}