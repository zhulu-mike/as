package com.thinkido.framework.events
{
	import flash.events.Event;

    public class TimeEvent extends Event
    {
        public static const DateChange:String = "dateChange";
        public static const ServerOpenDayChange:String = "ServerOpenDayChange";

        public function TimeEvent($type:String)
        {
            super($type, false, false);
            return;
        }

    }
}
