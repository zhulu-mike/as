package com.thinkido.framework.engine.utils
{
	import flash.display.Stage;
	import flash.events.Event;
	import flash.utils.Dictionary;

	public class FrameUtil
	{
		public function FrameUtil()
		{
		}
		
		private static var stage:Stage;
		private static var funcDic:Dictionary = new Dictionary();
		
		public static function init(s:Stage):void
		{
			stage = s;
			s.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		protected static function onEnterFrame(event:Event):void
		{
			var key:*, value:FrameVO;
			for (key in funcDic)
			{
				value = funcDic[key] as FrameVO;
				value.handler.call();
				if (value.oneTime)
				{
					funcDic[key] = null;
					delete funcDic[key];
				}
			}
		}
		
		public static function addOneCallLater(func:Function):void
		{
			if (funcDic[func])
			{
				funcDic[func].oneTime = true;
			}else{
				funcDic[func] = new FrameVO(func,true);
			}
		}
		
	}
}
class FrameVO
{
	public var handler:Function;
	public var oneTime:Boolean;
	public function FrameVO($func:Function, $onetime:Boolean=false)
	{
		handler = $func;
		oneTime = $onetime;
	}
}