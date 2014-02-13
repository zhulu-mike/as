package com.thinkido.framework.net
{
	import com.adobe.serialization.json.JSON;
	
	import flash.utils.ByteArray;
	
	public class SProtocol extends TProtocol
	{
		/**
		 *序列化方式 
		 */		
		private var _sType:int = 2 ;
		private var _data:* = "" ;
		private var _external:int = 0 ;
		
		public function SProtocol()
		{
		}
		
		/**
		 * @return 序列化方式,json格式或者...
		 */		
		public function get sType():int
		{
			return _sType;
		}
		
		public function set sType(value:int):void
		{
			_sType = value;
		}

		public function get external():int
		{
			return _external;
		}

		public function set external(value:int):void
		{
			_external = value;
		}
		
		/**
		 * 不包含协议头 
		 * @return 
		 * 
		 */
		public override function get length():uint
		{
			//TODO Auto-generated method stub
			return body.length;
		}
		
		/**
		 * 当从服务器返回数据时data 为object 
		 * @return 
		 * 
		 */		
		public override function get data():*
		{
			return _data;
		}

		public override function set data(value:*):void
		{
			if( typeof(value) is Object){
				value = com.adobe.serialization.json.JSON.encode(value);
				content = value ;
			}
			_data = value;
		}


		public override function set body(value:ByteArray):void
		{
			//TODO Auto-generated method stub
			_data = value.readMultiByte(value.length,"utf-8");
			content = _data;
			_data = com.adobe.serialization.json.JSON.decode(_data);
			super.body = value;
		}


		public override function get body():ByteArray
		{
			//TODO Auto-generated method stub
			return super.body;
		}


	}
}