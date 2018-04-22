package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.AntiAliasType;
	import flash.text.TextFieldAutoSize;
	
	import com.greensock.*;
	
	public class LevelSelect extends Sprite
	{
		[Embed(source="../lib/alphbeta.ttf",fontName="gameFont",mimeType="application/x-font",fontWeight="normal",fontStyle="normal",advancedAntiAliasing="true",embedAsCFF="false")]
		private var font:Class;
		private var scoreFont:Font = new font();
		private var textFormat:TextFormat = new TextFormat();
		
		private var playButton:Sprite = new Sprite();
		private var levelData:Object;
		
		private var leftMove:Sprite = new Sprite();
		private var rightMove:Sprite = new Sprite();
		
		private var levelTitle:TextField;
		private var levelNumber:TextField;
		
		private var index:int = 0;
		
		public function LevelSelect():void
		{
			if (stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			levelData = Main(parent.parent).jsonData;
			alpha = 0;
			TweenMax.to(this, .5, { alpha: 1 } );
			
			textFormat.color = 0x000000;
			textFormat.font = scoreFont.fontName;
			textFormat.size = 30;
			textFormat.align = "center";
			
			graphics.lineStyle(3, 0x000000, 1);
			graphics.drawRect(0, 0, 225, 125);
			
			addTexts();
			addPlaybutton();
			addButtons();
			
			leftMove.addEventListener(MouseEvent.CLICK, leftSelect);
			rightMove.addEventListener(MouseEvent.CLICK, rightSelect);
			playButton.addEventListener(MouseEvent.CLICK, playGame);
		}
		
		private function playGame(e:MouseEvent):void
		{
			Main(parent.parent).launchLevel(index);
			destroy();
		}
		
		private function addPlaybutton():void
		{
			var playText:TextField = new TextField();
			playText.defaultTextFormat = textFormat;
			playText.embedFonts = true;
			playText.antiAliasType = AntiAliasType.ADVANCED;
			playText.text = "Play";
			playText.selectable = false;
			playText.autoSize = TextFieldAutoSize.CENTER
			playButton.addChild(playText);
			addChild(playButton);
			playButton.x = 60;
			playButton.y = 125;
		}
		
		private function addButtons():void
		{
			leftMove.graphics.lineStyle(3, 0x000000);
			leftMove.graphics.beginFill(0xFFFFFF);
			leftMove.graphics.drawRect(0, 0, 40, 80);
			leftMove.graphics.endFill();
			addChild(leftMove);
			leftMove.x -= 65;
			leftMove.y = 25;
			
			rightMove.graphics.lineStyle(3, 0x000000);
			rightMove.graphics.beginFill(0xFFFFFF);
			rightMove.graphics.drawRect(0, 0, 40, 80);
			rightMove.graphics.endFill();
			addChild(rightMove);
			rightMove.x = 250;
			rightMove.y = 25;
		}
		
		private function addTexts():void
		{
			levelNumber = new TextField();
			levelNumber.defaultTextFormat = textFormat;
			levelNumber.embedFonts = true;
			levelNumber.antiAliasType = AntiAliasType.ADVANCED;
			levelNumber.text = levelData[0].levelNumber;
			levelNumber.selectable = false;
			levelNumber.autoSize = TextFieldAutoSize.CENTER
			addChild(levelNumber);
			levelNumber.x = (225 / 2) - (levelNumber.width / 2);
			levelNumber.y = -60;
			
			levelTitle = new TextField();
			levelTitle.defaultTextFormat = textFormat;
			levelTitle.embedFonts = true;
			levelTitle.antiAliasType = AntiAliasType.ADVANCED;
			levelTitle.text = levelData[0].levelTitle;
			levelTitle.selectable = false;
			levelTitle.autoSize = TextFieldAutoSize.CENTER
			addChild(levelTitle);
			levelTitle.x = (225 / 2) - (levelTitle.width / 2);
			levelTitle.y = -30;
		}
		
		private function leftSelect(e:MouseEvent):void
		{
			if (index != 0)
			{
				index--;
				levelNumber.text = levelData[index].levelNumber
				levelTitle.text = levelData[index].levelTitle
			}
		}
		
		private function rightSelect(e:MouseEvent):void
		{
			if (index < Main(parent.parent).levelCount && index < Main(parent.parent).maxLevels)
			{
				index++;
				levelNumber.text = levelData[index].levelNumber;
				levelTitle.text = levelData[index].levelTitle;
			}
		}
		
		public function destroy():void
		{
			playButton.removeEventListener(MouseEvent.CLICK, playGame);
			leftMove.removeEventListener(MouseEvent.CLICK, leftSelect);
			rightMove.removeEventListener(MouseEvent.CLICK, rightSelect);
		}
	}
}