package game.common.res.lianti
{
    import game.common.ui.componets.StaticValue;
    import game.common.res.goods.*;
    import game.common.res.lan.*;
    import game.manager.LanResManager;

    public class LiantiResManager extends Object
    {
        public static const MAX_LIANTI_LV:int = 8;
        private static var liantiResContainer:Object = new Object();

        public function LiantiResManager()
        {
            return;
        }

        public static function parseRes(param1:String) : void
        {
            var _loc_3:LiantiRes = null;
            var _loc_4:XML = null;
            var _loc_2:* = XML(param1);
            if (!_loc_2)
            {
                return;
            }
            for each (_loc_4 in _loc_2.lts.lt)
            {
                
                _loc_3 = new LiantiRes();
                _loc_3.f_id = _loc_4.@f_id;
                _loc_3.f_name = _loc_4.@f_name;
                _loc_3.f_desc = _loc_4.@f_desc;
                _loc_3.f_desc_tupo = _loc_4.@f_desc_tupo;
                _loc_3.f_hp = _loc_4.@f_hp;
                _loc_3.f_mp = _loc_4.@f_mp;
                _loc_3.f_sp = _loc_4.@f_sp;
                _loc_3.f_atk = _loc_4.@f_atk;
                _loc_3.f_def = _loc_4.@f_def;
                _loc_3.f_atk_speed = _loc_4.@f_atk_speed;
                _loc_3.f_move_speed = _loc_4.@f_move_speed;
                _loc_3.f_fjsh = _loc_4.@f_fjsh;
                _loc_3.f_shjm = _loc_4.@f_shjm;
                _loc_3.f_aq_jv = _loc_4.@f_aq_jv;
                _loc_3.f_tupo_need_goodsmodel = _loc_4.@f_tupo_need_goodsmodel;
                _loc_3.f_tupo_need_goodscount = _loc_4.@f_tupo_need_goodscount;
                _loc_3.f_tupo_show_probability = _loc_4.@f_tupo_show_probability;
                _loc_3.f_zhufu_max = _loc_4.@f_zhufu_max;
                _loc_3.f_food_goodsid = _loc_4.@f_food_goodsid;
                _loc_3.f_food_map = _loc_4.@f_food_map;
                _loc_3.f_food_monstername = _loc_4.@f_food_monstername;
                _loc_3.f_location = _loc_4.@f_location;
                liantiResContainer[_loc_3.f_id] = _loc_3;
            }
            return;
        }

        public static function getLiantiRes(param1:int) : LiantiRes
        {
            return liantiResContainer[param1];
        }

        public static function getLiantiMainDes(param1:int) : String
        {
            var _loc_2:* = getLiantiRes(param1);
            if (_loc_2 == null)
            {
                return "";
            }
            var _loc_3:* = GoodsResManager.getGoodsRes(_loc_2.f_food_goodsid);
            var _loc_4:* = "<u><font color=\'" + StaticValue.GREEN_HTML + "\'><a href=\'event:goodsID#" + _loc_3.id_kind + "\'>【" + _loc_3.name + "】</a></font></u>";
            var _loc_5:* = "<u><font color=\'" + StaticValue.GREEN_HTML + "\'><a href=\'event:findPath#" + _loc_2.f_location + ",-1\'>【" + _loc_2.f_food_map + "】【" + _loc_2.f_food_monstername + "】</a></font></u>";
            return LanResManager.getLanTextWords(LiantiResManager, Language.getKey("2514"), [_loc_4, _loc_4, _loc_5, _loc_4]);
        }

    }
}
