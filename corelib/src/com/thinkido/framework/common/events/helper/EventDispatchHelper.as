package com.thinkido.framework.common.events.helper
{
	import com.thinkido.framework.common.events.EventDispatchCenter;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;

    public class EventDispatchHelper extends Object
    {
        private static var _eventDispatchCenter:EventDispatchCenter = EventDispatchCenter.getInstance();

        public function EventDispatchHelper()
        {
            throw new Event("静态类");
        }
		/**
		 * 派发事件 
		 * @param event 事件
		 * @param dispatcher 事件派发器 
		 * 
		 */
        public static function dispatchEvent(event:Event, dispatcher:EventDispatcher = null) : void
        {
            var _dispatcher:* = dispatcher || _eventDispatchCenter;
            _dispatcher.dispatchEvent(event);
            return;
        }

    }
}
