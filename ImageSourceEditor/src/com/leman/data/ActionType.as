package com.leman.data
{
	public class ActionType
	{
		/**站立*/
		public static const STAND:String = 'stand';
		/**行走*/
		public static const WALK:String = 'walk';
		/**攻击*/
		public static const ATTACK:String = 'attack';
		/**死亡*/
		public static const DEATH:String = 'death';
		/**受伤害*/
		public static const INJURED:String = 'injured';
		/**坐下*/
		public static const SIT:String = 'sit';
		/**技能*/
		public static const SKILL:String = 'skill';
		/**战魂技*/
		public static const SOUL_SKILL:String = 'skill1';
		
		public static const actNameArr:Array = [[STAND,'站立'],[WALK,'行走'],[ATTACK,'攻击'],[DEATH,'死亡'],[INJURED,'受伤'],[SIT,'打坐'],[SKILL,'技能'],[SOUL_SKILL,'战魂技']]
				
		public function ActionType()
		{
		}
		
		public static function getActionNameByType(type:String):String
		{
			var num:int = actNameArr.length;
			for(var i:int = 0; i < num; i++)
			{
				if(type == actNameArr[i][0])
				{
					return actNameArr[i][1];
				}
			}
			return null;
		}
	}
}