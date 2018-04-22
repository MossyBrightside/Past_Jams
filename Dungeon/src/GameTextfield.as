package
{
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.AntiAliasType;

	
	public class GameTextfield extends TextField
	{
		public function GameTextfield(t:String):void
		{
			
			defaultTextFormat = Library.textFormat;
			embedFonts = true;
			antiAliasType = AntiAliasType.ADVANCED;
			text = t;
			selectable = false;
			autoSize = TextFieldAutoSize.LEFT
		}
	}
}