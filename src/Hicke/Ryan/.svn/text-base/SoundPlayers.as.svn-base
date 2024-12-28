package Hicke.Ryan{
	
	import flash.media.Sound;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;

	public class SoundPlayers{
		private static var shootSounds:Array = new Array();
		private static var deathSounds:Array = new Array();
		private static var soundTransform:SoundTransform = new SoundTransform();
		private static var cantBuild:Sound;
		
		public static function GetVolume():Number{
			return soundTransform.volume;
		}
		
		private static var muted:Boolean = false;
		
		public static function ToggleMute():void{
			soundTransform.volume = soundTransform.volume == 0?1:0;
		}
		
		public static function Init(soundFiles:Object):void{
			InitShootSounds(soundFiles.shoot);
			InitDeathSouds(soundFiles.die);
			cantBuild = LoadSound(soundFiles.buzzer);
		}
		private static function InitShootSounds(soundFiles:Object):void{
			shootSounds.push(LoadSound(soundFiles.tower1));
			shootSounds.push(LoadSound(soundFiles.tower2));
			shootSounds.push(LoadSound(soundFiles.tower3));
			shootSounds.push(LoadSound(soundFiles.tower4));
			shootSounds.push(LoadSound(soundFiles.tower5));
		}
		private static function InitDeathSouds(soundFiles:Object):void{
			deathSounds.push(LoadSound(soundFiles.die1));
			deathSounds.push(LoadSound(soundFiles.die2));
			deathSounds.push(LoadSound(soundFiles.die3));
			deathSounds.push(LoadSound(soundFiles.die4));
		}
						
		private static function LoadSound(soundFile:String):Sound{
			if(soundFile.length == 0) return null;
			var req:URLRequest = new URLRequest(soundFile);
			var s:Sound = new Sound();
			s.load(req);
			return s;
		}
		
		private static function Play(s:Sound):void{
			if(s!=null){
				s.play(0,0,soundTransform);
			}
		}
		
		public static function DeathSound():void{
			var i:int = Math.floor(Math.random() * deathSounds.length);
			Play(Sound(deathSounds[i]));
		}
		public static function ShootSound(index:int):void{
			Play(Sound(shootSounds[index]));
		}
		public static function CantBuild():void{
			Play(cantBuild);
		}
	}
}