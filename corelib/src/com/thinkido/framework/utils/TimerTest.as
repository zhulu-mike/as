package com.thinkido.framework.utils
{
    import flash.display.Sprite;
    import flash.display.Stage;
    import flash.events.Event;
    import flash.net.URLRequest;
    import flash.net.navigateToURL;
    import flash.utils.getTimer;
    
    import org.osflash.thunderbolt.Logger;
	/**
	 * 加速测试工具 
	 * @author thinkido
	 * 
	 */
    public class TimerTest extends Sprite
    {
        private var _sTime:Number;
        private var _dsTime:Number;
        private var _frame:int = 12;
        private var _stage:Stage;
        private var _num:int = 0;
        private var _isAlert:Boolean = false;
        private var i:int = 1;
        public static var Delay:Number = 40;
        public static var tipText:String = "检测到当前系统时间被修改，若是手动修改，\n请刷新后再进行游戏";
		/**
		 * 检测到当前系统时间被修改 
		 * @param $stage
		 * 
		 */
        public function TimerTest($stage:Stage) : void
        {
            this._frame = $stage.frameRate;
            this._stage = $stage;
            return;
        }
		/**
		 * 开始检查 
		 */
        public function start() : void
        {
            this._sTime = getTimer();
            this._dsTime = new Date().time;
            this._stage.addEventListener(Event.ENTER_FRAME, this.onEventFrameHandler);
            return;
        }

        private function onEventFrameHandler(event:Event) : void
        {
			this.i += 1;
            if (this.i > 5)
            {
                this.i = 1;
                this.testChangeTime();
            }
            return;
        }

        private function testChangeTime() : void
        {
            var _loc_1:uint = getTimer();
            var _loc_2:uint = new Date().time;
            var _loc_3:uint = _loc_1 - this._sTime;
            var _loc_4:uint = _loc_2 - this._dsTime;
            var _loc_5:uint = Math.abs(_loc_3 - _loc_4);
            Logger.debug("delayTime:" + [_loc_3, _loc_4]);
            if (_loc_5 > Delay)
            {               
                _num += 1;
                if (this._num > 5)
                {
                    if (this._isAlert == false)
                    {
//						  有注释
//                        KeyBoardManager.instance.cancelListener();
//                        this._isAlert = true;
//                        Alert.show(tipText, null, 0, null, this.close);
                    }
                }
            }
            this._sTime = _loc_1;
            this._dsTime = _loc_2;
            return;
        }
		/**
		 * 刷新，重新打开网页 
		 * @param param1
		 * 
		 */
        private function close(param1:int = 0 ) : void
        {
            this._isAlert = false;
            navigateToURL(new URLRequest("javascript:location.reload();"), "_self");
            this._stage.removeEventListener(Event.ENTER_FRAME, this.onEventFrameHandler);
            return;
        }

    }
}
