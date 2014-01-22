package game.common.res.monster
{
	import game.common.res.BaseResID;

	public class MonsterRes extends BaseResID
	{
		public var name:String;
		
		/**怪物类型0-普通怪物,1-镖车怪物 2-人形怪物*/
		public var type:int;
		
		/**描述*/
		public var desc:String;
		
		/**最大血量*/
		public var Hp_max:int;
		
		/**形象*/
		public var model:int;
		
		/**图像*/
		public var headimg:int;
		
		/**星级*/
		public var star_level:int;
		
		/**等级*/
		public var level:int;
		
		/**音效*/
		public var sound:int;
		
		/**性别 	0女，1男*/
		public var sex:int;
		
		/**是否可被攻击	0 : 不可以, 1 : 可以*/
		public var isattack:int;
		
//		public var talks:Array;
		
		public function MonsterRes()
		{
		}
	}
}