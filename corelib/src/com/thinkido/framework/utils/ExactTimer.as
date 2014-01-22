package com.thinkido.framework.utils {
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.getTimer;

	/**
	 * 精确计时器
	 * 
	 * @author bright
	 * @version 20101015
	 */
	public class ExactTimer extends EventDispatcher {
		private var _timer : Timer;
		private var _repeat : int;
		private var _currentCount : int;
		private var _time : int;
		private var _offset : int;
		private var _tick : int;

		private function timerHandler(event : TimerEvent) : void {
			var time : int = getTimer();
			var delta : int = time - _time;
			_time = time;
			_offset += delta;
			if (_offset > _tick) {
				_offset -= _tick;
				_currentCount++;
				if(_repeat > 0 && _currentCount > _repeat) {
					stop();
					return;
				}
				dispatchEvent(new TimerEvent(TimerEvent.TIMER));
			}
		}

		/**
		 * ExactTimer 构造函数
		 * 
		 * @param tick int 时间
		 * @param delay int 延迟
		 * @param repeat int 重复次数
		 */
		public function ExactTimer(tick : int = 60, delay : int = 15, repeat : int = 0) {
			_repeat = repeat;
			_timer = new Timer(delay);
			_tick = tick;
		}

		/**
		 * running
		 * 
		 * @return 运行状态(ture运行中false没有运行)
		 */
		public function get running() : Boolean {
			return _timer.running;
		}

		/**
		 * currentCount
		 * 
		 * @return int 当前计数
		 */
		public function get currentCount() : int {
			return _currentCount;
		}

		/**
		 * start
		 * 
		 * 启动精确计时器
		 */
		public function start() : void {
			if(_timer.running) {
				return;
			}
			_offset = 0;
			_time = getTimer();
			_timer.addEventListener(TimerEvent.TIMER, timerHandler);
			_currentCount = 0;
			_timer.reset();
			_timer.start();
		}

		/**
		 * stop
		 * 
		 * 停止精确计时器
		 */
		public function stop() : void {
			if(!_timer.running) {
				return;
			}
			_timer.removeEventListener(TimerEvent.TIMER, timerHandler);
			_timer.stop();
		}
	}
}
