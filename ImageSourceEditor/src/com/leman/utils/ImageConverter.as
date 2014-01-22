package com.leman.utils
{
	import mx.controls.Image;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	
	import com.leman.data.ImageInfo;
	import helper.bmpdHelper;
	import com.leman.data.ImageInfo;
	
	public class ImageConverter
	{
		private var row:int = 0;   //方向维数 
		private var col:int = 0;  //一个方向动画帧数
		private var imageArr:Array = [];  //待转换图片数组
		private var imgInfoArr:Array = [];
		
		public function ImageConverter(arr:Array)
		{
			imageArr = arr;
		}
		
		public static function create():void
		{
			
		}
		
		/**
		 * 获取所有小图片的信息
		 */
		private function getImageInfo(imgArr:Array):void
		{
			var imgInfo:ImageInfo;
			for each(var image:Image in imgArr)
			{
				imgInfo = new ImageInfo();
				imgInfoArr.push(imgInfo);
				getImgInfo(imgInfo,image);
			}
		}
		
		/**
		 * 获取单个小图片的信息
		 */
		private function getImgInfo(imgInfo:ImageInfo,image:Image):void
		{
			var bmd:BitmapData = image.content['bitmapData'];
			var arr:Array = bmpdHelper.getImgProp(bmd);
			imgInfo.tx = arr[0];
			imgInfo.ty = arr[1];
			imgInfo.min_w = arr[2];
			imgInfo.min_h = arr[3];
			imgInfo.bmd = new BitmapData(arr[2],arr[3]);
			imgInfo.bmd.copyPixels(bmd,new Rectangle(arr[0],arr[1],arr[2],arr[3]),new Point(0,0));
			var tempArr:Array = image.name.split('_');
			imgInfo.r = int(tempArr[0]);
			imgInfo.frame = int(tempArr[1]);
		}
		
		/**
		 * 根据图片文件名获取row x col
		 * imgName ：[ row_col ]
		 */ 
		private function getRowCol():void
		{
			for each(var item:Object in imgInfoArr)
			{
				if(item['r'] >= row){
					row = item['r'] + 1;
				}
				if(item['frame'] >= col){
					col = item['frame'] + 1;
				}
			}
		}
		
		
		private var maxRect:Object = {w: 0, h : 0};
		private function  getMaxWH():void
		{
			for each(var item:Object in imgInfoArr)
			{
				if(item['min_w'] > maxRect['w']){
					maxRect['w'] = item['min_w'];
				}
				if(item['min_h'] > maxRect['h']){
					maxRect['h'] = item['min_h'];
				}
			}
		}
		
		/**
		 *  根据方位(r)、帧(frame)排列imgInfoArr
		 */ 
		private function sortByRFrame():void
		{
			var len:int = imgInfoArr.length;
			var temp:ImageInfo;
			for(var i:int = 0; i < len - 1; i++)
			{
				for(var j:int = i + 1; j < len; j++)
				{
					if(imgInfoArr[i]['r'] > imgInfoArr[j]['r']){
						temp = imgInfoArr[i];
						imgInfoArr[i] = imgInfoArr[j];
						imgInfoArr[j] = temp;
					}else if(imgInfoArr[i]['r'] == imgInfoArr[j]['r']){
						if(imgInfoArr[i]['frame'] > imgInfoArr[j]['frame'])
						{
							temp = imgInfoArr[i];
							imgInfoArr[i] = imgInfoArr[j];
							imgInfoArr[j] = temp;
						}
					}
				}
			}
		}
		
		private function createSingleImage(voo:ActionVO):void
		{
			var imgArr:Array = voo.tempArr;
			reSetAllParam();
			getImageInfo(imgArr);
			getRowCol();
			getMaxWH();
			sortByRFrame();
			
			var bmd:BitmapData;
			var len:int = imgInfoArr.length;
			var info:ImageInfo;
			
			var tempBmd:BitmapData;
			if(row == 1 && len > 10)		//如果只有一个方向，并且图片的数量超过10
			{
				
				var tempCol:int = Math.ceil(len / 2);
				tempBmd = new BitmapData(maxRect.w * tempCol, maxRect.h * 2,true,0x00ff0000);
				var count:int = 0;
				var currIndex:int = 0;
				var widthTotal:int = 0;
				for(var i:int = 0; i < len; i++)
				{
					info = i % 2 == 0 ? imgInfoArr[int(i / 2)] : imgInfoArr[len - 1 - int(i / 2)];
					if(i % tempCol == 0)
					{
						info.sx = 0;
						widthTotal = info.min_w;
						
					}else
					{
						info.sx = widthTotal;
						widthTotal += info.min_w;
					}
					//						info.sx = i % tempCol * maxRect.w;
					info.sy = int(i / tempCol) * maxRect.h;
					copyImg(tempBmd,info,i);
				}
				var rect:Rectangle = tempBmd.getColorBoundsRect(0xFF000000,0x00000000,false);
				bmd = new BitmapData(rect.width, rect.height, true, 0xff0000);
				bmd.copyPixels(tempBmd,rect,new Point(0,0));
			}
			else
			{
				bmd = new BitmapData(maxRect.w * col, maxRect.h * row,true,0x00ff0000);
				for(var i:int = 0; i < len; i++)
				{
					info = imgInfoArr[i];
					info.sx = i % col * maxRect.w;
					info.sy = int(i / col) * maxRect.h;
					copyImg(bmd,info,i);
				}
			}
			
			
			var pngenc:PNGEncoder = new PNGEncoder();
			var imgByteArray:ByteArray = pngenc.encode(bmd);
			//				imgByteArray.compress('deflate');
			//				var pngenc2:JPEGEncoder = new JPEGEncoder(80);
			//				var imgByteArray:ByteArray = pngenc2.encode(bmd);
			//				imgByteArray2.compress();
			//				voo.bitmapByte = imgByteArray2;//org.libspark.swfassist.image.MyPNGEncoder.getIDATData(bmd);
			//				i=0;
			//				var j:int = 0, w:int = bmd.width, h:int = bmd.height, co:uint, al:uint;
			//				for (;i<h;i++)
			//				{
			//					for (j=0;j<w;j++)
			//					{
			//						co = bmd.getPixel32(j,i);
			//						al = co >> 24;
			//						voo.bitAlphaByte.writeByte(al & 0xff);
			//					}
			//				}
			//				voo.bitAlphaByte.compress();
			
			//				voo.height = maxRect.h * row;
			//				voo.width = maxRect.w * col;
			if (imgArr.length > 0)
			{
				var ws:FileStream = new FileStream();
				var file1:File ;	
				var fileName:String = rootFile.url  + '/outcome/' + currentDir.fileName + '/' + imgArr[0].data + ".png";
				file1= new File(fileName);
				ws.openAsync(file1,FileMode.WRITE);
				ws.writeBytes(imgByteArray,0,imgByteArray.bytesAvailable);
				ws.close();
			}
		}
	}
}