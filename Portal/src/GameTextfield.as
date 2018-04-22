package
{
	import flash.text.TextField;
	
	public class GameTextfield extends TextField
	{
		public function GameTextfield(text:String):void
		{
			
			defaultTextFormat = Library.textFormat;
			embedFonts = true;
			antiAliasType = AntiAliasType.ADVANCED;
			this.text = text;
			selectable = false;
			autoSize = TextFieldAutoSize.CENTER
		}
	}
}