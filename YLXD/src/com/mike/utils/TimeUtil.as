package com.mike.utils
{
	public class TimeUtil
	{
		public function TimeUtil()
		{
		}
		
		/**
		 * 把时间转化成字符串格式 1977-01-01 00:00:00
		 * @param time:int
		 * @return string
		 */
		public static function getYearStrByTime(time:int):String
		{
			if (time <= 0)
				return "- -";
			var str:String = "";
			var date:Date = new Date();
			date.setTime(time*1000);
			str += changeNumToStr(Math.floor(time/3600));
			str += ":";
			str += changeNumToStr(Math.floor(time%3600/60));
			str += ":";
			str += changeNumToStr(Math.floor(time%3600%60));
			return str;
		}
		
		public static function changeNumToStr(num:int):String
		{
			return num < 10 ? "0" + String(num) : String(num);
		}
		
		/**
		 * 把时间转化成字符串格式 00:00:00
		 * @param time:int
		 * @return string
		 */
		public static function getStrByTime(time:int):String
		{
			if (time < 0)
				time = 0;
			var str:String = "";
			str += changeNumToStr(Math.floor(time/3600));
			str += ":";
			str += changeNumToStr(Math.floor(time%3600/60));
			str += ":";
			str += changeNumToStr(Math.floor(time%3600%60));
			return str;
		}
		
		/**
		 * 把时间转化成字符串格式 00:00
		 * @param time:int
		 * @return string
		 */
		public static function getMinuteStrByTime(time:int):String
		{
			var str:String = "";
			str += changeNumToStr(Math.floor(time/60));
			str += ":";
			str += changeNumToStr(Math.floor(time%60));
			return str;
		}
		
		
		/**
		 * 把剩余时间转化成字符串格式xx天 xx小时xx分xx秒
		 * @param time:int
		 * @return string
		 */
		public static function getLeftTimeBySec(second:int):String
		{
			var str:String = "";
			var days:int = int(second / 86400);
			var hour:int = int(second % 86400 / 3600);
			var minute:int = int(second % 3600 / 60);
			var sec:int = second % 60;
			
			if(days > 0)
				str += days + "天";
			if(hour > 0)
				str += hour + "时";
			if(minute > 0)
				str += minute + "分";
			str += sec + "秒";
			return str;
		}
		
		
		/**
		 * 把剩余时间转化成字符串格式 00:00:00:00
		 * @param time:int
		 * @return string
		 */
		public static function getLeftTimeWithDays(second:int):String
		{
			var str:String = "";
			var days:int = int(second / 86400);
			var hour:String = changeNumToStr(int(second % 86400 / 3600));
			var minute:String = changeNumToStr(int(second % 3600 / 60));
			return days + ':' + hour + ':' + minute;
		}
		
		
		/**
		 * 根据结束时间，获取剩余时间字符串
		 */
		public static function getServerLeftTimeString(time:int):String
		{
			var nowTime:int = new Date().time * 0.001;
			var leftTime:int = time - nowTime;
			if (leftTime < 0)
				return "- -";
			return getStrByTime(leftTime);
		}
		
		/***/
		public static function getNowTime():int
		{
			var date:Date = new Date();
			return int(date.getTime()*0.001);
		}
		
		
		/**
		 *	获得系统的当前时间  (00:00:00)
		 * @return 
		 * 
		 */		
		public static function getCurrTime():String
		{
			var date:Date = new Date;
			var hour:int = date.getHours();
			var minute:int = date.getMinutes();
			var sec:int = date.getSeconds();
			
			var str:String = changeNumToStr(hour);
			str += ':';
			str += changeNumToStr(minute);
			str += ':';
			str +=changeNumToStr(sec);
			
			return str;
		}
		
		/***/
		public static function getTodayDay():int
		{
			var date:Date = new Date();
			return date.getDate();
		}
		
		/**
		 * 把秒转化为xx月xx日的格式
		 * 
		 */		
		public static function timeToDate(time:int):String
		{
			var date:Date = new Date();
			date.setTime(time*1000);
			var str:String = "";
			str = (date.getUTCMonth()+1) + "月";
			str = str + date.getUTCDate() + "日";
			return str;
			
		}
		
		/**
		 *	返回 时间格式 xxxx-xx-xx 00:00:00 
		 * @param sec
		 * @return 
		 * 
		 */		
		public static function getDateAndTimeBySec(sec:int):String
		{
			var date:Date = new Date(sec * 1000);
			var year:int = date.getFullYear();
			var month:int = date.getMonth() + 1;
			var day:int = date.getDate();
			
			var hour:int = date.getHours();
			var minute:int = date.getMinutes();
			var sec:int = date.getSeconds();
			
			var str:String  = year.toString();
			str += '-';
			str += changeNumToStr(month);
			str += '-';
			str += changeNumToStr(day);
			str += '  ';
			str += changeNumToStr(hour);
			str += ':';
			str += changeNumToStr(minute);
			str += ':';
			str +=changeNumToStr(sec);
			
			return str;
		}
		
		/**
		 * 获取今日的凌晨时候的时间，单位秒
		 * @return 
		 * 
		 */		
		public static function getTodayZeroTime():int
		{
			var date:Date = new Date();
			date.setHours(0,0,0,0);
			return date.getTime()*0.001;
		}
	}
}