package net
{
	/**
	 * 协议类 
	 * @author Administrator
	 * 
	 */	
	public class NProtocol
	{
		public function NProtocol()
		{
		}
		
		private var _type:int = 0;
		private var _body:Object = null;
		private var _destroyed:Boolean = false;
		private var _length:int = 0;
		
		
		public function get destroyed():Boolean
		{
			return _destroyed;
		}
		
		public function set destroyed(value:Boolean):void
		{
			_destroyed = value;
		}
		
		/**
		 * @param value
		 */		
		public function set body(value:Object):void
		{
			_body = value;
		}
		
		public function get body():Object
		{
			return _body;
		}
		
		/**
		 * @return 协议号
		 */
		public function get type():int
		{
			return _type;
		}
		
		public function set type(value:int):void
		{
			_type = value;
		}

		public function get length():int
		{
			return _length;
		}

		public function set length(value:int):void
		{
			_length = value;
		}

	}
}