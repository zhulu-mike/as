package com.leman.data
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class ImageInfo
	{
		public var _width:int;
		public var _height:int;
		
		public var r:int;     //方位
		public var frame:int; //帧索引
		
		public var sx:int;  //起始x坐标    新生成图片的x
		public var sy:int;	//新生成图片的y
		
		public var tx:int;  //x偏移 		原单帧图片中的x
		public var ty:int;	//y偏移 		原单帧图片中的y
		
		public var min_w:int;  //非透明区域宽度
		public var min_h:int;
		
		public var bmd:BitmapData;  //非透明像素数据

		public function ImageInfo($bmd:BitmapData)
		{
			var rect:Rectangle = $bmd.getColorBoundsRect(0xFF000000,0x00000000,false);
			this.tx = rect.x;
			this.ty = rect.y;
			this.min_w = rect.width;
			this.min_h = rect.height;
			this.bmd = new BitmapData(rect.width,rect.height,true,0xff0000);
			this.bmd.copyPixels($bmd,rect,new Point(0,0));
//			this.bmd.copyPixels(bmd,new rect,new Point(0,0));
//			var tempArr:Array = image.name.split('_');
//			this.r = int(tempArr[0]);
//			this.frame = int(tempArr[1]);
		}
	}
}