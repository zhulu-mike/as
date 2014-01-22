package game.common.res.shouji
{
    import game.common.res.task.vo.*;

    public class ShoujiResManager extends Object
    {
        private static var shoujiResContainer:Object = new Object();

        public function ShoujiResManager()
        {
            return;
        }

        public static function parseRes(param1:String) : void
        {
            var _loc_3:ShoujiRes = null;
            var _loc_4:XML = null;
            var _loc_2:* = XML(param1);
            if (!_loc_2)
            {
                return;
            }
            for each (_loc_4 in _loc_2.goods_dcs.goods_dc)
            {
                
                _loc_3 = new ShoujiRes();
                _loc_3.id = _loc_4.@id;
                _loc_3.name = _loc_4.name;
                _loc_3.grade = _loc_4.@grade;
                _loc_3.rewardDesc = _loc_4.rewardDesc;
                _loc_3.targetGoods = getTargetGoodsArr(_loc_4.@targetGoods);
                shoujiResContainer[_loc_3.id] = _loc_3;
            }
            return;
        }

        public static function getShoujiRes(param1:int) : ShoujiRes
        {
            return shoujiResContainer[param1];
        }

        public static function getAllShoujiResArr() : Array
        {
            var _loc_2:ShoujiRes = null;
            var _loc_1:Array = [];
            for each (_loc_2 in shoujiResContainer)
            {
                
                _loc_1.push(_loc_2);
            }
            _loc_1.sortOn("grade", Array.NUMERIC);
            return _loc_1;
        }

        public static function getTargetGoodsArr(param1:String, param2:Boolean = true) : Array
        {
            var _loc_5:Array = null;
            var _loc_6:String = null;
            var _loc_7:TaskTargetData = null;
            if (param1 == undefined || param1 == null || param1 == "" || param1 == "null" || param1 == "undefined")
            {
                return [];
            }
            param1 = param1.replace(/^,(.+)$""^,(.+)$/, "$1").replace(/^(.+),$""^(.+),$/, "$1");
            var _loc_3:Array = [];
            var _loc_4:* = param1.split(",");
            for each (_loc_6 in _loc_4)
            {
                
                _loc_5 = _loc_6.split("#");
                _loc_7 = new TaskTargetData(_loc_5[0], int(Number(_loc_5[1])), _loc_5[2], null, param2 ? (TaskTargetPos.fromSplitString(_loc_5[3], "_")) : (new TaskTargetPos(0, 0, 0, 0)));
                _loc_7.userData = _loc_5[4];
                _loc_3.push(_loc_7);
            }
            return _loc_3;
        }

    }
}
