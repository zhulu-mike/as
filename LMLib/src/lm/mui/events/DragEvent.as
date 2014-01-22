package lm.mui.events
{
    import flash.events.Event;
	import lm.mui.manager.IDragDrop;

    public class DragEvent extends Event
    {
        public var dragItem:IDragDrop;
        public var dropItem:IDragDrop;
        public var dragSouce:Object;
        public static const Event_Start_Drag:String = "开始拖动";
        public static const Event_Move_To:String = "物品拖动到新位置";
        public static const Event_Move_In:String = "有物品拖进此位置";
        public static const Event_Move_Over:String = "物品拖动时经过新的物品";
        public static const Event_Be_Drag_over:String = "被拖动物体经过";
        public static const Event_Throw_goods:String = "丢弃物品";
        public static const Event_Be_Drag_out:String = "物品拖动时滑出旧的物品";

        public function DragEvent(param1:String, param2:IDragDrop, param3:IDragDrop, param4:Object, param5:Boolean = false, param6:Boolean = false)
        {
            this.dragItem = param2;
            this.dropItem = param3;
            this.dragSouce = param4;
            super(param1, param5, param6);
            return;
        }

    }
}
