package
{
	import flash.events.Event;
	import flash.display.MovieClip;
	import flash.utils.getDefinitionByName;
	
	public class Projectile extends MovieClip
	{
		public var damage:int = 0;
		private var art:MovieClip;
		
		private var h:int = 100;
		private var k:int = 100;
		private var r:int = 600;
		private var theta:Number;
		private var velocity:Number;
		private var rotationSpeed:Number;
		private var variance:Number;
		
		public function Projectile(_damage:int)
		{
			damage = _damage;
			
			
			h += Math.random() * 300;
			k += Math.random() * 300;
			addEventListener(Event.ENTER_FRAME, projectileEnterFrame);
			
			theta = Math.floor(Math.random() * 360) + 2 * Math.PI / 20;
			velocity = (Math.random() * 5) + 2;
			rotationSpeed = Math.floor((Math.random() * 9) + 1);
			variance = (Math.random() * 10) + 1;
			theta += variance;
			x = h +r * Math.cos(theta);
			y = k - r * Math.sin(theta);
			
			art = new Rocks();
			art.gotoAndStop(Math.floor( Math.random() * 10 ) + 1);
			art.rotation = (Math.floor(Math.random() * 360) + 1);
			
			addChild(art);
			
			art.scaleX = 1.5;
			art.scaleY = 1.5;
		}
		
		public function projectileEnterFrame(e:Event):void
		{
			x -= Math.cos(theta) * velocity;
			y += Math.sin(theta) * velocity;
			art.rotation += rotationSpeed;
			
			if (x >= 1500 || x <= -1500 || y >= 1500 || y <= -1500)
				destroy();
				
		}
		
		public function destroy():void
		{
			removeEventListener(Event.ENTER_FRAME, projectileEnterFrame);
			removeChild(art);
		}
	}
}