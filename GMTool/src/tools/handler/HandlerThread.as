package tools.handler
{
	import tools.handler.helper.HandlerHelper;
	import tools.handler.vo.HandlerData;
	import tools.managers.TimerManager;

	/**
	 * 方法队列，执行一些列方法队列时使用  
	 * @author thinkido
	 * 
	 */
    public class HandlerThread extends Object
    {
        private var _handlerDataArr:Array;
        private var _handlerDataReadyArr:Array;
        private var _isRunning:Boolean;
		/**
		 * 是否能运行，不能运行时，executeNext 中断 
		 */		
        private var _canRun:Boolean;
		/**
		 * 队列运行 
		 */		
        private var _isQueue:Boolean;
		/**
		 * 下一个运行方法体 
		 */		
        private var _next:HandlerData;

        public function HandlerThread(hDataArr:Array = null, $isQueue:Boolean = true)
        {
            this._handlerDataArr = hDataArr || [];
            this._handlerDataReadyArr = [];
            this._isQueue = $isQueue;
            this._isRunning = false;
            this._canRun = true;
            this._next = null;
            return;
        }
		
		/**
		 * 当前运行状态 
		 */		
        public function get isRunning() : Boolean
        {
            return this._isRunning;
        }

        public function getHandlersNum() : int
        {
            return this._handlerDataArr.length;
        }
		/**
		 * 
		 * @param $handler
		 * @param $valueeters
		 * @param $delay
		 * @param $doNext
		 * @param run 如果没有运行就运行
		 * @param isUnShift
		 * @return 
		 * 
		 */		
        public function push($handler:Function, $valueeters:Array = null, $delay:Number = 0, $doNext:Boolean = true, run:Boolean = true, isUnShift:Boolean = false) : HandlerData
        {
            var hd:HandlerData = new HandlerData($handler, $valueeters, $delay, $doNext);
            if (isUnShift)
            {
                this._handlerDataArr.unshift(hd);
            }
            else
            {
                this._handlerDataArr.push(hd);
            }
            if (this._canRun && run && !this._isRunning)
            {
                this.executeNext();
            }
            return hd;
        }
		/**
		 * 删除所有方法 
		 * 
		 */
        public function removeAllHandlers() : void
        {
            this._handlerDataArr.length = 0;
            this._handlerDataReadyArr.length = 0;
            this._isRunning = false;
            return;
        }
		/**
		 * 删除指定方法
		 * @param $handler
		 * 
		 */
        public function removeHandler($handler:Function) : void
        {
            var hd:HandlerData = null;
            if ($handler == null)
            {
                return;
            }
            var len:int = this._handlerDataArr.length;
            while (len-- > 0)
            {
                
                hd = this._handlerDataArr[len];
                if (hd.handler == $handler)
                {
                    this._handlerDataArr.splice(len, 1);
                }
            }
            len = this._handlerDataReadyArr.length;
            while (len-- > 0)
            {
                
                hd = this._handlerDataReadyArr[len];
                if (hd.handler == $handler)
                {
                    this._handlerDataReadyArr.splice(len, 1);
                }
            }
            if (this._handlerDataArr.length == 0 && this._handlerDataReadyArr.length == 0)
            {
                this._isRunning = false;
            }
            return;
        }
		/**
		 * 判断是否含有某个function 
		 * @param $handler
		 * @return 
		 * 
		 */
        public function hasHandler($handler:Function) : Boolean
        {
            var hd:HandlerData = null;
            for each (hd in this._handlerDataArr)
            {
                if (hd.handler == $handler)
                {
                    return true;
                }
            }
            for each (hd in this._handlerDataReadyArr)
            {
                
                if (hd.handler == $handler)
                {
                    return true;
                }
            }
            return false;
        }
		/**
		 * 开始执行 
		 */
        public function start() : void
        {
            this._canRun = true;
            if (!this._isRunning)
            {
                this.executeNext();
            }
            return;
        }
		/**
		 * 停止运行，但不清楚数据 
		 * 
		 */
        public function stop() : void
        {
            this._canRun = false;
            return;
        }

        private function setNotRunning() : void
        {
            this._isRunning = false;
            return;
        }
		/**
		 * 执行下一个 
		 * 
		 */
        private function executeNext() : void
        {
            if (!this._canRun)
            {
                this._isRunning = false;
                return;
            }
            if (this._handlerDataArr.length == 0)
            {
                this._isRunning = false;
                return;
            }
            this._isRunning = true;
            this._next = (this._isQueue ? (this._handlerDataArr.shift()) : (this._handlerDataArr.pop())) as HandlerData;
            if (this._next)
            {
                if (this._next.delay > 0) 
                {
                    var newHandler:Function = function () : void
			            {
			                if (removeReadyHD(_next))
			                {
			                    HandlerHelper.execute(_next.handler, _next.valueeters);
			                }
			                if (_next.doNext)
			                {
			                    executeNext();
			                }
			                else
			                {
			                    setNotRunning();
			                }
			                return;
			            };
                    this.addReadyHD(this._next);
                    TimerManager.createOneOffTimer(this._next.delay, 1, newHandler, null, null, null, true);
                }
                else
                {
                    HandlerHelper.execute(this._next.handler, this._next.valueeters);
                    if (this._next.doNext)
                    {
                        this.executeNext();
                    }
                    else
                    {
                        this.setNotRunning();
                    }
                }
            }
            else
            {
                this.executeNext();
            }
            return;
        }
		/**
		 * 添加准备执行的 方法体 
		 * @param handlerData
		 * 
		 */
        private function addReadyHD(handlerData:HandlerData) : void
        {
            if (this._handlerDataReadyArr.indexOf(handlerData) != -1)
            {
                return;
            }
            this._handlerDataReadyArr.push(handlerData);
            return;
        }
		/**
		 * 删除指定方法体
		 * @param handlerData
		 * @return 
		 * 
		 */
        private function removeReadyHD(handlerData:HandlerData) : Boolean
        {
            var temp:int = this._handlerDataReadyArr.indexOf(handlerData);
            if (temp != -1)
            {
                this._handlerDataReadyArr.splice(temp, 1);
                return true;
            }
            return false;
        }

    }
}
