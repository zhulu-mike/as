package game.common.res.tuteng
{

    public class TuTengResManager extends Object
    {
        private static var tutengResContainer:Object = new Object();

        public function TuTengResManager()
        {
            return;
        }

        public static function parseRes(param1:String) : void
        {
            var _loc_3:TuTengRes = null;
            var _loc_4:XML = null;
            var _loc_2:* = XML(param1);
            if (!_loc_2)
            {
                return;
            }
            for each (_loc_4 in _loc_2.totems.totem)
            {
                
                _loc_3 = new TuTengRes();
                _loc_3.id = _loc_4.@id;
                _loc_3.name = _loc_4.name;
                tutengResContainer[_loc_3.id] = _loc_3;
            }
            return;
        }

        public static function getTuTeng(param1:int) : TuTengRes
        {
            return tutengResContainer[param1];
        }

    }
}
