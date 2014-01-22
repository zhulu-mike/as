package com.thinkido.framework.effect {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import com.thinkido.framework.utils.ExactTimer;

	/**
	 * Game Effect
	 * 
	 * @author bright
	 * @version 20101008
	 */
	public class TEffect extends EventDispatcher implements ITEffect {
		public static const END : String = "end";
		protected var _delay : int;
		protected var _duration : int;
		protected var _target : Sprite;
		protected var _timer : ExactTimer;

		private function timerHandler(event : TimerEvent) : void {
			next();
		}

		protected function onChangeTarget() : void {
		}

		protected function next() : void {
		}

		public function TEffect(duration : int, delay : int = 60) {
			_duration = duration;
			_delay = delay;
			_timer = new ExactTimer(_delay);
		}

		public function set target(value : Sprite) : void {
			_target = value;
			onChangeTarget();
		}

		public function set duration(value : int) : void {
			_duration = value;
		}

		public function start() : void {
			if (_target == null) {
				stop();
				return;
			}
			if (!_timer.running) {
				next();
				_timer.addEventListener(TimerEvent.TIMER, timerHandler);
				_timer.start();
			}
		}

		public function stop() : void {
			if (_timer.running) {
				_timer.removeEventListener(TimerEvent.TIMER, timerHandler);
				_timer.stop();
				dispatchEvent(new Event(TEffect.END));
			}
		}

		public function dispose() : void {
		}
	}
}
