package com.thinkido.framework.engine.events
{
	import com.thinkido.framework.common.events.BaseEvent;
	
	import flash.events.Event;
	/**
	 * 引擎场景事件 
	 * @author Administrator
	 * 
	 */
    public class SceneEvent extends BaseEvent
    {
        public static const INTERACTIVE:String = "SceneEvent.interactive";
        public static const WALK:String = "SceneEvent.walk";
        public static const STATUS:String = "SceneEvent.status";
        public static const PROCESS:String = "SceneEvent.process";

        public function SceneEvent($type:String, $action:String = "", $data:Object = null, $bubbles:Boolean = false, $cancelable:Boolean = false)
		{
			super($type,$action,$data,$bubbles, $cancelable);
            return;
        }

        override public function clone() : Event
        {
            return new SceneEvent(type, action, data, bubbles, cancelable);
        }

        override public function toString() : String
        {
            return "[SceneEvent]";
        }

    }
}
