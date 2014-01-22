package com.thinkido.framework.utils {

	/**
	 * 回调方法
	 * @author thinkido
	 */
	public class Callback {
		private var _method : Function;
		private var _args : Array;

		public function Callback(method : Function, ...args : Array) {
			_method = method;
			_args = args;
		}
		/**
		 * 返回回调的方法
		 * @return 方法体 function的引用
		 */
		public function get method() : Function {
			return _method;
		}
		/**
		 * 执行回调方法 
		 * @param args 回调方法的参数
		 * 
		 */
		public function execute(...args : Array) : void {
			try {
				var new_args : Array = _args.concat();
				for each(var item:* in args) {
					new_args.push(item);
				}
				_method.apply(null, new_args);
			} catch(error : Error) {
				
			}
		}
		/**
		 * 判断2个回调的方法是否一样 
		 * @param $callback
		 * @return 如果相等true
		 */
		public function equal($callback : Callback) : Boolean {
			return _method == $callback.method;
		}
	}
}