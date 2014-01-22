package com.thinkido.framework.utils
{
	/**
	 * 常用正则表达式 
	 * @author thinkido
	 * 
	 */	
	public class RegexUtil
	{
//		^[\u4E00-\u9FA5]+$   \x80-\xFF  [\x{4e00}-\x{9fa5}]+    grep:[^0-z[:space:][:punct:]] 排除法
		/**
		 * 中文正则表达式 
		 */		
		public static const CHINESE:String = "[\u4E00-\u9FA5，。；1-9：,\.;:-]";
		public function RegexUtil()
		{
		}
	}
}