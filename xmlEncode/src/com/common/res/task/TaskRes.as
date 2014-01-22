package game.common.res.task
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import game.common.res.task.vo.TaskTargetData;


    public class TaskRes extends Object
    {
        public var id:int;
        public var name:String;
        public var type:int;
		public var functionType:int;
        public var islost:Boolean;
        public var receptionLevel:int;
        public var limitTime:Number;
        public var endNpc:int;
        public var beginNpc:int;		
        public var title:int;
        public var isLoop:Boolean;
        public var loopMaxCount:int;
        public var isRepeat:Boolean;
		public var targetPlace:String;
		public var premiseTask:int;			//前置任务
		
		public var accept_movie_id:int;		//接取任务对话id
		public var submit_movie_id:int;		//提交任务对话
		public var chapterOver_id:int;		//章节id
		
		public var start_dialog_npc:String;		// 接取任务npc说的话
		public var start_dialog_player:String;	//接取任务玩家说的话
		public var end_dialog_npc:String;		//交任务npc说的话
		public var end_dialog_player:String;	//交任务玩家说的话
		
		public var exp:int;			//经验奖励
		public var copper:int;		//铜钱奖励
		public var props:Array;		//道具奖励	[id_num, id_num, ...]
		public var equips:Array;	//装备奖励	[id, id, ...]
		public var aura:int;
		public var prestige:int;
		public var mingdian:int;
		
		public var targetInfo:Array;	//['sceneid_x_y_name','sceneid_x_y_name'];
		public var count:Array;			//[id_count, id_count]
		
		public var copyID:int;		//副本id
		
		public var targetNPC:int;		//打开npc面板对应的npc ID
		public var targetGoods:int;		//采集对象id
		
//        public var targetGoods:Array;
        public var targetMonster:Array;
//        public var targetNpc:Array;
		public var targetArea:Array;
        public var targetAction:Array;
        public var taskTargetDes:String;
        public var targetShopping:Array;
        public var targetRecharge:TaskTargetData;
        public var targetGroup:TaskTargetData;
        public var targetFriend:TaskTargetData;
        public var targetEquip:TaskTargetData;
        public var targetSkillLv:TaskTargetData;
        public var targetAllSkillLv:TaskTargetData;
        public var targetPoint:TaskTargetData;
        public var targetChannel:TaskTargetData;
        public var targetBuff:TaskTargetData;
        public var accept_begin_time:String;
        public var complete_end_time:String;

        public function TaskRes()
        {
            this.id = 0;
            this.name = "";
            this.type = 0;
            this.islost = false;
            this.receptionLevel = 0;
            this.limitTime = -1;
            this.endNpc = 0;
//            this.targetGoods = [];
//            this.targetMonster = [];
//            this.targetNpc = [];
            this.targetArea = [];
            this.targetAction = [];
            this.title = 0;
            this.beginNpc = 0;
            this.isRepeat = false;
            this.taskTargetDes = "";
            this.targetShopping = [];
            this.targetRecharge = null;
            this.targetGroup = null;
            this.targetFriend = null;
            this.targetEquip = null;
            this.targetSkillLv = null;
            this.targetAllSkillLv = null;
            this.targetPoint = null;
            this.targetChannel = null;
            this.targetBuff = null;
            this.isLoop = false;
            this.loopMaxCount = 0;
            this.accept_begin_time = "";
            this.complete_end_time = "";
            return;
        }

        public function get acceptNpc() : int
        {
//            var _loc_1:Array = null;
//            var _loc_2:Array = null;
//            if (this._acceptNpc == 0)
//            {
//                if (this.publishStyle == TaskPublishType.SYSTEM)
//                {
//                    this._acceptNpc = -1;
//                }
//                else if (this.publishStyle == TaskPublishType.GOODS)
//                {
//                    this._acceptNpc = -2;
//                }
//                else if (this.publishStyle == TaskPublishType.CREAT_PLAYER)
//                {
//                    this._acceptNpc = -3;
//                }
//                else if (this.publishStyle == TaskPublishType.ADVENTURE)
//                {
//                    this._acceptNpc = -4;
//                }
//                else
//                {
//                    _loc_1 = NpcResManager.getNpcIDandTaskIDArrBySceneID();
//                    for each (_loc_2 in _loc_1)
//                    {
//                        
//                        if ((_loc_2[1] as Array).indexOf(this.id) != -1)
//                        {
//                            this._acceptNpc = _loc_2[0];
//                            break;
//                        }
//                    }
//                }
//            }
//            return this._acceptNpc;
			return -1;
        }

        public function getTargetGoods(param1:int) : TaskTargetData
        {
            var _loc_2:TaskTargetData = null;
            for each (_loc_2 in this.targetGoods)
            {
                
                if (_loc_2.id == param1)
                {
                    return _loc_2;
                }
            }
            return null;
        }

        public function getTargetMonster(param1:int) : TaskTargetData
        {
            var _loc_2:TaskTargetData = null;
            for each (_loc_2 in this.targetMonster)
            {
                
                if (_loc_2.id == param1)
                {
                    return _loc_2;
                }
            }
            return null;
        }

        public function getTargetNpc(param1:int) : TaskTargetData
        {
            var _loc_2:TaskTargetData = null;
//            for each (_loc_2 in this.targetNpc)
//            {
//                
//                if (_loc_2.id == param1)
//                {
//                    return _loc_2;
//                }
//            }
            return null;
        }

        public function getTargetArea(param1:int, param2:Rectangle = null, param3:Point = null) : TaskTargetData
        {
            var _loc_4:TaskTargetData = null;
            for each (_loc_4 in this.targetArea)
            {
                
                if (_loc_4.id == param1 && (!param2 || _loc_4.area.equals(param2)) && (!param3 || _loc_4.area.contains(param3.x, param3.y)))
                {
                    return _loc_4;
                }
            }
            return null;
        }

        public function getTargetAction(param1:int) : TaskTargetData
        {
            var _loc_2:TaskTargetData = null;
            for each (_loc_2 in this.targetAction)
            {
                
                if (_loc_2.id == param1)
                {
                    return _loc_2;
                }
            }
            return null;
        }

        public function getTargetHorse(param1:int) : TaskTargetData
        {
//            var _loc_2:TaskTargetData = null;
//            for each (_loc_2 in this.targetHorse)
//            {
//                
//                if (_loc_2.id == param1)
//                {
//                    return _loc_2;
//                }
//            }
            return null;
        }

        public function getTargetShopping(param1:int) : TaskTargetData
        {
            var _loc_2:TaskTargetData = null;
            for each (_loc_2 in this.targetShopping)
            {
                
                if (_loc_2.id == param1)
                {
                    return _loc_2;
                }
            }
            return null;
        }

    }
}
