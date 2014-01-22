package game.common.res.jingmai
{

    public class XueweiResManager extends Object
    {
        private static var xueweiResContainer:Object = new Object();
        private static var xueweiResContainer_zhenlong:Object = new Object();
        private static var jingmaiRes_xueweiNum:Object = new Object();

        public function XueweiResManager()
        {
            return;
        }

        public static function parseRes(param1:String) : void
        {
            var _loc_3:XueweiRes = null;
            var _loc_4:XML = null;
            var _loc_5:int = 0;
            var _loc_2:* = XML(param1);
            if (!_loc_2)
            {
                return;
            }
            for each (_loc_4 in _loc_2.RECORD)
            {
                
                _loc_3 = new XueweiRes();
                _loc_3.f_id = parseInt(_loc_4.f_id);
                _loc_3.f_name = _loc_4.f_name;
                _loc_3.f_hp_add = parseInt(_loc_4.f_hp_add);
                _loc_3.f_mp_add = parseInt(_loc_4.f_mp_add);
                _loc_3.f_sp_add = parseInt(_loc_4.f_sp_add);
                _loc_3.f_attack_add = parseInt(_loc_4.f_attack_add);
                _loc_3.f_defence_add = parseInt(_loc_4.f_defence_add);
                _loc_3.f_dodge_add = parseInt(_loc_4.f_dodge_add);
                _loc_3.f_crt_add = parseInt(_loc_4.f_crt_add);
                _loc_3.f_need_zhenqi = parseInt(_loc_4.f_need_zhenqi);
                _loc_3.f_odds = parseInt(_loc_4.f_odds);
                xueweiResContainer[_loc_3.f_id] = _loc_3;
                _loc_5 = Math.floor(_loc_3.f_id / 100);
                if (!jingmaiRes_xueweiNum.hasOwnProperty(_loc_5))
                {
                    jingmaiRes_xueweiNum[_loc_5] = 0;
                    continue;
                }
                (jingmaiRes_xueweiNum[_loc_5] + 1);
            }
            return;
        }

        public static function parseRes_zhenlong(param1:String) : void
        {
            var _loc_3:XueweiRes = null;
            var _loc_4:XML = null;
            var _loc_2:* = XML(param1);
            if (!_loc_2)
            {
                return;
            }
            for each (_loc_4 in _loc_2.RECORD)
            {
                
                _loc_3 = new XueweiRes();
                _loc_3.f_id = parseInt(_loc_4.f_id);
                _loc_3.f_name = _loc_4.f_name;
                _loc_3.f_hp_add = parseInt(_loc_4.f_hp_add);
                _loc_3.f_mp_add = parseInt(_loc_4.f_mp_add);
                _loc_3.f_sp_add = parseInt(_loc_4.f_sp_add);
                _loc_3.f_attack_add = parseInt(_loc_4.f_attack_add);
                _loc_3.f_defence_add = parseInt(_loc_4.f_defence_add);
                _loc_3.f_dodge_add = parseInt(_loc_4.f_dodge_add);
                _loc_3.f_crt_add = parseInt(_loc_4.f_crt_add);
                _loc_3.f_need_zhenqi = parseInt(_loc_4.f_need_zhenqi);
                _loc_3.f_odds = parseInt(_loc_4.f_odds);
                _loc_3.f_goodmodel_id = parseInt(_loc_4.f_goodmodel_id);
                _loc_3.f_goodmodel_count = parseInt(_loc_4.f_goodmodel_count);
                xueweiResContainer_zhenlong[_loc_3.f_id] = _loc_3;
            }
            return;
        }

        public static function getXueweiRes(param1:int, param2:Boolean) : XueweiRes
        {
            return param2 ? (xueweiResContainer_zhenlong[param1]) : (xueweiResContainer[param1]);
        }

        public static function getJingmaiRes(param1:int, param2:Boolean) : XueweiRes
        {
            return param2 ? (xueweiResContainer_zhenlong[param1 * 100 + 1]) : (xueweiResContainer[param1 * 100 + 1]);
        }

        public static function getJingmai_xueweiNum(param1:int) : int
        {
            return jingmaiRes_xueweiNum[param1];
        }

        public static function getXueweiResByName(param1:String, param2:Boolean) : XueweiRes
        {
            var _loc_3:XueweiRes = null;
            var _loc_4:* = param2 ? (xueweiResContainer_zhenlong) : (xueweiResContainer);
            for each (_loc_3 in _loc_4)
            {
                
                if (_loc_3.f_name == param1)
                {
                    return _loc_3;
                }
            }
            return null;
        }

    }
}
