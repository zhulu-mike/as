package lm.mui.events
{
	import flash.events.Event;

    public class LibraryEvent extends Event
    {
        public static var EMBED_COMPLETE:String = "embedComplete";
        public static var LOAD_COMPLETE:String = "loadComplete";

        public function LibraryEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
        {
            super(param1, param2, param3);
            return;
        }

        override public function clone() : Event
        {
            return new LibraryEvent(type, bubbles, cancelable);
        }

    }
}
