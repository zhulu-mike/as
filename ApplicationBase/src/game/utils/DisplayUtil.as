package game.utils
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.IBitmapDrawable;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class DisplayUtil
	{
		public function DisplayUtil()
		{
		}
		
		/**
		 * 根据表达式找到一个DisplayObjectContainer中的显示对象
		 * @param main
		 * @param express 比如topPanel.getChildAt-1.getButton
		 * @return 
		 * 
		 */		
		public static function getObjectByExpress(main:DisplayObjectContainer, express:String):DisplayObject
		{
			var ret:DisplayObject = main;
			var contain:Array = express.length > 0 ? express.split(".") : [];
			var len:int = contain.length, i:int = 0;
			var params:Array, func:*;
			for (;i<len;i++)
			{
				params = contain[i].split("-");//拆分参数,如果有参数，params数组不为空
				if (!ret.hasOwnProperty(params[0]))
					break;
				if (ret[params[0]] is Function)
				{
					func = ret[params[0]];
					if (params.length == 1)
						ret = func();
					else if (params.length == 2)
						ret = func(params[1]);
					else if (params.length == 3)
						ret = func(params[1], params[2]);
					else if (params.length == 4)
						ret = func(params[1], params[2], params[3]);
				}else if (ret[params[0]] is Array)
				{
					ret = ret[params[0]][params[1]];
				}else
				{
					ret = ret[params[0]];
				}
			}
			return ret;
		}
		
		/**
		 * 把一个显示对象切成碎片
		 * @param display要切割的显示对象
		 * @param rowHeight 碎片的高度
		 * @param columWidth 碎片的宽度
		 */		
		public static function cutDisplayObject(display:DisplayObject,rowHeight:int=5,columWidth:int=5):Array
		{
			var fragData:BitmapData = new BitmapData(display.width,display.height,true,0x000000);
			fragData.draw(display);
			var width:Number = display.width;
			var height:Number = display.height;
			var row:int = Math.ceil(height/rowHeight);
			var col:int = Math.ceil(width/columWidth);
			var i:int=0,j:int=0;
			var ret:Array = [], temp:BitmapData;
			var middleI:int = col >> 1;
			var middleJ:int = row >> 1;
			for (;i<col;i++)
			{
				for(j=0;j<row;j++)
				{
					temp = new BitmapData(columWidth,rowHeight,true,0x000000);
					temp.copyPixels(fragData, new Rectangle(i*columWidth,j*rowHeight,columWidth,rowHeight),
						new Point());
					ret.push({bitmapData:temp, offx:(i-middleI)*2,offy:(j-middleJ)*2,x:i*columWidth,y:j*rowHeight});
				}
			}
			
			return ret;
			
		}
	}
}