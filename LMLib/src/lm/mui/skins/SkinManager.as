package lm.mui.skins
{
	import fl.core.UIComponent;
	
	import flash.utils.Dictionary;

    public class SkinManager extends Object
    {
        private static var _skinObject:Dictionary = new Dictionary();

        public function SkinManager()
        {
            return;
        }
		/**
		 * 添加一个样式
		 * @param key 关键字，样式的名字
		 * @param value 样式
		 * 
		 */
        public static function addStyleSkin(key:String, value:SkinStyle) : void
        {
            _skinObject[key] = value;
            return;
        }

        public static function getStyleSkin(key:String) : SkinStyle
        {
            return _skinObject[key];
        }

		/**
		 * 移除一个样式
		 * @param key 样式名
		 * 
		 */		
        public static function removeStyleSkin(key:String) : void
        {
            _skinObject[key] = null;
            delete _skinObject[key];
            return;
        }

        public static function setComponentStyle(target:UIComponent, key:String) : void
        {
            var skinStyle:SkinStyle = null;
            var cls:Class = _skinObject[key] as Class;
            if (cls)
            {
				skinStyle = new cls as SkinStyle;
				skinStyle.setStyle(target);
            }
            return;
        }

    }
}
