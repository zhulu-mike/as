package com.thinkido.framework.common.dispose
{
    import com.thinkido.framework.common.timer.Tick;
    
    import flash.display.BitmapData;
    import flash.events.Event;
    import flash.system.System;
    import flash.utils.ByteArray;
    import flash.utils.getTimer;
    

    public class DisposeHelper extends Object
    {
        private static var sleepModeRenderTime:int = 83;
        private static var inSleepMode:Boolean = false;
        private static var lastRunTime:int = 0;
        private static var _disposList:Array = [];

        public function DisposeHelper()
        {
            throw new Event("静态类");
        }

        public static function get length() : int
        {
            return _disposList.length;
        }

        public static function add(dispostItem:*) : void
        {
            if (dispostItem == null)
            {
                return;
            }
            _disposList.push(dispostItem);
            if (!Tick.hasCallback(onEnterFrame))
            {
                lastRunTime = getTimer();
                Tick.addCallback(onEnterFrame);
            }
            return;
        }

        private static function onEnterFrame() : void
        {
            var _loc_1:* = getTimer();
            inSleepMode = _loc_1 - lastRunTime > sleepModeRenderTime;
            lastRunTime = _loc_1;
            if (inSleepMode)
            {
                while (_disposList.length > 0)
                {
                    
                    disposeObj(_disposList.shift());
                }
            }
            else
            {
                while (_disposList.length > 0)
                {
                    
                    disposeObj(_disposList.shift());
                    if (getTimer() - _loc_1 >= 5)
                    {
                        break;
                    }
                }
            }
            if (_disposList.length == 0)
            {
                Tick.removeCallback(onEnterFrame);
            }
            return;
        }

        private static function disposeObj(dispostItem:*) : void
        {
            if (dispostItem is BitmapData)
            {
                (dispostItem as BitmapData).dispose();
                dispostItem = null;
            }
            else if (dispostItem is XML)
            {
                System.disposeXML(dispostItem as XML);
            }
            else if (dispostItem is ByteArray)
            {
                (dispostItem as ByteArray).clear();
            }
            return;
        }

    }
}
