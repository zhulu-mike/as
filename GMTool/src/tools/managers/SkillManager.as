package tools.managers
{
	import tools.common.staticdata.PlayerCareerType;
	import tools.common.staticdata.SkillType;
	import tools.common.vo.SkillAffectDescInfo;
	import tools.common.vo.SkillBaseInfo;

	public class SkillManager
	{
		public function SkillManager()
		{
			if (instance)
				throw Error("");
		}
		
		private static var instance:SkillManager;
		public static function getInstance():SkillManager
		{
			if (!instance)
				instance = new SkillManager();
			return instance;
		}
		
		private var _xianling:Object = {};
		
		private var _xinfa:Object = {};
		
		private var _zhanhun:Object = {};
		
		private var _qianghao:Object = {};
		
		private var _yingwu:Object = {};
		
		private var _chenhaoSkill:Object = {};
		
		private var _xpSkill:Object = {};
		
		/** */
		public function get XianLingSkill():Object
		{
			return _xianling;
		}
		
		/** */
		public function get YingWuSkill():Object
		{
			return _yingwu;
		}
		
		/** */
		public function get QiangHaoSkill():Object
		{
			return _qianghao;
		}
		
		/** */
		public function get ZhanHun():Object
		{
			return _zhanhun;
		}
		
		/**获取某职业的所有主动技能*/
		public function getCareerSkill(career:int):Object
		{
			if (career == PlayerCareerType.QIANGHAO)
				return _qianghao;
			if (career == PlayerCareerType.XIANLING)
				return _xianling;
			if (career == PlayerCareerType.YINGWU)
				return _yingwu;
			return null;
		}
		
		/** */
		public function analysisXML(xml:XML):void
		{
			if (!xml)
				return;
			decodeXml(xml.child("qianghao")[0].child("s"), _qianghao);
			decodeXml(xml.child("yingwu")[0].child("s"), _yingwu);
			decodeXml(xml.child("xinfa")[0].child("s"), _xinfa);
			decodeXml(xml.child("xianling")[0].child("s"), _xianling);
			decodeXml(xml.child("zhanhun")[0].child("s"), _zhanhun);
			decodeXml(xml.child("xpjineng")[0].child("s"), _xpSkill);
			
		}
		
		/** */
		private function decodeXml(srcs:XMLList, vo:Object):void
		{
			if (!srcs || !vo)
				return;
			var id:int, tempVO:SkillBaseInfo;
			for each (var xml:XML in srcs)
			{
				id = xml.@id;
				tempVO = new SkillBaseInfo();
				if (vo.hasOwnProperty(id))
					vo[id].push(tempVO);
				else
					vo[id] = [tempVO];
				tempVO.id     = xml.@id;
				tempVO.type   = xml.@type;
				tempVO.level  = xml.@level;
				tempVO.name   = xml.@name;
				tempVO.desc   = xml.@desc;
				tempVO.bigImg = xml.@bigImg;
				tempVO.coldtime = xml.@coolingtime != null ? xml.@coolingtime : 0;
				tempVO.distance = xml.@distance ? xml.@distance : 0;
				tempVO.nuqi = xml.@depletion ? xml.@depletion : 0;
				tempVO.upgradeNeedLevel  = xml.@upgradeNeedLevel;
				tempVO.upgradeNeedLingqi = xml.@upgradeNeedLingqi;
				tempVO.isDanTi = int(xml.@isDanTi);
				var adesc:String  = xml.@affectDesc;
				if (adesc == "0")
					continue;
				var descArr:Array = adesc.split(";"); 
				var tempDesc:SkillAffectDescInfo, arrr:Array;
				for each (var obj:Object in descArr)
				{
					tempDesc = new SkillAffectDescInfo();
					arrr = obj.toString().split(",");
					tempDesc.type  = arrr[0];
					tempDesc.value = arrr[2];
					tempDesc.vType = arrr[1];
					tempVO.skillAffects.push(tempDesc);
				}
			}
		}
		
		/** 
		 * 获取某职业技能的所有等级的信息
		 * @param sid:int 技能ID
		 * @param career:int 职业类型
		 * @param type:int 技能类型
		 * @return Array
		 * @see SkillType.as
		 * 
		 */
		public function getSkillVO(sid:int, career:int, type:int):Array
		{
			var vo:Object = _xinfa;
			if (type != SkillType.XINFA)
			{
				vo = _xianling;
				if (career == PlayerCareerType.QIANGHAO)
					vo = _qianghao;
				else if (career == PlayerCareerType.YINGWU)
					vo = _yingwu;
			}
			if (!vo.hasOwnProperty(sid))
				return null;
			return vo[sid] as Array;
		}
		
		/**
		 * 获取技能的某个等级的信息
		 * @param sid:int 技能ID
		 * @param career:int 职业类型
		 * @param type:int 技能类型
		 * @param lev:int 技能等级
		 * @return SkillBaseInfo
		 * @see SkillType.as
		 *
		 */
		public function getSkillLevelVO(sid:int, career:int, type:int, lev:int):SkillBaseInfo
		{
			var vo:Object = _xinfa;
			if (type != SkillType.XINFA)
			{
				vo = _xianling;
				if (career == PlayerCareerType.QIANGHAO)
					vo = _qianghao;
				else if (career == PlayerCareerType.YINGWU)
					vo = _yingwu;
			}
			var arr:Array = vo[sid];
			for each (var obj:SkillBaseInfo in arr)
			{
				if (int(obj.level) == lev)
				{
					return obj;
				}
			}
			return null;
		}
		
		/**获取枪豪技能的某等级的信息*/
		public function getQianghaoSkilllLevelVO(sid:int, type:int, lev:int):SkillBaseInfo
		{
			var vo:Object = _qianghao;
			if (type == SkillType.XINFA)
				vo = _xinfa;
			if (!vo.hasOwnProperty(sid))
				return null;
			var arr:Array = vo[sid];
			for each (var obj:SkillBaseInfo in arr)
			{
				if (int(obj.level) == lev)
				{
					return obj;
				}
			}
			return null;
		}
		
		/**获取枪豪技能的所有等级的信息*/
		public function getQianghaoSkilllVO(sid:int, type:int):Array
		{
			var vo:Object = _qianghao;
			if (type == SkillType.XINFA)
				vo = _xinfa;
			if (vo.hasOwnProperty(sid))
				return vo[sid] as Array;
			return null;
		}
		
		/**获取仙灵技能的某等级的信息*/
		public function getXianLingSkilllLevelVO(sid:int, type:int, lev:int):SkillBaseInfo
		{
			var vo:Object = _xianling;
			if (type == SkillType.XINFA)
				vo = _xinfa;
			if (!vo.hasOwnProperty(sid))
				return null;
			var arr:Array = vo[sid];
			for each (var obj:SkillBaseInfo in arr)
			{
				if (int(obj.level) == lev)
				{
					return obj;
				}
			}
			return null;
		}
		
		/**获取仙灵技能的所有等级的信息*/
		public function getXianLingSkilllVO(sid:int, type:int):Array
		{
			var vo:Object = _xianling;
			if (type == SkillType.XINFA)
				vo = _xinfa;
			if (vo.hasOwnProperty(sid))
				return vo[sid] as Array;
			return null;
		}
		
		/**获取影舞技能的某等级的信息*/
		public function getYingWuSkilllLevelVO(sid:int, type:int, lev:int):SkillBaseInfo
		{
			var vo:Object = _yingwu;
			if (type == SkillType.XINFA)
				vo = _xinfa;
			if (!vo.hasOwnProperty(sid))
				return null;
			var arr:Array = vo[sid];
			for each (var obj:SkillBaseInfo in arr)
			{
				if (int(obj.level) == lev)
				{
					return obj;
				}
			}
			return null;
		}
		
		/**获取影舞技能的所有等级的信息*/
		public function getYingWuSkilllVO(sid:int, type:int):Array
		{
			var vo:Object = _yingwu;
			if (type == SkillType.XINFA)
				vo = _xinfa;
			if (vo.hasOwnProperty(sid))
				return vo[sid] as Array;
			return null;
		}
		
		/**获取一个心法技能的所有等级信息*/
		public function getXinFaSkillVO(sid:int):Array
		{
			var vo:Object = _xinfa;
			if (vo.hasOwnProperty(sid))
				return vo[sid] as Array;
			return null;
		}
		
		/**获取一个心法技能的某个等级信息*/
		public function getXinFaSkillLevelVO(sid:int, lev:int):SkillBaseInfo
		{
			var vo:Object = _xinfa;
			if (!vo.hasOwnProperty(sid))
				return null;
			var arr:Array = vo[sid];
			for each (var obj:SkillBaseInfo in arr)
			{
				if (int(obj.level) == lev)
				{
					return obj;
				}
			}
			return null;
		}
		/**战魂技能*/
		public function getZhanHunSkillLevelVO(sid:int, lev:int):SkillBaseInfo
		{
			var vo:Object = _zhanhun;
			if (!vo.hasOwnProperty(sid))
				return null;
			var arr:Array = vo[sid];
			for each (var obj:SkillBaseInfo in arr)
			{
				if (int(obj.level) == lev)
				{
					return obj;
				}
			}
			return null;
		}
		
		/**判断该技能是否为战魂技能*/
		public function isZhanHunSkill(sid:int):Boolean
		{
			return _zhanhun.hasOwnProperty(sid) ? true : false;
		}
		
		/**XP技能*/
		public function getXPSkillLevelVO(sid:int, lev:int):SkillBaseInfo
		{
			var vo:Object = _xpSkill;
			if (!vo.hasOwnProperty(sid))
				return null;
			var arr:Array = vo[sid];
			for each (var obj:SkillBaseInfo in arr)
			{
				if (int(obj.level) == lev)
				{
					return obj;
				}
			}
			return null;
		}
		
		/**
		 * 获取某个职业的某个主动技能的第一个等级信息
		 */
		public function getSkillFirstVO(sid:int, career:int):SkillBaseInfo
		{
			var vo:Object = _xianling;
			if (career == PlayerCareerType.QIANGHAO)
				vo = _qianghao;
			else if (career == PlayerCareerType.YINGWU)
				vo = _yingwu;
			
			var arr:Array = vo[sid], minLev:int = 9999999, i:int, r:int=0;
			for each (var obj:SkillBaseInfo in arr)
			{
				if (int(obj.level) < minLev)
				{
					minLev = int(obj.level);
					r = i;
				}
				i++;
			}
			return arr[r] as SkillBaseInfo;
		}


		public function get xpSkill():Object
		{
			return _xpSkill;
		}

	}
}