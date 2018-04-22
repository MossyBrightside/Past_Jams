package 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	
	
	public class Home extends MovieClip
	{
		public var circle:Sprite;
		private var art:MovieClip;
		public function Home()
		{
			circle = new Sprite();
			circle.graphics.lineStyle(2, 0xFF000000,1);
			circle.graphics.drawCircle( 0, 0, 30);
			circle.graphics.endFill();
			
			addChild(circle);
			
			
			art = new Mound();
			addChild(art);
			x = 750 / 2;
			y = 750 / 2;
		}
	}
}