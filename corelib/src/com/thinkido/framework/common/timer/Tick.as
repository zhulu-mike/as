package com.thinkido.framework.common.timer
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;

    public class Tick extends Object
    {
        private static const _sp:Sprite = new Sprite();
        private static var _funMap:Dictionary = new Dictionary();
        private static var _funCount:int;
        private static var _running:Boolean = true;
        private static var _isSleep:Boolean = false;
        private static const TM_GAP:uint = 100;
        private static var _preTime:Number = 0;
        private static var _nowTime:Number = 0;
        private static var _dTime:Number = 0;

        public function Tick()
        {
            return;
        }

        public static function get isSleepMode() : Boolean
        {
            return _isSleep;
        }

        public static function get running() : Boolean
        {
            return _running;
        }

        public static function start() : void
        {
            if (!_running)
            {
                if (_funCount > 0)
                {
                    _sp.addEventListener(Event.ENTER_FRAME, onTick);
                }
                _running = true;
            }
            return;
        }

        public static function stop() : void
        {
            if (_running)
            {
                if (_funCount > 0)
                {
                    _sp.removeEventListener(Event.ENTER_FRAME, onTick);
                    _preTime = 0;
                    _nowTime = 0;
                    _dTime = 0;
                }
                _running = false;
            }
            return;
        }

        public static function addCallback(param1:Function) : void
        {
            if (param1 in _funMap)
            {
                return;
            }
            _funMap[param1] = true;
            _funCount++;
            if (_running)
            {
                if (_funCount == 1)
                {
                    _sp.addEventListener(Event.ENTER_FRAME, onTick);
                }
            }
            return;
        }

        public static function removeCallback(param1:Function) : void
        {
            if (param1 in _funMap)
            {
                delete _funMap[param1];
                _funCount--;
                if (_running)
                {
                    if (_funCount == 0)
                    {
                        _sp.removeEventListener(Event.ENTER_FRAME, onTick);
                        _preTime = 0;
                        _nowTime = 0;
                        _dTime = 0;
                    }
                }
            }
            return;
        }

        public static function removeAllCallbacks() : void
        {
            if (_funCount == 0)
            {
                return;
            }
            _funMap = new Dictionary();
            _funCount = 0;
            _sp.removeEventListener(Event.ENTER_FRAME, onTick);
            _preTime = 0;
            _nowTime = 0;
            _dTime = 0;
            return;
        }

        public static function hasCallback(param1:Function) : Boolean
        {
            return param1 in _funMap;
        }

        private static function onTick(event:Event) : void
        {
            var _loc_2:* = undefined;
            _nowTime = getTimer();
            if (_preTime > 0)
            {
                _dTime = _nowTime - _preTime;
                _isSleep = _dTime > TM_GAP;
                for (_loc_2 in _funMap)
                {
                    _loc_2();
                }
            }
            _preTime = _nowTime;
            return;
        }

    }
}
