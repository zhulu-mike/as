package com.thinkido.framework.manager.loader.vo
{
	/**
	 * 通常用来加载swf 文件到 当前域中  
	 * @author thinkido
	 * 
	 */
    public class RslLoadingInfo extends Object
    {
        public var loadList:Array;
        public var callBack:Function;
        public var priority:int;
		/**
		 *  
		 * @param $loadList 加载队列
		 * @param $callBack 回调
		 * @param $priority 优先级
		 * 
		 */
        public function RslLoadingInfo($loadList:Array, $callBack:Function, $priority:int)
        {
            this.loadList = $loadList;
            this.callBack = $callBack;
            this.priority = $priority;
            return;
        }

    }
}
