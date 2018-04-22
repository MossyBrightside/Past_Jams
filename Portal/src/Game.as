package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.EventDispatcher;
	import flash.text.TextField;
	
	import com.greensock.*;
	import com.greensock.easing.*;
	
	import skyboy.serialization.JSON;
	
	public class Game extends Sprite
	{
		[Embed(source="../lib/Tileset.png")]
		private var tilesetImport:Class;
		private var tileset:Bitmap = new tilesetImport();
		
		private var levelDesign:Bitmap = new Bitmap();
		private var player:Player = new Player();
		private var selector:Sprite = new Sprite();
		
		public var levelData:Object = new Object();
		
		private var levelPrompt:LevelPrompt;
		
		private var pT:Point = new Point(0, 0); // Projected Tile
		private var pD:Point = new Point(1, 0); //Player Direction
		private var pC:Point = new Point(2, 7); //Player Coordinates
		private var pV:Point = new Point(1, 0); //Player Velocity
		private var fC:Point = new Point(0, 0); //Final Coordinates
		private var p1:Vector.<Point> = new Vector.<Point>(2, true); //Portal 1 [0] = COORDINATES [0] = EXIT VELOCITY
		private var p2:Vector.<Point> = new Vector.<Point>(2, true); //Portal 2 [0] = COORDINATES [0] = EXIT VELOCITY
		
		private var started:Boolean = false;
		private var index:int = 0;
		private var paused:Boolean = false;
		
		private var pauseMenu:PauseMenu;
		
		public function Game(levelIndex:int):void
		{
			if (stage)
				init();
			else
			{
				addEventListener(Event.ADDED_TO_STAGE, init);
				index = levelIndex;
			}
		}
		
		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			levelData = Main(parent).jsonData[index];
			alpha = 0;
			TweenMax.to(this, .5, {alpha: 1});
			generate();
			levelPrompt = new LevelPrompt();
			addChild(levelPrompt);
			stage.addEventListener(KeyboardEvent.KEY_UP, startGame);
			stage.focus = this;
		
		}
		
		private function startGame(e:KeyboardEvent):void
		{
			switch (e.keyCode)
			{
				case 32:
					
					if (levelPrompt)
					{
						TweenMax.to(levelPrompt, .5, {alpha: 0, onComplete: removeChild, onCompleteParams: [levelPrompt]});
					}
					levelPrompt = null;
					findPath();
					stage.addEventListener(Event.ENTER_FRAME, gameEnterFrame);
					stage.addEventListener(KeyboardEvent.KEY_DOWN, turnPlayer);
					stage.addEventListener(KeyboardEvent.KEY_UP, shootPortal);
					stage.removeEventListener(KeyboardEvent.KEY_UP, startGame);
					break;
			}
		}
		
		private function changeCoordinates(cX:int, cY:int):void
		{
			pC.x = cX;
			pC.y = cY;
			player.x = cX * 32;
			player.y = cY * 32;
		}
		
		private function changeVelocity(vX:int, vY:int):void
		{
			pV.x = vX;
			pV.y = vY;
		}
		
		private function generate():void
		{
			var levelBitmap:BitmapData = new BitmapData(608, 512, false);
			var instructionText:TextField = new TextField();
			instructionText.textColor = 0xFFFFFF;
			instructionText.text = "Space to start, space to continue, p to pause, arrow keys to look around, z/x to shoot portals";
			instructionText.selectable = false;
			instructionText.width = 500;
			instructionText.y = 490;
			
			changeCoordinates(levelData.sP[0], levelData.sP[1]);
			changeVelocity(levelData.sV[0], levelData.sV[1]);
			
			var tileRect:Rectangle = new Rectangle();
			var tilePoint:Point = new Point();
			var t:int;
			
			p1[0] = new Point();
			p1[1] = new Point();
			p2[0] = new Point();
			p2[1] = new Point();
			
			selector.graphics.lineStyle(3, 0xFF0000, 1);
			selector.graphics.drawRect(0, 0, 32, 32);
			selector.graphics.lineStyle(3, 0xFFFFFF, 1);
			selector.graphics.drawRect(3, 3, 27, 27);
			selector.alpha = 0;
			
			for (var i:int = 0; i < 16; i++)
			{
				for (var u:int = 0; u < 19; u++)
				{
					t = levelData.tiles[i][u];
					
					if (t == 3 || t == 4)
					{
						t = 1;
						levelData.tiles[i][u] = t;
					}
					tilePoint.setTo(u * 32, i * 32);
					tileRect = new Rectangle((t - Math.floor(t / 5) * 5) * 32, Math.floor(t / 5) * 32, 32, 32);
					levelBitmap.copyPixels(tileset.bitmapData, tileRect, tilePoint);
				}
			}
			
			levelDesign = new Bitmap(levelBitmap);
			addChild(levelDesign);
			addChild(player);
			addChild(selector);
			//addChild(instructionText);
		}
		
		private function findPath():void
		{
			var l:Number;
			var t:int;
			var d:Number;
			var p:int;
			
			if (pV.x != 0)
			{
				l = pV.x < 0 ? (pC.x * pV.x) - 1 : 18 - pC.x + 1;
				d = Math.abs(l) * .5;
				for (var i:int = 1; i < Math.abs(l); i++)
				{
					if (levelData.tiles[pC.y][(pC.x) + i * pV.x] != 0)
					{
						t = levelData.tiles[pC.y][(pC.x) + i * pV.x];
						p = (pC.x) + i * pV.x;
						d = p > pC.x ? (p - pC.x) * .5 : (pC.x - p) * .5;
						commute((pC.x) + i * pV.x, pC.y, t, d);
						break;
					}
				}
			}
			else
			{
				l = pV.y < 0 ? (pC.y * pV.y) - 1 : 15 - pC.y + 1;
				for (var e:int = 1; e < Math.abs(l); e++)
				{
					if (levelData.tiles[(pC.y) + e * pV.y][pC.x] != 0)
					{
						p = (pC.y + e * pV.y);
						d = p > pC.y ? (p - pC.y) * .5 : (pC.y - p) * .5;
						t = levelData.tiles[(pC.y) + e * pV.y][pC.x];
						commute(pC.x, (pC.y) + e * pV.y, t, d);
						break;
					}
				}
			}
		}
		
		private function getTile():int
		{
			var l:int;
			var t:int;
			
			if (pD.x != 0)
			{
				l = pD.x < 0 ? (pC.x * pD.x) - 1 : 18 - pC.x + 1;
				for (var i:int = 0; i < Math.abs(l); i++)
				{
					if (levelData.tiles[pC.y][(pC.x) + i * pD.x] != 0)
					{
						
						t = levelData.tiles[pC.y][(pC.x) + i * pD.x];
						
						pT.x = (pC.x) + i * pD.x;
						pT.y = pC.y;
						break;
					}
				}
			}
			else
			{
				l = pD.y < 0 ? (pC.y * pD.y) - 1 : 15 - pC.y + 1;
				for (var e:int = 0; e < Math.abs(l); e++)
				{
					if (levelData.tiles[(pC.y) + e * pD.y][pC.x] != 0)
					{
						
						t = levelData.tiles[(pC.y) + e * pD.y][pC.x];
						
						pT.x = pC.x;
						pT.y = (pC.y) + e * pD.y;
						break;
					}
				}
			}
			return t;
		}
		
		private function gameEnterFrame(e:Event):void
		{
			if (paused == false)
			{
				pC.x = Math.floor(player.x / 32);
				pC.y = Math.floor(player.y / 32);
				selector.alpha = projectPortal();
			}
		
		}
		
		private function projectPortal():int
		{
			var alpha:int = 0;
			alpha = getTile();
			selector.x = pT.x * 32;
			selector.y = pT.y * 32;
			return alpha;
		}
		
		private function turnPlayer(e:KeyboardEvent):void
		{
			if (paused == false)
			{
				switch (e.keyCode)
				{
					case 37: //Left Key
						pD.x = -1;
						pD.y = 1;
						break;
					
					case 39: //Right Key
						pD.x = 1;
						pD.y = 0;
						break;
					
					case 38: //Up Key
						pD.x = 0;
						pD.y = -1;
						break;
					
					case 40: //Down Key
						pD.x = 0;
						pD.y = 1;
						break;
					case 80: //P KEY
						if (paused == false)
						{
							pauseMenu = new PauseMenu();
							addChild(pauseMenu);
							TweenMax.to(player, 0, {x: player.x, y: player.y});
							paused = true;
						}
						break;
				}
			}
			else
			{
				if (e.keyCode == 80)
				{
					pauseMenu.destroy();
					findPath();
					paused = false;
				}
			}
		}
		
		private function shootPortal(e:KeyboardEvent):void
		{
			// Z = 90
			// X = 88
			if (paused == false)
			{
				switch (e.keyCode)
				{
					case 90: // Z Key ---PORTAL 1
						leftPortal();
						break;
					
					case 88: // X Key ---PORTAL 2
						rightPortal();
						break;
				
				}
			}
		}
		
		private function leftPortal():void
		{
			var tileRect:Rectangle = new Rectangle();
			var tilePoint:Point = new Point();
			if (getTile() == 1)
			{
				if (p1[0] != null)
				{
					levelData.tiles[p1[0].y][p1[0].x] = 1;
					tilePoint.setTo(p1[0].x * 32, p1[0].y * 32);
					tileRect = new Rectangle(1 * 32, 0, 32, 32);
					levelDesign.bitmapData.copyPixels(tileset.bitmapData, tileRect, tilePoint);
				}
				
				tilePoint.setTo(pT.x * 32, pT.y * 32);
				tileRect = new Rectangle(3 * 32, 0, 32, 32);
				levelDesign.bitmapData.copyPixels(tileset.bitmapData, tileRect, tilePoint);
				
				p1[0].setTo(pT.x, pT.y);
				p1[1].x = Math.abs(pD.x) == 1 ? pD.x * -1 : 0;
				p1[1].y = Math.abs(pD.y) == 1 ? pD.y * -1 : 0;
				levelData.tiles[p1[0].y][p1[0].x] = 3;
				findPath();
			}
		}
		
		private function rightPortal():void
		{
			var tileRect:Rectangle = new Rectangle();
			var tilePoint:Point = new Point();
			if (getTile() == 1)
			{
				if (p2[0] != null)
				{
					levelData.tiles[p2[0].y][p2[0].x] = 1;
					tilePoint.setTo(p2[0].x * 32, p2[0].y * 32);
					tileRect = new Rectangle(1 * 32, 0, 32, 32);
					levelDesign.bitmapData.copyPixels(tileset.bitmapData, tileRect, tilePoint);
				}
				tilePoint.setTo(pT.x * 32, pT.y * 32);
				tileRect = new Rectangle(4 * 32, 0, 32, 32);
				levelDesign.bitmapData.copyPixels(tileset.bitmapData, tileRect, tilePoint);
				
				p2[0].setTo(pT.x, pT.y);
				p2[1].x = Math.abs(pD.x) == 1 ? pD.x * -1 : 0;
				p2[1].y = Math.abs(pD.y) == 1 ? pD.y * -1 : 0;
				levelData.tiles[p2[0].y][p2[0].x] = 4;
				findPath();
			}
		}
		
		private function commute(fX:int, fY:int, t:int, d:int):void
		{
			TweenMax.to(player, d, {x: fX * 32, y: fY * 32, ease: Linear.easeNone, onComplete: onCommute, onCompleteParams: [t]});
		}
		
		private function reset():void
		{
			removeChild(levelDesign);
			removeChild(selector);
			generate();
			destroy();
			stage.addEventListener(KeyboardEvent.KEY_UP, startGame);
			TweenMax.to(this, .6, {alpha: 1});
		}
		
		public function menuReturn():void
		{
			Main(parent).endGame();
		}
		
		public function destroy():void
		{
			
			stage.removeEventListener(Event.ENTER_FRAME, gameEnterFrame);
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, turnPlayer);
			stage.removeEventListener(KeyboardEvent.KEY_UP, shootPortal);
			stage.removeEventListener(MouseEvent.RIGHT_CLICK, rightPortal);
			stage.removeEventListener(KeyboardEvent.KEY_UP, startGame);
			TweenMax.to(this, .5, {alpha: 0, onComplete: Main(parent).removeChild, onCompleteParams: [this]});
		}
		
		public function onCommute(t:int):void
		{
			switch (t)
			{
				case 1: 
					TweenMax.to(this, .6, {alpha: 0, onComplete: reset});
					break;
				
				case 2: 
					destroy();
					if (Main(parent).levelCount >= levelData.id)
					{
						Main(parent).levelCount = levelData.id + 1;
					}
					Main(parent).newLevel();
					levelData = null;
					break;
				
				case 3: 
					if (p2[0].x == 0 && p2[0].y == 0)
					{
						TweenMax.to(this, .6, {alpha: 0, onComplete: reset});
					}
					else
					{
						changeVelocity(p2[1].x, p2[1].y);
						changeCoordinates(p2[0].x, p2[0].y);
						findPath();
					}
					
					break;
				case 4: 
					if (p1[0].x == 0 && p1[0].y == 0)
					{
						TweenMax.to(this, .6, {alpha: 0, onComplete: reset});
					}
					else
					{
						changeVelocity(p1[1].x, p1[1].y);
						changeCoordinates(p1[0].x, p1[0].y);
						findPath();
					}
					
					break;
				case 5: 
					pV.x = pV.x == 0 ? 0 : pV.x * -1;
					pV.y = pV.y == 0 ? 0 : pV.y * -1;
					findPath();
					break;
				case 6: 
					TweenMax.to(this, .6, {alpha: 0, onComplete: reset});
					break;
			
			}
		}
	}

}