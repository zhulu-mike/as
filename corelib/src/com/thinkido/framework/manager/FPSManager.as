package com.thinkido.framework.manager
{
	
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.getTimer;

	/**
	 * 帧频管理器 ,用于每帧时间控制
	 * @author mike
	 * 
	 */	
	public class FPSManager extends EventDispatcher
	{
		
		public function FPSManager()
		{
			funcs = new Vector.<Function>();
		}
		
		private static var _instance:FPSManager
		
		public static function getInstance():FPSManager
		{
			if (_instance == null)
				_instance = new FPSManager();
			return _instance;
		}
		
		
		/**
		 * 上一次帧结束时间
		 */		
		private var lastTime:int = 0;
		
		private var funcs:Vector.<Function>;
		
		public function init(s:Stage):void
		{
			if (s == null)
				throw new Error("stage is null");
			s.addEventListener(Event.ENTER_FRAME, onEnterFrame,false,999);
		}
		
		private function onEnterFrame(e:Event):void
		{
			var now:int = getTimer();
			if (lastTime == 0){
				lastTime = now;
				return;
			}
			if (now - lastTime < 25)
			{
				var left:int = 30 - now + lastTime;
				var func:Function;
				for each (func in funcs)
				{
					func.call(null,left);
					now = getTimer();
					left = 30 - now + lastTime;
					if (left <= 0)
						break;
				}
			}
			lastTime = now;
		}
		
		/**
		 * 添加的回调方法必须有1个参数，表示剩余毫秒数
		 * @param func
		 * 
		 */		
		public function addCallBack(func:Function):void
		{
			if (func != null && funcs.indexOf(func) < 0)
			{
				funcs.push(func);	
			}
		}
		
		public function removeCallBack(func:Function):void
		{
			var i:int = funcs.indexOf(func);
			if (i >= 0)
			{
				funcs.splice(i,1);
			}
		}
	}
}