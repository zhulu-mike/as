package com.mike.utils
{
	/**
	 * 工厂基类
	 */
	public class BaseFactory
	{
		/**
		 * 空闲的实例
		 */		
		public var freePools:Array = [];
		
		/**
		 * 正在被使用的实例
		 */		
		public var usePools:Array = [];
		
		public function BaseFactory()
		{
		}
	}
}