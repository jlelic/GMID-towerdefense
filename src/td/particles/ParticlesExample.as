package td.particles 
{
	import starling.display.Sprite;
	import starling.extensions.PDParticleSystem;
	import starling.textures.Texture;
	import starling.core.Starling;
	
	
	public class ParticlesExample extends Sprite
	{
		
		// embed configuration XML
		[Embed(source="../../assets/particles/particle.pex", mimeType="application/octet-stream")]
		private static const FireConfig:Class;
		 
		// embed particle texture
		[Embed(source = "../../assets/particles/texture.png")]
		private static const ParticleTexture:Class;
		 
		//
		// INEFFECTIVE! LOAD PARTICLES ONLY ONCE! 
		// NOT WITH EVERY INSTANCE!
		//
		
		// instantiate embedded objects
		private var psConfig:XML = XML(new FireConfig());
		private var psTexture:Texture = Texture.fromBitmap(new ParticleTexture());
		
		private var ps:PDParticleSystem;
		
		private var started: Boolean = false;
		
		public function ParticlesExample() {
			// create particle system
			ps = new PDParticleSystem(psConfig, psTexture);
			ps.x = 0;
			ps.y = 0;
			 
			// change position where particles are emitted
			ps.emitterX = 0;
			ps.emitterY = 0;			
		}
		
		public function start() : void {
			if (started) return;
			started = true;
			
			// add it to the stage (juggler will be managed automatically)
			addChild(ps);
			Starling.juggler.add(ps);
			// start emitting particles
			ps.start();
		}
		
		public function stop() : void {
			if (!started) return;
			started = false;
			try {
				removeChild(ps);
			} catch (e: Error) {				
			}
			try {
				Starling.juggler.remove(ps);
			} catch (e:Error) {				
			}
		}
		
		public function kill() : void {
			if (ps == null) return;
			stop();			
			ps = null;
			psTexture = null;
			psConfig = null;
		}
		
	}

}