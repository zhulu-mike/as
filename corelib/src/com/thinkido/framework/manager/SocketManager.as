package com.thinkido.framework.manager
{
    import com.thinkido.framework.net.TSocket;
    
    import org.osflash.thunderbolt.Logger;
	/**
	 * socket 统一管理类,未完成 
	 * @author thinkido
	 * 
	 */
    public class SocketManager extends Object
    {
        private static var _socketArr:Array = [];

        public function SocketManager()
        {
            throw new Error("Can not New!");
        }

        public static function hasSocket($tSocket:TSocket) : Boolean
        {
            return _socketArr.indexOf($tSocket) != -1;
        }

        public static function creatSocket(param1:Function, param2:String = null, param3:int = 0, param4:uint = 127) : TSocket
        {
//            var _loc_5:TSocket = new TSocket(param1, param2, param3, param4);
//            _socketArr.push(_loc_5);
//            Logger.info("SocketManager.creatSocket::_socketArr.length:" + getSocketsNum());
            return null ;//_loc_5;
        }

        public static function deleteSocket($tSocket:TSocket) : void
        {
            if (!$tSocket)
            {
                return;
            }
            var _loc_2:int = _socketArr.indexOf($tSocket);
            if (_loc_2 != -1)
            {
                _socketArr.splice(_loc_2, 1);
				Logger.info("SocketManager.deleteSocket::_socketArr.length:" + getSocketsNum());
            }
            $tSocket.close();
            return;
        }

        public static function getSocketsNum() : int
        {
            return _socketArr.length;
        }

    }
}
