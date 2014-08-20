package com.mike.utils
{
	import flash.geom.Point;
	
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
		public function getBestRatio(x:Number, y:Number):Number
		{
			var ratio:Number = 1.0;
			var rw:int = designWidth > designHeight ? Math.max(x,y) : Math.min(x,y);
			var rh:int = designWidth > designHeight ? Math.min(x,y) : Math.max(x,y);
			ratio = Math.min(rw/designWidth,rh/designHeight);
			return ratio;
		}
	}
}