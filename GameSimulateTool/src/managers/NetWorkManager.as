package managers
{
	import com.adobe.serialization.json.JSON;
	import com.thinkido.framework.common.observer.Notification;
	import com.thinkido.framework.common.observer.Observer;
	import com.thinkido.framework.common.observer.ObserverThread;
	
	import flash.display.Stage;
	import flash.events.Event;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import flash.utils.getTimer;
	
	import net.NProtocol;
	import net.SSocket;
	
	import org.osflash.thunderbolt.Logger;

	public class NetWorkManager
	{
		
		public  var mainSocket:SSocket = new SSocket() ;
		
		
		private static  const importantMessageList:Array = [10052, 10020, 30000];
		private static  var sleepModeRenderTime:int = 100;
		private   var inSleepMode:Boolean = false;
		private   var lastRunTime:int = 0;
		private  var _msgObserverThread:ObserverThread = new ObserverThread();
		private  var stage:Stage;
		
		public function NetWorkManager() 
		{   
			
		}
		
		
		
		public  function init(sta:Stage):void
		{
			stage = sta;
			stage.addEventListener(Event.ENTER_FRAME, runReceiveMsgs);
		}
		
		public   function connectMain(ip:String, port:int) : void
		{
			mainSocket.connect(ip, port);
			return;
		}
		public function sendAuthString():void
		{
			var data:ByteArray = new ByteArray();
			data.endian = Endian.LITTLE_ENDIAN;
			data.writeUTFBytes("Client2Fe_V5");
			data.writeByte(0);
			mainSocket.sendRawData(data);
		}
		private   function runReceiveMsgs(event:Event) : void
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
		
		public function sendMsgData($protocolCode:int,$data:Object = null) : void
		{
			var p:NProtocol = new NProtocol() ;
			p.type = $protocolCode ;
			p.body = $data || {} ;			
			sendMsg(p);
			return;
		}
		public function sendMsg($protocol:NProtocol,$socket:SSocket = null) : void
		{
			$socket = $socket|| mainSocket ;
			$socket.send($protocol);			
//			Logger.warn("发送协议：" + $protocol.type + com.adobe.serialization.json.JSON.encode($protocol.body));
			return;
		}
		
		public function registerMsg(param1:int, $handle:Function, $name) : void
		{
			var _observer:Observer = new Observer($handle, $name);
			_msgObserverThread.registerObserver(param1, _observer);
			return;
		}
		
		public  function registerMsgs(obserArr:Array, $handle:Function, $name) : void
		{
			var item:* = undefined;
			for each (item in obserArr)
			{
				
				registerMsg(item, $handle, $name);
			}
			return;
		}
		
		public  function removeMsg(param1:int, $name:String) : void
		{
			_msgObserverThread.removeObserver(param1, $name);
			return;
		}
		
		public  function removeMsgs(param1:Array, $name:String) : void
		{
			var _loc_3:* = undefined;
			for each (_loc_3 in param1)
			{
				
				removeMsg(_loc_3, $name);
			}
			return;
		}
		
		private  function receiveMsg(protocol:NProtocol) : void
		{
			var _loc_4:* = new Notification(protocol.type.toString(), protocol);
			_msgObserverThread.notifyObservers(_loc_4);
			return;
		}
		
		private    function decodeData(param1:ByteArray) : ByteArray
		{
			var temp:ByteArray = new ByteArray();
			while (param1.bytesAvailable)
			{
				
				temp.writeByte(~param1.readByte());
			}
			temp.position = 0;
			return temp;
		}
		private    function encodeData(param1:ByteArray) : ByteArray
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