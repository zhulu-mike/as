package com.thinkido.framework.engine.events
{
	/**
	 * 主角状态改变事件 
	 * @author Administrator
	 * 
	 */
    public class SceneEventAction_status extends Object
    {
        public static const CHANGED:String = "SceneEventAction_status.CHANGED";
		/**
		 * 进入同屏时未加载模型时触发事件 
		 */		
        public static const INVIEW_CHECKANDLOAD:String = "SceneEventAction_status.INVIEW_CHECKANDLOAD";

        public function SceneEventAction_status()
        {
            return;
        }

    }
}
