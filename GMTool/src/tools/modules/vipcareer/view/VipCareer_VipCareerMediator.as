package tools.modules.vipcareer.view
{
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	import mx.collections.ArrayList;
	import mx.events.FlexEvent;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import spark.events.IndexChangeEvent;
	
	import tools.events.PipeEvent;
	import tools.managers.PipeManager;
	import tools.managers.ResizeManager;
	import tools.modules.vipcareer.VipCareer_ApplicationFacade;
	import tools.modules.vipcareer.model.VipCareer_MsgSendProxy;
	import tools.modules.vipcareer.view.components.VipCareerPanel;

	public class VipCareer_VipCareerMediator extends Mediator
	{

		private var _msgSenderProxy:VipCareer_MsgSendProxy;
		public static const NAME:String = "VipCareer_VipCareerMediator";

		public function VipCareer_VipCareerMediator(viewComponent:Object)
		{
			super(NAME, viewComponent);
			mainUI.addEventListener(FlexEvent.CREATION_COMPLETE, initUI);
		}
		
		protected function initUI(event:FlexEvent):void
		{
			mainUI.levelJG.addEventListener(Event.CHANGE,changeVipLevel);
		}
		
		protected function changeVipLevel(event:IndexChangeEvent):void
		{
			if(mainUI.levelJG.selectedItem)
			{
				var level:int=mainUI.levelJG.selectedItem.data;
				msgSenderProxy.send_20092(level);
			}
			
		}
		
		protected function get mainUI() : VipCareerPanel
		{
			return viewComponent as VipCareerPanel;
		}

		override public function onRegister() : void
		{
			return;
		}

		override public function listNotificationInterests() : Array
		{
			return [VipCareer_ApplicationFacade.SHOW_MAINUI,VipCareer_ApplicationFacade.VIP_CAREER_RESP];
		}

		override public function handleNotification(param1:INotification) : void
		{
			var data:Object = param1.getBody();
			switch(param1.getName())
			{
				case VipCareer_ApplicationFacade.SHOW_MAINUI:
				{
					showMain(data);
					break;
				}
				case VipCareer_ApplicationFacade.VIP_CAREER_RESP:
				{
					vipCareerResp(data);
					break;
				}
				default:
				{
					break;
				}
			}
			return;
		}
		
		private function vipCareerResp(data:Object):void
		{
			var arr:Array=data.v_vip_info,arr1:Array=data.v_career_info;
			var vipAll:int=0,careerAll:int=0;
			var level_Jg:int=mainUI.levelJG.selectedItem.data;
			var level:String='';
			var num:int=0;
			var str:String='';
			//vip玩家所占比例计算
			for (var i:int = 0; i < arr.length; i++) 
			{
				vipAll+=arr[i].num;
			}
			for (var j:int = 0; j < arr.length; j++) 
			{
				str=String(arr[j].num / vipAll);
				str=str.substr(0,5);
				arr[j].level_percent=str;
				if(mainUI.levelJG.selectedItem.data==1)
				{
					arr[j].level=arr[j].section-1;
				}
				else
				{
					if(num<12)
					{
						arr[j].level=String(num)+"~"+String(level_Jg-1+num);
					}
					else
					{
						arr[j].level=12;
					}
					num++;
					num+=level_Jg-1;
					
				}
				
			}
			//职业玩家所占比例计算
			for (var k:int = 0; k < arr1.length; k++) 
			{
				careerAll+=arr1[k].num;
				if(arr1[k].career==1){
					arr1[k].career_z=Language.QIANGHAO;
				}
				else if(arr1[k].career==2){
					arr1[k].career_z=Language.YINGWU;
				}
				else if(arr1[k].career==3){
					arr1[k].career_z=Language.XIANLING;
				}
				
			}
			for (var a:int = 0; a < arr1.length; a++) 
			{
				str=String(arr1[a].num / careerAll);
				str=str.substr(0,5);
				arr1[a].career_percent=str;
			}
			mainUI.dg1.dataProvider=new ArrayList(arr);
			mainUI.piechart1.dataProvider=new ArrayCollection(arr);
			mainUI.dg2.dataProvider=new ArrayList(arr1);
			mainUI.piechart2.dataProvider=new ArrayCollection(arr1);
		}		
		
		private function get msgSenderProxy() : VipCareer_MsgSendProxy
		{
			if (this._msgSenderProxy == null)
			{
				this._msgSenderProxy = facade.retrieveProxy(VipCareer_MsgSendProxy.NAME) as VipCareer_MsgSendProxy;
			}
			return this._msgSenderProxy;
		}
		
		private function showMain(data:Object):void
		{
			ResizeManager.registerResize(mainUI);
			PipeManager.sendMsg(PipeEvent.ADD_CHILD_TO_MAINUI, mainUI);
			msgSenderProxy.send_20092(1);
		}
	}
}