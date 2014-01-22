package com.thinkido.framework.net
{
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	import org.osflash.thunderbolt.Logger;
	
	/**
	 * 协议对应规则：  1: Byte					2: Short
	 * 				 3: UnsignedInt			4: Int
	 * 				 5: UTFBytes			6: UnsignedShort():uint
	 */
	/**
	 * 
	 * @author thinkido
	 * @example 例子的说明性文字
		<listing version="3.0">		
		 * 发送消息
			var testPro:TProtocol = new TProtocol();
			testPro.type = 1052 ;
			testPro.rule = [2,2,4,4,16,16,2,4,2,2] ;
			testPro.data = [1052,9999,"350"," ",1,1,1,1] ; 			
			NetWorkManager.getInstance().sendMsg(testPro); 
			 * 
			 * 
		接收消息
		 * CenterEventDispatcher.getInstance().addEventListener("1052",onData);
		 * 
		 * private function onData(event:ProtocalEvent):void
			{
				var pro:TProtocol = event.data as TProtocol ;
				pro.rule =  [2,2,4,4,16,16,2,4,2,2] ;   //rule 内容根据协议定，
				var data:Array = pro.data ;
			}
		</listing>
	 */	
	public class TProtocol implements IProtocol
	{ 
		private var _length:uint ;
		private var _type:* ;
		private var _body:ByteArray ;
		private var _data:Array ;
		
		private var _rule:Array ;
		private var _content:String ="";
		
		public function TProtocol()
		{
			
		}
		/**
		 * 返回协议包内容长度 
		 * @return 
		 * 
		 */		
		public function get length():uint
		{
			_length = 7 + body.length ;
			return _length;
		}
		/**
		 *  获取协议号
		 * @return 协议号
		 * 
		 */
		public function get type():*
		{
			return _type;
		}
		/**
		 * 设置
		 * @param value 协议号
		 * 整形或者字符串
		 */		
		public function set type(value:*):void
		{
			_type = value;
		}
		/**
		 	获取协议字节内容 
		 * @return 协议字节内容 
		 * 
		 */		
		private function get_body():ByteArray
		{
			if( !_body){
				_body = new ByteArray();
				_body.endian = Endian.LITTLE_ENDIAN ;
				
				if( _data && rule ){
					if(_data.length != rule.length ){
						Logger.error("协议错误：",type);
					}
					
					var len:int = rule.length;
					for (var i:int = 0; i < len; i++) 
					{
						switch(rule[i]){
							case 1:
								_body.writeByte(_data[i]);
								break;
							case 2:
								_body.writeShort(_data[i]);
								break;
							case 3:
								_body.writeUnsignedInt(_data[i]);
								break;
							case 4:
								_body.writeInt(_data[i]);
								break;	
							case 5:
								var temp:int = _body.position ;
								_body.writeMultiByte(_data[i],"gb2312");
								_body.position = temp + 16 ;
//								SystemUtil.writeUTFBytesBylen(_body,_data[i],16);
//								_body.writeUTFBytes(_data[i]);
								break;
							case 6:		
//								UnsignedShort():uint
							default :
								Logger.error("协议输入错误");
								break;
						}
					}
				}
			}
			return _body;
		}
		
		/**
		 * 获取协议字节内容 
		 * @param value 协议字节内容 
		 * 
		 */	
		public function get body():ByteArray
		{
			if( !_body){
				_body = new ByteArray();
				_body.endian = Endian.LITTLE_ENDIAN ;
			}
			return _body;
		}
		public function set body(value:ByteArray):void
		{
			_body = value ;
		}
		/**
		 * 获取协议规则
		 * @return 协议规则
		 * 
		 */	
		public function get rule():Array
		{
			return _rule;
		}
		/**
		 * 设置协议传输、解析规则
		 * @param value 协议规则
		 * 
		 */		
		public function set rule(value:Array):void
		{
			_rule = value;
		}
		
		/**
		 * 发送请求时，设置协议数据 
		 * @param value
		 * 
		 */		
		public function set data(value:*):void
		{
			_data = value;
			_body = get_body();
		}
		
		/**
		 *  
		 * @return 根据规则将字节内容解析为数组
		 * 
		 */		
		public function get data():*
		{
			if( _body  && rule ){
				_body.position = 0 ;
				_data = [] ;
				var len:int = rule.length;
				_body.position = 0;
				for(var i:int = 0; i < len; i++)
				{
					switch(rule[i]){
						case 1:
							_data[i] = _body.readByte();
							break;
						case 2:
							_data[i] = _body.readShort();
							break;
						case 3:
							_data[i] = _body.readUnsignedInt();
							break;
						case 4:
							_data[i] = _body.readInt();
							break;	
						case 5:
							_data[i] = _body.readMultiByte(16,'gb2312');
							break;
						case 6:
							_data[i] = _body.readUnsignedShort();
							break;
						default :
							Logger.error("协议解析错误");
							break;
					}
				}
			}
			return _data;
		}
		/**
		 * 打印信息，以便开发 
		 * @return 传输内容
		 * 
		 */	
		public function get content():String
		{
			return _content;
		}
		public function set content(value:String):void
		{
			_content = value;
		}

	}
}