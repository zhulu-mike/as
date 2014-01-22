package com.thinkido.framework.common.events.helper
{
	import com.thinkido.framework.common.events.EventDispatchCenter;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;

    public class EventListenHelper extends Object
    {
        private static var _eventDispatchCenter:EventDispatchCenter = EventDispatchCenter.getInstance();

        public function EventListenHelper()
        {
            throw new Event("静态类");
        }

        public static function addEvent($type:String, $handler:Function, $dispatcher:EventDispatcher = null, $useCapture:Boolean = false, $priority:int = 0, $useWeakReference:Boolean = false) : void
        {
            var _dispatcher:EventDispatcher = ($dispatcher || _eventDispatchCenter) as EventDispatcher;
			_dispatcher.addEventListener($type, $handler, $useCapture, $priority, $useWeakReference);
            return;
        }

        public static function removeEvent($type:String, $handler:Function, $dispatcher:EventDispatcher = null, $useCapture:Boolean = false) : void
        {
			var _dispatcher:EventDispatcher = ($dispatcher || _eventDispatchCenter) as EventDispatcher;
			_dispatcher.removeEventListener($type, $handler, $useCapture);
            return;
        }

        public static function hasEvent($type:String, $dispatcher:EventDispatcher = null) : Boolean
        {
			var _dispatcher:EventDispatcher = ($dispatcher || _eventDispatchCenter) as EventDispatcher;
			return _dispatcher.hasEventListener($type);
        }

        public static function willTrigger($type:String, $dispatcher:EventDispatcher = null) : Boolean
        {
			var _dispatcher:EventDispatcher = ($dispatcher || _eventDispatchCenter) as EventDispatcher;
			return _dispatcher.willTrigger($type);
        }

    }
}
