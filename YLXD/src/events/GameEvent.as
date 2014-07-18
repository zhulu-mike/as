package events
{
	import flash.events.Event;
	
	public class GameEvent extends Event
	{
		
		public var data:Object;
		
		public function GameEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		/**
		 * 游戏状态改变
		 */		
		public static const GAME_STATE_CHANGE:String = "GAME_STATE_CHANGE";
		
		/**
		 * 分数更新
		 */		
		public static const SCORE_UPDATE:String = "SCORE_UPDATE";
		
		/**
		 * 检测对战是否结束
		 */		
		public static const CHECK_RACE_END:String = "CHECK_RACE_END";
		
		public static const STARLING_CREATE:String = "STARLING_CREATE";
		
		public static const START_GAME:String = "START_GAME";
		
		public static const UPDATE_MAX_SCORE:String = "UPDATE_MAX_SCORE";
		
		public static const PLAY_GAME_OVER_SOUND:String = "PLAY_GAME_OVER_SOUND";
		
		/**
		 *  显示开发商介绍
		 */		
		public static const SHOW_INTRODUCE:String = "SHOW_INTRODUCE";
		
		/**
		 * 对战模式时用来隐藏大背景
		 */		
		public static const CONTROL_BIG_BACKGROUND:String = "CONTROL_BIG_BACKGROUND";
	}
}