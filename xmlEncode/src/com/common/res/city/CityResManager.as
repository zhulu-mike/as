package game.common.res.city
{

    public class CityResManager extends Object
    {
        public static var cityXML:XML;

        public function CityResManager()
        {
            return;
        }

        public static function parseRes(param1:String) : void
        {
            cityXML = XML(param1);
            return;
        }

    }
}
