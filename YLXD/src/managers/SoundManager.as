package managers
{
	import com.mike.utils.SoundUtil;
	
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
			SoundUtil.playSound(url);
		}
	}
}