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
		
		private static var currentPlat:String = PlatType.BAUDU;
		
		/**
		 * 设置本次发布版本平台
		 * @param plat
		 * 
		 */		
		public static function initPlat(plat:String):void
		{
			currentPlat = plat;
		}
		
		/**
		 * 是否是某个平台
		 * @param type
		 * @return 
		 * 
		 */		
		public static function isCertainPlat(type:String):Boolean
		{
			return currentPlat == type;
		}
	}
}