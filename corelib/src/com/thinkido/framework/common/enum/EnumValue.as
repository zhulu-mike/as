package com.thinkido.framework.common.enum
{
	public class EnumValue
	{
		public static const HEART_DELAY:Number = 180000;
		public static const MAX_JUMP_DIS:Number = 450;
		public static const BLINK2_DELAY:Number = 0.5;
		public static const JUMP_USE_HUOLI:Number = 1;
		public static const DIS_TO_NPC:Number = 125;
		public static const DIS_TO_SHENJIANG:Number = 75;
		public static const DIS_SONG:Number = 75;
		public static const BEAT_BACK_SPEED:Number = 4000;
		public static const CATCH_PET_TIME:Number = 1000;
		public static const FLYING_TIME:Number = 3000;
		
		/**
		 * 实现自定义跑动速度控制接口,如果为空，使用默认
		 */		
		public static var moveSpeedFun:Function ;
		/**
		 * 实现自定义攻击速度控制接口 ,如果为空，使用默认
		 */		
		public static var attackSpeedFun:Function ;
		
		public function EnumValue()
		{
			return;
		}
		
		public static function getMoveAvatarPlaySpeed($speed:Number) : Number
		{
			if( moveSpeedFun != null ){
				return moveSpeedFun($speed) ;
			}
			if ($speed < 200)
			{
				return 1;
			}
			if ($speed < 800)
			{
				return 1 / (1 + (200 - $speed) / 1000);
			}
			return 1.6667;
		}
		
		public static function getAttackAvatarPlaySpeed($speed:Number) : Number
		{
			if( moveSpeedFun != null ){
				return attackSpeedFun($speed) ;
			}
			if ($speed < 700)
			{
				return 1;
			}
			if ($speed < 3000)
			{
				return 1 / (1 + (700 - $speed) / 4600);
			}
			return 2;
		}
	}
}