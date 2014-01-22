package helper
{
	import flash.display.BitmapData;
	
	public class bmpdHelper
	{
		public function bmpdHelper()
		{
		}
		
		/**
		 * 取得单个图片的非透明区域矩形的偏移、长宽
		 *  return : [offset_X, offset_Y, width, height]
		 */ 
		public static function getImgProp(bmd:BitmapData):Array
		{				
			var _width:int = bmd.width;
			var _height:int = bmd.height;
			
			var top:int = 0;
			var bottom:int = 0;
			var left:int = 0;
			var right:int = 0;
			
			var isFirst:Boolean = false;
			for(var i:int = 0; i < _width; i++)
			{					
				for(var j:int = 0; j < _height; j++)
				{
					if(bmd.getPixel32(i,j) & 0xFF000000)
					{ 
						if(isFirst == false){
							isFirst = true;
							top = j;
							left = i;
						}
						
						if(i < left){
							left = i;
						}else if(i > right){
							right = i;
						}
						if(j < top){
							top = j;
						}else if(j > bottom){
							bottom = j;
						}
					}
				}
			}
			return [left,top,right - left + 1, bottom - top + 1];
		}
	}
}