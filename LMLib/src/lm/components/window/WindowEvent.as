package lm.components.window
{
	import flash.events.Event;
    
    public class WindowEvent extends Event
    {
        public static const CLOSE:String = "window_close";
        public static const SHOW:String = "window_show";
		public static const MINIMIZE:String = 'window_minimize';
		
		public var detail:int;
		public var data:Object;

        public function WindowEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
        {
            super(param1, param2, param3);
            return;
        }

    }
}
