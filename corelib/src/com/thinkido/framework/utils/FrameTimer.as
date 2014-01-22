package com.thinkido.framework.utils {
	import flash.events.TimerEvent;

	/**
	 * 帧控制器
	 * 
	 * @author bright
	 * @version 20101008
	 */
	public class FrameTimer {
		private static var _timer : ExactTimer = new ExactTimer(60, 15, 0);
		private static var _list : Array = new Array();

		private static function timerHandler(event : TimerEvent) : void {
			if(_list.length == 0) {
				_timer.removeEventListener(TimerEvent.TIMER, timerHandler);
				_timer.stop();
				return;
			}
			for each(var frame:IFrame in _list) {
				frame.action();
			}
			event.updateAfterEvent();
		}

		public static function add(frame : IFrame) : void {
			var index : int = _list.indexOf(frame);
			if(index == -1) {
				_list.push(frame);
				if(!_timer.running) {
					_timer.addEventListener(TimerEvent.TIMER, timerHandler);
					_timer.start();
				}
			}
		}

		public static function remove(frame : IFrame) : void {
			var index : int = _list.indexOf(frame);
			if(index == -1)
				return;
			_list.splice(index, 1);
			if(_list.length == 0 ) {
				if(_timer.running) {
					_timer.removeEventListener(TimerEvent.TIMER, timerHandler);
					_timer.stop();
				}
			}
		}

		public static function get running() : Boolean {
			return _timer.running ? true : _list.length > 0;
		}
	}
}
