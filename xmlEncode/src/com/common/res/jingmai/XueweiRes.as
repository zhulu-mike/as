package game.common.res.jingmai
{
    import game.common.res.lan.*;
    import game.manager.LanResManager;

    public class XueweiRes extends Object
    {
        public var f_id:int;
        public var f_name:String;
        public var f_hp_add:int;
        public var f_mp_add:int;
        public var f_sp_add:int;
        public var f_attack_add:int;
        public var f_defence_add:int;
        public var f_dodge_add:int;
        public var f_crt_add:int;
        public var f_need_zhenqi:int;
        public var f_odds:int;
        public var f_goodmodel_id:int;
        public var f_goodmodel_count:int;

        public function XueweiRes()
        {
            return;
        }

        public function get jingmaiID() : int
        {
            return Math.floor(this.f_id / 100);
        }

        public function get addStr() : String
        {
            var _loc_1:* = LanResManager.getLanCommonTextWords(Language.getKey("2513"));
            var _loc_2:* = _loc_1.split("|");
            var _loc_3:Array = [];
            if (this.f_hp_add > 0)
            {
                _loc_3.push(_loc_2[0] + "+" + this.f_hp_add);
            }
            if (this.f_mp_add > 0)
            {
                _loc_3.push(_loc_2[1] + "+" + this.f_mp_add);
            }
            if (this.f_sp_add > 0)
            {
                _loc_3.push(_loc_2[2] + "+" + this.f_sp_add);
            }
            if (this.f_attack_add > 0)
            {
                _loc_3.push(_loc_2[3] + "+" + this.f_attack_add);
            }
            if (this.f_defence_add > 0)
            {
                _loc_3.push(_loc_2[4] + "+" + this.f_defence_add);
            }
            if (this.f_dodge_add > 0)
            {
                _loc_3.push(_loc_2[5] + "+" + this.f_dodge_add);
            }
            if (this.f_crt_add > 0)
            {
                _loc_3.push(_loc_2[6] + "+" + this.f_crt_add);
            }
            return _loc_3.join(",");
        }

    }
}
