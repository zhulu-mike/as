package com.thinkido.framework.engine.events
{
	/**
	 * 主角走动事件 
	 * @author Administrator
	 * 
	 */
    public class SceneEventAction_walk extends Object
    {
        public static const READY:String = "SceneEventAction_walk.READY";
        public static const THROUGH:String = "SceneEventAction_walk.THROUGH";
        public static const ARRIVED:String = "SceneEventAction_walk.ARRIVED";
        public static const UNABLE:String = "SceneEventAction_walk.UNABLE";
        public static const JUMP_READY:String = "SceneEventAction_walk.JUMP_READY";
        public static const JUMP_THROUGH:String = "SceneEventAction_walk.JUMP_THROUGH";
        public static const JUMP_ARRIVED:String = "SceneEventAction_walk.JUMP_ARRIVED";
        public static const JUMP_UNABLE:String = "SceneEventAction_walk.JUMP_UNABLE";
        public static const ON_TRANSPORT:String = "SceneEventAction_walk.ON_TRANSPORT";
        public static const SEND_PATH:String = "SceneEventAction_walk.SEND_PATH";
        public static const SEND_JUMP_PATH:String = "SceneEventAction_walk.SEND_JUMP_PATH";

        public function SceneEventAction_walk()
        {
            return;
        }

    }
}
