package game.common.res.combo
{

    public class ComboResManager extends Object
    {
        private static var comboXML:XML;

        public function ComboResManager()
        {
            return;
        }

        public static function parseRes(param1:String) : void
        {
            comboXML = XML(param1);
            return;
        }

        public static function getComboXML(param1:int) : XML
        {
            var _loc_2:int = 0;
            var _loc_3:* = comboXML.children();
            var _loc_4:* = _loc_3.length();
            _loc_2 = 0;
            while (_loc_2 < _loc_4)
            {
                
                if (param1.toString() == _loc_3[_loc_2].@id)
                {
                    return _loc_3[_loc_2];
                }
                _loc_2++;
            }
            return null;
        }

    }
}
