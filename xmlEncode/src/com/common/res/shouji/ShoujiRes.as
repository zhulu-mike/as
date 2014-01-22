package game.common.res.shouji
{
    import game.common.res.task.vo.*;

    public class ShoujiRes extends Object
    {
        public var id:int;
        public var name:String;
        public var grade:int;
        public var targetGoods:Array;
        public var rewardDesc:String;
        public var pointCnt:int;

        public function ShoujiRes()
        {
            this.targetGoods = [];
            return;
        }

        public function getTargetGoods(param1:int) : TaskTargetData
        {
            var _loc_2:TaskTargetData = null;
            for each (_loc_2 in this.targetGoods)
            {
                
                if (_loc_2.id == param1)
                {
                    return _loc_2;
                }
            }
            return null;
        }

    }
}
