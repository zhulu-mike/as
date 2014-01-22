package com.thinkido.framework.net
{
	import com.adobe.serialization.json.JSON;
	import com.adobe.serialization.json.JSONParseError;
	import com.thinkido.framework.data.LocalSO;
	import com.thinkido.framework.events.TSocketEvent;
	
	import flash.errors.IOError;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import flash.utils.Timer;
	
	import org.osflash.thunderbolt.Logger;
	
	public class SSocket extends EventDispatcher
	{
		private var _fSocket:Socket = null;
		private var _strHost:String = "";
		private var _iPort:int = -1;
		
		private var _fReconnectTime:Timer = null;
		private var _iReconnectCount:int = -1;
		private var _iReconnectTime:uint = 50;
		private var _bRconnected:Boolean = true;
		private var _bConnecting:Boolean = false;
		
		private var _buffer:ByteArray = null;
		private var _tmpBuffer:ByteArray = null;
		private var _WriteBytes:uint = 0;
		private var _ReadBytes:uint = 0;
		
		private var _fTimeoutTime:Timer = null;
		private var _iTimeout:uint = 15000;
		
		private var _receiveLen:uint = 0;
		private var _msgLen:int = -1;
		private var _seqLen:uint = 0;
		private var _pacLen:uint = 0;
		private var _readHeadBytes:uint = 4 ;
		
		private var _strError:String = "";
		
		public var serverMsgArr:Vector.<NProtocol> = new Vector.<NProtocol>() ;
		
		public static const KEEPING:int = 0;
		public static const CLOSE:int = -1;
		
		private var _protocol:NProtocol;

		
		public function SSocket()
		{
			_fSocket = new Socket();
			_fSocket.endian = Endian.LITTLE_ENDIAN ;
			addSocketEventListener();
			
			_buffer = new ByteArray();
			_buffer.endian = Endian.LITTLE_ENDIAN;
			
			_tmpBuffer = new ByteArray();
			_tmpBuffer.endian = Endian.LITTLE_ENDIAN;
		}
		
		private function addSocketEventListener():void
		{
			_fSocket.addEventListener(Event.CONNECT, connectHandler, false, 0, true);
			_fSocket.addEventListener(Event.CLOSE, connectHandler, false, 0, true);
			_fSocket.addEventListener(IOErrorEvent.IO_ERROR, errorHandler, false, 0, true);
			_fSocket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, errorHandler, false, 0, true);
			_fSocket.addEventListener(ProgressEvent.SOCKET_DATA, dataHandler, false, 0, true);
		}
		
		private function removeSocketEventListener():void
		{
			_fSocket.removeEventListener(Event.CONNECT, connectHandler);
			_fSocket.removeEventListener(Event.CLOSE, connectHandler);
			_fSocket.removeEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			_fSocket.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, errorHandler);
			_fSocket.removeEventListener(ProgressEvent.SOCKET_DATA, dataHandler);
		}
		
		public function connect(host:String, hostPort:int, repeatCount:int = -1, delay:uint = 0) : void
		{
			if (_bConnecting)
			{
				return;
			}
			_strHost = host;
			_iPort = hostPort;
			if (repeatCount >= 0 && !_fReconnectTime)
			{
				_iReconnectCount = repeatCount ? (repeatCount) : (int.MAX_VALUE);
				_iReconnectTime = delay;
				if (_iReconnectTime > 0)
				{
					if (_fReconnectTime == null)
					{
						_fReconnectTime = new Timer(_iReconnectTime);
						_fReconnectTime.addEventListener(TimerEvent.TIMER, reconnectHandler, false, 0, true);
					}
				}
			}
			if (_iTimeout > 0 && !_fTimeoutTime)
			{
				if (_fTimeoutTime == null)
				{
					_fTimeoutTime = new Timer(_iTimeout);
					_fTimeoutTime.addEventListener(TimerEvent.TIMER, timeoutHandler, false, 0, true);
				}
			}
			tryConnect();
		}
		
		public function close() : void
		{
			if (_fTimeoutTime != null)
			{
				if (_fTimeoutTime.running)
				{
					_fTimeoutTime.stop();
				}
			}
			if (_fReconnectTime != null)
			{
				if (_fReconnectTime.running)
				{
					_fReconnectTime.stop();
				}
			}
			_bRconnected = true;
			_bConnecting = false;
			if (_fSocket != null)
			{
				if (_fSocket.connected)
				{
					_fSocket.close();
				}
			}
		}
		
		public function get lastError() : String
		{
			return _strError;
		}
		
		public function get connected():Boolean
		{
			return _fSocket.connected ;
		}
		
		private function dataHandler(event:ProgressEvent) : void
		{
			while (_fSocket.bytesAvailable >= _msgLen )
			{
				if (_msgLen == -1 && _fSocket.bytesAvailable >= 10)
				{
					_protocol = new NProtocol();
//					_protocol = ObjectPoolManager.getInstance().getItem(SProtocol) as SProtocol;
					_protocol.type = _fSocket.readInt();
					_msgLen = _fSocket.readInt();
					/* sType */ _fSocket.readByte();
					/* external */ _fSocket.readByte();
				}
				
				if (_msgLen == -1)
					return;
				
				if (_fSocket.bytesAvailable < _msgLen)
					return;
				
				_buffer.position = 0;
				_buffer.length = 0;
				try{
					_fSocket.readBytes(_buffer, 0, _msgLen);
				}catch(e:*){
					var error:ErrorEvent = new ErrorEvent(ErrorEvent.ERROR);
					_fSocket.readBytes(_buffer, 0, _fSocket.bytesAvailable );
					var txt:String = _buffer.readUTFBytes(_buffer.bytesAvailable);
					error.text = "严重错误： socket head != content , type:" + _protocol.type + ",len:" + _msgLen + ",bytesAvailable:" + _fSocket.bytesAvailable + ",content:" + txt ;
					this.dispatchEvent(error);
				}
				var jsonStr:String = _buffer.readUTFBytes(_buffer.bytesAvailable);
				//Logger.warn(jsonStr);
				try{
					_protocol.body = JSON.decode(jsonStr);
					serverMsgArr.push(_protocol);
				}catch(e:JSONParseError){
					Logger.warn("socket 以收到" + _protocol.type , {location:e.location , errorID:e.errorID , message:e.message ,name:e.name , text: e.text });
				}
				_msgLen = -1;
			}
		}
		
		public function send(protocol:NProtocol):void
		{
			if (!protocol)
				return;
			
			var dataStr:String = JSON.encode(protocol.body);
			
			var sendBytes:ByteArray = new ByteArray();
			sendBytes.endian = Endian.LITTLE_ENDIAN ;
			sendBytes.writeInt(protocol.type);
			sendBytes.writeInt(dataStr.length);
			sendBytes.writeByte(2);
			sendBytes.writeByte(0);
			sendBytes.writeUTFBytes(dataStr);
			sendBytes.writeByte(0);
			
			try
			{
				_fSocket.writeBytes(sendBytes);
				_fSocket.flush();
			}
			catch (e:IOError)
			{
				Logger.error(e.toString());
			}
		}
		
		public function sendRawData(data:ByteArray):void
		{
			try
			{
				_fSocket.writeBytes(data);
				_fSocket.flush();
			}
			catch (e:IOError)
			{
				Logger.error(e.toString());
			}
		}
		
		
		public function get readTotalBytes() : uint
		{
			return _ReadBytes;
		}
		
		public function get writeTotalBytes() : uint
		{
			return _WriteBytes;
		}
		
		private function reconnectHandler(event:TimerEvent) : void
		{
			tryConnect();
			_fReconnectTime.stop();
		}
		
		private function timeoutHandler(event:TimerEvent) : void
		{
			_fTimeoutTime.stop();
			trace("connect remote host[" + _strHost + ":" + _iPort + "] timeout.");
			if (!_fSocket.connected)
			{
				_iReconnectCount -= 1;
				if (_iReconnectCount-- > 0)
				{
					if (_fReconnectTime)
					{
						_fReconnectTime.start();
					}
				}
				else
				{
					_bConnecting = false;
				}
			}
		}
		
		private function connectHandler(event:Event) : void
		{
			if (event.type == Event.CONNECT)
			{
				_bRconnected = false;
				trace("connect remote host[" + _strHost + ":" + _iPort + "] success.");
				dispatchEvent(new TSocketEvent(TSocketEvent.LOGIN_SUCCESS));
				if (_fTimeoutTime)
				{
					_fTimeoutTime.stop();
					_fTimeoutTime.removeEventListener(TimerEvent.TIMER, timeoutHandler);
				}
				if (_fReconnectTime)
				{
					_fReconnectTime.stop();
					_fReconnectTime.removeEventListener(TimerEvent.TIMER, reconnectHandler);
				}
			}
			else if (event.type == Event.CLOSE)
			{
				_strError = "disconnect the game server " + _strHost + ":" + _iPort;
				dispatchEvent(new TSocketEvent(TSocketEvent.CLOSE));
				_bRconnected = true;
				trace(_strError);
			}
			_bConnecting = false;
		}
		
		private function errorHandler(event:Event) : void
		{
			dispatchEvent(new TSocketEvent(TSocketEvent.LOGIN_FAILURE));
			if (event.type == SecurityErrorEvent.SECURITY_ERROR)
			{
				_strError = (event as SecurityErrorEvent).text;
				trace(_strError);
			}
			else if (event.type == IOErrorEvent.IO_ERROR)
			{
				_strError = (event as IOErrorEvent).text;
				trace(_strError);
			}
			if (_fReconnectTime && _bRconnected)
			{
				_fReconnectTime.start();
			}
			_bRconnected = true;
			_bConnecting = true;
		}
		
		private function tryConnect():void
		{
			trace("try connect: " + _strHost + ":" + _iPort);
			if (_fSocket.connected)
			{
				_fSocket.close();
			}
			_bConnecting = true;
			_fSocket.connect(_strHost, _iPort);
			if (_fTimeoutTime)
			{
				if (!_fTimeoutTime.running)
				{
					_fTimeoutTime.start();
				}
			}
		}
	}
}