package manager
{
	import flash.display.Stage;
	import flash.events.Event;
	
	import interfaces.IResize;
	

	public class ResizeManager
	{
		
		private static var _resizeList:Vector.<IResize>;
		private static var st:Stage;
		
		public function ResizeManager() 
		{   
		}
		public static function init(s:Stage):void
		{
			st = s;
			_resizeList = new Vector.<IResize>();
			s.addEventListener(Event.RESIZE, resize);
		}
		public static function resize(event:Event = null) : void
		{
			var temp:IResize;
			for each (temp in _resizeList)
			{
				temp.resize(st.stageWidth, st.stageHeight);
			}
		}
		
		/**
		 * 注册。当舞台发生RESIZE事件时，此MANAGER将遍历注册的IResize实例，调用其resize方法
		 * @param target 必须继承IResize接口
		 * 
		 */		
		public static function registerResize(target:IResize):void
		{
			var index:int = _resizeList.indexOf(target);
			if (index >= 0)
				return;
			_resizeList.push(target);
			target.resize(st.stageWidth, st.stageHeight);
		}
		
		/***/
		public static function unRegisterResize(target:IResize):void
		{
			var index:int = _resizeList.indexOf(target);
			if (index >= 0)
			{
				_resizeList.splice(index, 1);
			}
		}
	}
}