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
	
	public class PauseMenu extends Sprite
	{
		
		[Embed(source="../lib/alphbeta.ttf",fontName="gameFont",mimeType="application/x-font",fontWeight="normal",fontStyle="normal",advancedAntiAliasing="true",embedAsCFF="false")]
		private var font:Class;
		private var scoreFont:Font = new font();
		private var textFormat:TextFormat = new TextFormat();
		
		private var menuButton:Sprite = new Sprite();
		private var restartButton:Sprite = new Sprite();
		
		public function PauseMenu():void
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
			
			alpha = 0;
			TweenMax.to(this, .5, {alpha: 1});
			graphics.lineStyle(2, 0xFFFFFF);
			graphics.beginFill(0x000000);
			graphics.drawRect(0, 0, 300, 275);
			graphics.endFill();
			
			textFormat.color = 0xFFFFFF;
			textFormat.font = scoreFont.fontName;
			textFormat.size = 40;
			textFormat.align = "center";
			
			addTexts();
		}
		
		private function addTexts():void
		{
			
			var pausedText:TextField = new TextField();
			pausedText.defaultTextFormat = textFormat;
			pausedText.embedFonts = true;
			pausedText.antiAliasType = AntiAliasType.ADVANCED;
			pausedText.text = "Paused";
			pausedText.selectable = false;
			pausedText.autoSize = TextFieldAutoSize.CENTER
			addChild(pausedText);
			pausedText.x = this.width / 2 - pausedText.width / 2;
			pausedText.y = 5;
			
			textFormat.size = 30;
			var menuText:TextField = new TextField();
			menuText.defaultTextFormat = textFormat;
			menuText.embedFonts = true;
			menuText.antiAliasType = AntiAliasType.ADVANCED;
			menuText.text = "Menu";
			menuText.selectable = false;
			menuText.autoSize = TextFieldAutoSize.CENTER
			menuButton.addChild(menuText);
			
			addChild(menuButton);
			menuButton.x = this.width / 2 - menuButton.width / 2-15;
			menuButton.y = 75;
			menuButton.addEventListener(MouseEvent.CLICK, returnToMenu);
			
			var restartText:TextField = new TextField();
			restartText.defaultTextFormat = textFormat;
			restartText.embedFonts = true;
			restartText.antiAliasType = AntiAliasType.ADVANCED;
			restartText.text = "Restart";
			restartText.selectable = false;
			restartText.autoSize = TextFieldAutoSize.CENTER
			restartButton.addChild(restartText);
			
			addChild(restartButton);
			restartButton.x = this.width / 2 - restartButton.width / 2;
			restartButton.y = 130;
			restartButton.addEventListener(MouseEvent.CLICK, restart);
		
		}
		
		private function restart(e:MouseEvent):void
		{
			Game(parent).onCommute(1);
			destroy();
		}
		
		private function returnToMenu(e:MouseEvent):void
		{
			restartButton.removeEventListener(MouseEvent.CLICK, restart);
			menuButton.removeEventListener(MouseEvent.CLICK, returnToMenu);
			Game(parent).menuReturn();
			parent.removeChild(this);
		}
		
		public function destroy():void
		{
			menuButton.removeEventListener(MouseEvent.CLICK, returnToMenu);
			restartButton.removeEventListener(MouseEvent.CLICK, restart);
			
			TweenMax.to(this, .5, {alpha: 0, onComplete: parent.removeChild, onCompleteParams: [this]});
		}
	}
}