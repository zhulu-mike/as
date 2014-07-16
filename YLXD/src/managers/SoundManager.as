package managers
{
	import flash.media.Sound;
	import flash.net.URLRequest;
	
	import configs.GameInstance;

	public class SoundManager
	{
		public function SoundManager()
		{
		}
		
		public static function playSound(url:String):void
		{
			if (!GameInstance.instance.soundEnable)
				return;
			var sound:Sound = new Sound(new URLRequest(url));
			sound.play();
		}
	}
}