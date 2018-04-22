package
{
	import flash.display.MovieClip;
	import flash.utils.getDefinitionByName;
	
	public class Pickup extends MovieClip
	{
		private var art:MovieClip;
		public var score:int;
		public var multiplier:int;
		private var pickupList:Array;
		private var pickupNum:int;
		public var sugarNum:int;
		public var antPowerNeeded:int;
		
		public function Pickup()
		{
			pickupList = [[SugarCube, 100, 1, 1], [Item1, 800, 2, 3], [Item2, 500, 1, 2], [Item3, 200, 0, 1], [Item4, 150, 2, 1], [Item5, 150, 0, 1], [Item6, 100, 0, 1], [Item7, 200, 1, 1], [Item8, 250, 1, 1], [Item9, 100, 0, 1], [Item10, 400, 2, 2], [Item11, 100, 0, 1], [Item12, 700, 3, 3], [Item13, 700, 4, 3], [Item14, 500, 3, 2],[Item15, 600, 2, 2],[Item16, 1500, 10, 6],];
			pickupNum = Math.floor(Math.random() * pickupList.length);
			art = new pickupList[pickupNum][0]();
			antPowerNeeded = pickupList[pickupNum][3];
			if (pickupNum == 0)
			{
				sugarNum = Math.floor(Math.random() * 4) + 1;
				art.gotoAndStop(sugarNum);
				score = sugarNum * 100;
				multiplier = sugarNum;
			}
			else
			{
				sugarNum = 0;
				score = pickupList[pickupNum][1];
				multiplier = pickupList[pickupNum][2];
			}
			
			this.addChild(art);
			
			x = (Math.random() * 690) + 35;
			y = (Math.random() * 690) + 35;
		}
	}
}