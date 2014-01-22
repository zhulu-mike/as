package com.thinkido.framework.manager.keyBoard
{
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	/**
	 * 自定义键盘事件 
	 * @author Administrator
	 * 
	 */
    public class KeyEvent extends Event
    {
        public var keyEvent:KeyboardEvent;
        public static const KEY_DOWN:String = "key_down";
        public static const KEY_UP:String = "key_up";

        public function KeyEvent($type:String, $bubbles:Boolean = false, $cancelable:Boolean = false)
        {
            super($type, $bubbles, $cancelable);
            return;
        }

    }
}
