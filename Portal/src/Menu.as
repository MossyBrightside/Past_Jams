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
	
	/**
	 * ...
	 * @author
	 */
	public class Menu extends Sprite
	{
		[Embed(source="../lib/alphbeta.ttf",fontName="gameFont",mimeType="application/x-font",fontWeight="normal",fontStyle="normal",advancedAntiAliasing="true",embedAsCFF="false")]
		private var font:Class;
		private var scoreFont:Font = new font();
		private var textFormat:TextFormat = new TextFormat();
		
		private var playButton:Sprite = new Sprite();
		private var instructionsButton:Sprite = new Sprite();
		
		private var levelSelect:LevelSelect;
		
		private var menuBox:Sprite = new Sprite();
		private var open:Boolean = false;
		private var openType:int = 0;
		
		private var jsonData:Object;
		
		private var levelData:Object;
		
		public function Menu():void
		{
			if (stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			jsonData = Main(parent).jsonData;
			alpha = 0;
			TweenMax.to(this, .5, {alpha: 1});
			
			textFormat.color = 0x000000;
			textFormat.font = scoreFont.fontName;
			textFormat.size = 60;
			
			menuBox.graphics.lineStyle(2.5, 0x000000, 1);
			menuBox.graphics.drawRect(-160, -50, 320, 100);
			
			addChild(menuBox);
			menuBox.x = 150 + 160;
			menuBox.y = 240 + 50;
			
			addTitle();
			addButtons();
			
			playButton.addEventListener(MouseEvent.CLICK, levelSelectMenu);
			instructionsButton.addEventListener(MouseEvent.CLICK, instructionsMenu);
		}
		
		private function levelSelectMenu(e:MouseEvent):void
		{
			if (open == true)
			{
				closeMenu(1);
			}
			else
			{
				openType = 1;
				open = true;
				levelSelect = new LevelSelect();
				TweenMax.to(menuBox, .5, {width: menuBox.width * 1.7, height: menuBox.height * 3});
				TweenMax.to(playButton, .5, {y: playButton.y - 100});
				TweenMax.to(instructionsButton, .5, {y: instructionsButton.y + 100});
				addChild(levelSelect);
				levelSelect.x = 190;
				levelSelect.y = 250;
			}
		}
		
		private function instructionsMenu(e:MouseEvent):void
		{
			if (open == true)
			{
				closeMenu(2);
			}
			else
			{
				open = true;
				openType = 2;
				TweenMax.to(menuBox, .5, {width: menuBox.width * 1.7, height: menuBox.height * 3});
				TweenMax.to(playButton, .5, {y: playButton.y - 100});
				TweenMax.to(instructionsButton, .5, {y: instructionsButton.y + 100});
			}
		}
		
		private function closeMenu(item:int):void
		{
			TweenMax.to(menuBox, .5, {width: menuBox.width / 1.7, height: menuBox.height / 3, onComplete: reopen, onCompleteParams: [item, openType]});
			TweenMax.to(playButton, .5, {y: playButton.y + 100});
			TweenMax.to(instructionsButton, .5, {y: instructionsButton.y - 100});
			switch (openType)
			{
				case 1: 
					levelSelect.destroy();
					TweenMax.to(levelSelect, .5, {alpha: 0, onComplete: removeChild, onCompleteParams: [levelSelect]});
					break;
				case 2: 
					break;
			}
			openType = 0;
			open = false;
		}
		
		private function reopen(item:int, type:int):void
		{
			switch (item)
			{
				case 1: 
					if (type != 1)
					{
						levelSelectMenu(null);
					}
					
					break;
				case 2: 
					if (type != 2)
					{
						instructionsMenu(null);
					}
					
					break;
			}
		}
		
		private function addTitle():void
		{
			var title:TextField = new TextField();
			
			title.defaultTextFormat = textFormat;
			title.embedFonts = true;
			title.antiAliasType = AntiAliasType.ADVANCED;
			
			title.text = "Portal or Die";
			title.selectable = false;
			textFormat.align = "center";
			title.autoSize = TextFieldAutoSize.CENTER
			title.x = 300 - (title.width / 2);
			title.y = 25;
			addChild(title);
		}
		
		private function addButtons():void
		{
			textFormat.size = 35;
			
			var playText:TextField = new TextField();
			
			playText.defaultTextFormat = textFormat;
			playText.embedFonts = true;
			playText.antiAliasType = AntiAliasType.ADVANCED;
			playText.text = "Play";
			playText.selectable = false;
			playText.autoSize = TextFieldAutoSize.CENTER
			playButton.addChild(playText);
			
			addChild(playButton);
			playButton.x = 255;
			playButton.y = 250;
			
			var instructionsText:TextField = new TextField();
			instructionsText.defaultTextFormat = textFormat;
			instructionsText.embedFonts = true;
			instructionsText.antiAliasType = AntiAliasType.ADVANCED;
			instructionsText.text = "Instructions";
			instructionsText.selectable = false;
			instructionsText.autoSize = TextFieldAutoSize.CENTER
			instructionsButton.addChild(instructionsText);
			addChild(instructionsButton);
			instructionsButton.x = 260;
			instructionsButton.y = 300;
		}
		
		public function destroy():void
		{
			playButton.removeEventListener(MouseEvent.CLICK, levelSelectMenu);
			instructionsButton.removeEventListener(MouseEvent.CLICK, instructionsMenu);
			TweenMax.to(this, .5, { alpha:0, onComplete:Main(parent).removeChild, onCompleteParams:[this] } );
		}
		
		public function launch():void
		{
		
		}
	}

}