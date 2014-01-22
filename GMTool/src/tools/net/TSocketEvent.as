package tools.net
{
	import flash.events.Event;
	
	public class TSocketEvent extends Event
	{
		public static const LOGIN_SUCCESS:String = "TSocketEvent_loginSuccess";
		public static const LOGIN_FAILURE:String = "TSocketEvent_loginFailure";
		public static const CLOSE:String = "TSocketEvent_close";

		public function TSocketEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}