package
{
	import flash.display.Bitmap;
	import skyboy.serialization.JSON;
	
	import flash.text.Font;
	import flash.text.TextFormat;
	
	import flash.net.SharedObject;
	
	public class Library
	{
		
		[Embed(source="../lib/levelData.json",mimeType="application/octet-stream")]
		private static var jsonEmbed:Class;
		public static var jsonData:Object;
		
		public static var jsonDataCopy:Object;
		
		
		[Embed(source = "../lib/blackout.png")]
		private static var blackoutEmbed:Class;
		public static var blackout:Bitmap = new blackoutEmbed();
		
		[Embed(source = "../lib/promptImage.png")]
		private static var promptEmbed:Class;
		public static var prompt:Bitmap = new promptEmbed();
		
		
		[Embed(source="../lib/tiles.png")]
		private static var tilesEmbed:Class;
		public static var tiles:Bitmap = new tilesEmbed();
		
		[Embed(source="../lib/menuImage.png")]
		private static var menuImageEmbed:Class;
		public static var menuImage:Bitmap = new menuImageEmbed();
		
		[Embed(source = "../lib/levelSelect.png")]
		private static var levelSelectEmbed:Class;
		public static var levelSelectIMG:Bitmap = new levelSelectEmbed();
		
		[Embed(source="../lib/8bitlim.ttf",fontName="gameFont",mimeType="application/x-font",fontWeight="normal",fontStyle="normal",advancedAntiAliasing="true",embedAsCFF="false")]
		private static var font:Class;
		public static var gameFont:Font = new font();
		public static var textFormat:TextFormat = new TextFormat();
		
		public static var gameSave:SharedObject;
		
		public static var currentLevel:int;
		
		
		
		
		public static function serializeJson():void
		{
			jsonData = skyboy.serialization.JSON.decode(new jsonEmbed())["levelData"];
			jsonDataCopy = skyboy.serialization.JSON.decode(new jsonEmbed())["levelData"];
		}
		
		public static function getSave():void
		{
			gameSave = SharedObject.getLocal("saveData");
		}
		
		public static function resetJson():void
		{
			
			
		}
		
		public static function prepareFont():void
		{
			textFormat.color = 0x000000;
			textFormat.font = gameFont.fontName;
			textFormat.size = 30;
			textFormat.align = "center";
		}
	}

}