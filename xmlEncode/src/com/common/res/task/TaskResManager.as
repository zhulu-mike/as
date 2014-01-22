package game.common.res.task
{
	import flash.geom.Rectangle;
	
	import game.common.res.npc.NpcResManager;
	import game.common.res.task.vo.TaskTargetData;
	import game.common.res.task.vo.TaskTargetPos;
	import game.common.staticdata.ItemPositionRange;
	import game.common.staticdata.TaskActionType;
	import game.common.staticdata.TaskType;
	import game.manager.LanResManager;
	import game.manager.TaskManager;
    

    public class TaskResManager extends Object
    {
        private static var taskResXML:XML;
        private static var taskResContainer:Object = new Object();
        private static var drama:Object = new Object();

        public function TaskResManager()
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
            var taskRes:TaskRes = new TaskRes();
            var _loc_4:Array = null;
            var _loc_5:Array = null;
            var _loc_6:Array = null;
            var _loc_7:String = null;
            var _loc_8:String = null;
            var _loc_9:String = null;
            var _loc_12:TaskTargetData = null;
            var xml:* = param1;
            taskRes.id = xml.@id;
            taskRes.name = xml.name;
            taskRes.type = xml.@type;
			taskRes.functionType = xml.@functionType;
			taskRes.targetPlace = xml.@targetPlace;
            taskRes.islost = String(xml.@islost) == "1" ? true : false;
            taskRes.receptionLevel = int(Number(xml.@receptionLevel));
			taskRes.premiseTask = int(Number(xml.@premiseTask));
            taskRes.limitTime = int(Number(xml.@limitTime));
            taskRes.endNpc = int(Number(xml.@endNpc));
            taskRes.targetMonster = getTargetMonsterArr(xml.@targetMonster);
//            taskRes.targetGoods = getTargetGoodsArr(xml.@targetGoods);
//            taskRes.targetNpc = getTargetNpcArr(xml.@targetNpc);
            taskRes.targetArea = getTargetAreaArr(xml.@targetArea);
            taskRes.targetAction = getTargetActionArr(xml.@targetAction);
            taskRes.targetShopping = getTargetShoppingArr(xml.@targetShopping);
            taskRes.targetRecharge = getTargetRechargeTTD(xml.@targetRecharge);
            taskRes.targetGroup = getTargetGroupTTD(xml.@targetGroup);
            taskRes.targetFriend = getTargetFriendTTD(xml.@targetFriend);
            taskRes.targetEquip = getTargetEquipTTD(xml.@targetEquip);
            taskRes.targetSkillLv = getTargetSkillLvTTD(xml.@targetSkillLv);
            taskRes.targetAllSkillLv = getTargetAllSkillLvTTD(xml.@targetAllSkillLv);
            taskRes.targetPoint = getTargetPointTTD(xml.@targetPoint);
            taskRes.targetChannel = getTargetChannelTTD(xml.@targetChannel);
            taskRes.targetBuff = getTargetBuffTTD(xml.@targetBuff);
			
            if (xml.@goods != undefined && xml.@goods != null && xml.@goods != "" && xml.@goods != "null")
            {
                _loc_9 = xml.@goods.replace(/^,(.+)$""^,(.+)$/, "$1").replace(/^(.+),$""^(.+),$/, "$1");
                _loc_4 = _loc_9.split(",");
                for each (_loc_7 in _loc_4)
                {
                    
                    _loc_5 = _loc_7.split("#");
                    _loc_12 = new TaskTargetData(int(Number(_loc_5[0])), int(Number(_loc_5[1])));
                    _loc_12.userData = int(Number(_loc_5[2]));
//                    taskRes.goods.push(_loc_12);
                }
            }
			
			taskRes.accept_movie_id = int(xml.@accept_movie_id);
			taskRes.submit_movie_id = int(xml.@submit_movie_id);
			taskRes.chapterOver_id = int(xml.@chapterOver_id);
			taskRes.start_dialog_npc = String(xml.start_dialog_npc);
			taskRes.start_dialog_player = String(xml.start_dialog_player);
			taskRes.end_dialog_npc = String(xml.end_dialog_npc);
			taskRes.end_dialog_player =	String(xml.end_dialog_player);
			
			taskRes.targetGoods = int(xml.@targetGoods);
			taskRes.targetNPC = int(xml.@targetNpc);
			
			taskRes.exp = int(xml.@expreward);
			taskRes.copper = int(xml.@goldreward);
			taskRes.aura = int(xml.@aura);
			taskRes.prestige = int(xml.@prestige);
			taskRes.mingdian = int(xml.@mingdian);
			
			var str:String = String(xml.@prop);
			var arr:Array;
			taskRes.props = [];
			if(str != null && str != '' && str != '0')
			{
				arr = str.split(',');
				var num:int = arr.length;
				var obj:Object;
				var temp:Array;
				for(var i:int = 0; i < num; i++)
				{
					temp = arr[i].split('_');
					obj = {};
					obj.id = temp[0];
					obj.num = temp[1];
					taskRes.props.push(obj);
				}
			}
			
			str = String(xml.@equip);
			taskRes.equips = [];
			if(str != null && str != '' && str != '0')
			{
				taskRes.equips = str.split(',');
			}
			
			
			taskRes.copyID = int(xml.@copyid);
			
            taskRes.title = int(Number(xml.@title));
            taskRes.beginNpc = int(Number(xml.@beginNpc));
            taskRes.isRepeat = String(xml.@isRepeat) == "1" ? (true) : (false);
            taskRes.taskTargetDes = xml.taskTargetDes;
            taskRes.loopMaxCount = xml.@loopMaxCount;
            var _loc_10:* = new Date();
            var _loc_11:* = Number(String(xml.@accept_begin_time));
            if (Number(String(xml.@accept_begin_time)) > 0)
            {
                _loc_10.time = _loc_11;
                taskRes.accept_begin_time = LanResManager.getLanTextWords(TaskResManager, Language.getKey("2518"), [_loc_10.getFullYear(), (_loc_10.getMonth() + 1), _loc_10.getDate(), _loc_10.getHours()]);
            }
            else
            {
                taskRes.accept_begin_time = "";
            }
            _loc_11 = Number(String(xml.@complete_end_time));
            if (_loc_11 > 0)
            {
                _loc_10.time = _loc_11;
                taskRes.complete_end_time = LanResManager.getLanTextWords(TaskResManager, Language.getKey("2518"), [_loc_10.getFullYear(), (_loc_10.getMonth() + 1), _loc_10.getDate(), _loc_10.getHours()]);
            }
            else
            {
                taskRes.complete_end_time = "";
            }
            if (taskRes.type == TaskType.ZHOU_YI || taskRes.type == TaskType.WEEK_LOOP)
            {
                taskRes.isLoop = true;
            }
            else
            {
                taskRes.isLoop = false;
            }
            taskResContainer[taskRes.id] = taskRes;
            return;
        }

        public static function removeTaskRes(param1:int) : void
        {
            delete taskResContainer[param1];
            return;
        }

        /*public static function parseTaskDialogRes(param1:String) : void
        {
            var dialog:TaskDialogRes;
            var talk:TaskTalk = null;
            var xmlData:* = XML(param1);
            if (!xmlData)
            {
                return;
            }
            for each (var xml:XML in xmlData.dialogs.dialog)
            {
                
				dialog = new TaskDialogRes();
				dialog.taskId = int(Number(xml.@taskId));
				dialog.dialogType = int(Number(xml.@dialogType));
				dialog.npcId = int(Number(xml.@npcId));
				dialog.talks = [];
                for each (var item in xml.children())
                {
                    
					talk = new TaskTalk();
					talk.talkType = int(Number(item.@talkType));
					talk.talkNpc = int(Number(item.@talkNpc)) != 0 ? (int(Number(item.@talkNpc))) : (dialog.npcId);
					talk.talk = item;
					dialog.talks.push(talk);
                }
                taskDialogResContainer[dialog.taskId + "_" + dialog.dialogType + "_" + dialog.npcId] = dialog;
            }
            return;
        }*/
		
		public static function parseTaskDialogRes(param1:String) : void
		{
			var xml:XML = XML(param1);
			
			var xml_1:XMLList = xml.elements('npc');
			var xml_2:XMLList = xml.elements('data');
			var obj:Object;
			var dramaData:Object;
			var subscript:String;
			for each(var $daram:XML in xml.dialog)
			{
				subscript = $daram.@dialogId;
				drama[subscript] = {};
				drama[subscript]['npc'] = [];
				drama[subscript]['data'] = [];
				for each(var item:XML in $daram.npc)
				{
					trace(item.name());
					obj = {};
					obj.id = int(item.@id);
					obj.x = int(item.@x);
					obj.y = int(item.@y);
					obj.status = String(item.@status);
					obj.direction = int(item.@direction);
					drama[subscript]['npc'].push(obj);
				}
				for each(var item:XML in $daram.data)
				{
					obj = {};
					obj.id = int(item.@id);
					obj.type = String(item.@type);
					obj.step = int(item.@step);
					obj.dest_x = int(item.@dest_x);
					obj.dest_y = int(item.@dest_y);
					obj.status = String(item.@status);
					obj.direction = int(item.@direction);
					obj.msg = String(item.@msg);
					drama[subscript]['data'].push(obj);
				}
				(drama[subscript]['data'] as Array).sortOn('step',Array.NUMERIC);
			}
		}
		
		public static function getTaskDialogRes(dialogID:int):Object
		{
			return drama[dialogID];
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

//        public static function getTaskDialogRes(param1:int, param2:int, param3:int) : TaskDialogRes
//        {
//            return drama[param1 + "_" + param2 + "_" + param3];
//        }

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
