package tools.managers
{
    
    import flash.events.Event;
    
    import org.osflash.thunderbolt.Logger;
    
    import tools.handler.HandlerThread;
    import tools.handler.helper.HandlerHelper;

	/**
	 * handler 帮助类 
	 * @author thinkido
	 * 
	 */
    public class HandlerManager extends Object
    {
        private static var _defaultHandlerThread:HandlerThread = new HandlerThread(new Array(), true);
        private static var _handlerThreadArr:Array = [_defaultHandlerThread];

        public function HandlerManager()
        {
            throw new Event("静态类");
        }
		/**
		 * 获取 HandlerThread 数
		 * @return 
		 * 
		 */
        public static function getHandlerThreadsNum() : int
        {
            return _handlerThreadArr.length;
        }
		/**
		 * 后去handler 数 
		 * @return 
		 * 
		 */
        public static function getHandlersNum() : int
        {
            var ht:HandlerThread = null;
            var num:Number = 0;
            for each (ht in _handlerThreadArr)
            {
                
                num = num + ht.getHandlersNum();
            }
            return num;
        }

        public static function creatNewHandlerThread($handlerArr:Array = null, $isQueue:Boolean = true) : HandlerThread
        {
            var ht:HandlerThread = new HandlerThread($handlerArr, $isQueue);
            _handlerThreadArr[_handlerThreadArr.length] = new HandlerThread($handlerArr, $isQueue);
            try
            {
                Logger.info("HandlerManager.creatNewHandlerThread::_handlerThreadArr.length:" + getHandlerThreadsNum());
            }
            catch (e:Error)
            {
            }
            return ht;
        }

        public static function push($handler:Function, $valueeters:Array = null, $delay:Number = 0, $doNext:Boolean = true, $run:Boolean = true, isUnShift:Boolean = false, $ht:HandlerThread = null) : HandlerThread
        {
            var ht:HandlerThread = null;
            if ($ht != null)
            {
                ht = $ht;
                if (!hasHandlerThread(ht))
                {
                    _handlerThreadArr.push(ht);
					Logger.info("HandlerManager.push::_handlerThreadArr.length:" + getHandlerThreadsNum());
                }
            }
            else
            {
                ht = _defaultHandlerThread;
            }
            ht.push($handler, $valueeters, $delay, $doNext, $run, isUnShift);
            return ht;
        }

        public static function execute(handler:Function, param2:Array = null):*
        {
            return HandlerHelper.execute(handler, param2);
        }

        public static function getDefaultHandlerThread() : HandlerThread
        {
            return _defaultHandlerThread;
        }

        public static function removeAllHandlerThreads() : void
        {
            removeAllHandlers();
            _handlerThreadArr = [];
            Logger.info("HandlerManager.removeAllHandlerThreads::_handlerThreadArr.length:0");
            return;
        }

        public static function removeAllHandlers() : void
        {
            var ht:HandlerThread = null;
            for each (ht in _handlerThreadArr)
            {
                
                ht.removeAllHandlers();
            }
            return;
        }

        public static function removeHandlerThread($ht:HandlerThread) : void
        {
            var ht:HandlerThread = null;
            if (!$ht)
            {
                return;
            }
            for each (ht in _handlerThreadArr)
            {
                
                if (ht == $ht)
                {
                    ht.removeAllHandlers();
                    _handlerThreadArr.splice(_handlerThreadArr.indexOf(ht), 1);
                    Logger.info("HandlerManager.removeHandlerThread::_handlerThreadArr.length:" + getHandlerThreadsNum());
                    break;
                }
            }
            return;
        }

        public static function removeHandler(handler:Function) : void
        {
            var ht:HandlerThread = null;
            if (handler == null)
            {
                return;
            }
            for each (ht in _handlerThreadArr)
            {
                
                ht.removeHandler(handler);
            }
            return;
        }

        public static function hasHandlerThread($ht:HandlerThread) : Boolean
        {
            return _handlerThreadArr.indexOf($ht) != -1;
        }

        public static function hasHandler(handler:Function) : Boolean
        {
            var ht:HandlerThread = null;
            for each (ht in _handlerThreadArr)
            {
                
                if (ht.hasHandler(handler))
                {
                    return true;
                }
            }
            return false;
        }

    }
}
