package tools.modules.playerlevel.view
{
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.collections.ArrayList;
	import mx.collections.Sort;
	import mx.collections.SortField;
	import mx.controls.Alert;
	import mx.events.FlexEvent;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import tools.events.PipeEvent;
	import tools.managers.PipeManager;
	import tools.managers.ResizeManager;
	import tools.modules.playerlevel.PlayerLevel_ApplicationFacade;
	import tools.modules.playerlevel.model.PlayerLevel_MsgSendProxy;
	import tools.modules.playerlevel.view.components.PlayerLevelPanel;

	public class PlayerLevel_PlayerLevelMediator extends Mediator
	{

		private var _msgSenderProxy:PlayerLevel_MsgSendProxy;
		public static const NAME:String = "PlayerLevel_PlayerLevelMediator";

		public function PlayerLevel_PlayerLevelMediator(viewComponent:Object)
		{
			super(NAME, viewComponent);
			mainUI.addEventListener(FlexEvent.CREATION_COMPLETE, initUI);
		}
		
		protected function initUI(event:FlexEvent):void
		{
			
			mainUI.searchBtn.addEventListener(MouseEvent.CLICK,onSearchBtn);
		}
		
		protected function onSearchBtn(event:MouseEvent):void
		{
			var bSeconds:Number=int(mainUI.bHours.text)*3600+int(mainUI.bMinute.text)*60+int(mainUI.bSeconds.text);
			var btime:Number=mainUI.btime.selectedDate.getTime()*0.001+bSeconds;//结束时间
			var day:int=1;
			if(mainUI.dayChoose.selectedItem>31)
			{
				day=31;
			}
			else
			{
				day==mainUI.dayChoose.selectedItem.label;
			}
			if(bSeconds<=86400&&day<=30)
			{
				msgSenderProxy.send_20094(btime,day);
			}
			else
			{
				Alert.show(Language.CHECK_TIME_OVER_RANGE,Language.TISHI);
			}
			
		}
		
		protected function get mainUI() : PlayerLevelPanel
		{
			return viewComponent as PlayerLevelPanel;
		}

		override public function onRegister() : void
		{
			return;
		}

		override public function listNotificationInterests() : Array
		{
			return [PlayerLevel_ApplicationFacade.SHOW_MAINUI,PlayerLevel_ApplicationFacade.LAST_LOGIN_RESP];
		}

		override public function handleNotification(param1:INotification) : void
		{
			var data:Object = param1.getBody();
			switch(param1.getName())
			{
				case PlayerLevel_ApplicationFacade.SHOW_MAINUI:
				{
					showMain(data);
					break;
				}
				case PlayerLevel_ApplicationFacade.LAST_LOGIN_RESP:
				{
					lastLoginResp(data);
					break;
				}
				default:
				{
					break;
				}
			}
			return;
		}
		
		private function lastLoginResp(data:Object):void
		{
			var arr:Array=data.v_info;
			var str:String=String(data.num / data.total_num);
			str=str.substr(0,5);
			if(str=="NaN")
			{
				mainUI.loseRate.text="流失率为：0";
			}
			else
			{
				mainUI.loseRate.text="流失率为："+str;
			}
			
			for (var i:int = 0; i < arr.length; i++) 
			{
				var date:Date=new Date(arr[i].create_time*1000);
				arr[i].create_time=date.getFullYear()+"-"+(date.getMonth()+1)+"-"+date.getDate()+" "+date.toLocaleTimeString();
				date=new Date(arr[i].login_time*1000);
				arr[i].login_time=date.getFullYear()+"-"+(date.getMonth()+1)+"-"+date.getDate()+" "+date.toLocaleTimeString();
			}
			var dataArr:ArrayCollection=new ArrayCollection(arr);
			dataArr.sort=new Sort();
			dataArr.sort.fields=[new SortField("recharge_num",false,true)];
			dataArr.refresh();
			mainUI.dg.dataProvider =dataArr;
		}		
		
		private function get msgSenderProxy() : PlayerLevel_MsgSendProxy
		{
			if (this._msgSenderProxy == null)
			{
				this._msgSenderProxy = facade.retrieveProxy(PlayerLevel_MsgSendProxy.NAME) as PlayerLevel_MsgSendProxy;
			}
			return this._msgSenderProxy;
		}
		
		private function showMain(data:Object):void
		{
			ResizeManager.registerResize(mainUI);
			PipeManager.sendMsg(PipeEvent.ADD_CHILD_TO_MAINUI, mainUI);
		}
	}
}