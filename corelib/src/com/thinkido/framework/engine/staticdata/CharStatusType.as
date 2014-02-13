package com.thinkido.framework.engine.staticdata
{
	/**
	 * 人物状态 
	 * @author thinkido
	 * 
	 */
    public class CharStatusType extends Object
    {
		/**
		 * 站 
		 */		
        public static const STAND:String = "stand";
		/**
		 * 走 
		 */		
        public static const WALK:String = "walk";
		/**
		 * 跳 
		 */		
        public static const JUMP:String = "jump";
		/**
		 *坐 
		 */		
        public static const SIT:String = "sit";
		/**
		 * 攻击 
		 */		
        public static const ATTACK:String = "attack";
		/**
		 * 技能
		 */		
        public static const SKILL:String = "skill";
		/**战魂技能*/
		public static const SKILL1:String = "skill1";
		/**
		 * 坐骑攻击 
		 */		
        public static const MOUNT_ATTACK:String = "mount_attack";
		/**
		 * 受伤 
		 */		
        public static const INJURED:String = "injured";
		/**
		 * 死亡 
		 */		
        public static const DEATH:String = "death";

        public function CharStatusType()
        {
            return;
        }
		/**
		 * 是否只播放1次 
		 * @param $type
		 * @return false 需要循环播放
		 * 
		 */
        public static function isOnly1Repeat($type:String) : Boolean
        {
            if ($type == STAND || $type == WALK || $type == SIT)
            {
                return false;
            }
            return true;
        }
		public static function getIsShowWeapon(status:String) : Boolean
		{
			if (status == SIT )
			{
				return false;
			}
			return true;
		}
		
		public static function getIsFight(status:String) : Boolean
		{
			if (status == ATTACK || status == SKILL || status == SKILL1 )
			{
				return true;
			}
			return false;
		}

    }
}
