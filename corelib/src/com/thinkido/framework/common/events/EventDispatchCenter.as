package com.thinkido.framework.common.events
{
	import flash.events.EventDispatcher;

	/**
	 * 引擎事件派发器，如位图中捕获的鼠标事件
	 * @author thinkido
	 * 
	 */	
    public class EventDispatchCenter extends EventDispatcher
    {
        private static var _instance:EventDispatchCenter;

        public function EventDispatchCenter()
        {
            if (_instance != null)
            {
                throw new Error("单例!");
            }
            _instance = this;
            return;
        }

        public static function getInstance() : EventDispatchCenter
        {
            if (_instance == null)
            {
                _instance = new EventDispatchCenter;
            }
            return _instance;
        }

    }
}
