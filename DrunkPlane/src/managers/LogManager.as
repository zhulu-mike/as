package managers
{
	import flash.events.Event;

	public class LogManager
	{
		public function LogManager()
		{
		}
		
		
		public static var logList:Array = [];
		
		private static var keepList:Array = [];
		
		private static var logThread:Boolean = false;
		
		public static function logTrace(str:*):void
		{
			trace(str);
		}
		
		
	}
}