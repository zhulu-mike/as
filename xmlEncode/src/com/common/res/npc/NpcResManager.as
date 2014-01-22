package game.common.res.npc
{
	public class NpcResManager
	{
		private static var npcResContainer:Object = new Object();
		private static var npcTransContainer:Object = new Object();
		
		public function NpcResManager()
		{
			return;
		}
		
		public static function parseNpcRes(xmlStr:String) : void
		{
			var npcRes:NpcRes;
			var xml:XML;
			var useFindXY:Boolean;
			var npcResXML:XML = XML(xmlStr);
			if (!npcResXML)
			{
				return;
			}
			for each (xml in npcResXML.npcs.npc) {
				npcRes = new NpcRes();
				npcRes.id_kind = int(Number(xml.@id));
				npcRes.id_m = int(Number(xml.@npcmodel));
				npcRes.name = String(xml.name).split("_")[0];
				npcRes.nickname = xml.nickname;
				npcRes.sceneid = int(Number(xml.@sceneid));
				npcRes.x = int(Number(xml.@x));
				npcRes.y = int(Number(xml.@y));
				useFindXY = int(Number(xml.@findX)) != 0 || int(Number(xml.@findY)) != 0;
				npcRes.findX = useFindXY ? (int(Number(xml.@findX))) : (npcRes.x);
				npcRes.findY = useFindXY ? (int(Number(xml.@findY))) : (npcRes.y);
				npcRes.direction = int(Number(xml.@direction));
				npcRes.can_redirect = int(Number(xml.@can_redirect));
				npcRes.simpleTalk = String(xml.simpleTalk).split("#");
				npcRes.randomTalk = String(xml.@randomTalk).split("#");
				npcRes.npctype = int(Number(xml.@npctype));
				npcRes.shop_type = int(Number(xml.@shopType));
				npcRes.id_ico = int(Number(xml.@npc_icon));
				npcRes.id_ico_big = int(Number(xml.@img));
				npcRes.targetGoods = int(xml.@targetGoods);
				npcRes.targetFuben = int(xml.@targetFuben);
				npcRes.functions = xml.@functions == undefined || String(xml.@functions) == "" ? ([]) : (String(xml.@functions).split(",").map(function (param1, param2:int, param3:Array) : int
				{
					return int(Number(param1));
				}
				));
				npcRes.function_task = xml.@function_task == undefined || String(xml.@function_task) == "" ? ([]) : (String(xml.@function_task).split(",").map(function (param1, param2:int, param3:Array) : int
				{
					return int(Number(param1));
				}
				));
				npcRes.function_shop = xml.@function_shop == undefined || String(xml.@function_shop) == "" ? ([]) : (String(xml.@function_shop).split(",").map(function (param1, param2:int, param3:Array) : int
				{
					return int(Number(param1));
				}
				));
				npcRes.function_transfer = xml.@function_transfer == undefined || String(xml.@function_transfer) == "" ? ([]) : (String(xml.@function_transfer).split(",").map(function (param1, param2:int, param3:Array) : int
				{
					return int(Number(param1));
				}
				));
				npcRes.function_activity = xml.@function_activity == undefined || String(xml.@function_activity) == "" ? ([]) : (String(xml.@function_activity).split(",").map(function (param1, param2:int, param3:Array) : int
				{
					return int(Number(param1));
				}
				));
				npcResContainer[npcRes.id_kind] = npcRes;
			}
			return;
		}
		
		public static function parseTransRes(param1:String) : void
		{
			var _loc_3:XML = null;
			var _loc_2:* = XML(param1);
			if (!_loc_2)
			{
				return;
			}
			for each (_loc_3 in _loc_2.trans.t)
			{
				
				npcTransContainer[int(Number(_loc_3.@id))] = _loc_3;
			}
			return;
		}
		
		public static function getNpcRes($id_kind:int) : NpcRes
		{
			return npcResContainer[$id_kind];
		}
		
		public static function getNpcTransXML(param1:int) : XML
		{
			return npcTransContainer[param1];
		}
		
		public static function getNpcIDandTaskIDArrBySceneID(param1:int = -1) : Array
		{
			var _loc_3:NpcRes = null;
			var _loc_4:Array = null;
			var _loc_2:Array = [];
			for each (_loc_3 in npcResContainer)
			{
				
				if (param1 == -1 || _loc_3.sceneid == param1)
				{
					_loc_4 = getTaskIDListByNpcID(_loc_3.id_kind);
					if (_loc_4 && _loc_4.length > 0)
					{
						_loc_2[_loc_2.length] = [_loc_3.id_kind, _loc_4];
					}
				}
			}
			return _loc_2;
		}
		
		public static function getNpcArrBySceneID(param1:int = -1) : Array
		{
			var _loc_3:NpcRes = null;
			var _loc_4:Array = null;
			var _loc_2:Array = [];
			for each (_loc_3 in npcResContainer)
			{
				
				if (param1 == -1 || _loc_3.sceneid == param1)
				{
					_loc_2[_loc_2.length] = _loc_3;
				}
			}
			return _loc_2;
		}
		
		public static function getNpcArrBySceneIDAndNpcType(scene:int, type:int) : NpcRes
		{
			var _loc_3:NpcRes = null;
			var _loc_4:Array = null;
			var _loc_2:Array = [];
			for each (_loc_3 in npcResContainer)
			{
				
				if (_loc_3.sceneid == scene && _loc_3.npctype == type)
				{
					return _loc_3;
				}
			}
			return null;
		}
		
		public static function getNpcResListBySceneID(param1:int) : Array
		{
			var _loc_3:NpcRes = null;
			var _loc_2:Array = [];
			for each (_loc_3 in npcResContainer)
			{
				
				if (_loc_3.sceneid == param1)
				{
					_loc_2[_loc_2.length] = _loc_3;
				}
			}
			return _loc_2;
		}
		
		public static function getFunctionIDListByNpcID(param1:int) : Array
		{
			var _loc_2:* = getNpcRes(param1);
			if (_loc_2 != null)
			{
				return _loc_2.functions;
			}
			return [];
		}
		
		public static function getTaskIDListByNpcID(param1:int) : Array
		{
			var _loc_2:* = getNpcRes(param1);
			if (_loc_2 != null)
			{
				return _loc_2.function_task;
			}
			return [];
		}
		
		public static function getGoodsListByNpcID(param1:int) : Array
		{
			throw new Error(Language.getKey("2515"));
		}
		
		public static function getTransListByNpcID(param1:int) : Array
		{
			throw new Error(Language.getKey("2516"));
		}
		
		public static function getActivityListByNpcID(param1:int) : Array
		{
			throw new Error(Language.getKey("2517"));
		}
	}
}