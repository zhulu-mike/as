package game.common.res.activity
{
	import game.common.res.activity.ActivityResManager;
	
    public class ActivityRes extends Object
    {
        public var id:int;
		public var icon:int;
		public var type:int;
        public var name:String;
        public var desc:String;
		public var memo:String;
		public var during:String;
//        public var fromTime:String;
//        public var toTime:String;
        public var receptionLevel:int;
		public var receptionPropID:int;
		public var loop:int;
		
		public var copper:int;
		public var aura:int;
		public var exp:int;
		public var prestige:int;
		
		public var button_label:String;
//		public var minPlayerNum:int;

        public function ActivityRes()
        {
        }
    }
}
