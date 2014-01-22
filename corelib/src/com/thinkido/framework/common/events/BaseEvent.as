package com.thinkido.framework.common.events
{
	import flash.events.Event;
	/**
	 * 自定义事件基类 
	 * @author Administrator
	 */
    public class BaseEvent extends Event
    {
        public var action:String;
        public var data:Object;
        public static const INIT_COMPLETE:String = "BaseEvent.initComplete";
        public static const UPDATE:String = "BaseEvent.update";
        public static const COMPLETE:String = "BaseEvent.complete";

        public function BaseEvent($type:String, $action:String = "", $data:Object = null, $bubbles:Boolean = false, $cancelable:Boolean = false)
        {
            super($type, $bubbles, $cancelable);
            this.action = $action;
            this.data = $data;
            return;
        }

        override public function clone() : Event
        {
            return new BaseEvent(type, this.action, this.data, bubbles, cancelable);
        }

        override public function toString() : String
        {
            return "[BaseEvent]";
        }

    }
}
