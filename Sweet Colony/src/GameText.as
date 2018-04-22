package 
{
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.Font;

	
	public class GameText extends TextField 
	{
		[Embed(source = "../Assets/gameFont.ttf", fontName = "gameFont", mimeType = "application/x-font", fontWeight = "normal", fontStyle = "normal", advancedAntiAliasing = "true", embedAsCFF = "false")]
		private static var font:Class;
		public static var gameFont:Font = new font();
		public static var textFormat:TextFormat = new TextFormat();
		
		private var format:TextFormat;
		
		public function GameText()
		{
			embedFonts = true;
			
			textFormat.color = 0x000000;
			textFormat.font = gameFont.fontName;
			textFormat.size = 50;
			
            defaultTextFormat = textFormat;
			selectable = false;
			width = 700;
		}
	}
}