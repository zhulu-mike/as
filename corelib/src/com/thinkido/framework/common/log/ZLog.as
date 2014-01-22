package com.thinkido.framework.common.log
{
    import com.thinkido.framework.common.handler.*;
    import com.thinkido.framework.manager.HandlerManager;
    
    import flash.text.*;

    public class ZLog extends Object
    {
        private static const _logHt:HandlerThread = HandlerManager.creatNewHandlerThread();
        public static var enableLog:Boolean = true;
        public static var enableTrace:Boolean = true;
        public static var enableShowInLogArea:Boolean = false;
        public static var max_log_num:Number;
        private static var _logArea:TextField;
        private static var _logNum:Number;

        public function ZLog()
        {
            return;
        }

        public static function init(value1:TextField = null, value2:int = 1000, value3:Boolean = true, value4:Boolean = false) : void
        {
            enableLog = true;
            max_log_num = value2;
            enableTrace = value3;
            enableShowInLogArea = value4;
            _logArea = value1;
            if (_logArea)
            {
                _logArea.text = "";
            }
            _logNum = 0;
            return;
        }

        public static function add(value1:*) : void
        {
            if (!enableLog)
            {
                return;
            }
            var _loc_2:* = value1 is Array && value1.length > 0 ? (value1.slice(" ")) : (value1);
            if (enableTrace)
            {
                trace(_loc_2);
            }
            if (enableShowInLogArea && _logArea != null)
            {
                _logHt.push(doAdd, [_loc_2], 10);
            }
            return;
        }

        private static function doAdd(value1:*) : void
        {
            var _loc_2:int = 0;
            if (enableShowInLogArea && _logArea != null)
            {
                _logArea.appendText(value1 + "\n");
                _logNum += 1;
                while (_logNum > max_log_num)
                {
                    
                    _loc_2 = _logArea.text.indexOf("\r");
                    _logArea.replaceText(0, _loc_2 != -1 ? ((_loc_2 + 1)) : (0), "");
                    _logNum -= 1;
                }
            }
            return;
        }

    }
}
