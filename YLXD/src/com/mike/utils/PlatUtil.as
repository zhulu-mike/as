package com.mike.utils
{
	/**
	 * 平台管理
	 * @author administrater
	 * 
	 */	
	public class PlatUtil
	{
		public function PlatUtil()
		{
		}
		
		private static var _currentPlat:int = PlatType.BAUDU;

		public static function set currentPlat(value:int):void
		{
			_currentPlat = value;
		}

		
		public static function get currentPlat():int
		{
			return _currentPlat;
		}
		
		/**
		 * 设置本次发布版本平台
		 * @param plat
		 * 
		 */		
		public static function initPlat(plat:int):void
		{
			currentPlat = plat;
		}
		
		/**
		 * 是否是某个平台
		 * @param type
		 * @return 
		 * 
		 */		
		public static function isCertainPlat(type:int):Boolean
		{
			return currentPlat == type;
		}
	}
}