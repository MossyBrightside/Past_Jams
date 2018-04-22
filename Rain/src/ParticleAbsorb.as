package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import org.flintparticles.twoD.actions.TweenPosition;
	import org.flintparticles.twoD.emitters.Emitter2D;
	import org.flintparticles.common.actions.Age;
	import org.flintparticles.common.easing.Quadratic;
	import org.flintparticles.common.easing.Elastic;
	import org.flintparticles.common.initializers.Lifetime;
	import org.flintparticles.twoD.actions.TweenToZone;
	import org.flintparticles.twoD.emitters.Emitter2D;
	import org.flintparticles.twoD.zones.BitmapDataZone;
	
	
	
	/**
	 * ...
	 * @author Jacob Strickland
	 */
	public class ParticleAbsorb extends Emitter2D
	{
		[Embed(source = "../lib/tree.png")]
		private var treeImg:Class;
		private var absorbData:BitmapData;
		
		public function ParticleAbsorb()
		{
			absorbData = (new treeImg() as Bitmap).bitmapData;
			addInitializer(new Lifetime(2));
			addAction(new Age(Quadratic.easeInOut));
			addAction(new TweenToZone(new BitmapDataZone(absorbData, 245, 500, 1, 1)));
		}
	}

}