package tools.handler.vo
{
	/**
	 * 方法体，执行一些列方法队列时使用 
	 * @author thinkido
	 * 
	 */
    public class HandlerData extends Object
    {
        private var _handler:Function;
        private var _valueeters:Array;
        private var _delay:Number;
        private var _doNext:Boolean;
		/**
		 *  
		 * @param $handler 方法
		 * @param $valueeters 参数数组
		 * @param $delay 延迟
		 * @param $doNext 是否执行下一个
		 * 
		 */
        public function HandlerData($handler:Function, $valueeters:Array = null, $delay:Number = 0, $doNext:Boolean = true)
        {
            this._handler = $handler;
            this._valueeters = $valueeters;
            this._delay = $delay;
            this._doNext = $doNext;
            return;
        }

        public function get handler() : Function
        {
            return this._handler;
        }

        public function get valueeters() : Array
        {
            return this._valueeters;
        }

        public function get delay() : Number
        {
            return this._delay;
        }

        public function get doNext() : Boolean
        {
            return this._doNext;
        }

    }
}
