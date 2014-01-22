package com.thinkido.framework.utils
{
	/**
	 * 字符串工具、常用字符串方法 
	 * @author thinkido
	 * 
	 */
    public class StringHelper extends Object
    {

        public function StringHelper()
        {
            return;
        }
		/**
		 * 获取字符长度,charcode 小于0 ，大于255 的双字节，否则单字节
		 * @param param1
		 * @return 
		 * 
		 */
        public static function getCharLength(param1:String) : int
        {
            var _loc_5:Number = NaN;
            var len:int = param1.length;
            var _loc_3:int = 0;
            var _index:int = 0;
            while (_index < len)
            {
                _loc_5 = param1.charCodeAt(_index);
                if (_loc_5 > 255 || _loc_5 < 0)
                {
                    _loc_3 = _loc_3 + 2;
                }
                else
                {
                    _loc_3 = _loc_3 + 1;
                }
                _index++;
            }
            return _loc_3;
        }
		/**
		 * 删除空白 
		 * @param param1
		 * @return 
		 * 
		 */
        public static function trim(param1:String) : String
        {
            if (param1 == null)
            {
                return "";
            }
            var _loc_2:int = 0;
            while (isWhitespace(param1.charAt(_loc_2)))
            {
                
                _loc_2++;
            }
            var _loc_3:* = param1.length - 1;
            while (isWhitespace(param1.charAt(_loc_3)))
            {
                
                _loc_3 = _loc_3 - 1;
            }
            if (_loc_3 >= _loc_2)
            {
                return param1.slice(_loc_2, (_loc_3 + 1));
            }
            return "";
        }
		/**
		 * 判断字符是否是空白字符 
		 * @param param1
		 * @return 
		 * 
		 */ 
        public static function isWhitespace(param1:String) : Boolean
        {
            switch(param1)
            {
                case " ":
                case "\t":
                case "\r":
                case "\n":
                case "\f":
                {
                    return true;
                }
                default:
                {
                    return false;
                    break;
                }
            }
        }

        public static function getString(param1:String) : String
        {
            return param1 == null ? ("") : (param1);
        }

    }
}
