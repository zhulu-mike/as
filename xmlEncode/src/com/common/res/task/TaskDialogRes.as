package game.common.res.task
{

    public class TaskDialogRes extends Object
    {
        public var taskId:int;
        public var dialogType:int;
        public var npcId:int;
        public var talks:Array;

        public function TaskDialogRes()
        {
            this.taskId = 0;
            this.dialogType = 3;
            this.npcId = 0;
            this.talks = [];
            return;
        }

    }
}
