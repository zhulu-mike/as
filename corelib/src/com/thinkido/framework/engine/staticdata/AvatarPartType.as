package com.thinkido.framework.engine.staticdata
{
	/**
	 * 控制播放次数和深度
	 * @author thinkido.com
	 */
    public class AvatarPartType extends Object
    {
		/**
		 * 人物 
		 */		
        public static var BODY:String = "body";
		/**
		 * 武器 
		 */		
        public static var WEAPON:String = "weapon";
		
		/**
		 * 翅膀
		 */		
		public static var WING:String = "wing";
		
        public static var BOW:String = "bow";
		/**
		 * 坐骑 
		 */		
        public static var MOUNT:String = "mount";
		/**
		 * 魔法光环 
		 */		
        public static var MAGIC_RING:String = "magic_ring";
		/**
		 * 魔法 
		 */		
        public static var MAGIC:String = "magic";
		/**
		 * 移动时魔法 
		 */		
        public static var MAGIC_PASS:String = "magic_pass";
		/**
		 * avatarParamData 类型对应播放次数
		 * 0：无限次，
		 * 1：一次 
		 */		
        private static const defautRepeatArr:Array = [[MOUNT, 0], [BODY, 0], [WEAPON, 0], [BOW, 0], [MAGIC_RING, 0], [MAGIC_PASS, 0], [MAGIC, 1], [WING,0]];
		/**
		 * 方向01267 深度排序
		 */       
		private static const depth01267Arr:Array = [[MOUNT, -100], [WING,-40], [BOW, -21], [BODY, 0], [WEAPON, 22], [MAGIC_RING, 29], [MAGIC_PASS, 30], [MAGIC, 31]];
		/**
		 * 方向345 深度排序
		 */        
		private static const depth345Arr:Array = [[MOUNT, -100], [BODY, 0], [BOW, 21], [WEAPON, 22],[WING,24], [MAGIC_RING, 29], [MAGIC_PASS, 30], [MAGIC, 31]];

        public function AvatarPartType()
        {
            return;
        }
		/**
		 *  获取默认重复次数
		 * @param $type 类型
		 * @return  次数
		 * 次数固定，不能由参数设置
		 */
        public static function getDefaultRepeat($type:String) : int
        {
            var item:Array = null;
            for each (item in defautRepeatArr)
            {
                if (item[0] == $type)
                {
                    return item[1];
                }
            }
            return 0;
        }
		/**
		 * 获取物体某方向 渲染时的深度
		 * @param $type 类型
		 * @param $way 方向
		 * @return 渲染时的深度排序
		 * 
		 */
        public static function getDefaultDepth($type:String, $way:int = 0) : int
        {
            var item:Array = null;
            var depthArr:Array = null;
            if ($way == 3 || $way == 4 || $way == 5)
            {
                depthArr = depth345Arr;
            }
            else
            {
                depthArr = depth01267Arr;
            }
            for each (item in depthArr)
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
