package com.thinkido.framework.manager.keyBoard
{
	/**
	 * 键盘事件数据 
	 * @author Administrator
	 * 
	 */
    public class KeyData extends Object
    {
        public var isKeyDown:Boolean = false;
        public var keyCode:uint;
        public var keyEvent:Object;

        public function KeyData($keyCode:uint, $keyEvent:Object = null)
        {
            this.keyCode = $keyCode;
            this.keyEvent = $keyEvent;
            return;
        }

    }
}
