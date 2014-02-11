package com.leman.data
{
	import flash.display.BitmapData;

	/**
	 * 单个方向的图片数据
	 * @author jianglinwang
	 * 
	 */	
	public class SingleDirectionImage
	{
		
		public var bitmapdata:BitmapData;
		
		public static var status_list:Array = [];
		
		/**
		 * 方向04567
		 */		
		public var direct:int = 0;
		
		public function SingleDirectionImage(bmd:BitmapData)
		{
			bitmapdata = bmd;
			
		}
	}
}