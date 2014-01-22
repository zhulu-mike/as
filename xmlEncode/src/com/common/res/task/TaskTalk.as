package game.common.res.task
{

    public class TaskTalk extends Object
    {
        public var talkType:int;
        public var talkNpc:int;
        public var talk:String;

        public function TaskTalk()
        {
            return;
        }

        public function getTalk(param1:Boolean = true) : String
        {
            var _loc_2:* = this.talk;
            var _loc_3:* = new RegExp("{([^}]*?)/([^}]*?)}", "g");
            if (param1)
            {
                _loc_2 = _loc_2.replace(_loc_3, "$1");
            }
            else
            {
                _loc_2 = _loc_2.replace(_loc_3, "$2");
            }
            return _loc_2;
        }

    }
}
