package tools.common.vo
{
	public class EquipAtt
	{
		public function EquipAtt()
		{
		}
		
		/**力量*/
		public var power:int;
		
		/**耐力*/
		public var ep:int;
		
		/**体力*/
		public var bp:int;
		
		/**攻击*/
		public var attack:int;
		
		/**防御*/
		public var defense:int;
		
		/**生命值*/
		public var hp:int;
		
		/**必杀等级*/
		public var kill_level:int;
		
		/**暴击等级*/
		public var cp:int;
		
		/**抗暴等级*/
		public var dcp:int;
		
		/**免伤值*/
		public var dhurt:int;
		
		/**移动速度*/
		public var moveSpeed:int;
		
		/**强化系数*/
		public var upgradeFactor:int;
		
		/**强化等级*/
		public var upgradeLevel:int;
		
		/**天星等级*/
		public var starLevel:int;
		
		/**强化消费铜钱 */
		public var streng_cost:int;
		
		/**天星消耗星陨值 */
		public var star_cost:int;

		/**出售价格 */
		public var sell_price:int;
		
		/**
		 * 镶嵌的孔位信息
		 * [{pos:孔位ID，id:宝石配置ID}]
		 */		
		public var holes:Array = [];
	}
}