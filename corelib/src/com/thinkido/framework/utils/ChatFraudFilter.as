package com.thinkido.framework.utils
{
	/**
	 * 聊天骗子屏蔽 
	 * @author thinkido
	 * 
	 */
    public class ChatFraudFilter extends Object
    {
        private static var _source:Array = [];
        private static const LIMITVALUE:Number = 1;
		/**
		 * 屏蔽 
		 */		
        private static var reg:RegExp = new RegExp("[\\s█﹦﹢【】〖〗﹝﹞〔〕﹜﹛﹢＋≒＝（）]", "img");
		/**
		 * 过滤字符，如QQ 
		 */        
		private static var DelReg:RegExp = new RegExp("[^IO1234567890１２３４５６７８９０①②③④⑤⑥⑦⑧⑨⒈⒉⒊⒋⒌⒍⒎⒏⒐ⅠⅡⅢⅣⅤⅥⅦⅧⅨ㈠㈡㈢㈣㈤㈥㈦㈧㈨⑴⑵⑶⑷⑸⑹⑺⑻⑼零壹贰叁肆伍陆柒捌玖一二三四五六七八九]", "img");
        private static var regIndex:int = 0;

        public function ChatFraudFilter()
        {
            return;
        }

        public static function set source(param1:Array) : void
        {
            var _loc_2:Object = null;
            if (param1 != null)
            {
                _source = param1;
                for each (_loc_2 in _source)
                {
                    
                    _loc_2.rep = new RegExp(_loc_2.rep, "ig");
                    _loc_2.point = parseFloat(_loc_2.point);
                }
            }
            return;
        }
		/**
		 * 验证是否是骗子 
		 * @param $string 聊天内容
		 * @return 骗子返回true
		 * 
		 */
        public static function isChatFraud($string:String) : Boolean
        {
            var _item:Object = null;
            var _num:Number = 0;
            for each (_item in _source)
            {
                if ($string.search(_item.rep) > -1)
                {
                    _num = _num + _item.point;
                    if (_num >= LIMITVALUE)
                    {
                        return true;
                    }
                }
            }
            return false;
        }
		/**
		 * 验证内容是否有QQ号 
		 * @param $content 需验证的字符串
		 * @return 有QQ号 true
		 * 
		 */
        public static function hasQQInfo($content:String) : Boolean
        {
            var _reg:RegExp = new RegExp("[IO1234567890１２３４５６７８９０①②③④⑤⑥⑦⑧⑨⒈⒉⒊⒋⒌⒍⒎⒏⒐ⅠⅡⅢⅣⅤⅥⅦⅧⅨ㈠㈡㈢㈣㈤㈥㈦㈧㈨⑴⑵⑶⑷⑸⑹⑺⑻⑼零壹贰叁肆伍陆柒捌玖一二三四五六七八九]{7,13}", "img");
            return _reg.test($content);
        }
		/**
		 * 删除字符串中的特殊字符 
		 * @param $content 
		 * @return 删除后的字符串
		 * 
		 */
        public static function delSpecialSymbols($content:String) : String
        {
            return $content.replace(DelReg, "");
        }

    }
}
