package tools.managers
{
	import flash.utils.Dictionary;
	
	import tools.common.staticdata.EquipPosition;
	import tools.common.vo.EquipAtt;
	import tools.common.vo.EquipBase;
	import tools.common.vo.EquipCompoundInfo;
	import tools.common.vo.UserEquipInfo;
	import tools.events.PipeEvent;

	public class EquipManager
	{
		public function EquipManager()
		{
			if (instance)
			{
				throw new Error("instance error");
			}
		}
		
		/**存放装备的基本信息*/
		private var equipConfig:Dictionary = new Dictionary();
		/**装备强化消耗*/
		private var equipUpgrade:Dictionary = new Dictionary();
		
		/**装备合成配置数据*/
		private static var equipCompound:Dictionary = new Dictionary();
		
		public static var starMulti:int = 10;
		
		private static var instance:EquipManager;
		public static function getInstance():EquipManager
		{
			if (!instance)
				instance = new EquipManager();
			return instance;
		}
		
		
		public function creatConfigByXml($data:XML):void
		{
			var baseVO:EquipBase;
			
			if (!equipConfig.hasOwnProperty($data.@config_equ_id))
			{
				baseVO = new EquipBase();
				baseVO.id 			 = $data.@config_equ_id;
				baseVO.ep 			 = $data.@ep;
				baseVO.hp 			 = $data.@blood;
				baseVO.cp 			 = $data.@cru_level;
				baseVO.bp            = $data.@bp;
				baseVO.dcp           = $data.@def_cru_level;
				baseVO.desc          = $data.@desc;
				baseVO.sale          = $data.@is_sell;
				baseVO.name          = $data.@name;
				baseVO.type          = $data.@type;
				baseVO.power         = $data.@power;
				baseVO.dhurt         = $data.@avoid_harm;
				baseVO.image         = $data.@icon;
				baseVO.model         = $data.@image;
				baseVO.attack        = $data.@att;
				baseVO.career        = $data.@career;
				baseVO.defense       = $data.@def;
				baseVO.discard       = $data.@is_give_up;
				baseVO.quaility      = $data.@quality;
				baseVO.buyPrice      = $data.@buy_price;
				baseVO.dressLev      = $data.@level_lmt;
				baseVO.equipLev      = $data.@level;
				baseVO.salePrice     = $data.@sell_pirce;
				baseVO.equipType     = $data.@flag;
				baseVO.moveSpeed     = $data.@speed;
				baseVO.kill_level    = $data.@kill_level;
				baseVO.upgradeFactor = $data.@upgradeFactor;
				baseVO.hpUp 		 = $data.@blood_strengcoe;
				baseVO.attackUp 	 = $data.@att_strengcoe;
				baseVO.defenseUp 	 = $data.@def_strengcoe;
				baseVO.source 		 = $data.@source;
				equipConfig[baseVO.id]  = baseVO;
//				vo.equipBase = baseVO;
			}else{
//				vo.equipBase = getEquipConfigInfo($data.@config_equ_id);
			}
		}
		
		public function getAllEquipInfo():Array
		{
			var equipArr:Array=new Array();
			for(var k:* in equipConfig)
			{
				var equipObj:Object=new Object();
				equipObj.id=equipConfig[k].id;
				equipObj.ep=equipConfig[k].ep;
				equipObj.hp=equipConfig[k].hp;
				equipObj.cp=equipConfig[k].cp;
				equipObj.bp=equipConfig[k].bp;
				equipObj.dcp=equipConfig[k].dcp;
				equipObj.desc=equipConfig[k].desc;
				equipObj.sale=equipConfig[k].sale;
				equipObj.name=equipConfig[k].name;
				equipObj.type=equipConfig[k].type
				equipObj.power=equipConfig[k].power;
				equipObj.dhurt=equipConfig[k].dhurt;
				equipObj.image=equipConfig[k].image;
				equipObj.model=equipConfig[k].model
				equipObj.attack=equipConfig[k].attack;
				equipObj.career=equipConfig[k].career;
				equipObj.defense=equipConfig[k].defense;
				equipObj.discard=equipConfig[k].discard;
				equipObj.quaility=equipConfig[k].quaility;
				equipObj.buyPrice=equipConfig[k].buyPrice;
				equipObj.dressLev=equipConfig[k].dressLev;
				equipObj.equipLev=equipConfig[k].equipLev;
				equipObj.salePrice=equipConfig[k].salePrice;
				equipObj.equipType=equipConfig[k].equipType;
				equipObj.moveSpeed=equipConfig[k].moveSpeed;
				equipObj.kill_level=equipConfig[k].kill_level;
				equipObj.upgradeFactor=equipConfig[k].upgradeFactor;
				equipObj.hpUp=equipConfig[k].hpUp;
				equipObj.attackUp=equipConfig[k].attackUp;
				equipObj.source=equipConfig[k].source;
				equipObj.defenseUp=equipConfig[k].defenseUp;
				equipArr.push(equipObj);
			}
			return equipArr;
		}
		
		
		/**
		 * 获取装备的基本信息 
		 * @param cid 配置ID
		 * 
		 */		
		public function getEquipConfigInfo(cid:int):EquipBase
		{
			if (equipConfig.hasOwnProperty(cid))
			{
				return equipConfig[cid] as EquipBase;
			}
			return null;
		}
		
		
	
		
		
		
		
		
		/**
		 * 根据人物属性类型，返回其代表的属性名.eg.1表示攻击力
		 * @param ptype
		 * 
		 */		
		public static function getRolePropertyString(ptype:int):String
		{
			switch (ptype)
			{
				case 1:
					return Language.ATTACK;
				case 2:
					return Language.DEFENSE;
				case 3:
					return Language.POWER;
				case 4:
					return Language.TILI;
				case 5:
					return Language.NAILI;
				case 6:
					return Language.BAOJIDENGJI;
				case 7:
					return Language.BISHADENGJI;
				case 8:
					return Language.MIANSHANGZHI;
				case 9:
					return Language.HP;
				case 10:
					return Language.KANGBAODENGJI;
				default:
					return "";
			}
		}
		
		
		
		/**解析装备强化消耗*/
		public function parseUpgradeConfig(xml:XML):void
		{
			var infos:XMLList = xml.p;
			var info:XML, temp:Object;
			for each (info in infos)
			{
				temp = {};
				temp.lev = int(info.@lev);
				temp.levtype = int(info.@levtype);
				temp.typelev = int(info.@typelev);
				temp.pos1 = int(info.@pos1);
				temp.pos2 = int(info.@pos2);
				temp.pos3 = int(info.@pos3);
				temp.pos4 = int(info.@pos4);
				temp.pos5 = int(info.@pos5);
				temp.pos6 = int(info.@pos6);
				temp.pos7 = int(info.@pos7);
				temp.pos8 = int(info.@pos8);
				equipUpgrade[temp.lev] = temp;
			}
			infos = xml.skystar;
			//天星系数
			if (info.length() > 0)
			{
				starMulti = infos[0].@multi;
			}
		}
		
		/**取装备强化消耗*/
		public function getEquipUpgradeCost(lev:int, pos:int): int
		{
			lev++;
			if (equipUpgrade.hasOwnProperty(lev))
			{
				return equipUpgrade[lev]["pos"+pos];
			}else{
				return 0;
			}
		}
		
		/**取装备强化到人物等级需要的消耗*/
		public function getEquipUpgradeMaxCost(lev:int, pos:int, toLev:int): int
		{
			var total:int = 0, i:int = 0;
			
			for (lev++;lev<=toLev;lev++)
			{
				if (equipUpgrade.hasOwnProperty(lev))
				{
					total += equipUpgrade[lev]["pos"+pos];
				}
			}
			return total;
		}
		
		/**
		 * 根据位置获得该位置最低级的装备
		 * @param pos
		 * 
		 */		
		public static function getPrimaryEquipConfigInfoByPos(pos:int, career:int):EquipBase
		{
			var tar:Dictionary = getInstance().equipConfig;
			var base:EquipBase;
			for each(base in tar)
			{
				if (base.equipType == pos && base.quaility == 1)
				{
					if (base.equipType != EquipPosition.WUQI)
						return base;
					else if (base.career == career)
						return base;
				}
			}
			return null;
		}
		
		public static function parseEquipCompound(data:XML):void
		{
			var xmls:XMLList = data.p;
			var equip:XML, vo:EquipCompoundInfo;
			var id:int = 0;
			for each (equip in xmls)
			{
				id = equip.@needequip;
				if (equipCompound.hasOwnProperty(id))
					continue;
				vo = new EquipCompoundInfo();
				vo.id = equip.@id;
				vo.needequip = id;
				vo.cailiao = String(equip.@cailiao).split(";");
				vo.scroll = equip.@scroll;
				equipCompound[id] = vo;
			}
		}
		
		/**
		 * 获取该装备可以合成的装备数据
		 * @param cid
		 * @return 
		 * 
		 */		
		public static function getEquipCompound(cid:int):EquipCompoundInfo
		{
			if (equipCompound.hasOwnProperty(cid)==false)
				return null;
			return equipCompound[cid] as EquipCompoundInfo;
		}
		
		
		
	}
}