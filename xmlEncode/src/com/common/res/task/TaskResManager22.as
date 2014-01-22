package game.common.res.task
{
	import game.common.staticdata.*;
	import game.common.res.lan.*;
	import game.common.res.npc.*;
	import game.common.res.task.vo.*;
	import game.manager.*;
	
	import flash.geom.*;
	
	public class TaskResManager22 extends Object
	{
		private static var taskResXML:XML;
		private static var taskResContainer:Object = new Object();
		private static var taskDialogResContainer:Object = new Object();
		
		public function TaskResManager22()
		{
			return;
		}
		
		public static function parseTaskRes(param1:String) : void
		{
			var _loc_2:TaskRes = null;
			var _loc_3:XML = null;
			var _loc_4:Array = null;
			var _loc_5:Array = null;
			var _loc_6:Array = null;
			var _loc_7:String = null;
			var _loc_8:String = null;
			var _loc_9:String = null;
			taskResXML = XML(param1);
			if (!taskResXML)
			{
				return;
			}
			for each (_loc_3 in taskResXML.tasks.task)
			{
				
				addTaskRes(_loc_3);
			}
			return;
		}
		
		public static function addTaskRes(param1:XML) : void
		{
			var _loc_3:TaskRes = null;
			var _loc_4:Array = null;
			var _loc_5:Array = null;
			var _loc_6:Array = null;
			var _loc_7:String = null;
			var _loc_8:String = null;
			var _loc_9:String = null;
			var _loc_12:TaskTargetData = null;
			var _loc_2:* = param1;
			_loc_3 = new TaskRes();
			_loc_3.id = int(Number(_loc_2.@id));
			_loc_3.name = _loc_2.name;
			_loc_3.type = int(Number(_loc_2.@type));
			_loc_3.islost = String(_loc_2.@islost) == "1" ? (true) : (false);
			_loc_3.publishStyle = int(Number(_loc_2.@publishStyle));
			_loc_3.receptionLevel = int(Number(_loc_2.@receptionLevel));
			_loc_3.receptionUpLevel = int(Number(_loc_2.@receptionUpLevel));
			_loc_3.endTaskLevel = int(Number(_loc_2.@endTaskLevel));
			_loc_3.premiseTask = int(Number(_loc_2.@premiseTask));
			_loc_3.limitTime = int(Number(_loc_2.@limitTime));
			_loc_3.endNpc = int(Number(_loc_2.@endNpc));
			_loc_3.publishDes = _loc_2.publishDes;
			_loc_3.unEndDes = _loc_2.unEndDes;
			_loc_3.endDes = _loc_2.endDes;
			_loc_3.targetGoods = getTargetGoodsArr(_loc_2.@targetGoods);
			_loc_3.targetMonster = getTargetMonsterArr(_loc_2.@targetMonster);
			_loc_3.targetNpc = getTargetNpcArr(_loc_2.@targetNpc);
			_loc_3.targetArea = getTargetAreaArr(_loc_2.@targetArea);
			_loc_3.targetAction = getTargetActionArr(_loc_2.@targetAction);
			_loc_3.targetHorse = getTargetHorseArr(_loc_2.@targetHorse);
			_loc_3.targetShopping = getTargetShoppingArr(_loc_2.@targetShopping);
			_loc_3.targetRecharge = getTargetRechargeTTD(_loc_2.@targetRecharge);
			_loc_3.targetMountUpgrade = getTargetMountUpgradeTTD(_loc_2.@targetMountUpgrade);
			_loc_3.targetGroup = getTargetGroupTTD(_loc_2.@targetGroup);
			_loc_3.targetFriend = getTargetFriendTTD(_loc_2.@targetFriend);
			_loc_3.targetEquip = getTargetEquipTTD(_loc_2.@targetEquip);
			_loc_3.targetSkillLv = getTargetSkillLvTTD(_loc_2.@targetSkillLv);
			_loc_3.targetAllSkillLv = getTargetAllSkillLvTTD(_loc_2.@targetAllSkillLv);
			_loc_3.targetPoint = getTargetPointTTD(_loc_2.@targetPoint);
			_loc_3.targetChannel = getTargetChannelTTD(_loc_2.@targetChannel);
			_loc_3.targetBuff = getTargetBuffTTD(_loc_2.@targetBuff);
			_loc_3.goods = [];
			if (_loc_2.@goods != undefined && _loc_2.@goods != null && _loc_2.@goods != "" && _loc_2.@goods != "null")
			{
				_loc_9 = _loc_2.@goods.replace(/^,(.+)$""^,(.+)$/, "$1").replace(/^(.+),$""^(.+),$/, "$1");
				_loc_4 = _loc_9.split(",");
				for each (_loc_7 in _loc_4)
				{
					
					_loc_5 = _loc_7.split("#");
					_loc_12 = new TaskTargetData(int(Number(_loc_5[0])), int(Number(_loc_5[1])));
					_loc_12.userData = int(Number(_loc_5[2]));
					_loc_3.goods.push(_loc_12);
				}
			}
			_loc_3.copper = int(Number(_loc_2.@copper));
			_loc_3.gold = int(Number(_loc_2.@gold));
			_loc_3.experience = int(Number(_loc_2.@experience));
			_loc_3.goodFeel = int(Number(_loc_2.@goodFeel));
			_loc_3.party = int(Number(_loc_2.@party));
			_loc_3.goodBad = int(Number(_loc_2.@goodBad));
			_loc_3.title = int(Number(_loc_2.@title));
			_loc_3.beginNpc = int(Number(_loc_2.@beginNpc));
			_loc_3.isRepeat = String(_loc_2.@isRepeat) == "1" ? (true) : (false);
			_loc_3.warrepute = int(Number(_loc_2.@warrepute));
			_loc_3.buffid = int(Number(_loc_2.@buffid));
			_loc_3.bulletin = int(Number(_loc_2.@bulletin));
			_loc_3.zhenqi = int(Number(_loc_2.@zhenqi));
			_loc_3.loopTaskDifficulty = int(Number(_loc_2.@loopTaskDifficulty));
			_loc_3.loopTaskBonus = int(Number(_loc_2.@loopTaskBonus));
			_loc_3.hourseDrop = String(_loc_2.@horseDrop) == "1" ? (true) : (false);
			_loc_3.taskTargetDes = _loc_2.taskTargetDes;
			_loc_3.loopMaxCount = _loc_2.@loopMaxCount;
			var _loc_10:* = new Date();
			var _loc_11:* = Number(String(_loc_2.@accept_begin_time));
			if (Number(String(_loc_2.@accept_begin_time)) > 0)
			{
				_loc_10.time = _loc_11;
				_loc_3.accept_begin_time = LanResManager.getLanTextWords(TaskResManager, Language.getKey("2518"), [_loc_10.getFullYear(), (_loc_10.getMonth() + 1), _loc_10.getDate(), _loc_10.getHours()]);
			}
			else
			{
				_loc_3.accept_begin_time = "";
			}
			_loc_11 = Number(String(_loc_2.@complete_end_time));
			if (_loc_11 > 0)
			{
				_loc_10.time = _loc_11;
				_loc_3.complete_end_time = LanResManager.getLanTextWords(TaskResManager, Language.getKey("2518"), [_loc_10.getFullYear(), (_loc_10.getMonth() + 1), _loc_10.getDate(), _loc_10.getHours()]);
			}
			else
			{
				_loc_3.complete_end_time = "";
			}
			if (_loc_3.type == TaskType.DAY_LOOP || _loc_3.type == TaskType.DAY_YABIAO || _loc_3.type == TaskType.WEEK_LOOP || _loc_3.type == TaskType.LV_LOOP)
			{
				_loc_3.isLoop = true;
			}
			else
			{
				_loc_3.isLoop = false;
			}
			taskResContainer[_loc_3.id] = _loc_3;
			return;
		}
		
		public static function removeTaskRes(param1:int) : void
		{
			delete taskResContainer[param1];
			return;
		}
		
		public static function parseTaskDialogRes(param1:String) : void
		{
			var _loc_3:TaskDialogRes = null;
			var _loc_4:XML = null;
			var _loc_5:TaskTalk = null;
			var _loc_6:XML = null;
			var _loc_2:* = XML(param1);
			if (!_loc_2)
			{
				return;
			}
			for each (_loc_4 in _loc_2.dialogs.dialog)
			{
				
				_loc_3 = new TaskDialogRes();
				_loc_3.taskId = int(Number(_loc_4.@taskId));
				_loc_3.dialogType = int(Number(_loc_4.@dialogType));
				_loc_3.npcId = int(Number(_loc_4.@npcId));
				_loc_3.talks = [];
				for each (_loc_6 in _loc_4.children())
				{
					
					_loc_5 = new TaskTalk();
					_loc_5.talkType = int(Number(_loc_6.@talkType));
					_loc_5.talkNpc = int(Number(_loc_6.@talkNpc)) != 0 ? (int(Number(_loc_6.@talkNpc))) : (_loc_3.npcId);
					_loc_5.talk = _loc_6;
					_loc_3.talks.push(_loc_5);
				}
				taskDialogResContainer[_loc_3.taskId + "_" + _loc_3.dialogType + "_" + _loc_3.npcId] = _loc_3;
			}
			return;
		}
		
		public static function getTaskRes(param1:int) : TaskRes
		{
			return taskResContainer[param1];
		}
		
		public static function getOriginalTaskResXML(param1:int) : XML
		{
			var _loc_2:XML = null;
			for each (_loc_2 in taskResXML.tasks.task)
			{
				
				if (int(Number(_loc_2.@id)) == param1)
				{
					return _loc_2;
				}
			}
			return null;
		}
		
		public static function recoveryTaskRes(param1:int) : void
		{
			var _loc_2:* = getOriginalTaskResXML(param1);
			if (_loc_2 != null)
			{
				addTaskRes(_loc_2);
			}
			else
			{
				removeTaskRes(param1);
			}
			return;
		}
		
		public static function getTaskDialogRes(param1:int, param2:int, param3:int) : TaskDialogRes
		{
			return taskDialogResContainer[param1 + "_" + param2 + "_" + param3];
		}
		
		public static function getTargetMonsterArr(param1:String, param2:Boolean = true) : Array
		{
			var _loc_5:Array = null;
			var _loc_6:String = null;
			if (param1 == undefined || param1 == null || param1 == "" || param1 == "null" || param1 == "undefined")
			{
				return [];
			}
			param1 = param1.replace(/^,(.+)$""^,(.+)$/, "$1").replace(/^(.+),$""^(.+),$/, "$1");
			var _loc_3:Array = [];
			var _loc_4:* = param1.split(",");
			for each (_loc_6 in _loc_4)
			{
				
				_loc_5 = _loc_6.split("#");
				_loc_3.push(new TaskTargetData(_loc_5[0], int(Number(_loc_5[1])), _loc_5[2], null, param2 ? (TaskTargetPos.fromSplitString(_loc_5[3], "_")) : (new TaskTargetPos(0, 0, 0, 0))));
			}
			return _loc_3;
		}
		
		public static function getTargetGoodsArr(param1:String, param2:Boolean = true) : Array
		{
			var _loc_5:Array = null;
			var _loc_6:String = null;
			if (param1 == undefined || param1 == null || param1 == "" || param1 == "null" || param1 == "undefined")
			{
				return [];
			}
			param1 = param1.replace(/^,(.+)$""^,(.+)$/, "$1").replace(/^(.+),$""^(.+),$/, "$1");
			var _loc_3:Array = [];
			var _loc_4:* = param1.split(",");
			for each (_loc_6 in _loc_4)
			{
				
				_loc_5 = _loc_6.split("#");
				_loc_3.push(new TaskTargetData(_loc_5[0], int(Number(_loc_5[1])), _loc_5[2], null, param2 ? (TaskTargetPos.fromSplitString(_loc_5[3], "_")) : (new TaskTargetPos(0, 0, 0, 0))));
			}
			return _loc_3;
		}
		
		public static function getTargetNpcArr(param1:String, param2:Boolean = true) : Array
		{
			var _loc_5:String = null;
			if (param1 == undefined || param1 == null || param1 == "" || param1 == "0" || param1 == "null" || param1 == "undefined")
			{
				return [];
			}
			param1 = param1.replace(/^,(.+)$""^,(.+)$/, "$1").replace(/^(.+),$""^(.+),$/, "$1");
			var _loc_3:Array = [];
			var _loc_4:* = param1.split(",");
			for each (_loc_5 in _loc_4)
			{
				
				_loc_3.push(new TaskTargetData(int(Number(_loc_5)), 1, "", null, new TaskTargetPos(0, 0, 0, 0)));
			}
			return _loc_3;
		}
		
		public static function getTargetAreaArr(param1:String, param2:Boolean = true) : Array
		{
			var _loc_5:Array = null;
			var _loc_6:Array = null;
			var _loc_7:String = null;
			var _loc_8:String = null;
			if (param1 == undefined || param1 == null || param1 == "" || param1 == "null" || param1 == "undefined")
			{
				return [];
			}
			param1 = param1.replace(/^,(.+)$""^,(.+)$/, "$1").replace(/^(.+),$""^(.+),$/, "$1");
			var _loc_3:Array = [];
			var _loc_4:* = param1.split(",");
			for each (_loc_7 in _loc_4)
			{
				
				_loc_5 = _loc_7.split("#");
				_loc_6 = [];
				for each (_loc_8 in _loc_5[1].split("_"))
				{
					
					_loc_6[_loc_6.length] = int(Number(_loc_8));
				}
				_loc_3.push(new TaskTargetData(int(Number(_loc_5[0])), 1, "", new Rectangle(_loc_6[0], _loc_6[1], _loc_6[2], _loc_6[3]), param2 ? (TaskTargetPos.fromSplitString(_loc_5[2], "_")) : (new TaskTargetPos(0, 0, 0, 0))));
			}
			return _loc_3;
		}
		
		public static function getTargetActionArr(param1:String, param2:Boolean = true) : Array
		{
			var _loc_5:String = null;
			if (param1 == undefined || param1 == null || param1 == "" || param1 == "0" || param1 == "null" || param1 == "undefined")
			{
				return [];
			}
			param1 = param1.replace(/^,(.+)$""^,(.+)$/, "$1").replace(/^(.+),$""^(.+),$/, "$1");
			var _loc_3:Array = [];
			var _loc_4:* = param1.split(",");
			for each (_loc_5 in _loc_4)
			{
				
				_loc_3.push(new TaskTargetData(int(Number(_loc_5)), 1, TaskActionType.getNameByValue(int(Number(_loc_5))), null, new TaskTargetPos(0, 0, 0, 0)));
			}
			return _loc_3;
		}
		
		public static function getTargetHorseArr(param1:String, param2:Boolean = true) : Array
		{
			var _loc_5:Array = null;
			var _loc_6:String = null;
			if (param1 == undefined || param1 == null || param1 == "" || param1 == "null" || param1 == "undefined")
			{
				return [];
			}
			param1 = param1.replace(/^,(.+)$""^,(.+)$/, "$1").replace(/^(.+),$""^(.+),$/, "$1");
			var _loc_3:Array = [];
			var _loc_4:* = param1.split(",");
			for each (_loc_6 in _loc_4)
			{
				
				_loc_5 = _loc_6.split("#");
				_loc_3.push(new TaskTargetData(_loc_5[0], int(Number(_loc_5[1])), _loc_5[2], null, param2 ? (TaskTargetPos.fromSplitString(_loc_5[3], "_")) : (new TaskTargetPos(0, 0, 0, 0))));
			}
			return _loc_3;
		}
		
		public static function getTargetShoppingArr(param1:String) : Array
		{
			var _loc_5:Array = null;
			var _loc_6:String = null;
			var _loc_2:Boolean = false;
			if (param1 == undefined || param1 == null || param1 == "" || param1 == "null" || param1 == "undefined")
			{
				return [];
			}
			param1 = param1.replace(/^,(.+)$""^,(.+)$/, "$1").replace(/^(.+),$""^(.+),$/, "$1");
			var _loc_3:Array = [];
			var _loc_4:* = param1.split(",");
			for each (_loc_6 in _loc_4)
			{
				
				_loc_5 = _loc_6.split("#");
				_loc_3.push(new TaskTargetData(_loc_5[0], int(Number(_loc_5[1])), _loc_5[2], null, _loc_2 ? (TaskTargetPos.fromSplitString(_loc_5[3], "_")) : (new TaskTargetPos(0, 0, 0, 0))));
			}
			return _loc_3;
		}
		
		public static function getTargetRechargeTTD(param1:String) : TaskTargetData
		{
			if (param1 == undefined || param1 == null || param1 == "" || param1 == "null" || param1 == "undefined")
			{
				return null;
			}
			return new TaskTargetData(0, int(Number(param1)), LanResManager.getLanCommonTextWords(Language.getKey("2519")), null, new TaskTargetPos(0, 0, 0, 0));
		}
		
		public static function getTargetMountUpgradeTTD(param1:String) : TaskTargetData
		{
			if (param1 == undefined || param1 == null || param1 == "" || param1 == "null" || param1 == "undefined")
			{
				return null;
			}
			return new TaskTargetData(0, 1, LanResManager.getLanCommonTextWords(Language.getKey("2520")), null, new TaskTargetPos(0, 0, 0, 0));
		}
		
		public static function getTargetGroupTTD(param1:String) : TaskTargetData
		{
			if (param1 == undefined || param1 == null || param1 == "" || param1 == "null" || param1 == "undefined")
			{
				return null;
			}
			return new TaskTargetData(0, int(Number(param1)), LanResManager.getLanCommonTextWords(Language.getKey("2521")), null, new TaskTargetPos(0, 0, 0, 0));
		}
		
		public static function getTargetFriendTTD(param1:String) : TaskTargetData
		{
			if (param1 == undefined || param1 == null || param1 == "" || param1 == "null" || param1 == "undefined")
			{
				return null;
			}
			return new TaskTargetData(0, int(Number(param1)), LanResManager.getLanCommonTextWords(Language.getKey("2522")), null, new TaskTargetPos(0, 0, 0, 0));
		}
		
		public static function getTargetEquipTTD(param1:String) : TaskTargetData
		{
			if (param1 == undefined || param1 == null || param1 == "" || param1 == "null" || param1 == "undefined")
			{
				return null;
			}
			var _loc_2:* = param1.split("#");
			var _loc_3:* = parseInt(_loc_2[0]);
			var _loc_4:* = ItemPositionRange.getEquipTypeName(_loc_3);
			var _loc_5:* = parseInt(_loc_2[1]);
			var _loc_6:* = _loc_2[2];
			return new TaskTargetData(0, 1, _loc_5 != 0 ? (_loc_6) : (_loc_4), new Rectangle(_loc_3, _loc_5, 0, 0), new TaskTargetPos(0, 0, 0, 0));
		}
		
		public static function getTargetSkillLvTTD(param1:String) : TaskTargetData
		{
			if (param1 == undefined || param1 == null || param1 == "" || param1 == "null" || param1 == "undefined")
			{
				return null;
			}
			var _loc_2:* = param1.split("#");
			var _loc_3:* = parseInt(_loc_2[0]);
			var _loc_4:* = parseInt(_loc_2[1]);
			var _loc_5:* = _loc_2[2];
			return new TaskTargetData(0, 1, "[" + _loc_5 + "]" + LanResManager.getLanCommonTextWords(Language.getKey("2523")), new Rectangle(_loc_3, _loc_4, 0, 0), new TaskTargetPos(0, 0, 0, 0));
		}
		
		public static function getTargetAllSkillLvTTD(param1:String) : TaskTargetData
		{
			if (param1 == undefined || param1 == null || param1 == "" || param1 == "null" || param1 == "undefined")
			{
				return null;
			}
			return new TaskTargetData(0, int(Number(param1)), LanResManager.getLanCommonTextWords(Language.getKey("2524")), null, new TaskTargetPos(0, 0, 0, 0));
		}
		
		public static function getTargetPointTTD(param1:String) : TaskTargetData
		{
			if (param1 == undefined || param1 == null || param1 == "" || param1 == "null" || param1 == "undefined")
			{
				return null;
			}
			var _loc_2:* = param1.split("#");
			var _loc_3:* = parseInt(_loc_2[0]);
			var _loc_4:* = _loc_2[1];
			return new TaskTargetData(_loc_3, 1, LanResManager.getLanCommonTextWords(Language.getKey("2525")) + "[" + _loc_4 + "]", null, new TaskTargetPos(0, 0, 0, 0));
		}
		
		public static function getTargetChannelTTD(param1:String) : TaskTargetData
		{
			if (param1 == undefined || param1 == null || param1 == "" || param1 == "null" || param1 == "undefined")
			{
				return null;
			}
			var _loc_2:* = param1.split("#");
			var _loc_3:* = parseInt(_loc_2[0]);
			var _loc_4:* = _loc_2[1];
			return new TaskTargetData(_loc_3, 1, LanResManager.getLanCommonTextWords(Language.getKey("2526")) + "[" + _loc_4 + "]", null, new TaskTargetPos(0, 0, 0, 0));
		}
		
		public static function getTargetBuffTTD(param1:String) : TaskTargetData
		{
			if (param1 == undefined || param1 == null || param1 == "" || param1 == "null" || param1 == "undefined")
			{
				return null;
			}
			var _loc_2:* = param1.split("#");
			var _loc_3:* = parseInt(_loc_2[0]);
			var _loc_4:* = _loc_2[1];
			return new TaskTargetData(_loc_3, 1, LanResManager.getLanCommonTextWords(Language.getKey("2527")) + "[" + _loc_4 + "]", null, new TaskTargetPos(0, 0, 0, 0));
		}
		
		public static function getAcceptableTaskResListByNpc(param1:int) : Array
		{
			var _loc_4:int = 0;
			var _loc_2:* = NpcResManager.getTaskIDListByNpcID(param1);
			if (_loc_2 == null || _loc_2.length == 0)
			{
				return [];
			}
			var _loc_3:Array = [];
			for each (_loc_4 in _loc_2)
			{
				
				if (TaskManager.checkAcceptableTask(_loc_4, false)[0] == 1)
				{
					_loc_3[_loc_3.length] = getTaskRes(_loc_4);
				}
			}
			return _loc_3;
		}
		
		public static function getHandInTaskResListByNpc(param1:int) : Array
		{
			var _loc_3:TaskRes = null;
			var _loc_2:Array = [];
			for each (_loc_3 in taskResContainer)
			{
				
				if (_loc_3.endNpc == param1)
				{
					if (TaskManager.checkHandInTask(_loc_3.id, false, true)[0] == 1)
					{
						_loc_2[_loc_2.length] = _loc_3;
					}
				}
			}
			return _loc_2;
		}
		
		public static function getActivateTaskResListByNpcID(param1:int) : Array
		{
			var _loc_3:TaskRes = null;
			var _loc_2:Array = [];
			for each (_loc_3 in taskResContainer)
			{
				
				if (_loc_3.endNpc == param1)
				{
					if (TaskManager.hasTask(_loc_3.id) && TaskManager.checkHandInTask(_loc_3.id, false, true)[0] == 0)
					{
						_loc_2[_loc_2.length] = _loc_3;
					}
				}
			}
			return _loc_2;
		}
		
		public static function getDialogTaskResListByNpcID(param1:int) : Array
		{
			var _loc_3:TaskRes = null;
			var _loc_2:Array = [];
			for each (_loc_3 in taskResContainer)
			{
				
				if (_loc_3.getTargetNpc(param1))
				{
					if (TaskManager.hasTask(_loc_3.id) && !TaskManager.hasTalkedWithNpc(_loc_3.id, param1))
					{
						_loc_2[_loc_2.length] = _loc_3;
					}
				}
			}
			return _loc_2;
		}
		
		public static function getAcceptableLoopTaskResListByType(param1:int = -1) : Array
		{
			var _loc_3:TaskRes = null;
			var _loc_2:Array = [];
			for each (_loc_3 in taskResContainer)
			{
				
				if (_loc_3.isLoop == true)
				{
					if (param1 == -1 || _loc_3.type == param1)
					{
						if (TaskManager.checkAcceptableTask(_loc_3.id, false)[0] == 1)
						{
							_loc_2[_loc_2.length] = _loc_3;
						}
					}
				}
			}
			return _loc_2;
		}
		
		public static function getAcceptableTaskResListByType(param1:int = -1) : Array
		{
			var _loc_3:TaskRes = null;
			var _loc_2:Array = [];
			for each (_loc_3 in taskResContainer)
			{
				
				if (param1 == -1 || _loc_3.type == param1)
				{
					if (TaskManager.checkAcceptableTask(_loc_3.id, false)[0] == 1)
					{
						_loc_2[_loc_2.length] = _loc_3;
					}
				}
			}
			return _loc_2;
		}
		
		public static function getHandInTaskResListByType(param1:int = -1) : Array
		{
			var _loc_3:TaskRes = null;
			var _loc_2:Array = [];
			for each (_loc_3 in taskResContainer)
			{
				
				if (param1 == -1 || _loc_3.type == param1)
				{
					if (TaskManager.checkHandInTask(_loc_3.id, false, true)[0] == 1)
					{
						_loc_2[_loc_2.length] = _loc_3;
					}
				}
			}
			return _loc_2;
		}
		
		public static function getActivateTaskResListByType(param1:int = -1) : Array
		{
			var _loc_3:TaskRes = null;
			var _loc_2:Array = [];
			for each (_loc_3 in taskResContainer)
			{
				
				if (param1 == -1 || _loc_3.type == param1)
				{
					if (TaskManager.hasTask(_loc_3.id) && TaskManager.checkHandInTask(_loc_3.id, false, true)[0] == 0)
					{
						_loc_2[_loc_2.length] = _loc_3;
					}
				}
			}
			return _loc_2;
		}
		
	}
}
