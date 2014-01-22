package lm.mui.core
{
    
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.geom.Rectangle;
    import flash.utils.Dictionary;
    
    import lm.mui.display.ScaleBitmap;

    public class GlobalClass extends Object
    {
        public static var libaray:Library = new Library("global");
        private static var _bitmapdataMap:Dictionary = new Dictionary();

        public function GlobalClass()
        {
            return;
        }

        public static function hasRes(param1:String) : Boolean
        {
            return libaray.hasDefinition(param1);
        }

        public static function getInstance(param1:String):Object
        {
            var cls:Class = libaray.getDefinition(param1);
            return new cls;
        }

        public static function getClass(param1:String) : Class
        {
            return libaray.getDefinition(param1);
        }

        public static function getBitmapData(param1:String) : BitmapData
        {
            if (!(param1 in _bitmapdataMap))
            {
				var bmd:BitmapData = getBitmapdataImpl(param1);
				if(bmd != null)
				{
	                _bitmapdataMap[param1] = bmd;
				}
            }
            return _bitmapdataMap[param1];
        }

        public static function getBitmap(param1:String) : Bitmap
        {
            var bmd:BitmapData = getBitmapData(param1);
            if (bmd != null)
            {
                return new Bitmap(bmd);
            }
            return null;
        }

        public static function getScaleBitmap(param1:String, param2:Rectangle = null) : ScaleBitmap
        {
            var scaleBitmap:ScaleBitmap = null;
            var bmd:BitmapData = getBitmapData(param1);
            if (bmd != null)
            {
				scaleBitmap = new ScaleBitmap(bmd.clone());
				scaleBitmap.scale9Grid = param2;
                return scaleBitmap;
            }
            return null;
        }

        private static function getBitmapdataImpl(param1:String) : BitmapData
        {
            var cls:Class = getClass(param1);
            if (cls != null)
            {
                return new cls(0, 0) as BitmapData;
            }
            return null;
        }

    }
}
