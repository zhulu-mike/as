package com.thinkido.framework.manager
{
    
    import com.thinkido.framework.common.events.helper.EventDispatchHelper;
    import com.thinkido.framework.common.events.helper.EventListenHelper;
    import com.thinkido.framework.common.events.vo.EventListenData;
    
    import flash.events.Event;
    import flash.events.EventDispatcher;
    
    import org.osflash.thunderbolt.Logger;

    public class EventManager extends Object
    {
        private static var _eventArr:Array = [];

        public function EventManager()
        {
            throw new Event("静态类");
        }

        public static function dispatchEvent(event:Event, dispatcher:EventDispatcher = null) : void
        {
            EventDispatchHelper.dispatchEvent(event, dispatcher);
            return;
        }

        public static function addEvent($type:String, $listener:Function, $dispatcher:EventDispatcher = null, $useCapture:Boolean = false, $priority:int = 0, $useWeakReference:Boolean = false) : void
        {
            var _eventData:EventListenData = null;
            if (hasSameEvent($type, $listener, $dispatcher, $useCapture, $priority, $useWeakReference))
            {
                return;
            }
            _eventArr[_eventArr.length] = new EventListenData($type, $listener, $dispatcher, $useCapture, $priority, $useWeakReference);
            EventListenHelper.addEvent($type, $listener, $dispatcher, $useCapture, $priority, $useWeakReference);
            return;
        }

        public static function removeEvent(param1:String, param2:Function, param3:EventDispatcher = null, param4:Boolean = false) : void
        {
            var _loc_5:EventListenData = null;
            for each (_loc_5 in _eventArr)
            {
                
                if (_loc_5.type == param1 && _loc_5.listener == param2 && _loc_5.dispatcher == param3 && _loc_5.useCapture == param4)
                {
                    _eventArr.splice(_eventArr.indexOf(_loc_5), 1);
                    Logger.info("EventManager.removeEvent::_eventArr.length:" + getEventsNum());
                    break;
                }
            }
            EventListenHelper.removeEvent(param1, param2, param3, param4);
            return;
        }

        public static function hasEvent(param1:String, param2:EventDispatcher = null) : Boolean
        {
            return EventListenHelper.hasEvent(param1, param2);
        }

        public static function willTrigger(param1:String, param2:EventDispatcher = null) : Boolean
        {
            return EventListenHelper.willTrigger(param1, param2);
        }

        public static function getEventsNum() : int
        {
            return _eventArr.length;
        }

        public static function getEventsNumByDispatcher(param1:EventDispatcher) : int
        {
            var _loc_3:EventListenData = null;
            var _loc_2:int = 0;
            for each (_loc_3 in _eventArr)
            {
                
                if (_loc_3.dispatcher == param1)
                {
                    _loc_2++;
                }
            }
            return _loc_2;
        }

        public static function addEvents(param1:Array, param2:Function, param3:EventDispatcher = null, param4:Boolean = false, param5:int = 0, param6:Boolean = false) : void
        {
            var _loc_7:String = null;
            if (!param1 || param1.length == 0)
            {
                return;
            }
            for each (_loc_7 in param1)
            {
                
                addEvent(_loc_7, param2, param3, param4, param5, param6);
            }
            return;
        }

        public static function removeEvents(param1:Array, param2:Function, param3:EventDispatcher = null, param4:Boolean = false) : void
        {
            var _loc_5:String = null;
            if (!param1 || param1.length == 0)
            {
                return;
            }
            for each (_loc_5 in param1)
            {
                
                removeEvent(_loc_5, param2, param3, param4);
            }
            return;
        }

        public static function removeAllEvents() : void
        {
            var _loc_1:EventListenData = null;
            for each (_loc_1 in _eventArr)
            {
                
                EventListenHelper.removeEvent(_loc_1.type, _loc_1.listener, _loc_1.dispatcher, _loc_1.useCapture);
            }
            _eventArr = [];
            return;
        }

        public static function removeEventsByDispatcher(param1:EventDispatcher) : void
        {
            var _loc_2:int = 0;
            var _loc_3:EventListenData = null;
            _loc_2 = 0;
            while (_loc_2 < _eventArr.length)
            {
                
                _loc_3 = _eventArr[_loc_2];
                if (_loc_3.dispatcher == param1)
                {
                    EventListenHelper.removeEvent(_loc_3.type, _loc_3.listener, _loc_3.dispatcher, _loc_3.useCapture);
                    _eventArr.splice(_loc_2, 1);
                }
                _loc_2++;
            }
            return;
        }

        public static function hasSameEvent(param1:String, param2:Function, param3:EventDispatcher = null, param4:Boolean = false, param5:int = 0, param6:Boolean = false) : Boolean
        {
            var _loc_8:EventListenData = null;
            var _loc_7:Boolean = false;
            for each (_loc_8 in _eventArr)
            {
                
                if (_loc_8.equals(param1, param2, param3, param4, param5, param6))
                {
                    _loc_7 = true;
                    break;
                }
            }
            return _loc_7 && hasEvent(param1);
        }

    }
}
