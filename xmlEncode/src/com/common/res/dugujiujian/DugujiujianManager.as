package game.common.res.dugujiujian
{

    public class DugujiujianManager extends Object
    {
        public static const MAX_LIANTI_LV:int = 8;
        private static var dugujiujianResContainer:Object = new Object();

        public function DugujiujianManager()
        {
            return;
        }

        public static function parseRes(param1:String) : void
        {
            var _loc_3:XML = null;
            var _loc_4:DugujiujianRes = null;
            var _loc_2:* = XML(param1);
            if (!_loc_2)
            {
                return;
            }
            for each (_loc_3 in _loc_2.dgwds.dgwd)
            {
                
                _loc_4 = new DugujiujianRes();
                _loc_4.id = _loc_3.@id;
                _loc_4.dzeffect_id = _loc_3.@dzeffect_id;
                _loc_4.degree = _loc_3.degree;
                _loc_4.degree_xj = _loc_3.degree_xj;
                _loc_4.rich_level = _loc_3.rich_level;
                _loc_4.sub_desc = _loc_3.sub_desc;
                _loc_4.name = _loc_3.name;
                _loc_4.main_desc = _loc_3.main_desc;
                _loc_4.ico = _loc_3.@ico_id || 50000;
                dugujiujianResContainer[_loc_4.id] = _loc_4;
            }
            return;
        }

        public static function getDugujiujianRes(param1:String) : DugujiujianRes
        {
            return dugujiujianResContainer[param1] as DugujiujianRes;
        }

    }
}
