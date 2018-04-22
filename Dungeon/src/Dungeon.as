package
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.TimerEvent;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	import flash.geom.Rectangle;
	import flash.geom.Point;
	
	import com.greensock.TweenMax;
	
	public class Dungeon extends Sprite
	{
		private var tilegroupArray:Array;
		public var levelData:Object = new Object();
		
		private var hero:Hero = new Hero();
		private var speed:int = 0;
		
		private var staticLayer:Bitmap;
		private var animatedLayer:Sprite = new Sprite();
		public var compoundLayer:Bitmap = new Bitmap(new BitmapData(525, 525));
		
		private var keyObject:Object = new Object();
		private var keyHolder:Object;
		
		private var p1:Point = new Point(0, 0);
		private var p2:Point = new Point(0, 0);
		private var selected:Boolean = false;
		
		private var levelPrompt:LevelPrompt;
		private var promptOpen:Boolean = true;
		
		private var pause:Boolean = true;
		private var rotating:Boolean = false;
		
		private var blackout:Bitmap = Library.blackout;
		
		private var exit:Exit;
		private var spaceControl:Boolean = false;
		
		private var quitControl:Boolean = false;
		
		private var lP:Point = new Point(0, 0);
		
		public function Dungeon(l:int):void
		{
			if (stage)
				init();
			else
			{
				addEventListener(Event.ADDED_TO_STAGE, init);
				
				levelData = cloneData(Library.jsonData[l]);
				Library.currentLevel = l;
			}
		}
		
		private function cloneData(p:Object):Object
		{
			var o:ByteArray = new ByteArray();
			o.writeObject(p);
			o.position = 0;
			return (o.readObject());
		}
		
		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			generateTiles();
			generateTilegroups();
			
			levelPrompt = new LevelPrompt(levelData.id, levelData.title, levelData.description);
			addChild(levelPrompt);
			
			stage.addEventListener(Event.ENTER_FRAME, drawGame);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keysDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, keysUp);
			
			this.focusRect = false;
			stage.focus = this;
		
		}
		
		private function generateTiles():void
		{
			staticLayer = new Bitmap(new BitmapData(525, 525));
			
			var tileRect:Rectangle = new Rectangle();
			var tilePoint:Point = new Point();
			
			for (var i:int = 0; i < 15; i++)
			{
				for (var e:int = 0; e < 15; e++)
				{
					tilePoint.setTo(32 * e, 32 * i);
					tileRect = new Rectangle(levelData.tiles[i][e] * 32, 0, 32, 32);
					
					staticLayer.bitmapData.copyPixels(Library.tiles.bitmapData, tileRect, tilePoint);
				}
			}
			addChild(animatedLayer);
			animatedLayer.x = 525 + 22;
			animatedLayer.y = 22;
			addChild(compoundLayer);
			compoundLayer.x = 525 + 22;
			compoundLayer.y = 22;
			
			hero.x = levelData.sp[0] * 32 + 16;
			hero.y = levelData.sp[1] * 32 + 16;
			animatedLayer.addChild(hero);
		}
		
		private function generateTilegroups():void
		{
			tilegroupArray = new Array();
			
			var tile:TileGroup;
			var tiles:Array;
			var tempArray:Array;
			
			var tileBitmap:BitmapData = new BitmapData(96, 96);
			
			var tileRect:Rectangle = new Rectangle();
			
			exit = new Exit();
			
			for (var i:int = 0; i < 5; i++)
			{
				
				tempArray = new Array();
				for (var e:int = 0; e < 5; e++)
				{
					tiles = new Array();
					tileBitmap = new BitmapData(96, 96);
					tileRect = new Rectangle(96 * e, 96 * i, 96, 96);
					
					tileBitmap.copyPixels(staticLayer.bitmapData, tileRect, new Point(0, 0));
					
					for (var u:int = 0; u < 3; u++)
					{
						tiles.push(new Array());
						for (var o:int = 0; o < 3; o++)
						{
							tiles[u][o] = levelData.tiles[(i * 3) + u][(e * 3) + o];
						}
					}
					
					tile = new TileGroup(tileBitmap, new Point(e, i), tiles);
					addChild(tile);
					tile.x = e * 96 + (7.5 * e) + 7.5;
					tile.y = i * 96 + (7.5 * i) + 7.5;
					tempArray.push(tile);
				}
				tilegroupArray.push(tempArray);
			}
			exit.x = (levelData.exit[0] * 32) + (525 + 22);
			exit.y = (levelData.exit[1] * 32) + (22);
			addChild(exit);
		}
		
		private function keysDown(e:KeyboardEvent):void
		{
			
			switch (e.keyCode)
			{
				case 32: 
					if (rotating == false && spaceControl == false)
					{
						rotateTile();
					}
					keyObject.spaceDown = true;
					spaceControl = true;
					break;
			}
			
			switch (e.keyCode)
			{
				case 65: //LEFT
					keyObject.leftDown = true;
					break;
				case 87: //UP
					keyObject.upDown = true;
					break;
				case 68: //RIGHT
					keyObject.rightDown = true;
					break;
				case 83: //DOWN
					keyObject.downDown = true;
					break;
				case 77: //M
					if (quitControl == false)
					{
						quitControl = true;
						addChild(blackout);
						blackout.alpha = 0;
						TweenMax.to(blackout, .5, {alpha: 1, onComplete: endGame, onCompleteParams: [1]});
					}
					break;
				case 82: // R
					if (quitControl == false)
					{
						quitControl = true;
						addChild(blackout);
						blackout.alpha = 0;
						TweenMax.to(blackout, .5, {alpha: 1, onComplete: endGame, onCompleteParams: [2]});
					}
			
			}
		
		}
		
		private function keysUp(e:KeyboardEvent):void
		{
			switch (e.keyCode)
			{
				case 32: // SPACE
					keyObject.spaceDown = false;
					spaceControl = false;
					break;
			}
			
			switch (e.keyCode)
			{
				case 65: //LEFT
					keyObject.leftDown = false;
					break;
				case 87: //UP
					keyObject.upDown = false;
					break;
				case 68: //RIGHT
					keyObject.rightDown = false;
					break;
				case 83: //DOWN
					keyObject.downDown = false;
					break;
			}
		}
		
		private function drawGame(e:Event):void
		{
			speed = 5;
			var count:int = 0;
			
			var pPos:Point = getPosition(hero.x, hero.y);
			
			if (hero.hitTestObject(exit))
			{
				if (pause == false)
				{
					levelComplete();
				}
				pause = true;
			}
			
			for each (var bool:Boolean in keyObject)
				if (bool == true)
					count++;
			
			if (count >= 2)
				speed = speed *= .8;
			
			if (keyObject.spaceDown == true)
			{
				if (promptOpen == true)
				{
					promptOpen = false;
					removeChild(levelPrompt);
					levelPrompt.destroy();
					levelPrompt = null;
					pause = false;
					
					this.focusRect = false;
					stage.focus = this;
					
					stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
					stage.addEventListener(MouseEvent.MOUSE_UP, mouseUp);
				}
			}
			
			if (pause == false)
			{
				if (keyObject.leftDown == true)
				{
					if (checkTile(-1, 0) != true)
						hero.x -= speed;
				}
				
				if (keyObject.rightDown == true)
				{
					if (checkTile(1, 0) != true)
						hero.x += speed;
				}
				
				if (keyObject.upDown == true)
				{
					if (checkTile(-1, 1) != true)
						hero.y -= speed;
				}
				
				if (keyObject.downDown == true)
				{
					if (checkTile(1, 1) != true)
						hero.y += speed;
				}
				
				testSafePoint();
				compoundLayer.bitmapData.draw(staticLayer.bitmapData);
				compoundLayer.bitmapData.draw(animatedLayer);
				drawTiles();
			}
		
		}
		
		private function testSafePoint():void
		{
			if (levelData.tiles[Math.floor(hero.y / 32)][Math.floor(hero.x / 32)] == 0)
				lP.setTo((Math.floor(hero.x / 32) * 32) + 16, (Math.floor(hero.y / 32) * 32) + 16);
		}
		
		private function checkTile(n:int, dir:int):Boolean
		{
			var c:Boolean = false; // COLLIDING
			var p:Array = getCorners(); //Player Corners
			var t:Array = new Array(new Point(0, 0), new Point(0, 0));
			var d:Boolean = false;
			var v:int = 0;
			if (dir == 0)
			{
				if (n == 1)
				{
					for (var e:int = 0; e < 2; e++)
					{
						t.x = (Math.floor(p[e][1].x / 32));
						t.y = (Math.floor(p[e][1].y / 32));
						
						if (t.x + 1 > 14)
						{
							v = 1;
						}
						else
							v = levelData.tiles[t.y][t.x + 1]
						
						if (v == 1)
						{
							t.x = (t.x + 1) * 32;
							t.y = (t.y) * 32;
							if (p[e][1].x + speed >= t.x)
							{
								hero.x += t.x - p[e][1].x - .5;
								c = true;
								break;
							}
						}
					}
				}
				else if (n == -1)
				{
					for (var i:int = 0; i < 2; i++)
					{
						t.x = (Math.floor(p[i][0].x / 32));
						t.y = (Math.floor(p[i][0].y / 32));
						
						if (t.x - 1 < 0)
						{
							v = 1;
						}
						else
							v = levelData.tiles[t.y][t.x - 1]
						
						if (v == 1)
						{
							t.x = (t.x) * 32;
							t.y = (t.y) * 32;
							if (p[i][0].x - speed <= t.x)
							{
								hero.x -= p[i][0].x - t.x;
								c = true;
								break;
							}
						}
					}
				}
			}
			else if (dir == 1)
			{
				if (n == 1)
				{
					for (var u:int = 0; u < 2; u++)
					{
						t.x = (Math.floor(p[1][u].x / 32));
						t.y = (Math.floor(p[1][u].y / 32));
						
						if (t.y + 1 > 14)
						{
							v = 1;
						}
						else
							v = levelData.tiles[t.y + 1][t.x]
						
						if (v == 1)
						{
							t.x = (t.x) * 32;
							t.y = (t.y + 1) * 32;
							if (p[1][u].y + speed >= t.y)
							{
								hero.y += t.y - p[1][u].y - .5;
								c = true;
								break;
							}
						}
					}
				}
				else if (n == -1)
				{
					for (var q:int = 0; q < 2; q++)
					{
						t.x = (Math.floor(p[0][q].x / 32));
						t.y = (Math.floor(p[0][q].y / 32));
						
						if (t.y - 1 < 0)
						{
							v = 1;
						}
						else
							v = levelData.tiles[t.y - 1][t.x]
						
						if (v == 1)
						{
							t.x = (t.x) * 32;
							t.y = (t.y) * 32;
							if (p[0][q].y - speed <= t.y)
							{
								hero.y -= p[0][q].y - t.y;
								c = true;
								break;
							}
						}
					}
				}
			}
			return c;
		}
		
		private function getCorners():Array
		{
			var corners:Array = new Array([[], []], [[], []]);
			corners[0][0] = new Point(hero.x - 12, hero.y - 12);
			corners[0][1] = new Point(hero.x + 12, hero.y - 12);
			corners[1][0] = new Point(hero.x - 12, hero.y + 12);
			corners[1][1] = new Point(hero.x + 12, hero.y + 12);
			return corners;
		}
		
		private function checkCorners():void
		{
			var c:Boolean = false;
			corners: 
			{
				if (hero.x - 12 < 0 || hero.x + 12 > 480)
				{
					center();
					break corners;
				}
				else if (hero.y - 12 < 0 || hero.y + 12 > 480)
				{
					center();
					break corners;
				}
				
				if (levelData.tiles[Math.floor((hero.y - 12) / 32)][Math.floor((hero.x - 12) / 32)] == 1)
					c = true;
				if (levelData.tiles[Math.floor((hero.y - 12) / 32)][Math.floor((hero.x + 12) / 32)] == 1)
					c = true;
				if (levelData.tiles[Math.floor((hero.y + 12) / 32)][Math.floor((hero.x - 12) / 32)] == 1)
					c = true;
				if (levelData.tiles[Math.floor((hero.y + 12) / 32)][Math.floor((hero.x + 12) / 32)] == 1)
					c = true;
				
				if (c == true)
					center();
			}
		}
		
		private function center():void
		{
			rotating = true;
			TweenMax.to(hero, .15, {x: lP.x, y: lP.y, onComplete: centerComplete});
		}
		
		private function centerComplete():void
		{
			pause = false;
			rotating = false;
		}
		
		private function resetKeys():void
		{
			keyHolder = keyObject;
			keyObject.spaceDown = false;
			keyObject.leftDown = false;
			keyObject.upDown = false;
			keyObject.rightDown = false;
			keyObject.downDown = false;
		}
		
		private function getPosition(dx:int, dy:int):Point
		{
			var returnPoint:Point = new Point();
			returnPoint.x = Math.floor(dx / 32);
			returnPoint.y = Math.floor(dy / 32);
			return returnPoint;
		}
		
		private function drawTiles():void
		{
			for (var i:int = 0; i < 5; i++)
			{
				for (var e:int = 0; e < 5; e++)
				{
					tilegroupArray[i][e].redraw();
				}
			}
		}
		
		private function mouseDown(e:MouseEvent):void
		{
			var v:Point = new Point(0, 0);
			v.x = Math.floor(Math.floor(stage.mouseX - (Math.floor(stage.mouseX / 96) * 7.5)) / 96);
			v.y = Math.floor(Math.floor(stage.mouseY - (Math.floor(stage.mouseY / 96) * 7.5)) / 96);
			
			var p:Point = new Point(0, 0);
			p.x = Math.floor(Math.floor(hero.x - (Math.floor(hero.x / 96))) / 96);
			p.y = Math.floor(Math.floor(hero.y - (Math.floor(hero.y / 96))) / 96);
			
			if (p.x == v.x && p.y == v.y)
			{
				selected = false;
				p1 = new Point(0, 0);
				p2 = new Point(0, 0);
			}
			else
			{
				if (tilegroupArray[v.y][v.x] != undefined && tilegroupArray[v.y][v.x].lock == 0)
				{
					if (selected == false)
					{
						p1.x = v.x;
						p1.y = v.y;
						
						selected = true;
						this.setChildIndex(tilegroupArray[p1.y][p1.x], this.numChildren - 1);
						tilegroupArray[v.y][v.x].startDrag();
						tilegroupArray[v.y][v.x].alpha = .25;
					}
				}
			}
		
		}
		
		private function mouseUp(e:MouseEvent):void
		{
			
			var v:Point = new Point(0, 0);
			v.x = Math.floor(Math.floor(stage.mouseX - (Math.floor(stage.mouseX / 96) * 7.5)) / 96);
			v.y = Math.floor(Math.floor(stage.mouseY - (Math.floor(stage.mouseY / 96) * 7.5)) / 96);
			
			var p:Point = new Point(0, 0);
			p.x = Math.floor(Math.floor(hero.x - (Math.floor(hero.x / 96))) / 96);
			p.y = Math.floor(Math.floor(hero.y - (Math.floor(hero.y / 96))) / 96);
			
			checks: 
			{
				if (v.x < 0 || v.x > 4)
				{
					resetTile();
					break checks;
				}
				else if (v.y < 0 || v.y > 4)
				{
					resetTile();
					break checks;
				}
				else if (p.x == v.x && p.y == v.y)
					resetTile();
				else if (p.x == p1.x && p.y == p1.y)
					resetTile();
				else if (tilegroupArray[v.y][v.x].lock == 1)
					resetTile();
				else
				{
					if (tilegroupArray[v.y][v.x] != undefined)
					{
						if (selected == true)
						{
							p2.x = v.x;
							p2.y = v.y;
							selected = false;
							swapTiles();
						}
					}
					else
					{
						resetTile();
					}
					
				}
			}
		
		}
		
		private function resetTile():void
		{
			selected = false;
			tilegroupArray[p1.y][p1.x].stopDrag();
			tilegroupArray[p1.y][p1.x].alpha = 1;
			TweenMax.to(tilegroupArray[p1.y][p1.x], .5, {x: p1.x * 96 + (7.5 * p1.x) + 7.5, y: p1.y * 96 + (7.5 * p1.y) + 7.5});
			p1 = new Point(0, 0);
			p2 = new Point(0, 0);
		}
		
		private function swapTiles():void
		{
			var t:TileGroup = tilegroupArray[p1.y][p1.x];
			var t2:TileGroup = tilegroupArray[p2.y][p2.x];
			var b:BitmapData = new BitmapData(96, 96);
			var p:Point = new Point(0, 0);
			
			tilegroupArray[p1.y][p1.x].stopDrag();
			tilegroupArray[p1.y][p1.x].alpha = 1;
			
			for (var i:int = 0; i < 3; i++)
			{
				for (var e:int = 0; e < 3; e++)
				{
					levelData.tiles[(p1.y * 3) + i][(p1.x * 3) + e] = t2.tiles[i][e];
					levelData.tiles[(p2.y * 3) + i][(p2.x * 3) + e] = t.tiles[i][e];
				}
			}
			
			b.copyPixels(staticLayer.bitmapData, new Rectangle(p1.x * 96, p1.y * 96, 96, 96), new Point(0, 0));
			staticLayer.bitmapData.copyPixels(staticLayer.bitmapData, new Rectangle(p2.x * 96, p2.y * 96, 96, 96), new Point(p1.x * 96, p1.y * 96));
			staticLayer.bitmapData.copyPixels(b, new Rectangle(0, 0, 96, 96), new Point(p2.x * 96, p2.y * 96));
			
			p = t.position;
			t.position = t2.position;
			t2.position = p;
			
			tilegroupArray[p1.y][p1.x] = tilegroupArray[p2.y][p2.x];
			tilegroupArray[p2.y][p2.x] = t;
			
			var vX:int = Math.floor(stage.mouseX - (Math.floor(stage.mouseX / 96) * 7.5)) / 96;
			var vY:int = Math.floor(stage.mouseY - (Math.floor(stage.mouseY / 96) * 7.5)) / 96;
			
			TweenMax.to(tilegroupArray[p1.y][p1.x], .3, {x: (p1.x * 7.5 + (p1.x * 96)) + 7.5, y: (p1.y * 7.5 + (p1.y * 96)) + 7.5});
			this.setChildIndex(tilegroupArray[p1.y][p1.x], this.numChildren - 1);
			
			TweenMax.to(tilegroupArray[p2.y][p2.x], .3, {x: (p2.x * 7.5 + (p2.x * 96)) + 7.5, y: (p2.y * 7.5 + (p2.y * 96)) + 7.5});
			this.setChildIndex(tilegroupArray[p2.y][p2.x], this.numChildren - 1);
			
			p1 = new Point();
			p2 = new Point();
			checkCorners();
		}
		
		private function rotateTile():void
		{
			var p:Point = new Point(0, 0);
			p.x = Math.floor(Math.round(hero.x - (Math.round(hero.x / 96))) / 96);
			p.y = Math.floor(Math.round(hero.y - (Math.round(hero.y / 96))) / 96);
			
			var t:TileGroup = tilegroupArray[p.y][p.x];
			
			if (p.x == p1.x && p.y == p1.y)
			{
				
			}
			else
			{
				if (t.lock == false)
				{
					centerRotate(t);
						//TweenMax.to(hero, .15, {x: (Math.floor(hero.x / 32) * 32) + 16, y: (Math.floor(hero.y / 32) * 32) + 16, onComplete: centerRotate, onCompleteParams: [t]});
				}
			}
		
		}
		
		private function centerRotate(t:TileGroup):void
		{
			pause = true;
			rotating = true;
			TweenMax.to(t, 1, {rotation: t.rotation + 90, x: t.x + 96, onComplete: rotationComplete, onCompleteParams: [t]});
		}
		
		private function rotationComplete(t:TileGroup):void
		{
			var d:Array = new Array();
			var b:Bitmap = new Bitmap(new BitmapData(96, 96));
			var g:Point = new Point(0, 0);
			g.x = ((t.position.x * 96) + 48) - hero.x;
			g.y = ((t.position.y * 96) + 48) - hero.y;
			
			hero.x = ((t.position.x * 96) + 48) + g.y;
			hero.y = ((t.position.y * 96) + 48) + (g.x * -1);
			
			for (var i:int = 0; i < 3; i++)
			{
				var a:Array = new Array();
				for (var e:int = 2; e >= 0; e--)
				{
					
					a.push(t.tiles[e][i]);
				}
				d.push(a);
			}
			
			t.tiles = d;
			for (var u:int = 0; u < 3; u++)
			{
				for (var s:int = 0; s < 3; s++)
				{
					b.bitmapData.copyPixels(Library.tiles.bitmapData, new Rectangle(d[u][s] * 32, 0, 32, 32), new Point(s * 32, u * 32));
					levelData.tiles[(t.position.y * 3) + u][(t.position.x * 3) + s] = t.tiles[u][s];
				}
			}
			staticLayer.bitmapData.copyPixels(b.bitmapData, new Rectangle(0, 0, 96, 96), new Point(t.position.x * 96, t.position.y * 96));
			t.maskSource.bitmapData = b.bitmapData;
			
			t.rotation -= 90;
			t.x -= 96;
			
			compoundLayer.bitmapData.draw(staticLayer.bitmapData);
			compoundLayer.bitmapData.draw(animatedLayer);
			t.redraw();
			testSafePoint();
			pause = false;
			rotating = false;
			checkCorners();
		}
		
		public function levelComplete():void
		{
			Library.gameSave.data.highestLevel = levelData.id
			addChild(blackout);
			blackout.alpha = 0;
			TweenMax.to(blackout, .5, {alpha: 1, onComplete: endGame, onCompleteParams: [0]});
		}
		
		public function endGame(choice:int):void
		{
			stage.removeEventListener(Event.ENTER_FRAME, drawGame);
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, keysDown);
			stage.removeEventListener(KeyboardEvent.KEY_UP, keysUp);
			stage.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
			stage.removeEventListener(MouseEvent.RIGHT_CLICK, endGame);
			
			removeChild(blackout);
			blackout = null;
			removeChild(compoundLayer);
			compoundLayer = null;
			removeChild(animatedLayer);
			animatedLayer = null;
			removeChild(exit);
			exit = null;
			
			for (var i:int = 0; i < 5; i++)
			{
				for (var u:int = 0; u < 5; u++)
				{
					removeChild(tilegroupArray[i][u]);
					tilegroupArray[i][u] = null;
				}
			}
			switch (choice)
			{
				case 0: 
					Main(parent).endLevel();
					break;
				case 1: 
					Main(parent).returnToMenu();
					break;
				case 2: 
					Main(parent).resetLevel();
					break;
			}
		
		}
	
	}
}