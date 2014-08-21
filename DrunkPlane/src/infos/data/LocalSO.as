package infos.data {

	import flash.events.NetStatusEvent;
	import flash.net.ObjectEncoding;
	import flash.net.SharedObject;
	import flash.net.SharedObjectFlushStatus;
	import flash.system.Security;
	import flash.system.SecurityPanel;
	

	/**
	 * 本地共享对象类
	 * 
	 * @author bright
	 * @version 20101015
	 */
	public class LocalSO {
		private var _shareObject : SharedObject;
		public static var allow:Boolean = true;
		private function netStatusHandler(event : NetStatusEvent) : void {
			_shareObject.removeEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			switch(event.info.code) {
				case SharedObjectFlushStatus.FLUSHED:
					break;
				case SharedObjectFlushStatus.PENDING:
					if (allow)
						this.flush(1024*1024*20);
					break;
				case "SharedObject.Flush.Failed":
					allow = false;
					break;
			}
		}

		/**
		 * 构造函数
		 * 
		 * @param name 本地对象名称
		 */
		public function LocalSO(name : String) {
			_shareObject = SharedObject.getLocal(name);
			_shareObject.objectEncoding = ObjectEncoding.AMF3;
			_shareObject.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
		}

		public function showSetting() : void {
			Security.showSettings(SecurityPanel.LOCAL_STORAGE);
		}

		/**
		 * setAt 设置键值
		 * 
		 * @param key 键
		 * @param value 值
		 * @example 
		 * <listing version="3.0">
		 * var lso:LocalSO=new LocalSO("game");
		 * lso.setAt("key","value");
		 * lso.flush();
		 * </listing>
		 */
		public function setAt(key : String, value : Object) : void {
			if(value != null) {
				_shareObject.setProperty(key, value);
			} else {
				delete _shareObject.data[key];
			}
			_shareObject.flush();
		}

		/**
		 * getAt 获得键值
		 * 
		 * @param key 键
		 * @example 
		 * <listing version="3.0">
		 * var lso:LocalSO=new LocalSO("game")
		 * trace(lso.getAt("key")); // 如果flush成功则输出"value"
		 * </listing>
		 * @see #setAt()
		 */
		public function getAt(key : String) : Object {
			return _shareObject.data[key];
		}

		/**
		 * 保存数据到本地对象
		 * 
		 * @return Boolean 成功
		 */
		public function flush(minDiskSpace:int=0) : Boolean {
			var done : Boolean = true;
			try {
				var result : Object = _shareObject.flush(minDiskSpace);
				if(result == SharedObjectFlushStatus.FLUSHED) {
				} else if(result == SharedObjectFlushStatus.PENDING) {
					_shareObject.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
					done = false;
				}
			} catch(e : Error) {
				done = false;
				
			}
			return done;
		}

		/**
		 * 清除此本地对象中的所有数据
		 */
		public function clear() : void {
			_shareObject.clear();
		}
		
		/**
		 * 查询SO里是否有某个属性
		 * @param key
		 * @return 
		 * 
		 */		
		public function hasKey(key:String):Boolean
		{
			if (_shareObject.data.hasOwnProperty(key))
				return true;
			else
				return false;
		}
		
		public function get data():Object
		{
			return _shareObject.data;
		}
	}
}
