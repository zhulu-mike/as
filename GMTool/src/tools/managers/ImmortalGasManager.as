package tools.managers
{
	import flash.utils.Dictionary;
	
	import tools.common.vo.ImmortalGasVO;
	
	/**
	 *  仙气配置文件读取
	 * @author wangjianglin
	 * 
	 */	
	public class ImmortalGasManager
	{
		public function ImmortalGasManager()
		{
		}
		
		protected static var dic:Dictionary = new Dictionary();
		public static var exchange:Array = [];
		public static var costDic:Dictionary = new Dictionary();
		
		/***/
		public static function parseConfig(xml:XML):void
		{
			var xmls:XMLList = xml.p;
			var data:XML;
			var tempVO:ImmortalGasVO, tempObj:Object;
			for each (data in xmls)
			{
				tempVO = new ImmortalGasVO();
				tempVO.id = data.@id;
				tempVO.name = data.@name;
				tempVO.attack = data.@attack;
				tempVO.baoji  = data.@baoji;
				tempVO.defense = data.@defense;
				tempVO.desc = data.@desc;
				tempVO.exchangeNeed = data.@exchangeNeed;
				tempVO.exp = data.@exp;
				tempVO.hp = data.@hp;
				tempVO.icon = data.@icon;
				tempVO.kangbaodengji = data.@kangbaodengji;
				tempVO.killLevel = data.@killLevel;
				tempVO.lev = data.@lev;
				tempVO.qua = data.@qua;
				tempVO.salePrice = data.@salePrice;
				tempVO.type = data.@type;
				tempVO.upExp = data.@upExp;
				if (dic.hasOwnProperty(tempVO.id))
				{
					dic[tempVO.id][tempVO.lev] = tempVO;
				}else{
					dic[tempVO.id] = {};
					dic[tempVO.id][tempVO.lev] = tempVO;
				}
				if (tempVO.lev == 1 && tempVO.qua >= 5)
				{
					tempObj = {};
					tempObj.id =tempVO.id;
					tempObj.name = tempVO.name;
					tempObj.desc = tempVO.desc;
					tempObj.need = tempVO.exchangeNeed;
					tempObj.label = "";
					tempObj.icon = {};
					tempObj.img = tempVO.icon;
					tempObj.qua = tempVO.qua;
					exchange.push(tempObj);
				}
				exchange.sortOn("id", Array.NUMERIC | Array.DESCENDING);
			}
			
			var costs:XML = xml.costs[0];
			xmls = costs.cost;
			for each (data in xmls)
			{
				costDic[int(data.@id)] = int(data.@tongqian);
			}
				
		}
		
		/***/
		public static function getImmortalGasVO(id:int, lev:int):ImmortalGasVO
		{
			if (dic.hasOwnProperty(id))
			{
				var obj:Object = dic[id];
				if (obj.hasOwnProperty(lev))
				{
					return obj[lev] as ImmortalGasVO;
				}
			}
			return null;
		}
		
		/***/
		public static function getColorByQuality(qua:int):uint
		{
			switch (qua)
			{
				case 1:
					return 0xc87d7d;
					break;
				case 2:
					return 0xffff00;
					break;
				case 3:
					return 0x00ff00;
					break;
				case 4:
					return 0x00ffff;
					break;
				case 5:
					return 0xff00ff;
					break;
				case 6:
					return 0xffdc14;
					break;
				default:
					return 0xc87d7d;
			}
		}
		
		/**获取炉鼎的花费*/
		public static function getFurnaceCost(id:int):int
		{
			if (costDic.hasOwnProperty(id))
			{
				return costDic[id] << 0;
			}
			return 0;
		}
		
	}
}