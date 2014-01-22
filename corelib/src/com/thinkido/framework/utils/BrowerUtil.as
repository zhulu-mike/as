package com.thinkido.framework.utils
{
    import flash.net.*;
	/**
	 * 浏览器工具类，更多可以查看使用browerHelper
	 * @author thinkido
	 * 
	 */
    public class BrowerUtil extends Object
    {

        public function BrowerUtil()
        {
            return;
        }
		/**
		 * @param $url 网址
		 * @param $type 打开类型
		 */
        public static function getUrl($url:String, $type:String = "_blank") : void
        {
            if ($url != null && $url != "")
            {
                navigateToURL(new URLRequest($url), $type);
            }
            return;
        }
		/**
		 * 刷新页面 
		 */
        public static function reload() : void
        {
            navigateToURL(new URLRequest("javascript:location.reload();"), "_self");
            return;
        }

    }
}
