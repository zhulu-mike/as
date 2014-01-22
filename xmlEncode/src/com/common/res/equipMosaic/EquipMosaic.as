package game.common.res.equipMosaic
{
    import game.common.res.lan.*;
    import game.manager.LanResManager;

    public class EquipMosaic extends Object
    {
        private static var equipMosaicObj:Object = {};

        public function EquipMosaic()
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
            for each (_loc_3 in _loc_2.equipmenplayconfig)
            {
                
                equipMosaicObj["" + _loc_3.@goodmodel_id] = (_loc_3.ronghe_condition as XMLList).toString();
            }
            return;
        }

        public static function getEquipMosaicData(param1:int) : int
        {
            if (equipMosaicObj["" + param1] == undefined || equipMosaicObj["" + param1] == "0" || equipMosaicObj["" + param1] == "")
            {
                return 0;
            }
            if (String(equipMosaicObj["" + param1]) == LanResManager.getLanCommonTextWords(Language.getKey("2509")))
            {
                return 1;
            }
            return 2;
        }

    }
}
