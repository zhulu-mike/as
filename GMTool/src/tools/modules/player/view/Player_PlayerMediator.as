package tools.modules.player.view
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.collections.ArrayList;
	import mx.collections.Sort;
	import mx.collections.SortField;
	import mx.controls.Alert;
	import mx.events.FlexEvent;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import tools.common.vo.EquipBase;
	import tools.common.vo.SkillBaseInfo;
	import tools.common.vo.ToolBase;
	import tools.events.PipeEvent;
	import tools.managers.EquipManager;
	import tools.managers.PipeManager;
	import tools.managers.ResizeManager;
	import tools.managers.SkillManager;
	import tools.managers.ToolManager;
	import tools.modules.player.Player_ApplicationFacade;
	import tools.modules.player.model.PlayerModel;
	import tools.modules.player.model.Player_MsgSendProxy;
	import tools.modules.player.view.components.OperationPassPanel;
	import tools.modules.player.view.components.PlayerInfoPanel;
	import tools.modules.player.view.components.PlayerOperationItem;
	import tools.modules.player.view.components.PlayerPackagePanel;
	import tools.modules.player.view.components.PlayerSkillPanel;

	public class Player_PlayerMediator extends Mediator
	{

		private var _msgSenderProxy:Player_MsgSendProxy;
		public static const NAME:String = "Player_PlayerMediator";
		private var model:PlayerModel=PlayerModel.getInstance();
		public var nowPage:int=1;
		
		private var packagePanel:PlayerPackagePanel;//包裹
		private var skillPanel:PlayerSkillPanel;//技能
		private var operationPassPanel:OperationPassPanel;//操作

		public function Player_PlayerMediator(viewComponent:Object)
		{
			super(NAME, viewComponent);
			mainUI.addEventListener(FlexEvent.CREATION_COMPLETE, initUI);
		}
		
		private function initUI(e:FlexEvent):void
		{
			//-----面板-----
			//包裹面板
			packagePanel = new PlayerPackagePanel();
			packagePanel.x=mainUI.width/2-packagePanel.width/2;
			packagePanel.y=mainUI.height/2-packagePanel.height/2;
			packagePanel.visible=false;
			mainUI.addElement(packagePanel);
			//技能面板
			skillPanel = new PlayerSkillPanel();
			skillPanel.x=mainUI.width/2-packagePanel.width/2;
			skillPanel.y=mainUI.height/2-packagePanel.height/2;
			skillPanel.visible=false;
			mainUI.addElement(skillPanel);
			//禁言踢人面板
			operationPassPanel = new OperationPassPanel();
			operationPassPanel.x=mainUI.width/2-operationPassPanel.width/2;
			operationPassPanel.y=mainUI.height/2-operationPassPanel.height/2;
			operationPassPanel.visible=false;
			mainUI.addElement(operationPassPanel);
			//-----按钮-----
			mainUI.searchWay.addEventListener(Event.CHANGE, onSearchWay);
			mainUI.searchBtn.addEventListener(MouseEvent.CLICK, searchPlayer);
			mainUI.nextBtn.addEventListener(MouseEvent.CLICK, nextPage);
			mainUI.preBtn.addEventListener(MouseEvent.CLICK, prePage);
			mainUI.go.addEventListener(MouseEvent.CLICK, goToPage);			
			mainUI.dg.addEventListener(PlayerOperationItem.FORBID_PASSPORT,onForbidPassport);
			mainUI.dg.addEventListener(PlayerOperationItem.FORBID_SPEAK,onForbidSpeak);
			mainUI.dg.addEventListener(PlayerOperationItem.KICK_PLAYER,onClickPlayer);
			//--面板按钮-----
			mainUI.searchChoose1.visible=false;
			//装备
			mainUI.equipBtn.addEventListener(MouseEvent.CLICK, equipPanel);
			//仙气
			mainUI.supgasBtn.addEventListener(MouseEvent.CLICK, superGas);
			//包裹
			mainUI.packageBtn.addEventListener(MouseEvent.CLICK, packagePanelOpen);
			packagePanel.closeBtn.addEventListener(MouseEvent.CLICK, onClose);
			//技能
			mainUI.skillBtn.addEventListener(MouseEvent.CLICK, skillPanelOpen);
			skillPanel.closeBtn.addEventListener(MouseEvent.CLICK, onSkillClose);
			//战魂
			mainUI.fightBtn.addEventListener(MouseEvent.CLICK, fightPanel);
			//操作
			operationPassPanel.sureBtn.addEventListener(MouseEvent.CLICK,onSureBtn);
			operationPassPanel.closeBtn.addEventListener(MouseEvent.CLICK,onCloseBtn);
			//一开始就发送协议
			var linenumber:int=mainUI.dg.height / mainUI.dg.rowHeight;
			msgSenderProxy.send_20007(model.type,"",nowPage,linenumber);
		}
		
		/**关闭视图*/
		protected function onCloseBtn(event:MouseEvent):void
		{
			operationPassPanel.visible=false;
		}
		
		/**确定操作键*/
		protected function onSureBtn(event:MouseEvent):void
		{
			
		}
		
		/**管理员踢人操作*/
		protected function onClickPlayer(event:Event):void
		{
			var id:int=mainUI.dg.selectedItem.uid;
			msgSenderProxy.send_20075(id,1);
		}
		
		/**管理员禁言操作*/
		protected function onForbidSpeak(event:Event):void
		{
			var id:int=mainUI.dg.selectedItem.uid;
			var ifForbidSpeak:int=mainUI.dg.selectedItem.ifForbidSpeak;
			if(ifForbidSpeak==2)
			{
				msgSenderProxy.send_20081(id);
			}
			else
			{
				msgSenderProxy.send_20076(id);
			}
//			operationPassPanel.visible=true;
		}
		
		/**管理员封号操作*/
		protected function onForbidPassport(event:Event):void
		{
			var id:int=mainUI.dg.selectedItem.uid;
			var ifForbidPass:int=mainUI.dg.selectedItem.ifForbidPass;
			if(ifForbidPass==1)
			{
				msgSenderProxy.send_20079(id);
			}
			else
			{
				msgSenderProxy.send_20077(id);
			}
//			operationPassPanel.visible=true;
		}
		
		protected function fightPanel(event:MouseEvent):void
		{
			PipeManager.sendMsg(PipeEvent.SHOW_FIGHTER_SPIRIT_MAINUI, {type:1,cond:model.name});
		}		
		
		protected function onSkillClose(event:MouseEvent):void
		{
			skillPanel.visible=false;
		}
		
		/**
		 * 技能发送的协议 
		 * @param event
		 */
		protected function skillPanelOpen(event:MouseEvent):void
		{
			if(model.main_id!=0)
			{
				msgSenderProxy.send_20017(model.main_id);
			}
			skillPanel.visible=true;
		}
		
		protected function onClose(event:MouseEvent):void
		{
			packagePanel.visible=false;
		}
		
		/**
		 * 包裹发送的协议 
		 * @param event
		 */
		protected function packagePanelOpen(event:MouseEvent):void
		{
			if(model.gameuid!=0)
			{
				msgSenderProxy.send_20011(model.gameuid);
			}
			packagePanel.visible=true;
		}		
		
		/**
		 * 仙气发送的协议 
		 * @param event
		 */
		protected function superGas(event:MouseEvent):void
		{
			if(model.gameuid!=0)
			{
				PipeManager.sendMsg(PipeEvent.SHOW_SUPER_GAS_MAINUI, {id:model.gameuid, ismain:model.is_main, pid:model.partnerid});
			}
		}
		
		/**
		 *  装备发送的协议
		 * @param event
		 */
		protected function equipPanel(event:MouseEvent):void
		{
			if(model.gameuid!=0)
			{
				PipeManager.sendMsg(PipeEvent.SHOW_PLAYER_EQUIP_MAINUI, {id:model.gameuid, ismain:model.is_main, pid:model.partnerid});
			}
			
		}		
		
		protected function goToPage(event:MouseEvent):void
		{
			var number:int=int(mainUI.pageNum.text);
			nowPage=number;
			if(number>model.maxPage||number<=0)
			{
				nowPage=model.maxPage;
			}
			research();
		}
		
		protected function prePage(event:MouseEvent):void
		{
			if(nowPage>1)
			{
				nowPage--;
			}
			else
			{
				nowPage=1;
			}
			research();
		}
		
		protected function nextPage(event:MouseEvent):void
		{
			if(nowPage<model.maxPage)
			{
				nowPage++;
			}
			else
			{
				nowPage=model.maxPage;
			}
			research();
		}
		
		/**
		 * 点击查询，发送数据 
		 * @param event
		 */
		protected function searchPlayer(event:MouseEvent):void
		{
			research();
		}
		private function research():void
		{
			var cond:String='';
			var linenumber:int=mainUI.dg.height / mainUI.dg.rowHeight;
			if(model.type!=0)
			{
				if(model.type!=3)
				{
					cond=mainUI.searchIuput.text;
				}
				else
				{
					cond='';
				}
				msgSenderProxy.send_20007(model.type,cond,nowPage,linenumber);
			}
			
		}
		
		private function researchWay():void
		{
			var cond:String='';
			cond=mainUI.searchIuput.text;
			var linenumber:int=mainUI.dg.height / mainUI.dg.rowHeight;
			msgSenderProxy.send_20007(model.type,cond,nowPage,linenumber);
		}
		
		protected function get mainUI() :PlayerInfoPanel
		{
			return viewComponent as PlayerInfoPanel;
		}

		override public function onRegister() : void
		{
			return;
		}

		override public function listNotificationInterests() : Array
		{
			return [Player_ApplicationFacade.SHOW_MAINUI,Player_ApplicationFacade.RESEARCH,Player_ApplicationFacade.PACKAGE_RESEARCH,Player_ApplicationFacade.SKILL_RESEARCH,
			Player_ApplicationFacade.FORBID_PASSPOET,Player_ApplicationFacade.UNFORBID_PASSPOET,Player_ApplicationFacade.CLICK_PEOPLE,Player_ApplicationFacade.FORBID_SPEAK,
			Player_ApplicationFacade.NO_PRESSION_CLICK_PEOPLE]
		}

		override public function handleNotification(param1:INotification) : void
		{
			var data:Object = param1.getBody();
			switch(param1.getName())
			{
				case Player_ApplicationFacade.SHOW_MAINUI:
				{
					showMain(data);
					break;
				}
				case Player_ApplicationFacade.RESEARCH:
				{
					handleSearchResp(data);
					break;
				}
				case Player_ApplicationFacade.PACKAGE_RESEARCH:
				{
					handlePackageResp(data);
					break;
				}
				case Player_ApplicationFacade.SKILL_RESEARCH:
				{
					handleSkillResp(data);
					break;
				}
				case Player_ApplicationFacade.FORBID_PASSPOET:
				{
					forbidPassportResp(data);
					break;
				}
				case Player_ApplicationFacade.UNFORBID_PASSPOET:
				{
					unForbidPassportResp(data);
					break;
				}
				case Player_ApplicationFacade.CLICK_PEOPLE:
				{
					clickPeopleResp(data);
					break;
				}
				case Player_ApplicationFacade.FORBID_SPEAK:
				{
					forbidSpeakResp(data);
					break;
				}
				case Player_ApplicationFacade.NO_PRESSION_CLICK_PEOPLE:
				{
					noClickPeopleResp(data);
					break;
				}
				default:
				{
					break;
				}
			}
			return;
		}
		
		private function noClickPeopleResp(data:Object):void
		{
			if(data.ret==2008)
			{
				Alert.show(Language.NO_PREMISS_OPERATION,Language.TISHI);
				return;
			}
		}
		
		private function forbidSpeakResp(data:Object):void
		{
			if(data.ret==2008)
			{
				
			}
			else
			{
				researchWay();
				Alert.show(Language.CAOZUOCHENGGONG,Language.TISHI);
			}
		}
		
		private function clickPeopleResp(data:Object):void
		{
			if(data.ret==2008)
			{
				Alert.show(Language.NO_PREMISS_OPERATION,Language.TISHI)
			}
			else if(data.ret==2041)
			{
				Alert.show(Language.PLAYER_NO_ONLINE,Language.TISHI);
			}
			else
			{
				Alert.show(Language.CAOZUOCHENGGONG,Language.TISHI);
			}
		}
		
		private function unForbidPassportResp(data:Object):void
		{
			if(data.ret==2008)
			{
				Alert.show(Language.NO_PREMISS_OPERATION,Language.TISHI)
			}
			else
			{
				researchWay();
				Alert.show(Language.CAOZUOCHENGGONG,Language.TISHI);
			}
			
		}
		
		private function forbidPassportResp(data:Object):void
		{
			if(data.ret==2008)
			{
				Alert.show(Language.NO_PREMISS_OPERATION,Language.TISHI)
			}
			else
			{
				var id:int=mainUI.dg.selectedItem.uid;
				msgSenderProxy.send_20075(id,1);
				researchWay();
				Alert.show(Language.CAOZUOCHENGGONG,Language.TISHI);
			}
			
		}
		
		private function handleSkillResp(data:Object):void/////技能  ????
		{
			var arr:Array=data.v_hero_skill;
			var skillBase:SkillBaseInfo;
			for (var i:int = 0; i < arr.length; i++) 
			{
				skillBase = SkillManager.getInstance().getSkillLevelVO(arr[i].id,model.career,arr[i].type,arr[i].level);
				arr[i].skillName = skillBase.name;
				arr[i].skillLev = skillBase.level;
				if(arr[i].type==1)
				{
					arr[i].skillType=Language.INITIATIVE;
				}
				else
				{
					arr[i].skillType=Language.PASSIVE;
				}
			}
			skillPanel.skillDg.dataProvider = new ArrayList(arr);
			
		}
		
		/**
		 * 包裹物品的数据接收 
		 * @param data
		 * 
		 */
		private function handlePackageResp(data:Object):void
		{
			var arr:Array=data.v_goods;
			var equipBase:EquipBase;
			var toolBase:ToolBase;
			var numb:int=1;
			for (var i:int = 0; i < arr.length; i++) 
			{
				if(arr[i].type==1)
				{
					arr[i].type=Language.EQUIP;
					equipBase = EquipManager.getInstance().getEquipConfigInfo(arr[i].config_id);
					if(equipBase!=null)
					{
						arr[i].packName = equipBase.name;
					}
					else
					{
						arr[i].packName = Language.UNKNOW;
					}
				}
				else
				{
					arr[i].type=Language.PROP;
					toolBase = ToolManager.getInstance().getToolConfigInfo(arr[i].config_id);
					if(toolBase!=null)
					{
						arr[i].packName = toolBase.name;
					}
					else
					{
						arr[i].packName =Language.UNKNOW;
					}
				}
				
				arr[i].number = numb++;
				
			}
			packagePanel.pkDg.dataProvider = new ArrayList(arr);
		}		
		
		/**
		 * 查询数据的接收 
		 * @param data
		 */
		private function handleSearchResp(data:Object):void
		{
			if(data.ret==2009)
			{
				Alert.show(Language.CHECK_TYPE_ERROR,Language.TISHI);
			}
			else if(data.ret==2010)
			{
				Alert.show(Language.CHECK_ID_NO,Language.TISHI);
			}
			else if(data.ret==2011)
			{
				Alert.show(Language.PAGE_ERROR,Language.TISHI);
			}
			else if(data.ret==2012)
			{
				Alert.show(Language.CHECK_BDATE_ERROR,Language.TISHI);
			}
			else if(data.ret==2013)
			{
				Alert.show(Language.CHECK_EDATE_ERROR,Language.TISHI);
			}
			else if(data.ret==2014)
			{
				Alert.show(Language.PLAYER_NO_EXIST,Language.TISHI);
			}
			else if(data.ret==2015)
			{
				Alert.show(Language.PLAT_NO_EXIST,Language.TISHI);
			}
			else
			{
				var arr:Array=data.v_user;
				for (var i:int = 0; i < arr.length; i++) 
				{
					arr[i].ifForbidPass=arr[i].astrict&1;
					arr[i].ifForbidSpeak=arr[i].astrict&2;
				}
				var dataArr:ArrayCollection=new ArrayCollection(arr);
				dataArr.sort=new Sort();
				dataArr.sort.fields=[new SortField("level",false,true)];
				dataArr.refresh();
				mainUI.dg.dataProvider =dataArr;
				mainUI.playerAllCount.text=String(data.num);
				model.maxPage=data.max_page;
				mainUI.labelNum.text=nowPage+"/"+data.max_page;
				mainUI.no_createLabel = data.no_create;
				mainUI.uniqueLabel = data.unique;
			}
			
		}
		
		
		protected function onSearchWay(event:Event):void
		{
			if(mainUI.searchWay.selectedItem==Language.JUESEMINGCHAXUN)
			{
				mainUI.searchChoose1.visible=true;
				model.type=1;
			}
			else if(mainUI.searchWay.selectedItem==Language.PINGTAIIDCHAXUN)
			{
				mainUI.searchChoose1.visible=true;
				model.type=2;
			}
			else if(mainUI.searchWay.selectedItem==Language.CHECK_ALL_PLAYER)
			{
				mainUI.searchChoose1.visible=false;
				model.type=3;
			}
			else
			{
				model.type=0;
			}
		}
		
		private function get msgSenderProxy() : Player_MsgSendProxy
		{
			if (this._msgSenderProxy == null)
			{
				this._msgSenderProxy = facade.retrieveProxy(Player_MsgSendProxy.NAME) as Player_MsgSendProxy;
			}
			return this._msgSenderProxy;
		}
		
		private function showMain(data:Object):void
		{
			model.data = int(data);
			ResizeManager.registerResize(mainUI);
			PipeManager.sendMsg(PipeEvent.ADD_CHILD_TO_MAINUI, mainUI);
		}
	}
}