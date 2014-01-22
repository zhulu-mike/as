package com.thinkido.framework.utils {
	import flash.utils.Dictionary;
	/**
	 * 字典工具 
	 * @author thinkido
	 */
	public class DictionaryUtil {
		/**
		 * 判断字典是否为空 
		 * @param dict 
		 * @return true:空
		 * 
		 */
		public static function isEmpty(dict : Dictionary) : Boolean {
			var item : Object;
			for each (item in dict) {
				return false;
			}
			item;
			return true;
		}
		/**
		 * 返回字典中的所有key数组 
		 * @param dict 
		 * @return key数组
		 * 
		 */
		public static function getKeys(dict : Dictionary) : Array {
			var keys : Array = new Array();
			for(var key:Object in dict) {
				keys.push(key);
			}
			return keys;
		}
		/**
		 * 返回字典中的值数组 
		 * @param dict
		 * @return 值数组
		 * 
		 */
		public static function getValues(dict : Dictionary) : Array {
			var values : Array = new Array();
			for each(var value:Object in dict) {
				values.push(value);
			}
			return values;
		}
	}
}