package lm.mui.events
{
	import flash.events.Event;
	
	public class GLoadEvent extends Event
	{
		public static const IO_ERROR:String = "GLoadEvent_IO_ERROR";
		public static const HTTP_STATUS:String = "GLoadEvent_HTTP_STATUS";
		public var data:Object;
		
		public function GLoadEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}