package com.thinkido.framework.common.utils
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.Stage;
	import flash.net.LocalConnection;
	/**
	 * 类似SystemUtil ，推荐使用SystemUtil 
	 * @author Administrator
	 * 
	 */
    public class Fun extends Object
    {

        public function Fun()
        {
            return;
        }

        public static function clearChildren(value1:DisplayObject, value2:Boolean = false, value3:Boolean = true) : void
        {
            var _loc_4:int = 0;
            if (value1 == null)
            {
                return;
            }
            if (value1 is DisplayObjectContainer)
            {
                _loc_4 = (value1 as DisplayObjectContainer).numChildren;
                while (_loc_4-- > 0)
                {
                    
                    if (value3)
                    {
                        clearChildren((value1 as DisplayObjectContainer).getChildAt(_loc_4), value2, value3);
                    }
                    if (!(value1 is Loader))
                    {
                        (value1 as DisplayObjectContainer).removeChildAt(_loc_4);
                    }
                }
            }
            else if (value2 && value1 is Bitmap && (value1 as Bitmap).bitmapData)
            {
                (value1 as Bitmap).bitmapData.dispose();
            }
            return;
        }

        public static function clearChildrenByName(value1:DisplayObject, value2:String, value3:Boolean = false, value4:Boolean = true) : void
        {
            if (!value1)
            {
                return;
            }
            var _loc_5:* = value1 as DisplayObjectContainer;
            var _loc_6:* = (value1 as DisplayObjectContainer).getChildByName(value2);
            if ((value1 as DisplayObjectContainer).getChildByName(value2) != null)
            {
                _loc_5.removeChild(_loc_6);
                clearChildren(_loc_6, value3, value4);
            }
            return;
        }

        public static function isParentChild(value1:DisplayObjectContainer, value2:DisplayObject) : Boolean
        {
            if (value2 == null || value1 == null || value2.parent == null)
            {
                return false;
            }
            if (value2.parent == value1)
            {
                return true;
            }
            return isParentChild(value1, value2.parent);
        }

        public static function isVisible(value1:DisplayObject) : Boolean
        {
            if (value1 == null || value1.visible == false)
            {
                return false;
            }
            if (value1 is Stage)
            {
                return true;
            }
            return isVisible(value1.parent);
        }

        public static function doGC() : void
        {
            try
            {
                new LocalConnection().connect("foo");
                new LocalConnection().connect("foo");
            }
            catch (error:Error)
            {
            }
            return;
        }

    }
}
