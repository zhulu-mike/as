package tools.modules.chargecount.view
{
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayList;
	import mx.events.FlexEvent;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import tools.events.PipeEvent;
	import tools.managers.PipeManager;
	import tools.managers.ResizeManager;
	import tools.modules.charge.Charge_ApplicationFacade;
	import tools.modules.chargecount.ChargeCount_ApplicationFacade;
	import tools.modules.chargecount.model.ChargeCount_MsgSendProxy;
	import tools.modules.chargecount.view.components.ChargeCountPanel;

	public class ChargeCount_ChargeCountMediator extends Mediator
	{

		private var _msgSenderProxy:ChargeCount_MsgSendProxy;
		public static const NAME:String = "ChargeCount_ChargeCountMediator";

		public function ChargeCount_ChargeCountMediator(viewComponent:Object)
		{
			super(NAME, viewComponent);
			mainUI.addEventListener(FlexEvent.CREATION_COMPLETE, initUI);
		}
		
		protected function initUI(event:FlexEvent):void
		{
			//按钮
			mainUI.sumbitBtn.addEventListener(MouseEvent.CLICK,onSumbit);
		}
		
		protected function onSumbit(event:MouseEvent):void
		{
			var eSeconds:Number=int(mainUI.eHours.text)*3600+int(mainUI.eMinute.text)*60+int(mainUI.eSeconds.text);
			var bSeconds:Number=int(mainUI.bHours.text)*3600+int(mainUI.bMinute.text)*60+int(mainUI.bSeconds.text);
			var etime:Number=mainUI.etime.selectedDate.getTime()*0.001+eSeconds;//开始时间
			var btime:Number=mainUI.btime.selectedDate.getTime()*0.001+bSeconds;//结束时间
			if(eSeconds<=86400&&bSeconds<=86400)
			{
				msgSenderProxy.send_20090(btime,etime);
			}
		}
		
		protected function get mainUI() : ChargeCountPanel
		{
			return viewComponent as ChargeCountPanel;
		}

		override public function onRegister() : void
		{
			return;
		}

		override public function listNotificationInterests() : Array
		{
			return [ChargeCount_ApplicationFacade.SHOW_MAINUI,ChargeCount_ApplicationFacade.CHECK_CHARGE_RESP];
		}

		override public function handleNotification(param1:INotification) : void
		{
			var data:Object = param1.getBody();
			switch(param1.getName())
			{
				case ChargeCount_ApplicationFacade.SHOW_MAINUI:
				{
					showMain(data);
					break;
				}
				case ChargeCount_ApplicationFacade.CHECK_CHARGE_RESP:
				{
					checkChargeResp(data);
					break;
				}
				default:
				{
					break;
				}
			}
			return;
		}
		
		private function checkChargeResp(data:Object):void
		{
			mainUI.moneyAll.text=data.total_num;
			mainUI.chargeAllLabel.text=data.all;
			var str:String=String(int(data.total_num) / int(data.all));
			if(str=="NaN")
			{
				mainUI.percent.text="0";
			}
			else
			{
				mainUI.percent.text=str;
			}
			var arr:Array=data.v_info;
			for (var i:int = 0; i < arr.length; i++) 
			{
				var date:Date=new Date(arr[i].time*1000);
				arr[i].opentime=date.getFullYear()+"-"+(date.getMonth()+1)+"-"+date.getDate()+" "+date.toLocaleTimeString();
			}
			mainUI.dg.dataProvider=new ArrayList(arr);
			
		}
		
		private function get msgSenderProxy() : ChargeCount_MsgSendProxy
		{
			if (this._msgSenderProxy == null)
			{
				this._msgSenderProxy = facade.retrieveProxy(ChargeCount_MsgSendProxy.NAME) as ChargeCount_MsgSendProxy;
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