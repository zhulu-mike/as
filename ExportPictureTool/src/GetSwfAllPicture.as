package 
{
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	/**
	* swf信息工具类
	*/ 
	public class GetSwfAllPicture
	{
		private static var bytes:ByteArray;
		private static var className:Array ;
		private static var tagNum:int ;
		
		/**
		* 获取一个swf中的类
		* @param swfBytes
		* @return 
		* 
		*/  
		public static function getSWFImages(swfBytes:ByteArray):Array
		{
			tagNum = 0 ;
			className = [];
			
			bytes = new ByteArray();
			bytes.writeBytes(swfBytes);
			bytes.position = 0;
			bytes.endian = Endian.LITTLE_ENDIAN ;

			var compressModal:String ;

			compressModal = bytes.readUTFBytes(3);
			if (compressModal != "FWS" && compressModal != "CWS") {
				throw new Error("不能识别的SWF文件格式");
			}
			bytes.readByte()
			bytes.readUnsignedInt();
			bytes.readBytes(bytes);
			bytes.length = bytes.length - 8;

			if (compressModal == "CWS") {
				bytes.uncompress();
			}
			bytes.position=13

			var tag:int;
			var tagFlag:int;
			var tagLength:int;

			var tagBytes:ByteArray ;
			while (bytes.bytesAvailable) {
				readSWFTag(bytes);
			}
			return className.splice(0,className.length);
		}
		
		private static function readSWFTag(tagBytes:ByteArray):void 
		{
			var tag:int=tagBytes.readUnsignedShort();
			//   tracer("tag = " + tag);
			var tagFlag:int=tag >> 6;
			var tagLength:int=tag & 63;   
			if ((tagLength & 63 )== 63) {
				tagLength = tagBytes.readInt();
			}
			var tagContent:ByteArray;
			if (tagFlag == 36) {//TAG_DEFINE_BITS_LOSSLESS2
				tagContent =new ByteArray () ;
				tagContent.endian = Endian.LITTLE_ENDIAN;
				if (tagLength != 0) {
					tagBytes.readBytes(tagContent,0,tagLength);
				}
				readDefineBitsLossless2(tagLength, tagContent);
			} else if (tagFlag == 20) {//TAG_DEFINE_BITS_LOSSLESS
				tagContent = new ByteArray () ;
				tagContent.endian = Endian.LITTLE_ENDIAN;
				if (tagLength != 0) {
					tagBytes.readBytes(tagContent,0,tagLength);
				}
				
				readDefineBitsLossless(tagLength, tagContent);
			}else if (tagFlag == 35) {//TAG_DEFINE_BITS_LOSSLESS
				tagContent = new ByteArray () ;
				tagContent.endian = Endian.LITTLE_ENDIAN;
				if (tagLength != 0) {
					tagBytes.readBytes(tagContent,0,tagLength);
				}
				
				readDefineBitsJPEG3(tagLength, tagContent);
			} else {
				tagBytes.position=tagBytes.position + tagLength;
			}
		}
		
		public static function readDefineBitsLossless2(length:int, input:ByteArray):ByteArray
		{
			
//			var tag:int=input.readUnsignedShort();
//			input.position -= 2;
//			
//			var length:uint = input;
			trace(input.position);
			var characterId:uint = input.readUnsignedShort();
			var bitmapFormat:uint = input.readUnsignedByte();
			var bitmapWidth:uint = input.readUnsignedShort();
			var bitmapHeight:uint = input.readUnsignedShort();
			var ret:ByteArray = new ByteArray();
			var vo:Object = {width:bitmapWidth, height:bitmapHeight, type:36};
			if (bitmapFormat == 3) {
				var colorTableSize:uint = input.readUnsignedByte();
//				if (context.needsBitmapData) {
					var bytes:ByteArray = new ByteArray();
					if ((length - 8) > 0) {
						input.readBytes(bytes, length - 8);
						bytes.uncompress();
					}
					var table:Array = [];
					if (table.length != colorTableSize) {
						table.length = colorTableSize;
					}
					for (var i:uint = 0; i < colorTableSize; ++i) {
//						table[i] = readRGBA(bytes);
					}
					bytes.readBytes(ret);
					bytes.length = 0;
//				}
//				else {
//					input.skip(length - 8);
//				}
			}
			else {
//				if (context.needsBitmapData) {
					if ((length - 7) > 0) {
						input.readBytes(ret, 0, length - 7);
						ret.uncompress();
					}
//				}
//				else {
//					input.skip(length - 7);
//				}
			}
			vo.data = ret;
			className.push(vo);
			return ret;
		}
		
		public static function readDefineBitsLossless(length:int, input:ByteArray):ByteArray
		{
			trace(input.position);
			var characterId:uint = input.readUnsignedShort();
			var bitmapFormat:uint = input.readUnsignedByte();
			var bitmapWidth:uint = input.readUnsignedShort();
			var bitmapHeight:uint = input.readUnsignedShort();
			var ret:ByteArray = new ByteArray();
			var vo:Object = {width:bitmapWidth, height:bitmapHeight, type:20};
			if (bitmapFormat == 3) {
				var colorTableSize:uint = input.readUnsignedByte();
				var bytes:ByteArray = new ByteArray();
				if ((length - 8) > 0) {
					input.readBytes(bytes, length - 8);
					bytes.uncompress();
				}
				var table:Array = [];
				if (table.length != colorTableSize) {
					table.length = colorTableSize;
				}
				for (var i:uint = 0; i < colorTableSize; ++i) {
					//						table[i] = readRGBA(bytes);
				}
				bytes.readBytes(ret);
				bytes.length = 0;
			}
			else if (bitmapFormat == 5){
				if ((length - 7) > 0) {
					input.readBytes(ret, 0, length - 7);
					ret.uncompress();
					vo.data = ret;
					className.push(vo);
				}
			}
			return ret;
		}
		
		public static function readDefineBitsJPEG3(length:int, input:ByteArray):ByteArray
		{
			
			var characterId:int = input.readUnsignedShort();
			
			var alphaOffset:uint = input.readUnsignedInt();
			var jpegData:ByteArray = new ByteArray();
			var bitmapAlphaData:ByteArray = new ByteArray();
				if (alphaOffset > 0) {
					input.readBytes(jpegData, 0, alphaOffset);
					var len:int = jpegData.bytesAvailable / 8, i:int = 0;
					for (;i<len;i++)
					{
						trace(jpegData.readUnsignedByte());
					}
				}
				if (((length - 6) - alphaOffset) > 0) {
					input.readBytes(bitmapAlphaData, 0, (length - 6) - alphaOffset);
				}
			return null;
		}
		
		private static function getClass(tagBytes:ByteArray):void {
			var name:String;   
			var readLength:int = readUI16(tagBytes);
			var count:int=0;   
			while (count < readLength) {    
				readUI16(tagBytes);    
				name = readSwfString(tagBytes); 

				className.push(name);
				count++;
				tagNum++
				if(tagNum>400){
					return 
				}
			}
		}

		private static function readSwfString(tagBytes:ByteArray):String {
			var nameBytes:ByteArray;
			var length:int = 1;
			var num:int = 0;
			var name:String;
			while (true) {
				num = tagBytes.readByte();    
				if (num == 0) {
					nameBytes = new ByteArray () ;
					nameBytes.writeBytes(tagBytes,tagBytes.position - length,length);
					nameBytes.position = 0;
					name=nameBytes.readUTFBytes(length);
					break;
				}
				length++;
			}
			return name;
		}
		
		private static function readUI16(bytes:ByteArray):int {
			var num1:* =bytes.readUnsignedByte();
			var num2:* =bytes.readUnsignedByte();   
			return num1 +(num2 << 8);
		}
	}
}