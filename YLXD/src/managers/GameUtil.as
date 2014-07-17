package managers
{
	import configs.GameInstance;
	import configs.GamePattern;
	import configs.PlayerState;

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
			if (state == PlayerState.RECT)
				return PlayerState.CIRCLE;
			else if (state == PlayerState.CIRCLE)
				return PlayerState.TRIANGLE;
			else
				return PlayerState.RECT;
		}
		
	}
}