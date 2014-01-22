package tools.timer.vo
{
	import flash.utils.Timer;
	/**
	 * 自定义定时器数据 
	 * @author thinkido
	 * 
	 */
    public class TimerData extends Object
    {
        private var _timer:Timer;
        private var _destroy:Function;

        public function TimerData($timer:Timer, $destroy:Function)
        {
            this._timer = $timer;
            this._destroy = $destroy;
            return;
        }

        public function get timer() : Timer
        {
            return this._timer;
        }

        public function get destroy() : Function
        {
            return this._destroy;
        }

    }
}
