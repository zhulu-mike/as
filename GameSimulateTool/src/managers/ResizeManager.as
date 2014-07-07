package managers
{
	import flash.display.Stage;
	import flash.events.Event;
	
	import configs.IResize;

	public class ResizeManager
	{
		
		private static var _resizeList:Vector.<IResize>;
		
		public function ResizeManager() 
		{   
		}
		
		private static var stage:Stage;
		public static function init($stage:Stage):void
		{
			stage = $stage;
			_resizeList = new Vector.<IResize>();
			resize();
			$stage.addEventListener(Event.RESIZE, resize);
		}
		public static function resize(event:Event = null) : void
		{
			
			var temp:IResize;
			for each (temp in _resizeList)
			{
				temp.resize(stage.stageWidth, stage.stageHeight);
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
			target.resize(stage.stageWidth, stage.stageHeight);
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