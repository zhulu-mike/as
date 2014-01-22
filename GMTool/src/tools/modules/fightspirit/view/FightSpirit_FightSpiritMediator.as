package tools.modules.fightspirit.view
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.collections.Sort;
	import mx.collections.SortField;
	import mx.controls.Alert;
	import mx.events.FlexEvent;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import tools.common.staticdata.PlayerCareerType;
	import tools.events.PipeEvent;
	import tools.managers.LayerManager;
	import tools.managers.PipeManager;
	import tools.managers.ResizeManager;
	import tools.modules.fightspirit.FightSpirit_ApplicationFacade;
	import tools.modules.fightspirit.model.FightSpirit_MsgSendProxy;
	import tools.modules.fightspirit.model.FighterSpiritModel;
	import tools.modules.fightspirit.view.components.FightSpiritPanel;

	public class FightSpirit_FightSpiritMediator extends Mediator
	{

		private var _msgSenderProxy:FightSpirit_MsgSendProxy;
		public static const NAME:String = "FightSpirit_FightSpiritMediator";
		private var model:FighterSpiritModel=FighterSpiritModel.getInstance();

		public function FightSpirit_FightSpiritMediator(viewComponent:Object)
		{
			super(NAME, viewComponent);
			mainUI.addEventListener(FlexEvent.CREATION_COMPLETE, initUI);
		}
		
		protected function initUI(event:FlexEvent):void
		{
			//按钮
			mainUI.searchWay.addEventListener(Event.CHANGE, onSearchWay);
			mainUI.searchBtn.addEventListener(MouseEvent.CLICK, search);
			mainUI.equipBtn.addEventListener(MouseEvent.CLICK, onEquipBtn);
			mainUI.supgasBtn.addEventListener(MouseEvent.CLICK, onSupGas);
		}
		
		/**打开仙气*/
		protected function onSupGas(event:MouseEvent):void
		{
			if(model.gameuid!=0)
			{
				PipeManager.sendMsg(PipeEvent.SHOW_SUPER_GAS_MAINUI, {id:model.gameuid, ismain:model.is_main, pid:model.partnerid});
			}
		}
		
		/**打开装备*/
		protected function onEquipBtn(event:MouseEvent):void
		{
			if(model.gameuid!=0)
			{
				PipeManager.sendMsg(PipeEvent.SHOW_PLAYER_EQUIP_MAINUI, {id:model.gameuid, ismain:model.is_main, pid:model.partnerid});
			}
		}
		
		protected function search(event:MouseEvent):void
		{
			research();
		}
		
		/**选择查询方式*/
		protected function onSearchWay(event:Event):void
		{
			
			if(mainUI.searchWay.selectedItem)
			{
				model.type = mainUI.searchWay.selectedItem.data;
			}
			else
			{
				Alert.show(Language.PLEASE_CHOOSE);//请选择
			}

		}
		
		/**查询*/
		private function research():void
		{
			var cond:String='';
			if(model.type!=0)
			{
				cond=mainUI.searchIuput.text;
				msgSenderProxy.send_20019(model.type,cond);
			}
		}
		
		protected function onClose(event:MouseEvent):void
		{
			LayerManager.higherLayer.removeElement(mainUI);
		}
		

		protected function get mainUI() : FightSpiritPanel
		{
			return viewComponent as FightSpiritPanel;
		}

		override public function onRegister() : void
		{
			return;
		}

		override public function listNotificationInterests() : Array
		{
			return [FightSpirit_ApplicationFacade.SHOW_MAINUI,FightSpirit_ApplicationFacade.RESQ_FIGHT];
		}

		override public function handleNotification(param1:INotification) : void
		{
			var data:Object = param1.getBody();
			switch(param1.getName())
			{
				case FightSpirit_ApplicationFacade.SHOW_MAINUI:
				{
					showMainUi(data);
					break;
				}
				case FightSpirit_ApplicationFacade.RESQ_FIGHT:
				{
					handleSearchResp(data);
					break;
				}
				default:
				{
					break;
				}
			}
			return;
		}
		
		private function handleSearchResp(data:Object):void
		{
			if(data.ret==2014)
			{
				Alert.show(Language.PLAYER_NO_EXIST,Language.TISHI);
			}
			else if(data.ret==2015)
			{
				Alert.show(Language.PLAT_NO_EXIST,Language.TISHI);
			}
			else if(data.ret==2010)
			{
				Alert.show(Language.CHECK_ID_NO,Language.TISHI);
			}
			else if(data.ret==2009)
			{
				Alert.show(Language.CHECK_TYPE_ERROR,Language.TISHI);
			}
			var arr:Array=data.partnersvect;
			var obj:Object=[];
			for (var i:int = 0; i < arr.length; i++) 
			{
				if(arr[i].career==PlayerCareerType.QIANGHAO)
				{
					arr[i].careerType=Language.QIANGHAO;
				}
				else if(arr[i].career==PlayerCareerType.XIANLING)
				{
					arr[i].careerType=Language.XIANLING;
				}
				else
				{
					arr[i].careerType=Language.YINGWU;
				}
				obj=arr[i].user_parter_base;
				arr[i].fightpower=obj.fightpower;
				if(arr[i].state==0)
				{
					arr[i].state=Language.FIGHTER_SOUL_WEIZHAOMU;
				}
				else if(arr[i].state==3)
				{
					arr[i].state=Language.LEV_IN_SOUL;
				}
				else if(arr[i].state==4)
				{
					arr[i].state=Language.BIANSHEN;
				}
				else
				{
					arr[i].state=Language.XIANZHI;
				}
			}
			var dataArr:ArrayCollection=new ArrayCollection(arr);
			dataArr.sort=new Sort();
			dataArr.sort.fields=[new SortField("level",false,true)];
			dataArr.refresh();
			mainUI.dg.dataProvider =dataArr;
			
		}		
		
		private function get msgSenderProxy() : FightSpirit_MsgSendProxy
		{
			if (this._msgSenderProxy == null)
			{
				this._msgSenderProxy = facade.retrieveProxy(FightSpirit_MsgSendProxy.NAME) as FightSpirit_MsgSendProxy;
			}
			return this._msgSenderProxy;
		}
		
		private function showMainUi(data:Object):void
		{
			if(data.data!=4)
			{
				if(data.cond!=null)
				{
					msgSenderProxy.send_20019(data.type,data.cond);
				}
			}
			ResizeManager.registerResize(mainUI);
			PipeManager.sendMsg(PipeEvent.ADD_CHILD_TO_MAINUI, mainUI);
		}
	}
}