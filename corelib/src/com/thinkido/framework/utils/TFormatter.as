package com.thinkido.framework.utils {

	/**
	 * GFormatter 时间格式化工具类
	 * 
	 * @author bright
	 * @version 20101011
	 */
	public class TFormatter {
		/**
		 * 格式化日期 
		 * @param value
		 * @return 
		 * 
		 */
		public static function formatDate(value : Date) : String {
			var result : String = value.getFullYear() + "-";
			var month : int = value.getMonth() + 1;
			result += (month > 9) ? month : "0" + month;
			result += "-";
			var date : int = value.getDate();
			result += (date > 9) ? date : "0" + date;
			var hours : int = value.getHours();
			result += " ";
			result += (hours > 9) ? hours : "0" + hours;
			result += ":";
			var minutes : int = value.getMinutes();
			result += (minutes > 9) ? minutes : "0" + minutes;
			result += ":";
			var seconds : int = value.getSeconds();
			result += (seconds > 9) ? seconds : "0" + seconds;
			return result;
		}
		/**
		 * 根据毫秒返回时间信息 
		 * @param second
		 * @return 如 02:02:09 2小时2分9秒
		 * 
		 */	
		public static function formatFromSecond(second:uint) : String
		{
			var _loc_2:* = Math.floor(second / 3600);
			var _loc_3:* = Math.floor((second - _loc_2 * 3600) / 60);
			var _loc_4:* = second % 60;
			var _loc_5:* = OneDigitAddZero(_loc_2);
			var _loc_6:* = OneDigitAddZero(_loc_3);
			var _loc_7:* = OneDigitAddZero(_loc_4);
			if (_loc_5 == "00")
			{
				return _loc_6 + ":" + _loc_7;
			}
			return _loc_5 + ":" + _loc_6 + ":" + _loc_7;
		}
		/**
		 * 根据毫秒返回时间信息 
		 * @param second
		 * @return 如2小时8分钟37秒
		 * 
		 */		
		public static function formatFromSecond1(second:uint) : String
		{
			var _loc_2:* = Math.floor(second / 3600);
			var _loc_3:* = Math.floor((second - _loc_2 * 3600) / 60);
			var _loc_4:* = second % 60;
			var _loc_5:* = _loc_2.toString();
			var _loc_6:* = _loc_3.toString();
			var _loc_7:* = _loc_4.toString();
			var _loc_8:String = "";
			if (_loc_5 != "0")
			{
				_loc_8 = _loc_5 + "小时";
			}
			if (_loc_6 != "0")
			{
				_loc_8 = _loc_8 + (_loc_6 + "分");
			}
			if (_loc_7 != "0")
			{
				_loc_8 = _loc_8 + (_loc_7 + "秒");
			}
			return _loc_8;
		}
		/**
		 * 根据毫秒返回多久前登陆过。 如： 1月前 ，2天前、昨天、小时前
		 * @param start
		 * @param now
		 * @return 
		 * 
		 */		
		public static function formatFromSecond2(start:uint, now:uint) : String
		{
			var _loc_3:* = now - start;
			var _loc_4:* = Math.floor(_loc_3 / (3600 * 24));
			if (Math.floor(_loc_3 / (3600 * 24)) > 30)
			{
				return "1月前";
			}
			if (_loc_4 >= 2 && _loc_4 <= 30)
			{
				return _loc_4 + "天前";
			}
			if (_loc_4 == 1)
			{
				return "昨天";
			}
			var _loc_5:* = Math.floor(_loc_3 / 3600);
			if (Math.floor(_loc_3 / 3600) >= 1)
			{
				return _loc_5 + "小时前";
			}
			var _loc_6:* = Math.floor(_loc_3 / 60);
			if (Math.floor(_loc_3 / 60) >= 30)
			{
				return "半小时前";
			}
			if (_loc_6 > 0 && _loc_6 < 30)
			{
				return _loc_6 + "分钟前";
			}
			return "刚刚";
		}
		/**
		 * 补充0 ，如时间为 20:09 分钟 
		 * @param param1
		 * @return 
		 * 
		 */		
		private static function OneDigitAddZero(param1:uint) : String
		{
			if (param1 < 10)
			{
				return "0" + param1;
			}
			return param1.toString();
		}
		
	
	}
}