package
{
	import com.greensock.*;
	import com.greensock.easing.*;
	
	import bd.controls.KeyInput;
	import flash.display.MovieClip;
	import flash.events.Event;
	
	import flash.events.MouseEvent;
	
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.Font;
	
	public class Level extends MovieClip
	{
		public var score:int;
		public var multiplier:int;
		public var health:int;
		public var healthBar:HealthBarArt;
		public var sugarBar:SugarBarArt
		
		public var antPowerIcon:AntArt;
		public var antPowerText:GameText;
		
		public var scoreText:GameText;
		public var multiplierText:GameText;
		
		public var antPower:int = 1;
		public var sugarLevel:int = 0;
		
		public var projectileList:Array;
		public var pickupList:Array;
		
		public var player:Player;
		public var home:Home;
		
		public var projectileRate:Number;
		public var projectileRateIncrease:Number;
		public var itemRate:Number;
		
		public var holding:Boolean = false;
		public var heldItem:int;
		
		public var dir:int = 5;
		
		public var invincible:Boolean = false;
		
		public var maxPickups:int;
		
		public function Level()
		{
			if (stage)
				init();
			else
			{
				addEventListener(Event.ADDED_TO_STAGE, init);
				
			}
		}
		
		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			KeyInput.initialize(stage, this);
			KeyInput.addWASD();
			
			newGame();
			
			addEventListener(Event.ENTER_FRAME, gameEnterFrame);
			addEventListener(MouseEvent.CLICK, spawnItem);
		}
		
		private function newGame():void
		{
			stage.focus = this;
			player = new Player();
			home = new Home();
			projectileList = new Array();
			pickupList = new Array();
			
			scoreText = new GameText();
			multiplierText = new GameText();
			healthBar = new HealthBarArt();
			sugarBar = new SugarBarArt();
			
			addBackground(2);
			
			healthBar.x = 600;
			healthBar.y = 45;
			addChild(healthBar);
			healthBar.gotoAndStop(5);
			
			addChild(sugarBar);
			sugarBar.gotoAndStop(1);
			sugarBar.x = 230;
			sugarBar.y = 665;
			
			antPowerIcon = new AntArt();
			addChild(antPowerIcon);
			antPowerIcon.x = 65;
			antPowerIcon.y = 65;
			
			antPowerText = new GameText();
			antPowerText.text = "x" + antPower.toString();
			antPowerText.x = 95;
			antPowerText.y = 55;
			addChild(antPowerText);
			
			addChild(home);
			addChild(player);
			
			
			projectileRateIncrease = multiplier * .5;
			
			score = 0;
			multiplier = 1;
			health = 3;
			maxPickups = 4;
			
			multiplierText.x = 650;
			multiplierText.y = 670;
			multiplierText.text = "x1";
			addChild(multiplierText);
			
			scoreText.x = 35;
			scoreText.y = 670;
			scoreText.text = "0";
			addChild(scoreText);
			
			projectileRate = 0;
			itemRate = 0;
		
		}
		
		private function addBackground(backroundNum:int):void
		{
			var background:MovieClip = new Background1();
			background.gotoAndStop(backroundNum);
			addChild(background);
		}
		
		private function gameEnterFrame(e:Event):void
		{
			var speed:int = 5; //Pixels moved per frame
			var count:int = 0; //Key down count
			
			projectileRate = (projectileRate + 1)+projectileRateIncrease;
			if (projectileRate >= 60)
			{
				projectileRate = 0;
				var item:MovieClip = new Projectile(1);
				this.addChild(item);
				projectileList.push(item);
			}
			trace(projectileRateIncrease);
			itemRate += 1;
			if (itemRate >= 130)
			{
				itemRate = 0;
				var item2:MovieClip = new Pickup();
				this.addChild(item2);
				pickupList.push(item2);
			}
			
			for each (var bool:Boolean in KeyInput.keys)
				if (bool == true)
					count++;
			
			if (count >= 4)
				speed = speed *= .8;
			
			if (KeyInput.keys.W)
			{
				TweenMax.to(player, .2, {rotation: 0});
				if (player.y - speed > 35)
					player.y -= speed;
			}
			
			if (KeyInput.keys.D)
			{
				TweenMax.to(player, .2, {rotation: 90});
				if (player.x + speed < 710)
					player.x += speed;
			}
			
			if (KeyInput.keys.S)
			{
				TweenMax.to(player, .2, {rotation: 180});
				if (player.y + speed < 710)
					player.y += speed;
				
			}
			
			if (KeyInput.keys.A)
			{
				TweenMax.set(player, {rotation: 270});
				if (player.x - speed > 35)
					player.x -= speed;
			}
			
			for (var i:int = 0; i < projectileList.length; i++)
			{
				if (player.circle.hitTestObject(projectileList[i]))
				{
					projectileList[i].destroy();
					this.removeChild(projectileList[i]);
					
					if (invincible == false)
					{
						TweenMax.to(player, .2, {alpha: .5, onComplete: returnOpacity});
						invincible = true;
						multiplier = 1;
						projectileRateIncrease = multiplier * .5;
						health -= 1;
						healthBar.gotoAndStop(health);
					}
				}
			}
			
			for (var u:int = 0; u < pickupList.length; u++)
			{
				if (player.circle.hitTestObject(pickupList[u]))
				{
					if (holding == false && pickupList[u].antPowerNeeded <= antPower)
					{
						holding = true;
						heldItem = u;
					}
					else
					{
						addChild(player);
						for (var z:int = 0; z < pickupList.length; z++)
						{
							if (pickupList[z].antPowerNeeded <= antPower)
								addChild(pickupList[z]);
						}
					}
				}
			}
			
			if (holding == true)
			{
				if (player.circle.hitTestObject(home.circle))
				{
					var tempItem:MovieClip = pickupList[heldItem];
					
					pickupList.removeAt(heldItem);
					TweenMax.to(tempItem, 1, {x: 375, y: 375, scaleX: 0, scaleY: 0, onComplete: destroyPickup, onCompleteParams: [tempItem]});
					
					heldItem = 0;
					if (tempItem.sugarNum != 0)
					{
						sugarLevel += tempItem.sugarNum;
						if (sugarLevel >= 3)
						{
							sugarLevel = 0;
							antPower++;
							newAnt();
							antPowerText.text = "x" + antPower.toString();
						}
						
						sugarBar.gotoAndStop(sugarLevel + 1);
					}
					
					updateScore(tempItem.score);
					updateMultiplier(tempItem.multiplier);
					holding = false;
				}
				else
				{
					pickupList[heldItem].x = player.x;
					pickupList[heldItem].y = player.y;
				}
			}
		}
		
		private function returnOpacity():void
		{
			TweenMax.to(player, 2.5, {alpha: 1, onComplete: returnNormal});
		}
		
		private function returnNormal():void
		{
			invincible = false;
		}
		
		private function updateScore(change:int):void
		{
			score += change * multiplier;
			scoreText.text = score.toString();
		}
		
		private function updateMultiplier(change:int):void
		{
			multiplier += change;
			multiplierText.text = "x" + multiplier.toString();
			projectileRateIncrease = multiplier * .5;
		}
		
		private function destroyPickup(item:MovieClip):void
		{
			this.removeChild(item);
		}
		
		
		private function newAnt():void
		{
			var tempAnt:AntArt = new AntArt();
			addChild(tempAnt);
			tempAnt.x = 375;
			tempAnt.rotation = 180;
			TweenMax.to(tempAnt,2, {y:375,onComplete:newAnt2,onCompleteParams:[tempAnt]});
		}
		
		private function newAnt2(tempAnt:AntArt):void
		{
			TweenMax.to(tempAnt, .2, {scaleX:0, scaleY:0,onComplete:newAnt3,onCompleteParams:[tempAnt]});
		}
		
		private function newAnt3(tempAnt:AntArt):void
		{
			removeChild(tempAnt);
		}
		
		private function spawnItem(e:MouseEvent):void
		{
				
		}
	}
}