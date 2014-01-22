package game.common.res.anqi
{

    public class AnqiResManager extends Object
    {
        private static var anqiResContainer:Object = new Object();

        public function AnqiResManager()
        {
            return;
        }

        public static function parseRes(param1:String) : void
        {
            var _loc_3:AnQiRes = null;
            var _loc_4:XML = null;
            var _loc_2:* = XML(param1);
            if (!_loc_2)
            {
                return;
            }
            for each (_loc_4 in _loc_2.hidden_weaponss.hidden_weapons)
            {
                
                _loc_3 = new AnQiRes();
                _loc_3.id = _loc_4.@id;
                _loc_3.name = _loc_4.name;
                _loc_3.grade = _loc_4.@grade;
                _loc_3.xiu_grade = _loc_4.@xiu_grade;
                _loc_3.mastery = _loc_4.@mastery;
                _loc_3.method = _loc_4.method;
                _loc_3.spcialDesc = _loc_4.spcial_desc;
                _loc_3.spcialType = _loc_4.@spcial_type;
                _loc_3.attackDis = _loc_4.@attack_dis;
                _loc_3.tribLv = _loc_4.@trib_lv;
                _loc_3.attackTargets = _loc_4.@attack_targets;
                _loc_3.upgradeTribLv = _loc_4.@upgrade_trib_lv;
                _loc_3.upgradeNeedCopper = _loc_4.@upgrade_need_copper;
                _loc_3.upgradeNeedZhenqi = _loc_4.@upgrade_need_zhenqi;
                _loc_3.upgradeNeedGoods = _loc_4.@upgrade_need_goods;
                _loc_3.upgradeMinCnt = _loc_4.@upgrade_min_cnt;
                _loc_3.upgradeMaxCnt = _loc_4.@upgrade_max_cnt;
                _loc_3.hidden_weaponscol = _loc_4.@hidden_weaponscol;
                _loc_3.skillID = _loc_4.@skill_id;
                anqiResContainer[_loc_3.id] = _loc_3;
            }
            return;
        }

        public static function getAnQiRes(param1:int) : AnQiRes
        {
            return anqiResContainer[param1];
        }

        public static function getAnqiArray() : Array
        {
            var _loc_2:AnQiRes = null;
            var _loc_1:Array = [];
            var _loc_3:String = "";
            var _loc_4:String = "";
            for each (_loc_2 in anqiResContainer)
            {
                
                _loc_3 = _loc_2.name;
                if (_loc_3 != _loc_4)
                {
                    _loc_1.push(_loc_2);
                    _loc_4 = _loc_3;
                }
            }
            return _loc_1;
        }

        public static function getNextAnqiRes(param1:int) : AnQiRes
        {
            var _loc_4:AnQiRes = null;
            var _loc_2:* = getAnQiRes(param1);
            var _loc_3:* = _loc_2.grade + 1;
            for each (_loc_4 in anqiResContainer)
            {
                
                if (_loc_3 == _loc_4.grade)
                {
                    return _loc_4;
                }
            }
            return null;
        }

    }
}
