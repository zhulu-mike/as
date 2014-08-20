package
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import events.GameEvent;
	
	public class EventCenter extends EventDispatcher
	{
		public function EventCenter(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		private static var _instance:EventCenter;
		
		public static function get instance():EventCenter
		{
			if (_instance == null)
				_instance = new EventCenter();
			return _instance;
		}
		
		/**
		 * 派发GameEvent
		 * @param type
		 * @param data
		 * 
		 */		
		public function dispatchGameEvent(type:String, data:Object=null):void
		{
			var evt:GameEvent = new GameEvent(type);
			evt.data = data;
			this.dispatchEvent(evt);
		}
	}
}