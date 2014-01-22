package tools.common.vo
{
	public class EquipBase
	{
		public function EquipBase()
		{
		}
		
		/**装备的配置ID*/
		public var id:int;
		
		public var name:String = "";
		
		/**品质级别1是绿色品质、2是紫色品质、3是金色品质*/
		public var quaility:int;
		
		/**图标*/
		public var image:int;
		
		/**是否可丢弃*/
		public var discard:int;
		
		/**是否可出售*/
		public var sale:int;
		
		/**出售价格*/
		public var salePrice:int;
		
		/**购买价格*/
		public var buyPrice:int;
		
		/**装备部位*/
		public var equipType:int;
		
		/**装备类型，武器，防具，饰品*/
		public var type:int;
		
		/**穿戴等级*/
		public var dressLev:int;
		
		/**装备等级*/
		public var equipLev:int;
		
		/**职业要求*/
		public var career:int;
		
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
		
		/**描述*/
		public var desc:String = "";
		
		/**模型*/
		public var model:int;
		
		/**攻击强化值*/
		public var attackUp:int = 0;
		
		/**防御强化值*/
		public var defenseUp:int = 0;
		
		/**生命强化值*/
		public var hpUp:int = 0;
		
		/**产地*/
		public var source:String = "";
	}
}