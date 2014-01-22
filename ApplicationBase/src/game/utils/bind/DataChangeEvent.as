package game.utils.bind
{
	import flash.events.Event;

    public class DataChangeEvent extends Event
    {
        public var newValue:Object;
        public var oldValue:Object;
        public var valueName:String;
        public static const CHANGE:String = "change";

        public function DataChangeEvent($valueName:String, $oldValue = null, $newValue = null)
        {
            super(CHANGE);
            this.valueName = $valueName;
            this.oldValue = $oldValue;
            this.newValue = $newValue;
            return;
        }

    }
}
