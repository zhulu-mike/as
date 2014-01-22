package com.thinkido.framework.common.cache
{
	import com.thinkido.framework.common.linkedlist.LNode;
	import com.thinkido.framework.utils.SystemUtil;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	/**
	 * 缓存中的链表单元 
	 * @author thinkido
	 * 
	 */
    public class CacheUnit extends LNode
    {
		/**
		 *  
		 * @param $data 缓存数据
 		 * @param $id 缓存id
		 * 
		 */
        public function CacheUnit($data:Object, $id:String)
        {
            super($data, $id);
            return;
        }

        override public function dispose() : void
        {
            if (data is BitmapData)
            {
                (data as BitmapData).dispose();
            }
            else if (data is DisplayObject)
            {
                if (data.parent && !(data.parent is Loader))
                {
                    data.parent.removeChild(data);
                }
                SystemUtil.clearChildren(data as DisplayObject, true);
            }
            data = null;
            pre = null;
            next = null;
            return;
        }

    }
}
