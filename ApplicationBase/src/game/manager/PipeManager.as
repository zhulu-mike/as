package game.manager
{
	import com.thinkido.framework.common.observer.Notification;
	import com.thinkido.framework.common.observer.Observer;
	import com.thinkido.framework.common.observer.ObserverThread;
	
	/**
	 * 管道消息管理
	 * @author Administrator
	 * @see PipeEvent.as
	 */	
	public class PipeManager extends Object
	{
		private static var _msgObserverThread:ObserverThread = new ObserverThread();
		
		public function PipeManager()
		{
			return;
		}
		
		public static function registerMsg(param1:String, param2:Function, param3:Object) : void
		{
			var _loc_4:* = new Observer(param2, param3);
			_msgObserverThread.registerObserver(param1, _loc_4);
			return;
		}
		
		public static function registerMsgs(param1:Array, param2:Function, param3:Object) : void
		{
			var _loc_4:* = undefined;
			for each (_loc_4 in param1)
			{
				
				registerMsg(_loc_4, param2, param3);
			}
			return;
		}
		
		public static function removeMsg(param1:String, param2:Object) : void
		{
			_msgObserverThread.removeObserver(param1, param2);
			return;
		}
		
		public static function removeMsgs(param1:Array, param2:Object) : void
		{
			var _loc_3:* = undefined;
			for each (_loc_3 in param1)
			{
				
				removeMsg(_loc_3, param2);
			}
			return;
		}
		
		public static function sendMsg($name:String, $body:Object = null) : void
		{
			var _loc_3:* = new Notification($name, $body);
			_msgObserverThread.notifyObservers(_loc_3);
			return;
		}
		
	}
}
