package game.common.res.silingzhen
{

    public class SiLingZhenResManager extends Object
    {
        private static var siLingZhenObj:Object = {};

        public function SiLingZhenResManager()
        {
            return;
        }

        public static function parseRes(param1:Object) : void
        {
            var _loc_3:XML = null;
            var _loc_2:* = XML(param1);
            if (!_loc_2)
            {
                return;
            }
            for each (_loc_3 in _loc_2.lingzhens.lingzhen)
            {
                
                siLingZhenObj[String(_loc_3.@type) + "_" + String(_loc_3.@grade)] = {zhenFaName:String(_loc_3.name), btnid:int(_loc_3.@ico_swfid), avatarid:int(_loc_3.@beast_swfid), gongji:int(_loc_3.@attack), fangyu:int(_loc_3.@defence), hp:int(_loc_3.@maxhp), hurtjianmian:int(_loc_3.@shjm), hurtfantan:int(_loc_3.@shft), hushifanyu:int(_loc_3.@hsfy), gongjizhengqiang:int(_loc_3.@attack_add), tupo_show_lv:int(_loc_3.@tupo_show_lv), zhenqi:int(_loc_3.@zhenqi), cailiao_num:int(_loc_3.@cailiao_num), cailiao_id:int(_loc_3.@cailiao_id), limit_zufu:int(_loc_3.@limit_zufu)};
            }
            return;
        }

        public static function getSiLingZhenData(param1:int, param2:int) : Object
        {
            if (siLingZhenObj[param1 + "_" + param2] == undefined || siLingZhenObj[param1 + "_" + param2] == null)
            {
                return {};
            }
            return siLingZhenObj[param1 + "_" + param2];
        }

    }
}
