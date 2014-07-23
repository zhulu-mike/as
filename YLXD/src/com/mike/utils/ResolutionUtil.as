package com.mike.utils
{
	import flash.geom.Point;
	import flash.system.Capabilities;
	
	/**
	 * 屏幕分辨率类
	 * @author Administrator
	 * 
	 */	
	public class ResolutionUtil
	{
		public function ResolutionUtil()
		{
		}
		
		private static var _instance:ResolutionUtil;
		
		public static function get instance():ResolutionUtil
		{
			if (_instance == null)
				_instance = new ResolutionUtil();
			return _instance;
		}
		
		private var designWidth:int;
		private var designHeight:int;
		
		
		/**
		 * 初始化设计时的视图大小
		 * @param view,x表示宽度，y表示高度
		 * 
		 */		
		public function init(view:Point):void
		{
			designWidth = view.x;
			designHeight = view.y;
		}
		/**
		 * 计算返回最佳的缩放比例
		 * @return 
		 * 
		 */		
		public function getBestRatio():Number
		{
			var ratio:Number = 1.0;
			var rw:int = designWidth > designHeight ? Math.max(Capabilities.screenResolutionX,Capabilities.screenResolutionY) : Math.min(Capabilities.screenResolutionX,Capabilities.screenResolutionY);
			var rh:int = designWidth > designHeight ? Math.min(Capabilities.screenResolutionX,Capabilities.screenResolutionY) : Math.max(Capabilities.screenResolutionX,Capabilities.screenResolutionY);
			ratio = Math.min(rw/designWidth,rh/designHeight);
			return ratio;
		}
	}
}