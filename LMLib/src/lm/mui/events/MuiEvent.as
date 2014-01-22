package lm.mui.events
{
	import flash.events.Event;

    public class MuiEvent extends Event
    {
        public var selectedIndex:int;
        public static const GTABBAR_SELECTED_CHANGE:String = "GTabBarSelectedChange";
        public static const GLOADEDBUTTON_STYLE_COMPLETE:String = "GLoadedButton_style_complete";
		public static const UPDATE_COMPLETE:String = "GUICOMPONENT_UPDATE_COMPLETE";

        public function MuiEvent(param1:String, param2:int = -1, param3:Boolean = false, param4:Boolean = false)
        {
            super(param1, param3, param4);
            this.selectedIndex = param2;
            return;
        }

    }
}
