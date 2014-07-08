package managers
{
    
    import com.thinkido.framework.common.timer.helper.TimerHelper;
    import com.thinkido.framework.common.timer.vo.TimerData;
    
    import flash.events.Event;
    
    import org.osflash.thunderbolt.Logger;
    
	/**
	 * 计时器管理工具，统一管理timer相关类 
	 * @author thinkido
	 * 
	 */
    public class TimerManager extends Object
    {
        private static var _timerArr:Array = [];

        public function TimerManager()
        {
            throw new Event("静态类");
        }

        public static function getTimersNum() : int
        {
            return _timerArr.length;
        }

        public static function createOneOffTimer($delay:Number, $repeat:Number, $timerHandler:Function, $timerHandlervalueeters:Array = null, $timerCompleteHandler:Function = null, $timerCompleteHandlervalueeters:Array = null, $autoStart:Boolean = true) : void
        {
            TimerHelper.createTimer($delay, $repeat, $timerHandler, $timerHandlervalueeters, $timerCompleteHandler, $timerCompleteHandlervalueeters, $autoStart);
            return;
        }
		/**
		 * 添加timer 
		 * @param $delay
		 * @param $repeat
		 * @param $timerHandler
		 * @param $timerHandlervalueeters
		 * @param $timerCompleteHandler
		 * @param $timerCompleteHandlervalueeters
		 * @param $autoStart
		 * @return 
		 * 
		 */
        public static function createTimer($delay:Number, $repeat:Number, $timerHandler:Function, $timerHandlervalueeters:Array = null, $timerCompleteHandler:Function = null, $timerCompleteHandlervalueeters:Array = null, $autoStart:Boolean = true) : TimerData
        {
            var _td:TimerData = TimerHelper.createTimer($delay, $repeat, $timerHandler, $timerHandlervalueeters, $timerCompleteHandler, $timerCompleteHandlervalueeters, $autoStart);
            _timerArr[_timerArr.length] = _td;
            Logger.info("TimerManager.createTimer::_timerArr.length:" + getTimersNum());
            return _td;
        }

        public static function createOneOffExactTimer($duration:Number, $from:Number, $to:Number, $onUpdate:Function = null, $onComplete:Function = null, $updateStep:Number = 0) : void
        {
            TimerHelper.createExactTimer($duration, $from, $to, $onUpdate, $onComplete, $updateStep);
            return;
        }

        public static function createExactTimer($duration:Number, $from:Number, $to:Number, $onUpdate:Function = null, $onComplete:Function = null, $updateStep:Number = 0) : TimerData
        {
            var _td:TimerData = TimerHelper.createExactTimer($duration, $from, $to, $onUpdate, $onComplete, $updateStep);
            _timerArr[_timerArr.length] = _td;
            Logger.info("TimerManager.createTimer::_timerArr.length:" + getTimersNum());
            return _td;
        }
		/**
		 * 删除 TimerData
		 * @param $td
		 * 
		 */
        public static function deleteTimer($td:TimerData) : void
        {
            var _td:TimerData = null;
            var _len:int = _timerArr.length;
            while (_len-- > 0)
            {
                _td = _timerArr[_len];
                if (_td == $td)
                {
                    _timerArr.splice(_len, 1);
                    Logger.info("TimerManager.deleteTimer::_timerArr.length:" + getTimersNum());
                    _td.destroy();
                    break;
                }
            }
            return;
        }
		/**
		 * 删除所有timers 
		 * 
		 */
        public static function deleteAllTimers() : void
        {
            var _td:TimerData = null;
            for each (_td in _timerArr)
            {
               _td.destroy();
            }
            _timerArr = [];
            Logger.info("TimerManager.deleteAllTimers::_timerArr.length:0");
            return;
        }
		/**
		 * 添加延迟function 
		 * @param $time
		 * @param $callBack
		 * 
		 */
        public static function addDelayCallBack($time:Number, $callBack:Function) : void
        {
            TimerHelper.addDelayCallBack($time, $callBack);
            return;
        }
		/**
		 * 移除延迟function 
		 * @param $callBack
		 * 
		 */
        public static function removeDelayCallBack($callBack:Function) : void
        {
            TimerHelper.removeDelayCallBack($callBack);
            return;
        }

    }
}
