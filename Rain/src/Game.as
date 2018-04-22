package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.AntiAliasType;
	import flash.text.TextFieldAutoSize;
	
	import org.flintparticles.common.counters.Blast;
	import org.flintparticles.common.particles.Particle;
	import org.flintparticles.twoD.emitters.Emitter2D;
	import org.flintparticles.twoD.renderers.BitmapRenderer;
	import org.flintparticles.common.initializers.ColorInit;
	import org.flintparticles.common.events.EmitterEvent;
	import org.flintparticles.common.events.ParticleEvent;
	
	import org.flashdevelop.utils.FlashConnect;
	
	import flash.filters.BlurFilter;
	import flash.filters.ColorMatrixFilter;
	
	import flash.geom.Rectangle;
	import flash.geom.Point;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.FocusEvent;
	import flash.display.Sprite;
	
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import com.greensock.TweenMax;
	import com.greensock.plugins.*;
	import com.greensock.easing.*;
	
	public class Game extends Sprite
	{
		[Embed(source = "../lib/alphbeta.ttf", fontName = "gameFont", mimeType = "application/x-font", fontWeight = "normal", fontStyle = "normal", advancedAntiAliasing = "true", embedAsCFF = "false")]
		private var font:Class;
		private var scoreFont:Font = new font();
		private var textFormat:TextFormat = new TextFormat();
		
		private var menuButton:MenuButton = new MenuButton();
		
		private var sunTimer:Timer = new Timer(2100);
		private var renderer:BitmapRenderer
		private var burstEmitter:Emitter2D;
		private var absorbEmitter:Emitter2D;
		private var nonAbsorbEmitter:Emitter2D;
		
		private var plantSteps:PlantSteps = new PlantSteps();
		
		public var scoreLayer:Sprite = new Sprite();
		public var score:int = 0;
		public var multi:int = 1;
		public var health:int = 50;
		public var dropVel:int = 1;
		
		private var multiText:TextField = new TextField();
		private var scoreText:TextField = new TextField();
		
		private var healthbar:HealthBar = new HealthBar();
		
		public var bulletArray:Array = new Array();
		public var poisonArray:Array = new Array();
		public var sunArray:Array = new Array();
		public var dropContainer:Sprite = new Sprite();
		public var dropChance:int = 100;
		
		public var paused:Boolean = false;
		private var gameBorder:GameBorder = new GameBorder();
		
		public function Game():void
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
			addChild(dropContainer);
			sunTimer.addEventListener(TimerEvent.TIMER, dropSun);
			sunTimer.start();
			
			stage.addEventListener(MouseEvent.RIGHT_CLICK, shootLight);
			
			stage.addEventListener(Event.ENTER_FRAME, gameEnterFrame);
			
			stage.addEventListener(Event.ACTIVATE, unpauseGame);
			stage.addEventListener(Event.DEACTIVATE, pauseGame);
			
			addRenderer();
			addChild(gameBorder);
			addChild(healthbar);
			addChild(plantSteps);
			addChild(scoreLayer);
			plantSteps.x = 250;
			plantSteps.y = 393;
			addButtons();
			addTexts();
			TweenPlugin.activate([FramePlugin]);
		}
		
		private function addButtons():void
		{
			menuButton.x = 387;
			menuButton.y = 552;
			addChild(menuButton);
			menuButton.addEventListener(MouseEvent.CLICK, clickMenu);
		}
		
		private function addTexts():void
		{
			textFormat.color = 0x000000;
			textFormat.font = scoreFont.fontName;
			textFormat.size = 45;
			
			multiText.defaultTextFormat = textFormat;
			multiText.embedFonts = true;
			multiText.antiAliasType = AntiAliasType.ADVANCED;
			
			addChild(multiText);
			multiText.x = 400;
			multiText.y = 476;
			multiText.text = "x1";
			multiText.selectable = false;
			
			scoreText.defaultTextFormat = textFormat;
			scoreText.embedFonts = true;
			scoreText.antiAliasType = AntiAliasType.ADVANCED;
			
			scoreText.autoSize = TextFieldAutoSize.LEFT
			scoreText.textColor = 0xFFFFFF;
			addChild(scoreText);
			scoreText.x = 45;
			scoreText.y = 545;
			scoreText.text = "0";
			scoreText.selectable = false;
		}
		
		private function addRenderer():void
		{
			renderer = new BitmapRenderer(new Rectangle(0, 0, 500, 600));
			burstEmitter = new ParticleBurst();
			absorbEmitter = new ParticleAbsorb();
			nonAbsorbEmitter = new NonAbsorb();
			
			renderer.addFilter(new BlurFilter(2, 2, 1));
			renderer.addFilter(new ColorMatrixFilter([1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0.97, 0]));
			renderer.addEmitter(burstEmitter);
			renderer.addEmitter(absorbEmitter);
			renderer.addEmitter(nonAbsorbEmitter);
			addChild(renderer);
			burstEmitter.addEventListener(ParticleEvent.PARTICLE_DEAD, absorb);
			absorbEmitter.addEventListener(ParticleEvent.PARTICLE_DEAD, updateHealth);
		}
		
		private function gameEnterFrame(e:Event):void
		{
			//trace(this.numChildren);
			for (var i:int = 0; i < bulletArray.length; i++)
			{
				for (var u:int = 0; u < poisonArray.length; u++)
				{
					if (Math.sqrt((Math.abs((poisonArray[u].x - bulletArray[i].x) ^ 2)) + Math.abs((poisonArray[u].y - bulletArray[i].y) ^ 2)) <= 8)
					{
						
						changeScore(250, poisonArray[u].x, poisonArray[u].y, 0x000000);
						changeMulti(1);
						nonAbsorbBurst(poisonArray[u].x, poisonArray[u].y, 0xFF000000, 5);
						bulletArray[i].returnLight();
						poisonArray[u].destroy();
					}
				}
			}
		}
		
		private function dropSun(e:TimerEvent):void
		{
			if (Math.floor(Math.random() * 100) <= dropChance)
			{
				var sun:SunDrop = new SunDrop(dropVel);
				dropContainer.addChild(sun);
				sunArray.push(sun);
			}
			else
			{
				var poison:PoisonDrop = new PoisonDrop(dropVel);
				dropContainer.addChild(poison);
				poisonArray.push(poison);
			}
		}
		
		private function shootLight(e:MouseEvent):void
		{
			if (paused == false)
			{
				var lightBullet:LightBullet = new LightBullet(stage.mouseX, stage.mouseY);
				addChild(lightBullet);
				healthbar.updateBar(health -= 2);
				bulletArray.push(lightBullet);
			}
		}
		
		public function nonAbsorbBurst(orbX:int, orbY:int, color:int, count:int):void
		{
			
			nonAbsorbEmitter.x = orbX;
			nonAbsorbEmitter.y = orbY;
			
			nonAbsorbEmitter.addInitializer(new ColorInit(color, color));
			nonAbsorbEmitter.counter = new Blast(count);
			
			nonAbsorbEmitter.start();
		}
		
		public function burst(clickX:int, clickY:int, color:int):void
		{
			burstEmitter.x = clickX;
			burstEmitter.y = clickY;
			burstEmitter.addInitializer(new ColorInit(color, color));
			burstEmitter.counter = new Blast(5);
			burstEmitter.start();
			absorbEmitter.start();
		}
		
		public function changeMulti(change:int):void
		{
			multi += change;
			multiText.text = "x" + multi.toString();
		}
		
		public function changeScore(change:int, xPos:int, yPos:int, color:int):void
		{
			score += change * multi;
			scoreText.text = score.toString();
			var scoreAddition:Score = new Score(change * multi, xPos, yPos, 0x333333);
			scoreLayer.addChild(scoreAddition);
		
		}
		
		private function absorb(e:ParticleEvent):void
		{
			e.particle.revive();
			absorbEmitter.addParticles(Vector.<Particle>([e.particle]), true);
		}
		
		private function pauseGame(e:Event):void
		{
			pause();
		}
		
		private function unpauseGame(e:Event):void
		{
			unpause();
		}
		
		public function pause():void
		{
			paused = true;
			absorbEmitter.pause();
			burstEmitter.pause();
			nonAbsorbEmitter.pause();
			sunTimer.stop();
		}
		
		public function unpause():void
		{
			burstEmitter.counter = new Blast(0);
			nonAbsorbEmitter.counter = new Blast(0);
			burstEmitter.start();
			absorbEmitter.start();
			nonAbsorbEmitter.start();
			paused = false;
			sunTimer.start();
		}
		
		public function upgrade():void
		{
			pause();
			TweenMax.to(this, .75, {x: -250, y: -450, scaleX: 2, scaleY: 2, ease: Quad.easeOut, onComplete: upgrade2});
		}
		
		private function upgrade2():void
		{
			plantSteps.gotoAndPlay(plantSteps.currentFrame + 1);
			TweenMax.to(plantSteps, 2, {frame: dropVel * 40, ease: Linear.easeNone, onComplete: upgrade3});
		}
		
		private function upgrade3():void
		{
			TweenMax.to(this, 1, {x: +0, y: +0, scaleX: 1, scaleY: 1, ease: Quad.easeInOut, onComplete: revert});
		}
		
		public function revert():void
		{
			health = 50 - ((dropVel - 1)) * 5;
			healthbar.updateBarUpgrade(health);
			sunTimer.delay = sunTimer.delay -= 200;
			unpause();
			
			nonAbsorbBurst(245, 500, 0xFFFFFFFF, 50);
			dropVel += 1;
			if (dropVel == 2)
			{
				dropChance = 60;
			}
			else
			{
				dropChance -= 4;
			}
		}
		
		private function updateHealth(e:ParticleEvent):void
		{
			if (e.particle.color == 0xFFAAAAAA)
			{
				health += 1;
			}
			else
			{
				health -= 1;
			}
			if (health >= 100)
			{
				health = 100;
			}
			healthbar.updateBar(health);
		}
		
		private function clickMenu(e:MouseEvent):void
		{
			
			cleanup();
			Main(parent).startMenu();
		}
		
		public function cleanup():void
		{
			var length:int = bulletArray.length;
			
			for (var i:int = 0; i < length; i++)
			{
				bulletArray[0].destroy();
			}
			length = sunArray.length;
			for (var u:int = 0; u < length; u++)
			{
				sunArray[0].destroy();
			}
			length = poisonArray.length;
			for (var d:int = 0; d < length; d++)
			{
				poisonArray[0].destroy();
			}
			
			stage.removeEventListener(Event.DEACTIVATE, pauseGame);
			stage.removeEventListener(Event.ACTIVATE, unpauseGame);
			sunTimer.removeEventListener(TimerEvent.TIMER, dropSun);
			stage.removeEventListener(MouseEvent.RIGHT_CLICK, shootLight);
			stage.removeEventListener(Event.ENTER_FRAME, gameEnterFrame);
			burstEmitter.removeEventListener(ParticleEvent.PARTICLE_DEAD, absorb);
			absorbEmitter.removeEventListener(ParticleEvent.PARTICLE_DEAD, updateHealth);
			menuButton.removeEventListener(MouseEvent.CLICK, clickMenu);
		}
		
		public function gameVictory():void
		{
			
		}
		
		public function gameOver():void
		{
			cleanup();
		}
	
	}

}