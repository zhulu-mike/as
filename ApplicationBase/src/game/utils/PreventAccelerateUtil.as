package game.utils
{
	import flash.display.Stage;
	import flash.events.Event;
	import flash.utils.getTimer;

	/**
	 * 防加速工具
	 * PreventAccelerateUtil.init();
	 */		
	public class PreventAccelerateUtil
	{
		
		public function PreventAccelerateUtil()
		{
		}
		
		/**
		 * 初始化
		 * @param stage
		 * 
		 */		
		public static function init(stage:Stage, handFunc:Function=null):void
		{
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			lasttime = getTimer();
			lastLocalTime = new Date().getTime();
			accelerateHandFunc = handFunc;
		}
		
		private static var lasttime:int;
		/**
		 * 上一次本地系统时间
		 */		
		private static var lastLocalTime:Number;
		
		/**
		 * 是否已经处理过加速
		 */		
		private static var warnShow:Boolean = false;
		/**
		 * 检测到加速后回调方法
		 */		
		private static var accelerateHandFunc:Function;
		
		/**
		 * 加速原理：本地系统时间未被加速。flash内部的运行时间被加速。
		 * 所以检测内部的一秒与本地系统时间的1秒是否相同即可
		 * @param event
		 * 
		 */		
		private static function onEnterFrame(event:Event):void
		{
			var now:int = getTimer();
			if (now - lasttime >= 1000)
			{
				if (!warnShow && new Date().getTime() - lastLocalTime < 800)
				{
					warnShow = true;
					trace("do not accelerate");
					if (accelerateHandFunc != null)
					{
						accelerateHandFunc();
					}
				}
				lasttime = now;
				lastLocalTime = new Date().getTime();
			}
		}
	}
}