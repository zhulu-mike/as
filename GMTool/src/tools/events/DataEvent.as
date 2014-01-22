package tools.events
{
	import flash.events.Event;
	
	public class DataEvent extends Event
	{
		
		public var data:Object;
		public function DataEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, $data:Object=null)
		{
			super(type, bubbles, cancelable);
			this.data = $data;
		}
		
		
	}
}