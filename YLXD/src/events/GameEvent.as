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
	}
}