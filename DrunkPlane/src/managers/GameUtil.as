package managers
{
	import com.mike.utils.AdvertiseUtil;
	import com.mike.utils.MathUtil;
	
	import configs.GameInstance;
	import configs.GamePattern;
	import configs.IceArrow;
	import configs.PlayerState;
	
	import starling.filters.BlurFilter;
	import starling.filters.FragmentFilter;

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
		public static function getMaxScore():int
		{
			return GameInstance.instance.scoreRecord.maxScores;
		}
		
		/**
		 * 写某种模式的最高纪录
		 * @param pattern
		 * @param score
		 * 
		 */		
		public static function setMaxScore( score:int):void
		{
			GameInstance.instance.scoreRecord.maxScores = score;
			GameInstance.instance.so.setAt("score",score);
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
		
		private static var noFullCount:int = 0;
		public static function showFullSceenAd():void
		{
			GameInstance.instance.leftShowFullAd--;
			if (GameInstance.instance.leftShowFullAd <= 0)
			{
				if (AdvertiseUtil.isInterstitialReady())
				{
					noFullCount = 0;
					AdvertiseUtil.showInterstitial();
					GameInstance.instance.leftShowFullAd = GameInstance.FULLE_AD;
				}else{
					noFullCount++;
					if (noFullCount > 5)
					{
						AdvertiseUtil.cacheInterstitial();
						noFullCount = 0;
					}
				}
			}
		}
		
		public static function showMoreGame():void
		{
			if (AdvertiseUtil.isMoreGameReady())
				AdvertiseUtil.showMoreGame();
		}
		
		
		public static function getTextFieldFIlter():FragmentFilter
		{
			return BlurFilter.createDropShadow();
		}
		
		
		/**
		 * 根据数组规则随机其中一种
		 * @param src
		 * @return 
		 * 
		 */		
		public static function getRandomData(src:Array):*
		{
			if (src.length == 1)
				return src[0][0];
			var len:int = src.length;
			var max:int = src[len-1][1];
			var rand:int = MathUtil.random(0,max);
			var i:int = 0;
			for (;i<len;i++)
			{
				if (rand <= src[i][1])
					return src[i][0];
			}
			return src[len-1][0];
		}
		
	}
}