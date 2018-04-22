package
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.AntiAliasType;
	import flash.text.TextFieldAutoSize;
	
	public class LevelPrompt extends Sprite
	{
		
		[Embed(source="../lib/alphbeta.ttf",fontName="gameFont",mimeType="application/x-font",fontWeight="normal",fontStyle="normal",advancedAntiAliasing="true",embedAsCFF="false")]
		private var font:Class;
		private var scoreFont:Font = new font();
		private var textFormat:TextFormat = new TextFormat();
		
		public function LevelPrompt():void
		{
			if (stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			y = 100;
			x = (stage.width / 2) - (300 / 2);
			graphics.lineStyle(2, 0xFFFFFF);
			graphics.beginFill(0x000000);
			graphics.drawRect(0, 0, 300, 200);
			graphics.endFill();
			
			textFormat.color = 0xFFFFFF;
			textFormat.font = scoreFont.fontName;
			textFormat.size = 20;
			textFormat.align = "center";
			
			addTexts();
		}
		
		private function addTexts():void
		{
			var levelNumber:TextField = new TextField();
			levelNumber.defaultTextFormat = textFormat;
			levelNumber.embedFonts = true;
			levelNumber.antiAliasType = AntiAliasType.ADVANCED;
			levelNumber.text = Game(parent).levelData.levelNumber;
			levelNumber.selectable = false;
			levelNumber.autoSize = TextFieldAutoSize.CENTER
			addChild(levelNumber);
			levelNumber.x = this.width / 2 - levelNumber.width / 2;
			levelNumber.y = 5;
			
			var levelTitle:TextField = new TextField();
			levelTitle.defaultTextFormat = textFormat;
			levelTitle.embedFonts = true;
			levelTitle.antiAliasType = AntiAliasType.ADVANCED;
			levelTitle.text = Game(parent).levelData.levelTitle;
			levelTitle.selectable = false;
			levelTitle.autoSize = TextFieldAutoSize.CENTER
			addChild(levelTitle);
			levelTitle.x = this.width / 2 - levelTitle.width / 2;
			levelTitle.y = 25;
			
			var levelText:TextField = new TextField();
			levelText.defaultTextFormat = textFormat;
			levelText.embedFonts = true;
			levelText.antiAliasType = AntiAliasType.ADVANCED;
			levelText.text = Game(parent).levelData.levelText;
			levelText.selectable = false;
			textFormat.size = 12;
			levelText.width = 275;
			levelText.wordWrap = true;
			
			levelText.autoSize = TextFieldAutoSize.CENTER
			addChild(levelText);
			levelText.x = (this.width / 2 - levelText.width / 2);
			levelText.y = 50;
		}
	}
}