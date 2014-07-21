package managers
{
	import configs.GameInstance;
	import configs.GamePattern;
	import configs.PlayerState;
	
	import so.cuo.platform.baidu.BaiDu;
	import so.cuo.platform.baidu.BaiDuAdEvent;

	public class GameUtil
	{
		public function GameUtil()
		{
		}
		
		/**
		 * 获取某种模式的最高纪录
		 * @param pattern
		 * @return 
		 * 
		 */		
		public static function getMaxScore(pattern:int):int
		{
			return GameInstance.instance.scoreRecord.maxScores[pattern] as int;
		}
		
		/**
		 * 写某种模式的最高纪录
		 * @param pattern
		 * @param score
		 * 
		 */		
		public static function setMaxScore(pattern:int, score:int):void
		{
			GameInstance.instance.scoreRecord.maxScores[pattern] = score;
			GameInstance.instance.so.setAt("pattern_"+pattern,score);
		}
		
		public static function getPatternName(pattern:int):String
		{
			if (pattern == GamePattern.PUTONG)
				return Language.PUTONG;
			else if (pattern == GamePattern.NIXIANG)
				return Language.NIXIANG;
			else
				return Language.DUIZHAN;
		}
		/**
		 * 获取反向的手型
		 * @param state
		 * @return 
		 * 
		 */		
		public static function getReverseState(state:int):int
		{
			if (state == PlayerState.STONE)
				return PlayerState.JIANDAO;
			else if (state == PlayerState.JIANDAO)
				return PlayerState.BU;
			else
				return PlayerState.STONE;
		}
		
		public static function randomPlayerWord():String
		{
			return Language.PLAYER_WORDS[int(Math.random()*(Language.PLAYER_WORDS.length-1))];
		}
		public static function randomMonsterWord():String
		{
			return Language.MONSTER_WORDS[Math.random()*(Language.MONSTER_WORDS.length-1)];
		}
		
		public static function showFullSceenAd():void
		{
			GameInstance.instance.leftShowFullAd--;
			if (GameInstance.instance.leftShowFullAd <= 0)
			{
				if (BaiDu.getInstance().isInterstitialReady())
				{
					//延迟1秒显示
					BaiDu.getInstance().showInterstitial();
					BaiDu.getInstance().addEventListener(BaiDuAdEvent.onInterstitialDismiss, onCloseFullAd);
					GameInstance.instance.leftShowFullAd = GameInstance.FULLE_AD;
				}
			}
		}
		
		/**
		 * 关闭全屏广告后，再次缓冲 
		 * @param event
		 * 
		 */		
		private static function onCloseFullAd(event:BaiDuAdEvent):void
		{
			BaiDu.getInstance().removeEventListener(BaiDuAdEvent.onInterstitialDismiss, onCloseFullAd);
			BaiDu.getInstance().cacheInterstitial();
		}
		
	}
}