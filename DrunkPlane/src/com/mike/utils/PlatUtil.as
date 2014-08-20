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
		
		private static var currentPlat:int = PlatType.BAUDU;
		
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