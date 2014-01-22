package com.thinkido.framework.engine.staticdata
{
	/**
	 * 设置场景人物类型、加载优先级、深度
	 * @author thinkido.com
	 * 
	 */
    public class SceneCharacterType extends Object
    { 	
		/**
		 * 人体模型 
		 */		
        public static const DUMMY:int = 0;
		
		/**
		 * 宠物
		 */		
		public static const CHONGWU:int = 13;
		/**
		 * 观察者
		 */		
		public static const WATCHER:int = 14;
		
		/**
		 * 物品 
		 */		
        public static const BAG:int = 11;
		/**
		 * 玩家 
		 */		
        public static const PLAYER:int = 1;
		/**
		 * NPC ... 
		 */		
        public static const NPC_FRIEND:int = 4;
		/**
		 * 坐骑 
		 */		
        public static const MOUNT:int = 3;
		/**
		 * 怪物 
		 */		
        public static const MONSTER:int = 2;
		/**
		 * NPC 
		 */		
        public static const NPC:int = 6;
		
		/**
		 * 采集品
		 */		
		public static const COLLECT:int = 12;
		/**
		 * 传送点 
		 */		
        public static const TRANSPORT:int = 7;
		/**
		 * @private
		 * 深度排序 
		 */        
		private static const defautDepthArr:Array = [[BAG, -int.MAX_VALUE + 1], [TRANSPORT, -int.MAX_VALUE]];
		/**
		 *  优先级排序
		 */        
		private static const defautLoadPriority:Array = [[DUMMY, 1], [BAG, 5], [PLAYER, 8], [NPC_FRIEND, 6], [MOUNT, 7], [MONSTER, 2], [NPC, 3], [TRANSPORT, 4]];

        public function SceneCharacterType()
        {
            return;
        }
		/**
		 * 返回默认深度 
		 * @param $type
		 * @return 
		 * 
		 */
        public static function getDefaultDepth($type:int) : int
        {
            var item:Array = null;
            for each (item in defautDepthArr)
            {
                
                if (item[0] == $type)
                {
                    return item[1];
                }
            }
            return 0;
        }
		/**
		 * 返回优先级 
		 * @param $type
		 * @return 
		 * 
		 */
        public static function getDefaultLoadPriority($type:int) : int
        {
            var item:Array = null;
            for each (item in defautLoadPriority)
            {
                if (item[0] == $type)
                {
                    return item[1];
                }
            }
            return 0;
        }

    }
}
