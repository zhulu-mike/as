package tools.common.vo
{
	public class UserEquipInfo
	{
		public function UserEquipInfo()
		{
		}
		
		/**装备ID*/
		public var id:int;
		
		/**角色ID*/
		public var roleid:int;
		
		/**装备的配置ID*/
		public var cid:int;
		
		public var grid:int;
		
		/**
		 * 附加属性
		 */		
		public var equipAtt:EquipAtt = new EquipAtt();
		
		/**
		 * 配置属性
		 */		
		public var equipBase:EquipBase;
		
		/**
		 * 真实的基础属性
		 */		
		public var equipReal:EquipProperty = new EquipProperty();
		
		/***/
		public function copy(target:UserEquipInfo):void
		{
			if (target == null)
				return;
			this.id = target.id;
			this.cid = target.cid;
			this.equipBase = target.equipBase;
			this.grid = target.grid;
			this.roleid = target.roleid;
			this.equipAtt.attack = target.equipAtt.attack;
			this.equipAtt.bp = target.equipAtt.bp;
			this.equipAtt.cp = target.equipAtt.cp;
			this.equipAtt.dcp = target.equipAtt.dcp;
			this.equipAtt.defense = target.equipAtt.defense;
			this.equipAtt.dhurt = target.equipAtt.dhurt;
			this.equipAtt.ep = target.equipAtt.ep;
			this.equipAtt.hp = target.equipAtt.hp;
			this.equipAtt.kill_level = target.equipAtt.kill_level;
			this.equipAtt.moveSpeed = target.equipAtt.moveSpeed;
			this.equipAtt.power = target.equipAtt.power;
			this.equipAtt.sell_price = target.equipAtt.sell_price;
			this.equipAtt.star_cost = target.equipAtt.star_cost;
			this.equipAtt.starLevel = target.equipAtt.starLevel;
			this.equipAtt.streng_cost = target.equipAtt.streng_cost;
			this.equipAtt.upgradeLevel = target.equipAtt.upgradeLevel;
			this.equipAtt.upgradeFactor = target.equipAtt.upgradeFactor;
			
			this.equipReal.attack = target.equipReal.attack;
			this.equipReal.bp = target.equipReal.bp;
			this.equipReal.cp = target.equipReal.cp;
			this.equipReal.dcp = target.equipReal.dcp;
			this.equipReal.defense = target.equipReal.defense;
			this.equipReal.dhurt = target.equipReal.dhurt;
			this.equipReal.ep = target.equipReal.ep;
			this.equipReal.hp = target.equipReal.hp;
			this.equipReal.kill_level = target.equipReal.kill_level;
			this.equipReal.moveSpeed = target.equipReal.moveSpeed;
			this.equipReal.power = target.equipReal.power;
			this.equipReal.sell_price = target.equipReal.sell_price;
		}
	}
}