package game.manager
{
	import com.adobe.serialization.json.JSON;
	import com.adobe.serialization.json.JSONParseError;
	import com.thinkido.framework.common.observer.Notification;
	import com.thinkido.framework.common.observer.Observer;
	import com.thinkido.framework.common.observer.ObserverThread;
	import com.thinkido.framework.common.timer.vo.TimerData;
	import com.thinkido.framework.manager.TimerManager;
	import com.thinkido.framework.net.NProtocol;
	import com.thinkido.framework.net.SSocket;
	
	import flash.display.Stage;
	import flash.events.Event;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import flash.utils.getTimer;
	
	import org.osflash.thunderbolt.Logger;

	public class NetWorkManager
	{
		
		
		public static var mainSocket:SSocket = new SSocket() ;
		
//		public  var loginSocket:TSocket ;
//		public  var chatSocket:TSocket ;
//		public  var lineSocket:TSocket ;
		
		private static  const importantMessageList:Array = [10052, 10020, 30000];
		private static  var sleepModeRenderTime:int = 100;
		private static  var inSleepMode:Boolean = false;
		private static  var lastRunTime:int = 0;
		private static  var _heartTime:TimerData = TimerManager.createTimer(30000, 0, heartHandle, null, null, null, false);
		private static var _msgObserverThread:ObserverThread = new ObserverThread();

		public function NetWorkManager() 
		{   
			
		}
		
		public static  function init(stage:Stage):void
		{
			stage.addEventListener(Event.ENTER_FRAME, runReceiveMsgs);
		}
//			心跳包  待写
		private static   function heartHandle() : void
		{
			if (mainSocket.connected)
			{
//				sendMsg(40301, new ByteArray(), mainSocket);
			}
			return;
		}
		
		public static   function connectMain(ip:String, port:int) : void
		{
			mainSocket.connect(ip, port);
			return;
		}
		public static function sendAuthString():void
		{
			var data:ByteArray = new ByteArray();
			data.endian = Endian.LITTLE_ENDIAN;
			data.writeUTFBytes("Client2Fe_V5");
			data.writeByte(0);
			mainSocket.sendRawData(data);
		}
		private static   function runReceiveMsgs(event:Event) : void
		{
			var prot:NProtocol = null;
			var now:int = getTimer();
			inSleepMode = now - lastRunTime > sleepModeRenderTime;
			lastRunTime = now; 
			if (inSleepMode)
			{
				while (mainSocket.serverMsgArr.length > 0)
				{
					prot = mainSocket.serverMsgArr.shift();
					receiveMsg(prot);
				}
			}
			else
			{
				while (mainSocket.serverMsgArr.length > 0)
				{
					prot = mainSocket.serverMsgArr.shift();
					receiveMsg(prot);
					if (getTimer() - now >= 5)
					{
						break;
					}
				}
			}
			return;
		}
		
		public static function sendMsgData($protocolCode:int,$data:Object = null) : void
		{
			var p:NProtocol = new NProtocol() ;
			p.type = $protocolCode ;
			p.body = $data || {} ;			
			sendMsg(p);
			return;
		}
		public static function sendMsg($protocol:NProtocol,$socket:SSocket = null) : void
		{
			$socket = $socket|| mainSocket ;
			$socket.send($protocol);			
			Logger.warn("socket 发送" + $protocol.type + com.adobe.serialization.json.JSON.encode($protocol.body));
			return;
		}
		
		public static function registerMsg(param1:int, $handle:Function, $name:*) : void
		{
			var _observer:Observer = new Observer($handle, $name);
			_msgObserverThread.registerObserver(param1, _observer);
			return;
		}
		
		public static function registerMsgs(obserArr:Array, $handle:Function, $name:*) : void
		{
			var item:* = undefined;
			for each (item in obserArr)
			{
				
				registerMsg(item, $handle, $name);
			}
			return;
		}
		
		public static function removeMsg(param1:int, $name:String) : void
		{
			_msgObserverThread.removeObserver(param1, $name);
			return;
		}
		
		public static function removeMsgs(param1:Array, $name:String) : void
		{
			var _loc_3:* = undefined;
			for each (_loc_3 in param1)
			{
				
				removeMsg(_loc_3, $name);
			}
			return;
		}
		
		private static function receiveMsg(protocol:NProtocol) : void
		{
			var temp:String ; 
			try{
				temp = com.adobe.serialization.json.JSON.encode(protocol.body) ;
			}catch(e:JSONParseError){
				Logger.warn("socket 以收到" + protocol.type + "有json错误  location:" + e.location );
			}
			Logger.warn("socket 以收到" + protocol.type + temp);
			var _loc_4:* = new Notification(protocol.type.toString(), protocol);
			_msgObserverThread.notifyObservers(_loc_4);
			return;
		}
		
		private static   function decodeData(param1:ByteArray) : ByteArray
		{
			var temp:ByteArray = new ByteArray();
			while (param1.bytesAvailable)
			{
				
				temp.writeByte(~param1.readByte());
			}
			temp.position = 0;
			return temp;
		}
		private static   function encodeData(param1:ByteArray) : ByteArray
		{
			param1.position = 0;
			var temp:ByteArray = new ByteArray();
			while (param1.bytesAvailable)
			{
				temp.writeByte(~param1.readByte());
			}
			temp.position = 0;
			return temp;
		}
	}
}