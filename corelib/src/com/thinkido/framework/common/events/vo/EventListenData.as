package com.thinkido.framework.common.events.vo
{
	import flash.events.EventDispatcher;
	/**
	 * 自定义事件类型数据  
	 * @author thinkido
	 * 
	 */
    public class EventListenData extends Object
    {
        private var _type:String;
        private var _listener:Function;
        private var _dispatcher:EventDispatcher;
        private var _useCapture:Boolean;
        private var _priority:int;
        private var _useWeakReference:Boolean;
		/**
		 * 自定义事件类型数据 
		 * @param $type 事件类型
		 * @param $listener 监听器
		 * @param $dispatcher 拍发起
		 * @param $useCapture 是否捕获
		 * @param $priority 优先级
		 * @param $useWeakReference 弱引用
		 */
        public function EventListenData($type:String, $listener:Function, $dispatcher:EventDispatcher = null, $useCapture:Boolean = false, $priority:int = 0, $useWeakReference:Boolean = false)
        {
            this._type = $type;
            this._listener = $listener;
            this._dispatcher = $dispatcher;
            this._useCapture = $useCapture;
            this._priority = $priority;
            this._useWeakReference = $useWeakReference;
            return;
        }

        public function get type() : String
        {
            return this._type;
        }

        public function get listener() : Function
        {
            return this._listener;
        }

        public function get dispatcher() : EventDispatcher
        {
            return this._dispatcher;
        }

        public function get useCapture() : Boolean
        {
            return this._useCapture;
        }

        public function get priority() : int
        {
            return this._priority;
        }

        public function get useWeakReference() : Boolean
        {
            return this._useWeakReference;
        }

        public function equals($type:String, $listener:Function, $dispatcher:EventDispatcher = null, $useCapture:Boolean = false, $priority:int = 0, $useWeakReference:Boolean = false) : Boolean
        {
            return this._type == $type && this._listener == $listener && this._dispatcher == $dispatcher && this._useCapture == $useCapture && this._priority == $priority && this._useWeakReference == $useWeakReference;
        }

    }
}
