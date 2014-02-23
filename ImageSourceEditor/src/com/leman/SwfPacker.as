package com.leman
{
	import com.leman.data.ImageInfo;
	import com.leman.data.SingleDirectionImage;
	import com.leman.load.LoadData;
	import com.leman.load.LoaderManager;
	import com.leman.view.ControlPanel;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	
	import mx.graphics.codec.PNGEncoder;
	
	import br.com.stimuli.loading.BulkLoader;
	import br.com.stimuli.loading.loadingtypes.ImageItem;

	/**
	 *	sc处理器，每调用一次createSWF，即生成一个sc的一个 swf文件
	 * @author Administrator
	 * 
	 */	
	public class SwfPacker extends EventDispatcher
	{
		public static const CREATE_SWF_COMPLETE:String = 'CREATE_SWF_COMPLETE';
		
		private var _dir:File;				//一个场景对象的根目录
		private var scName:String;			//sc名称
		private var actionFolders:Array = [];	//保存一个sc所有动作文件夹
		private var loadIndex:int = 0;		//顺序处理动作文件夹，loadIndex指向actionFiles索引
		
		private var currFolder:File;	//当前文件夹
		
		private var row:int = 0;   //方向维数 
		private var col:int = 0;  //一个方向动画帧数
		
		public var localX:Number = 42;
		public var localY:Number = 55;
		public var playTime:int = 0;//播放时间
		public var registerPoint:int = 0;//0表示原点，1表示注册点
		
		private var actionBmd:BitmapData;
		
		public function SwfPacker($dir:File = null)
		{
			if($dir != null)
			{
				this._dir = $dir;
			}
		}
		
		private var xmlStr:String;
		
		private var info:Object;		//时间设置 
		
		private var swfData:String;
		//动作字符串
		private var actionStr:String = "";
		
		public function createSWF($dir:File, $info:Object):void
		{
			this.info = $info;
			actionStr = "";
			this.loadIndex = 0;
			this._dir = $dir;
			this.scName = _dir.name;
			this.actionFolders = $dir.getDirectoryListing();
			var i:int = 0, len:int = this.actionFolders.length, tFile:File;
			for (;i<len;i++)
			{
				tFile = actionFolders[i];
				if (tFile.isDirectory && actionTypeArr.indexOf(tFile.name) != -1)
				{
					actionStr += ("'"+tFile.name+"'"+",");
				}
			}
			if (actionStr.length > 0)
				actionStr = actionStr.substr(0,actionStr.length-1);
//			swfData = "package\n{\n\timport flash.display.MovieClip;\n\timport flash.system.Security;\n\n\tpublic class " + this._dir.name + " extends MovieClip\n\t{\n\t\tpublic static const STATUS_LIST:Array = [";
			xmlStr = "" ;
			
			loadactionfolder(this.actionFolders[loadIndex++]);
		}
		
		private var actionTypeArr:Array = ['death','walk','skill','attack','injured','stand','sit','skill1'];
		/**
		 *	加载一个动作文件夹 
		 * @param folder
		 * 
		 */		
		private function loadactionfolder(folder:File):void
		{
			if (folder.isDirectory == true)
			{
				if( actionTypeArr.indexOf(folder.name) == -1){
					trace("可能错误了");
				}
				this.loadExecute(folder);
			}else{
				loadactionfolder(this.actionFolders[loadIndex++]);
			}
		}
		
		/**
		 *	加载一个动作所有图片 
		 * @param actionFile
		 * 
		 */		
		private function loadExecute(actionFolder:File):void
		{
			this.currFolder = actionFolder;
			this.actionImages = [];
			
			var file:File;
			var loadData:LoadData;
			var extension:String;
			var loaderArr:Array = [];
			var files:Array = actionFolder.getDirectoryListing();
			var bulkLoader:BulkLoader = LoaderManager.creatNewLoader("actionImageLoader" + this.loadIndex, this.loadComplete, this.loadUpdate);
			var num:int = files.length;
			for(var i:int = 0; i < num; i++)
			{
				file = files[i];
				extension = file.extension.toLowerCase();
				if(extension ==  'jpg' || extension == 'png' || extension == 'gif')
				{
					loadData = new LoadData(file.url, this.itemLoadComplete, null, itemLoadError);
					loaderArr.push(loadData);
				}
			}
			LoaderManager.load(loaderArr,bulkLoader);
		}
		
		private var actionImages:Array = [];		//一个动作的所有图片
		
		
		/**
		 *	创建单个动作图片和as文件 
		 * @param actionFile
		 * 
		 */	
		private function createSingleImageInfo():void
		{
			createImage();
			xmlStr = createXmlStr(this.currFolder.name);
			//保存有哪些动作
//			swfData = swfData + this.currFolder.name + ",";
			
			createBmdClass(this.currFolder.name);
		}
		
		private function createBmdClass(fileName:String):void
		{
			/*var str:String = "﻿package " + this._dir.name + "\n{\n\timport " +
				"flash.display.BitmapData;\n\n\t" +
				"dynamic public class " + fileName + " extends BitmapData\n\t{\n\t\t " +
				"public function " + fileName + "(param1:int = " + this.actionBmd.width +", param2:int = " + this.actionBmd.height +")\n\t\t{\n\t\t\t" +
				"super(param1, param2);" +
				"\n\t\t\treturn;" +
				"\n\t\t}" +
				"\n\t}\n}";*/
			
			var str:String = '﻿package ' + this._dir.name +
'\n{'+
'\n    import flash.display.MovieClip;'+
'\n    import flash.system.Security;'+
'\n'+
'\n    public class '+ fileName +' extends MovieClip'+
'\n    {'+
'\n        public static const STATUS_LIST:Array = ['+actionStr+'];'+
'\n        public static const X_M_L:XML = '+xmlStr+';'+
'\n        public function '+ fileName +'()'+
'\n        {'+
'\n            addFrameScript(0, frame1);'+
'\n            return;'+
'\n        }'+
'\n'+
'\n        function frame1()'+
'\n        {'+
'\n            try'+
'\n            {'+
'\n                Security.allowDomain("*");'+
'\n            }'+
'\n            catch (e:Error)'+
'\n            {'+
'\n            }'+
'\n            return;'+
'\n        }'+
'\n    }'+
'\n}' ;
			xmlStr = "" ;
			var ws:FileStream = new FileStream();
			var file1:File ;
			var path:String = "" ;
			if( _dir.parent.parent.exists ){
				path = this._dir.parent.parent.url ;
			}else if( _dir.parent.exists ){
				path = this._dir.parent.url ;
			}else{
				path = this._dir.url ;
			}
			var fileName:String = path  + '/outcome/' + this._dir.name +'/' + fileName+ ".as";
			file1= new File(fileName);
			ws.open(file1,FileMode.WRITE);
			ws.writeUTFBytes(str);
			ws.close();
		}
		
//		private function createImage():void
//		{
//			
//		}
		
		/**
		 * 单个图片加载完成
		 * 
		 */		
		private function itemLoadComplete(event:Event):void
		{
			var bm:Bitmap;
			if (event.target is ImageItem)
			{
				bm = event.target.content as Bitmap;
				
				var imageInfo:ImageInfo = new ImageInfo(bm.bitmapData);
				var url:String = (event.target as ImageItem).url.url;
				var fileName:String = url.substring(url.lastIndexOf('/') + 1, url.indexOf('.'));
				var arr:Array = fileName.split('_');
				imageInfo.r = arr[0];
				imageInfo.frame = arr[1];
				this.actionImages.push(imageInfo);
			}
		}
		
		/**
		 * 加载出错
		 * 
		 */		
		private function itemLoadError(event:Event):void
		{
			trace('加载出错！');
		}
		
		/**
		 *	一个动作的所有图片加载完成 
		 */		
		private function loadComplete(event:Event):void
		{
			createSingleImageInfo();
			if(loadIndex >= this.actionFolders.length)
			{
//				swfData = swfData.substr(0, swfData.length-1);
				finishedLoaded();
			}
			else
			{
				loadactionfolder(this.actionFolders[loadIndex++]);
			}
		}
		
		/**
		 * 	param node	动作名称	walk、stand、death等等
		 */ 
		private function createXmlStr(node:String):String
		{
			var intervalTime:int;
			if(this.info.type == ControlPanel.TIME_INTERVAL)
			{
				intervalTime = int(this.info.data);
			}
			else
			{
				intervalTime = this.info.data[node];
			}
			
			var tempStr:String = "<s k='" + node + "' a='8' t='" + intervalTime +"' f='" + col + "'>";
			var len:int = this.actionImages.length, j:int = 0, frame:int = 0, dirArr:Array;
			
			var a:int;
			var sy:int;
			var tempTx:Number = 0;
			var tempTy:Number = 0;
			if (registerPoint==1)
			{
				//中心点的时候，直接取新图片的中心坐标
				localX = maxRect.w >> 1;
				localY = maxRect.h >> 1;
			}
			for(var i:int = 0; i < len; i++)
			{
				frame = actionImages[i].length;
				dirArr = actionImages[i];
				for (j=0;j<frame;j++)
				{
					if (registerPoint == 2)
					{
						tempTx = dirArr[j]['tx'];
						tempTy = dirArr[j]['ty'];
					}
					tempStr += "\t<p a='" + dirArr[j]['r'] + "' f='" + dirArr[j]['frame'] + "' sx='" + dirArr[j].sx + "' sy='" + dirArr[j].sy + "' w='" + dirArr[j]['min_w'] + "' h='" + dirArr[j]['min_h'] + "' tx='" + (localX-tempTx) + "' ty='" + (localY-tempTy) + "' ox='0' oy='0'/>";
				}
			}
			tempStr += '</s>';
			return tempStr;
		}
		
		/**
		 *	一个sc的所有图片处理完成后的善后工作 
		 * 
		 */		
		private function finishedLoaded():void
		{
			
			// 生成 mid3.as 文件
//			swfData += "];\n\t\tpublic function " + this._dir.name + "()\n\t\t{\n\t\t\taddFrameScript(0, frame1);\n\t\t\treturn;\n\t\t}\n\n\t\tfunction frame1()\n\t\t{\n\t\t\ttry\n\t\t\t{\n\t\t\t\tSecurity.allowDomain('*');\n\t\t\t}\n\t\t\tcatch (e:Error)\n\t\t\t{\n\t\t\t}\n\t\t\treturn;\n\t\t}\n\t}\n}" ;
		
//			var ws:FileStream = new FileStream();
//			var file1:File ;	
//			var fileName:String = this._dir.parent.url  + '/outcome/' + this._dir.name + ".as";//
//			file1= new File(fileName);
//			ws.open(file1,FileMode.WRITE);
//			ws.writeUTFBytes(swfData);
//			ws.close();
			
			this.dispatchEvent(new Event(CREATE_SWF_COMPLETE));
		}
			
		
		/**
		 *	一个动作的所有图片加载进行时
		 */		
		private function loadUpdate(event:Event):void
		{
			
		}
		
		private var maxRect:Object = {w: 0, h : 0};
		private function  getMaxWH(index:int):void
		{
			var tar:Array = actionImages[index];
			maxRect.w = 0;
			maxRect.h = 0;
			for each(var item:Object in tar)
			{
				if(item['min_w'] > maxRect['w']){
					maxRect['w'] = item['min_w'];
				}
				if(item['min_h'] > maxRect['h']){
					maxRect['h'] = item['min_h'];
				}
			}
		}
		
		private function reset():void
		{
			this.actionImages = [];
			row = 0;
			col = 0;
			maxRect.w = 1;
			maxRect.h = 1;
		}
		
		/**
		 * 根据图片文件名获取row x col
		 * imgName ：[ row_col ]
		 */ 
		private function getRowCol():void
		{
			this.row = 0;
			this.col = 0;
			var tempRow:Array = [], tempCol:Array = [];
			for each(var item:Object in this.actionImages)
			{
				if(tempRow.indexOf(item['r']) == -1){
					row++;
					tempRow.push(item['r']);
				}
				if(tempCol.indexOf(item['frame']) == -1){
					col++;
					tempCol.push(item['frame']);
				}
			}
			row = row < 1 ? 1 : row;
			col = col < 1 ? 1 : col;
		}
		
		/**
		 *  根据方位(r)、帧(frame)排列imgInfoArr, r从小到大， frame从小到大
		 */ 
		private function sortByRFrame():void
		{
			var len:int = actionImages.length;
			var temp:ImageInfo;
			for(var i:int = 0; i < len - 1; i++)
				for(var j:int = i + 1; j < len; j++)
				{
					if(actionImages[i]['r'] > actionImages[j]['r']){
						temp = actionImages[i];
						actionImages[i] = actionImages[j];
						actionImages[j] = temp;
					}else if(actionImages[i]['r'] == actionImages[j]['r']){
						if(actionImages[i]['frame'] > actionImages[j]['frame'])
						{
							temp = actionImages[i];
							actionImages[i] = actionImages[j];
							actionImages[j] = temp;
						}
					}
				}
		}
		
		private function divideGroupImage():void
		{
			var arr:Array = [];
			var i:int = 0, len:int = actionImages.length, last:int = -1, begin:int = 0;
			for (;i<len;i++)
			{
				if (last == -1){
					last = actionImages[i].r;
				}else if (actionImages[i].r != last || i == len - 1)
				{
					arr.push(actionImages.slice(begin,i == len - 1 ? len : i));
					last = actionImages[i].r;
					begin = i;
				}
			}
			actionImages = arr;
		}
		
		private function createImage():void
		{
//			reSetAllParam();
			getRowCol();
			sortByRFrame();
			divideGroupImage();
			
//			var bmd:BitmapData;
			var len:int = actionImages.length,i:int = 0, j:int = 0;
			var info:ImageInfo, directArr:Array = [], tempInfo:SingleDirectionImage;
			var tempBmd:BitmapData, dirArr:Array;
			//每个方向单独生成一张图片
			if(row == 1 && actionImages[0].length > 10)		//如果只有一个方向，并且图片的数量超过10
			{
				getMaxWH(0);
				dirArr = actionImages[0];
				len = dirArr.length;
				var tempCol:int = Math.ceil(len >> 1);
				tempBmd = new BitmapData(maxRect.w * tempCol, maxRect.h << 1,true,0x00ff0000);
				tempInfo = new SingleDirectionImage(tempBmd);
				directArr.push(tempInfo);
				var count:int = 0;
				var currIndex:int = 0;
				var widthTotal:int = 0;
				
				for(i; i < len; i++)
				{
					info = i % 2 == 0 ? dirArr[int(i >> 1)] : dirArr[len - 1 - int(i >> 1)];
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
					tempBmd.copyPixels(info.bmd,new Rectangle(0,0,info.bmd.width, info.bmd.height), new Point(info.sx,info.sy));
//					copyImg(tempBmd,info,i);
				}
				var rect:Rectangle = tempBmd.getColorBoundsRect(0xFF000000,0x00000000,false);
				actionBmd = new BitmapData(rect.width, rect.height, true, 0xff0000);
				actionBmd.copyPixels(tempBmd,rect,new Point(0,0));
			}
			else
			{
				var totalWidth:int = 0, sx:int = 0;
				for (;i<row;i++)
				{
					getMaxWH(i);
					dirArr = actionImages[i];
					len = dirArr.length;
					totalWidth = getDirecTotalWidth(dirArr);
					actionBmd = new BitmapData(totalWidth, maxRect.h,true,0x00ff0000);
					tempInfo = new SingleDirectionImage(actionBmd);
					directArr.push(tempInfo);
					tempInfo.direct = i == 0 ? 0 : (i + 3);
					sx = 0;
					//复制某方向的所有帧图片
					for(j = 0; j < len; j++)
					{
						info = dirArr[j];
						info.sx = sx;
						info.sy = 0;
						actionBmd.copyPixels(info.bmd,new Rectangle(0,0,info.bmd.width, info.bmd.height), new Point(info.sx,info.sy));
						sx += info.min_w;
					}
				}
			}
			
			
			if (this.actionImages.length > 0)
			{
				var ws:FileStream = new FileStream();
				var file1:File ;	
				var path:String = "" ;
				if( _dir.parent.parent.exists ){
					path = this._dir.parent.parent.url ;
				}else if( _dir.parent.exists ){
					path = this._dir.parent.url ;
				}else{
					path = this._dir.url ;
				}
				var pngenc:PNGEncoder = new PNGEncoder();
				var imgByteArray:ByteArray;
				var fileName:String, baseName:String = path  + '/outcome/' + this._dir.name + '/' +this.currFolder.name +'/'+this.currFolder.name+ "$.png" ;
				i = 0, j = directArr.length;
				for (;i<j;i++)
				{
					fileName = baseName.replace("$",directArr[i].direct);
					file1= new File(fileName);
					ws.open(file1,FileMode.WRITE);
					imgByteArray = pngenc.encode(directArr[i].bitmapdata);
					ws.writeBytes(imgByteArray,0,imgByteArray.bytesAvailable);
					ws.close();
				}
				file1 = null;
			}
		}
		
		/**
		 * 获取某个方向上的总的宽度
		 * @param tar
		 * 
		 */		
		private function getDirecTotalWidth(tar:Array):int
		{
			var i:int = 0, len:int = tar.length, total:int = 0;
			for (;i<len;i++)
			{
				total += tar[i].min_w;
			}
			return total;
		}
	}
}