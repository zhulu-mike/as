package com.thinkido.framework.utils
{
	/**
	 * 对象赋值工具，将一般object 的值赋值给固定类型vo 
	 * @author thinkido
	 * 
	 */
    public class ObjectParser extends Object
    {

        public function ObjectParser()
        {
            return;
        }
		/**
		 * 转换data 为 固定数据类型，如快速设置vo 值
		 * @param data 数据
		 * @param $class vo类
		 * @return vo赋值后的实例
		 * @example 下面是使用方法
		 * <listing version="3.0">		
		 * public class thinkidoVo{
		 *      public var ename:String = "william" ;
		 * 		public var website:string = "thinkido.com";
		 * }
		 * 
		 * var data:Object = {ename:"thinkido",website:"3-66.com"};
		 * var vo:thinkidoVo = ObjectParser.toClass(data,thinkidoVo) as thinkidoVo ;
		 * 
		 * </listing>
		 */
        public static function toClass(data:Object, $class:Class):*
        {
            var _loc_3:Object = new $class;
            putObject(data, _loc_3);
            return _loc_3;
        }
		/**
		 * 给vo类实例快速设置 值
		 * @param data 数据
		 * @param $vo vo类实例
		 * @return vo赋值后的实例
		 * @example 下面是使用方法
		 * <listing version="3.0">		
		 * public class thinkidoVo{
		 *      public var ename:String = "william" ;
		 * 		public var website:string = "thinkido.com";
		 * }
		 * var data:Object = {ename:"thinkido",website:"3-66.com"};
		 * var vo:thinkidoVo = new thinkidoVo() ;
		 * ObjectParser.toClass(data,vo) ;
		 * </listing>
		 * 
		 */
        public static function putObject(data:Object, $vo:Object) : void
        {
            var prop:* = undefined;
            for (prop in data)
            {
                if ($vo.hasOwnProperty(prop))
                {
                    $vo[prop] = data[prop];
                }
            }
            return;
        }

    }
}
