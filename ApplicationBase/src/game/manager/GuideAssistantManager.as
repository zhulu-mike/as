package game.manager
{
	import com.thinkido.framework.common.observer.Notification;
	
	import flash.display.DisplayObject;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import game.common.gui.interfaces.IGuide;
	import game.common.staticdata.ArrowDirection;
	import game.common.staticdata.GuideCompleteState;
	import game.common.staticdata.GuideConditionType;
	import game.common.vos.GuideCondition;
	import game.common.vos.GuideVO;
	import game.events.PipeEvent;
	import game.utils.bind.BindUtils;
	import game.utils.reg.RegExpConst;
	import game.utils.reg.RegExpUtil;
	
	public class GuideAssistantManager extends EventDispatcher
	{
		
		/***/
		public static const NAME:String = "GuideAssistantManager_";
		
		public function GuideAssistantManager(target:IEventDispatcher=null)
		{
			if (instance)
				throw new Error("please use getInstance() to get the instance of this class");
			PipeManager.registerMsgs([PipeEvent.GAME_GUIDE_NOTIFY], handlePipeEvent, GuideAssistantManager);
		}
		public static const GUIDELEVEL:int = 30;
		public static const RIGHTWIDTH:int = 107;
		public static const RIGHTHEIGHT:int = 76;
		public static const RECTHEIGHT:int = 10;//高亮框的发光宽度
		
		
		/**自动任务寻路中*/
		public static var autoTaskWalk:Boolean =  false;
		public static var autoTaskWalkID:int =  0;//任务ID
		
		public var id:int = 0;
		public var currState:int = 0;
		private static var guideData:Dictionary = new Dictionary();
		
		private static var instance:GuideAssistantManager;
		private static var guidePanels:Dictionary = new Dictionary();
		private static var waitOpenGuide:Dictionary = new Dictionary();
		private static var waitRegisterGuide:Dictionary = new Dictionary();
		
		public static function getInstance():GuideAssistantManager
		{
			if (!instance)
				instance = new GuideAssistantManager();
			return instance;
		}
		
		public static function parseXML(data:XML):void
		{
			var childs:XMLList = data.guide;
			var child:XML, vo:GuideVO;
			var conditions:Array, condition:GuideCondition;
			var index:int;
			for each (child in childs)
			{
				vo = new GuideVO();
				vo.id = child.@id;
				vo.dir = child.@dir;
				vo.offsetX = child.@offsetX;
				vo.offsetY = child.@offsetY;
				vo.panelName = String(child.@panelName).replace(RegExpConst.SPACE, "");
				vo.container = String(child.@container).replace(RegExpConst.SPACE, "");
				vo.posReferComponent = String(child.@posReferComponent).replace(RegExpConst.SPACE, "");;
				vo.prevID = child.@prevID;
				vo.nextID = child.@nextID;
				vo.endTpye = child.@endtype;
				vo.text = child.@text ? child.@text : "";
				conditions = String(child.@condition).split(";");
				for each (var c:String in conditions)
				{
					if (RegExpUtil.replaceSpace(c).length <= 0)
						continue;
					index = c.lastIndexOf(",");
					condition = new GuideCondition(int(RegExpUtil.replaceUnNumber(c.substring(0,index))), int(RegExpUtil.replaceUnNumber(c.substring(index+1,c.length))));
					vo.guideCondition.push(condition);				
				}
				conditions = String(child.@endCondition).split(";");
				for each (var c:String in conditions)
				{
					if (RegExpUtil.replaceSpace(c).length <= 0)
						continue;
					index = c.lastIndexOf(",");
					condition = new GuideCondition(int(RegExpUtil.replaceUnNumber(c.substring(0,index))), c.substring(index+1,c.length));
					vo.endCondition.push(condition);				
				}
				guideData[vo.id] = vo;
			}
		}
		
		/***/
		public static function writeGuides(guides:Array):void
		{
			var vo:GuideVO;
			var temp:GuideCondition;
			var guide:Object;
			for each (guide in guides)
			{
				vo = guideData[guide.id] as GuideVO;
				if (vo == null)
					continue;
				vo.state = guide.state;
			}
			for each (guide in guides)
			{
				vo = guideData[guide.id] as GuideVO;
				if (vo == null)
					continue;
				if (guide.state == GuideCompleteState.CLOSE)
				{
					for each (temp in vo.guideCondition)
					{
						if (!waitOpenGuide.hasOwnProperty(temp.type))
							waitOpenGuide[temp.type] = {};
						if (!waitOpenGuide[temp.type].hasOwnProperty(temp.data))
							waitOpenGuide[temp.type][temp.data] = [{condition:temp, vo:vo}];
						else
							waitOpenGuide[temp.type][temp.data].push({condition:temp, vo:vo});
					}
					if (canOpen(vo))
						openAssistant(vo.id);
				}else if (guide.state == GuideCompleteState.PROGRESS)
				{
					getInstance().guideOpenHandle(vo.id);
				}
			}
			registerEvent();
		}
		
		private static function registerEvent():void
		{
			if (waitOpenGuide.hasOwnProperty(GuideConditionType.LEVEL))
			{
//				BindUtils.bindSetter(levelUpdate, GameGlobal.getInstance().mainRoleVO.main, "level", true); 
			}
			if (waitOpenGuide.hasOwnProperty(GuideConditionType.FUNCTION_OPEN))
			{
//				PipeManager.registerMsg(PipeEvent.NOTICE_FUNCTION_OPEN_GUIDE, functionOpenHandle, GuideAssistantManager);
			}
			if (waitOpenGuide.hasOwnProperty(GuideConditionType.TASK_OPEN))
			{
//				PipeManager.registerMsg(PipeEvent.TASK_ACCEPTE, taskOpenHandle, GuideAssistantManager);
			}
			if (waitOpenGuide.hasOwnProperty(GuideConditionType.TASK_END))
			{
				
			}
		}
		
		private static function functionOpenHandle(e:Notification):void
		{
			var open:int = int(e.body);
			var datas:Object = waitOpenGuide[GuideConditionType.FUNCTION_OPEN];
			var key:String, order:int;
			for (key in datas)
			{
				order = int(key);
				if (order == open)
				{
					doWaitConditionGuide(GuideConditionType.FUNCTION_OPEN, order);
					break;
				}
			}
		}
		
		private static function levelUpdate(value:int):void
		{
			var datas:Object = waitOpenGuide[GuideConditionType.LEVEL];
			var key:String, lev:int;
			for (key in datas)
			{
				lev = int(key);
				if (lev<= value)
				{
					doWaitConditionGuide(GuideConditionType.LEVEL, lev);
				}
			}
		}
		
		private static function taskOpenHandle(e:Notification):void
		{
//			var data:TaskData = e.body as TaskData;
//			if (data && data.taskRes.type == TaskType.MAIN && data.status == TaskStatus.ACCEPTED)
//			{
//				var datas:Object = waitOpenGuide[GuideConditionType.TASK_OPEN];
//				var key:String, order:int;
//				for (key in datas)
//				{
//					order = int(key);
//					if (order == data.tid)
//					{
//						doWaitConditionGuide(GuideConditionType.TASK_OPEN, order);
//						break;
//					}
//				}
//			}
		}
		
		/**
		 * 处理条件满足的引导
		 * @param type 条件类型
		 * @param data 条件数据,如果是条件是等级，则为等级；如果是功能，则为功能order；等等
		 */		
		private static function doWaitConditionGuide(type:int, data:int):void
		{
			var arr:Array = waitOpenGuide[type][data];
			var i:int = 0, len:int = arr.length;
			var vo:GuideVO;
			for (;i<len;i++)
			{
				vo = arr[i].vo;
				arr[i].condition.ready = true;
				if (canOpen(vo))
					openAssistant(vo.id);
			}
			waitOpenGuide[type][data] = null;
			delete waitOpenGuide[type][data];
		}
		
		/**
		 * 判断某个引导是否可以开启
		 * 
		 */		
		private static function canOpen(vo:GuideVO):Boolean
		{
			var temp:GuideCondition;
			for each (temp in vo.guideCondition)
			{
				if (!temp.ready)
					return false;
			}
			//如果有前置引导并且前置引导未完成，则不能打开
			if (vo.prevID > 0 && !isComplete(vo.prevID))
				return false;
			if (vo.prevID == 0 && vo.nextID == 0 && vo.guideCondition.length == 0)
				return false;
			return true;
		}
		
		/**判断某引导是否已经完成*/
		public static function isComplete(gid:int):Boolean
		{
			if (guideData.hasOwnProperty(gid) && guideData[gid].state != GuideCompleteState.END)
				return false;
			return true;
		}
		
		public static function isOpen(gid:int):Boolean
		{
			if (guideData.hasOwnProperty(gid) && guideData[gid].state == GuideCompleteState.CLOSE)
				return false;
			return true;
		}
		
		/** */
		private function handlePipeEvent(e:Notification):void
		{
			switch (e.name)
			{
				case PipeEvent.GAME_GUIDE_NOTIFY:
					guideInfoHandler(e.body);
					break;
			}
		}
		
		/**处理引导项*/
		private function guideInfoHandler(data:Object):void
		{
			var state:int = data.state; 
			var vo:GuideVO;
			if (guideData.hasOwnProperty(data.id))
			{
				guideData[data.id].state = data.state;
			}
			if (state == GuideCompleteState.PROGRESS)
			{
//				this["guideProgress_"+data.id]();
				guideOpenHandle(data.id);
			}else if (state == GuideCompleteState.END)
			{
//				this["guideEnd_"+data.id]();
				vo = guideData[data.id] as GuideVO;
				if (vo == null || vo.endTpye != 0)
					guideEnd(data.id);
				if (vo && vo.nextID > 0 && !isComplete(vo.nextID))
				{
					openAssistant(vo.nextID);
				}
			}
		}
		
		/**通知服务端，完成某个引导*/
		public static function completeAssistant(aid:int):void
		{
//			NetWorkManager.sendMsgData(20411, {id:aid, state:GuideCompleteState.END});
		}
		
		/**通知服务端，开启某个引导*/
		public static function openAssistant(aid:int):void
		{
//			NetWorkManager.sendMsgData(20411, {id:aid, state:GuideCompleteState.PROGRESS});
		}
		
		/**关闭某个引导*/
		public static function guideEnd(gid:int):void
		{
			PipeManager.sendMsg(PipeEvent.CLOSE_ASSISTANT_MAINUI, gid);
		}
		
		/**
		 * 计算箭头的位置
		 * 
		 */		
		public static function getArrowPosition(target:Point, dir:int = 0, posComponent:DisplayObject=null, isSame:Boolean=false):Point
		{
			var p:Point = target;
			if (dir == ArrowDirection.RIGHT)
			{
				if (isSame){
					p.x = 0;
					if (posComponent != null)
						p.y = (posComponent.height>>1);
				}else{
					p.x = target.x;
					if (posComponent != null)
						p.y = target.y + (posComponent.height>>1);
				}
			}else if (dir == ArrowDirection.DOWN)
			{
				if (posComponent != null){
					if (!isSame){
						p.y = target.y;
						p.x = target.x + (posComponent.width>>1);
					}else{
						p.y = 0;
						p.x = (posComponent.width>>1);
					}
				}
			}else if (dir == ArrowDirection.LEFT)
			{
				if (posComponent != null){
					if (!isSame){
						p.x = target.x + posComponent.width;
						p.y = target.y + (posComponent.height>>1);
					}else{
						p.x = posComponent.width;
						p.y = (posComponent.height>>1);
					}
				}
			}else
			{
				if (posComponent != null){
					if (!isSame){
						p.y = target.y+posComponent.height;
						p.x = target.x + (posComponent.width>>1);
					}else{
						p.y = posComponent.height;
						p.x = (posComponent.width>>1);
					}
				}
			}
			return p;
		}
		
		/**
		 * 注册引导面板,放入waitRegisterGuide里的引导都是条件都满足，但是所属容器未注册
		 * @param name
		 * @param panel
		 * 
		 */		
		public static function registerPanel(name:String, panel:IGuide):void
		{
			if (guidePanels.hasOwnProperty(name))
				return;
			guidePanels[name] = panel;
			if (waitRegisterGuide.hasOwnProperty(name))
			{
				doWaitRegiterForGuide(name);
			}
		}
		
		private static function doWaitRegiterForGuide(name:String):void
		{
			var vos:Array = waitRegisterGuide[name];
			var i:int = 0, len:int = vos.length;
			for (;i<len;i++)
			{
				IGuide(guidePanels[name]).guideToDo(vos[i]);
			}
			waitRegisterGuide[name] = null;
			delete waitRegisterGuide[name];
		}
		
		/**
		 * 开启了某个引导
		 * @param id
		 * 
		 */		
		private function guideOpenHandle(id:int):void
		{
			if (guideData.hasOwnProperty(id) == false)
				return;
			var vo:GuideVO = guideData[id] as GuideVO;
			if (vo.panelName.length <= 0)
				return;
			if (guidePanels.hasOwnProperty(vo.panelName) == false)
			{
				if (waitRegisterGuide.hasOwnProperty(vo.panelName))
					waitRegisterGuide[vo.panelName].push(vo);
				else
					waitRegisterGuide[vo.panelName] = [vo];
				return;
			}
			IGuide(guidePanels[vo.panelName]).guideToDo(vo);
		}
		
		
	}
}