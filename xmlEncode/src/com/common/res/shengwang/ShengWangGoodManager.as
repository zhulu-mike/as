package game.common.res.shengwang
{

    public class ShengWangGoodManager extends Object
    {
        private static var goodsContainer:Object = new Object();

        public function ShengWangGoodManager()
        {
            return;
        }

        public static function parseTransRes(param1:String) : void
        {
            var _loc_3:XML = null;
            var _loc_4:ShengWangGoodRes = null;
            var _loc_2:* = XML(param1);
            if (!_loc_2)
            {
                return;
            }
            for each (_loc_3 in _loc_2.shop_shengwangs.shop_shengwang)
            {
                
                _loc_4 = new ShengWangGoodRes();
                _loc_4.id = _loc_3.@id;
                _loc_4.goodsID = _loc_3.@goodmodel_id;
                _loc_4.desc = _loc_3.desc;
                _loc_4.use_desc = _loc_3.use_desc;
                goodsContainer[_loc_4.id] = _loc_4;
            }
            return;
        }

        public static function getShengWangGoods(param1:int) : ShengWangGoodRes
        {
            var _loc_2:ShengWangGoodRes = null;
            for each (_loc_2 in goodsContainer)
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
