package com.thinkido.framework.net
{
	import com.thinkido.framework.events.TSocketEvent;
	
	import flash.errors.IOError;
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
	
	public class TSocket extends EventDispatcher
	{
		private var _tSocket:Socket ;
		private var _fReconnectTime:Timer = null;
		private var _iReconnectCount:int = -1;
		private var _iReconnectTime:uint = 50;
		private var _fTimeoutTime:Timer = null;
		private var _iTimeout:uint = 15000;
		private var _strHost:String = "";
		private var _iPort:int = -1;
		private var _bRconnected:Boolean = true;
		private var _bConnecting:Boolean = false;
		private var _buffer:ByteArray = null;
		private var _tmpBuffer:ByteArray = null;
		private var _fSocket:Socket = null;
		private var _strError:String = "";
		private var _receiveLen:uint = 0;
		private var _msgLen:int = -1 ;
		private var _readHeadBytes:uint = 4 ;
		private var _seqLen:uint = 0;
		private var _pacLen:uint = 0;
		private var _bEncode:Boolean = true;
		private var _WriteBytes:uint = 0;
		private var _ReadBytes:uint = 0;
		
		public var serverMsgArr:Array = [];
		
		public static const KEEPING:int = 0;
		public static const CLOSE:int = -1;
		
		public function TSocket()
		{
			_fSocket = new Socket(null,0);
			_fSocket.endian = Endian.LITTLE_ENDIAN ;
			addSocketEventListener();
			_buffer = new ByteArray();
			_buffer.endian = Endian.LITTLE_ENDIAN;
			_tmpBuffer = new ByteArray();
			_tmpBuffer.endian = Endian.LITTLE_ENDIAN;
			return;
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
			return;
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
			return;
		}
		
		
		public function get lastError() : String
		{
			return _strError;
		}
		
		public function get socket() : Socket
		{
			return _fSocket;
		}
		
		public function get timeout() : uint
		{
			return _iTimeout;
		}
		
		public function set timeout(value:uint) : void
		{
			_iTimeout = value;
			return;
		}
		
		public function get reconnCount() : int
		{
			return _iReconnectCount;
		}
		
		public function set reconnCount(value:int) : void
		{
			_iReconnectCount = value;
			return;
		}
		
		public function get reconnTime() : uint
		{
			return _iReconnectTime;
		}
		
		public function set reconnTime(value:uint) : void
		{
			_iReconnectTime = value;
			return;
		}
		public function get connected():Boolean{
			return _fSocket.connected ;
		}
		
		private var protocol:SProtocol ;
		private function dataHandler(event:ProgressEvent) : void
		{
			while (this._fSocket.bytesAvailable >= this._msgLen )
			{
				if (this._msgLen == -1 && this._fSocket.bytesAvailable > 8 )
				{
					protocol = new SProtocol();
					protocol.type = _fSocket.readShort() ;
					this._msgLen = this._fSocket.readInt();
					protocol.sType = this._fSocket.readByte();
					protocol.external = this._fSocket.readByte();
				}
				if (this._msgLen == -1)
				{
					return;
				}
				if (this._fSocket.bytesAvailable < this._msgLen )
				{
					return;
				}
				_buffer.position = 0;
				_buffer.length = 0 ;
				this._fSocket.readBytes(this._buffer, 0, this._msgLen );				
				
				var by:ByteArray = new ByteArray();
				by.endian = Endian.LITTLE_ENDIAN ;
				_buffer.readBytes(by,0,_buffer.bytesAvailable);
				protocol.body = by ;
				serverMsgArr.push(protocol);
				
//				this._fIProtocolParser.decode(this._buffer);
				this._msgLen = -1;
			}
			return;
		}
		public function send(protocal:IProtocol):void{
			
			var sendBytes:ByteArray = new ByteArray();
			sendBytes.endian = Endian.LITTLE_ENDIAN ;
			sendBytes.writeShort(protocal.type);
			sendBytes.writeInt(protocal.length);
			sendBytes.writeByte(2);
			sendBytes.writeByte(0);
			sendBytes.writeMultiByte(protocal.data, "utf-8");
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
			return;
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
			return;
		}
		
		private function addSocketEventListener() : void
		{
			_fSocket.addEventListener(Event.CONNECT, connectHandler, false, 0, true);
			_fSocket.addEventListener(Event.CLOSE, connectHandler, false, 0, true);
			_fSocket.addEventListener(IOErrorEvent.IO_ERROR, errorHandler, false, 0, true);
			_fSocket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, errorHandler, false, 0, true);
			_fSocket.addEventListener(ProgressEvent.SOCKET_DATA, dataHandler, false, 0, true);
			return;
		}
		
		private function removeSocketEventListener() : void
		{
			_fSocket.removeEventListener(Event.CONNECT, connectHandler);
			_fSocket.removeEventListener(Event.CLOSE, connectHandler);
			_fSocket.removeEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			_fSocket.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, errorHandler);
			_fSocket.removeEventListener(ProgressEvent.SOCKET_DATA, dataHandler);
			return;
		}
		
		private function connectHandler(event:Event) : void
		{
			if (event.type == Event.CONNECT)
			{
				_bRconnected = false;
				trace("connect remote host[" + _strHost + ":" + _iPort + "] success.");
				this.dispatchEvent(new TSocketEvent(TSocketEvent.LOGIN_SUCCESS));
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
				this.dispatchEvent(new TSocketEvent(TSocketEvent.CLOSE));
				_bRconnected = true;
				trace(_strError);
			}
			_bConnecting = false;
			return;
		}
		
		private function errorHandler(event:Event) : void
		{
			this.dispatchEvent(new TSocketEvent(TSocketEvent.LOGIN_FAILURE));
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
			return;
		}
		
		private function tryConnect() : void
		{
			trace("try connect: " + _strHost + ":" + _iPort);
			if (_fSocket.connected)
			{
				_fSocket.close();
			}
			_bConnecting = true ;
			_fSocket.connect(_strHost, _iPort);
			if (_fTimeoutTime)
			{
				if (!_fTimeoutTime.running)
				{
					_fTimeoutTime.start();
				}
			}
			return;
		}
	}
}