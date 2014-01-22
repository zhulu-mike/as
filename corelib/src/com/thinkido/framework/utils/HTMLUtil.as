package com.thinkido.framework.utils
{
	/**
	 * 字符于html字符的装换 
	 * @author thinkido
	 * 
	 */
    public class HTMLUtil extends Object
    {
        private static var delHtmlreg:RegExp = new RegExp("</?[^<>]+>", "gmi");

        public function HTMLUtil()
        {
            return;
        }
		/**
		 * 字符转换为html 字符 
		 * @param $color
		 * @param $text
		 * @return 
		 * 
		 */
        public static function addColor($color:String, $text:String) : String
        {
            return "<font color=\'" + $color + "\'>" + $text + "</font>";
        }
		/**
		 * 字符转换为html 字符 
		 * @param $color
		 * @param $text
		 * @return 
		 * 
		 */
        public static function addColorSize($color:String,$size:int, $text:String) : String
        {
            return "<font color=\'" + $color + "\' size=\'" + $size +"\'>" + $text + "</font>";
        }
		/**
		 *  html 字符转换为 字符
		 * @param $html
		 * @return 不包含html 格式的普通字符
		 * 
		 */
        public static function removeHtml($html:String) : String
        {
            if ($html)
            {
                return $html.replace(delHtmlreg, "");
            }
            return "";
        }

    }
}
