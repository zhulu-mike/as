package com.thinkido.framework.utils
{
	/**
	 * 字符验证工具，检查特殊字符，如qq,电话，身份证 
	 * @author thinkido
	 * 
	 */
    public class ValidatorUitl extends Object
    {

        public function ValidatorUitl()
        {
            return;
        }
		/**
		 * 是否为数字 
		 * @param $string
		 * @return 
		 * 
		 */
        public static function isNumber($string:String) : Boolean
        {
            var _loc_2:* = /^\d+$""^\d+$/mi;
            return _loc_2.test($string);
        }
		/**
		 * 是否为符号 
		 * @param $string
		 * @return 
		 * 
		 */
        public static function isChar($string:String) : Boolean
        {
            var _loc_2:* = /^[""^[/mi;
            return _loc_2.test($string);
        }
		/**
		 * 是否单词 
		 * @param $string
		 * @return 
		 * 
		 */
        public static function isLetter($string:String) : Boolean
        {
            var _loc_2:* = /^[a-z]{1}$""^[a-z]{1}$/mi;
            return _loc_2.test($string);
        }
		/**
		 * 是否英文 
		 * @param $string
		 * @return 
		 * 
		 */
        public static function isEn($string:String) : Boolean
        {
            var _loc_2:* = /^[a-z]+$""^[a-z]+$/mi;
            return _loc_2.test($string);
        }

        public static function isENum($string:String) : Boolean
        {
            var _loc_2:* = /^[0-9a-z]+$""^[0-9a-z]+$/mi;
            return _loc_2.test($string);
        }
		/**
		 * 是否boolean 
		 * @param $string
		 * @return 
		 * 
		 */
        public static function isBoolean($string:String) : Boolean
        {
            var _loc_2:* = /^(true|false)$""^(true|false)$/mi;
            return _loc_2.test($string);
        }
		/**
		 * 是否email格式 
		 * @param $string
		 * @return 
		 * 
		 */
        public static function isEmail($string:String) : Boolean
        {
            var _loc_2:* = /^[^\s\@]+\@[^\s\@]+$""^[^\s\@]+\@[^\s\@]+$/mi;
            return _loc_2.test($string);
        }
		/**
		 * 是否 url 字符串 
		 * @param $string
		 * @return 
		 * 
		 */
        public static function isURL($string:String) : Boolean
        {
            var _loc_2:* = /^(http|https|ftp|file)\:\/\/[\w\W]+$""^(http|https|ftp|file)\:\/\/[\w\W]+$/mi;
            return _loc_2.test($string);
        }
		/**
		 * 是否电话号码 
		 * @param $string
		 * @return 
		 * 
		 */
        public static function isTel($string:String) : Boolean
        {
            var _loc_2:* = /^(\d{3,4}-?)?(\d{7,8})(-?\d+)*$""^(\d{3,4}-?)?(\d{7,8})(-?\d+)*$/mi;
            return _loc_2.test($string);
        }
		/**
		 * 是否电话号码 
		 * @param $string
		 * @return 
		 * 
		 */
        public static function isMobile($string:String) : Boolean
        {
            var _loc_2:* = /^(13|15|18)\d{9}$""^(13|15|18)\d{9}$/mi;
            return _loc_2.test($string);
        }
		/**
		 * 是否敏感符号 
		 * @param $string
		 * @return 
		 * 
		 */
        public static function isFilter($string:String) : Boolean
        {
            var _loc_2:* = /^[^\\\\\/\?\:\\""\<\>\|]+$""^[^\\\/\?\:\"\<\>\|]+$/mi;
            return _loc_2.test($string);
        }
		/**
		 * 是否中文，包含简繁体 
		 * @param $string
		 * @return 
		 * 
		 */
        public static function isChinese($string:String) : Boolean
        {
            var _loc_2:* = /[一-龥]""[一-龥]/g;
            return _loc_2.test($string);
        }
		/**
		 * 是否身份证号码 
		 * @param $string
		 * @return 
		 * 
		 */
        public static function isCNID($string:String) : Boolean
        {
            var _loc_2:* = new Array();
            var _loc_3:String = null;
            if ($string.length != 15 && $string.length != 18)
            {
                return false;
            }
            $string = $string.toUpperCase();
            if ($string.length == 15)
            {
                _loc_3 = $string.substring(0, 6);
                _loc_3 = _loc_3 + "19";
                _loc_3 = _loc_3 + $string.substring(6, 15);
                _loc_3 = _loc_3 + getVerify(_loc_3);
                $string = _loc_3;
            }
            return getVerify($string) == $string.substring(17, 18);
        }
		/**
		 * 身份证验证字符使用
		 * @param $string
		 * @return 
		 * 
		 */
        private static function getVerify($string:String) : Object
        {
            var _loc_2:Array = [7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2, 1];
            var _loc_3:Array = [1, 0, "X", 9, 8, 7, 6, 5, 4, 3, 2];
            var _loc_4:Array = [];
            var _loc_5:int = 0;
            var _loc_6:int = 0;
            var _loc_7:int = 0;
            if ($string.length == 18)
            {
                $string = $string.substring(0, 17);
            }
            var _loc_8:int = 0;
            while (_loc_8 < 17)
            {
                
                _loc_7 = parseInt($string.substring(_loc_8, (_loc_8 + 1)));
                _loc_4[_loc_8] = _loc_7 * 1;
                _loc_8++;
            }
            var _loc_9:int = 0;
            while (_loc_9 < 17)
            {
                
                _loc_6 = _loc_6 + _loc_2[_loc_9] * _loc_4[_loc_9];
                _loc_9++;
            }
            _loc_5 = _loc_6 % 11;
            return _loc_3[_loc_5];
        }
		/**
		 * 是否香港身份证号码 
		 * @param $string
		 * @return 
		 * 
		 */
        public static function isHKID($string:String) : Boolean
        {
            var _loc_2:Object = {A:1, B:2, C:3, D:4, E:5, F:6, G:7, H:8, I:9, J:10, K:11, L:12, M:13, N:14, O:15, P:16, Q:17, R:18, S:19, T:20, U:21, V:22, W:23, X:24, Y:25, Z:26};
            var _loc_3:* = $string.substring(0, 7);
            var _loc_4:* = _loc_3.split("");
            var _loc_5:int = 0;
            var _loc_6:int = 0;
            var _loc_7:int = 0;
            var _loc_8:* = parseInt($string.substring(8, 9)) * 1;
            var _loc_9:int = 0;
            var _loc_10:int = 8;
            while (_loc_9 < 7)
            {
                
                _loc_5 = _loc_2[_loc_4[_loc_9]] || _loc_4[_loc_9];
                _loc_6 = _loc_6 + _loc_5 * _loc_10;
                _loc_9++;
                _loc_10 = _loc_10 - 1;
            }
            _loc_7 = _loc_6 % 11 == 0 ? (0) : (11 - _loc_6 % 11);
            return _loc_8 == _loc_7;
        }

    }
}
