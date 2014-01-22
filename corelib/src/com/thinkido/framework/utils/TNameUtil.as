package com.thinkido.framework.utils
{
	import flash.utils.getQualifiedClassName;
	/**
	 * 对象名字工具，生成唯一名字或获取类名， 
	 * @author thinkido
	 * 
	 */	
	public class TNameUtil
	{
		private static var _counter:int=0;
		/**
		 * 获取对象唯一名字 
		 * @param object
		 * @return 
		 * 
		 */		
		public static function createUniqueName(object:Object):String{
			if(!object)return null;
			var name:String=getQualifiedClassName(object);
			var index:int=name.indexOf("::");
			if (index!=-1)name=name.substr(index+2);
			var charCode:int=name.charCodeAt(name.length-1);
			if(charCode>=48&&charCode<= 57)name+="_";
			return name+_counter++;
		}
		/**
		 * 返回对象类名， 
		 * @param object
		 * @return 
		 * 
		 */		
		public static function getUnqualifiedClassName(object:Object):String{
			var name:String;
			if(object is String)name=object as String;
			else name=getQualifiedClassName(object);
			var index:int=name.indexOf("::");
			if(index!=-1)name=name.substr(index+2);
			return name;
		}
	}
}