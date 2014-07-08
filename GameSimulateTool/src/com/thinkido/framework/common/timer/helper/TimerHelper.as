package com.thinkido.framework.common.timer.helper
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Linear;
	import com.thinkido.framework.common.timer.vo.TimerData;
	import com.thinkido.framework.manager.HandlerManager;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	/**
	 * timer 帮助类 
	 * @author thinkido
	 * 
	 */	
	public class TimerHelper extends Object
	{
		private static var timeSprite:Sprite = new Sprite();
		private static var delayCallBackList:Array = new Array();
		
		public function TimerHelper()
		{
			throw new Event("静态类");
		}
		/**
		 * 
		 * @param $delay 毫秒
		 * @param $repeat 重复次数
		 * @param $timerHandler 触发方法
		 * @param $timerHandlervalueeters 参数数组
		 * @param $timerCompleteHandler 定时器完成时触发方法
		 * @param $timerCompleteHandlervalueeters 参数数组
		 * @param $autoStart 是否立刻开始
		 * @return 
		 * 
		 */		
		public static function createTimer($delay:Number, $repeat:Number, $timerHandler:Function, $timerHandlervalueeters:Array = null, $timerCompleteHandler:Function = null, $timerCompleteHandlervalueeters:Array = null, $autoStart:Boolean = true) : TimerData
		{
			var timer:Timer;
			var timerHandler:Function;
			var timerCompleteHandler:Function;
			var destroy:Function;
			timerHandler = function (event:TimerEvent) : void
			{
				HandlerManager.execute($timerHandler, $timerHandlervalueeters);
				return;
			}
				;
			timerCompleteHandler = function (event:TimerEvent) : void
			{
				destroy();
				HandlerManager.execute($timerCompleteHandler, $timerCompleteHandlervalueeters);
				return;
			}
				;
			destroy = function () : void
			{
				if (timer)
				{
					timer.stop();
					timer.removeEventListener(TimerEvent.TIMER, timerHandler);
					timer.removeEventListener(TimerEvent.TIMER_COMPLETE, timerCompleteHandler);
					timer = null;
				}
				return;
			}
				;
			timer = new TimerAdvance($delay, $repeat);
			if ($timerHandler != null)
			{
				timer.addEventListener(TimerEvent.TIMER, timerHandler);
			}
			if ($timerCompleteHandler != null)
			{
				timer.addEventListener(TimerEvent.TIMER_COMPLETE, timerCompleteHandler);
			}
			if ($autoStart)
			{
				timer.start();
			}
			return new TimerData(timer, destroy);
		}
		
		public static function createExactTimer($duration:Number, $from:Number, $to:Number, $onUpdate:Function = null, $onComplete:Function = null, $updateStep:Number = 0) : TimerData
		{
			var obj:Object;
			var i:Number;
			var absUpdateStep:Number;
			var onUpdate1:Function;
			var onUpdate2:Function;
			var onComplete:Function;
			var destroy:Function;
			onUpdate1 = function () : void
			{
				if (Math.abs(obj.i - i) >= absUpdateStep)
				{
					i = obj.i;
					if ($onUpdate != null)
					{
						$onUpdate(obj.i);
					}
				}
				return;
			}
				;
			onUpdate2 = function () : void
			{
				if ($onUpdate != null)
				{
					$onUpdate(obj.i);
				}
				return;
			}
				;
			onComplete = function () : void
			{
				if ($onUpdate != null)
				{
					$onUpdate(obj.i);
				}
				if ($onComplete != null)
				{
					$onComplete();
				}
				return;
			}
				;
			destroy = function () : void
			{
				TweenLite.killTweensOf(obj);
				return;
			}
				;
			obj = {i:$from};
			var onUpdate:* = $updateStep != 0 ? (onUpdate1) : (onUpdate2);
			TweenLite.to(obj, $duration, {i:$to, onUpdate:onUpdate, onComplete:onComplete, ease:Linear.easeNone});
			i = $from;
			absUpdateStep = Math.abs($updateStep);
			return new TimerData(null, destroy);
		}
		
		public static function addDelayCallBack($delay:Number, $fun:Function) : void
		{
			if ($delay <= 0)
			{
				$fun();
				return;
			}
			var delayItem:Array = [$delay, $fun, getTimer()];
			delayCallBackList.unshift(delayItem);
			delayCallBackList[$fun] = delayItem;
			if (delayCallBackList.length == 1)
			{
				timeSprite.addEventListener(Event.ENTER_FRAME, updateDelayCallBack);
			}
			return;
		}
		
		public static function removeDelayCallBack(value1:Function) : void
		{
			var _loc_3:int = 0;
			var _loc_2:* = delayCallBackList[value1];
			if (_loc_2 != null)
			{
				delayCallBackList[value1] = null;
				delete delayCallBackList[value1];
				_loc_3 = delayCallBackList.indexOf(_loc_2);
				if (_loc_3 != -1)
				{
					delayCallBackList.splice(_loc_3, 1);
				}
			}
			if (delayCallBackList.length == 0)
			{
				timeSprite.removeEventListener(Event.ENTER_FRAME, updateDelayCallBack);
			}
			return;
		}
		
		private static function updateDelayCallBack(event:Event) : void
		{
			var delayItem:Array = null;
			var delay:int = 0;
			var comFun:Function = null;
			var start:int = 0;
			var timer:uint = getTimer();
			var index:int = delayCallBackList.length - 1;
			while (index >= 0)
			{
				delayItem = delayCallBackList[index];
				delay = delayItem[0];
				comFun = delayItem[1];
				start = delayItem[2];
				if (timer - start >= delay)
				{
					delayCallBackList[comFun] = null;
					delete delayCallBackList[comFun];
					delayCallBackList.splice(index, 1);
					if (delayCallBackList.length == 0)
					{
						timeSprite.removeEventListener(Event.ENTER_FRAME, updateDelayCallBack);
					}
					comFun();
				}
				index = index - 1;
			}
			return;
		}
	}
}
