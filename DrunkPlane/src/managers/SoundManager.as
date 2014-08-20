package managers
{
	import com.mike.utils.SoundUtil;
	
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
		
		public static function playLoop(url:String):void
		{
			if (!GameInstance.instance.soundEnable)
				return;
			SoundUtil.playLoopSound(url);
		}
	}
}