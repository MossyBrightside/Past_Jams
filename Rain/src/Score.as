package
{
	import flash.events.Event;
	
	import flash.display.Sprite;
	
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.AntiAliasType;
	import flash.text.TextFieldAutoSize;
	
	import com.greensock.TweenMax;
	
	/**
	 * ...
	 * @author ...
	 */
	public class Score extends Sprite
	{
		[Embed(source="../lib/alphbeta.ttf",fontName="gameFont",mimeType="application/x-font",fontWeight="normal",fontStyle="normal",advancedAntiAliasing="true",embedAsCFF="false")]
		private var font:Class;
		private var scoreFont:Font = new font();
		private var textFormat:TextFormat = new TextFormat();
		
		private var scoreIncrease:int = 0;
		private var scoreText:TextField = new TextField();
		private var color:int = 0;
		
		public function Score(increase:int,xPos:int,yPos:int,scoreColor:int):void
		{
			if (stage)
				init();
			else
			{
				addEventListener(Event.ADDED_TO_STAGE, init);
				scoreIncrease = increase;
				x = xPos;
				y = yPos;
				color = scoreColor;
			}
		}
		
		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			textFormat.color = color;
			textFormat.font = scoreFont.fontName;
			textFormat.size = 25;
			
			scoreText.defaultTextFormat = textFormat;
			scoreText.embedFonts = true;
			scoreText.autoSize =  TextFieldAutoSize.CENTER;
			scoreText.antiAliasType = AntiAliasType.ADVANCED;
			
			addChild(scoreText);
			scoreText.text = scoreIncrease.toString();
			scoreText.selectable = false;
			x -= scoreText.width;
			y -= scoreText.height * .5;
			TweenMax.to(this, 1, { alpha:0, onComplete:destroy, tint:0xFFFFFF } );
		}
		public function changeColor():void
		{
			
		}
		private function destroy():void
		{
			parent.removeChild(this);
		}
	}
}