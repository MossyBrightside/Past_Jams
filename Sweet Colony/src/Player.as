package 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	
	
	public class Player extends MovieClip
	{
		public var circle:Sprite;
		public var art:MovieClip;
		public function Player()
		{
			circle = new Sprite();
			circle.graphics.lineStyle(2, 0x000000,1);
			circle.graphics.drawCircle(0, 0, 15);
			circle.graphics.endFill();
			
			x = 750 / 2 - (width/2);
			y = 750 / 2 - (width / 2);
			addChild(circle);
			
			
			art = new AntArt();
			this.addChild(art);
		}
	}
}