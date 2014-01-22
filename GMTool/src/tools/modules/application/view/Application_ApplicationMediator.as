package tools.modules.application.view
{
	import flash.events.Event;
	
	import mx.collections.ArrayList;
	import mx.controls.Alert;
	import mx.events.FlexEvent;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import spark.events.IndexChangeEvent;
	
	import tools.common.vo.EquipBase;
	import tools.common.vo.ToolBase;
	import tools.events.PipeEvent;
	import tools.managers.EquipManager;
	import tools.managers.PipeManager;
	import tools.managers.ResizeManager;
	import tools.managers.ToolManager;
	import tools.modules.application.Application_ApplicationFacade;
	import tools.modules.application.model.ApplicationModel;
	import tools.modules.application.model.Application_MsgSendProxy;
	import tools.modules.application.view.components.ApplicationPanel;
	import tools.modules.application.view.components.CheckOpera;

	public class Application_ApplicationMediator extends Mediator
	{

		private var _msgSenderProxy:Application_MsgSendProxy;
		public static const NAME:String = "Application_ApplicationMediator";
		private var model:ApplicationModel=ApplicationModel.getInstance();
		private var changeName:String='';
		private var changePlat:Boolean;

		public function Application_ApplicationMediator(viewComponent:Object)
		{
			super(NAME, viewComponent);
			mainUI.addEventListener(FlexEvent.CREATION_COMPLETE, initUI);
		}
		
		protected function initUI(event:FlexEvent):void
		{
			mainUI.chosPlat.addEventListener(Event.CHANGE,onChosPlat);
			mainUI.dg.addEventListener(CheckOpera.AGREE_APP,onAgreeApp);
			mainUI.dg.addEventListener(CheckOpera.DISAGREE_APP,onDisagreeApp);
		}
		
		/**拒绝申请*/
		protected function onDisagreeApp(event:Event):void
		{
			var agreeArr:Array=new Array();
			agreeArr.push(model.agreeId);//disagreeId=agreeId
			msgSenderProxy.send_20059(agreeArr);
		}
		
		/**同意申请*/
		protected function onAgreeApp(event:Event):void
		{
			var agreeArr:Array=new Array();
			agreeArr.push(model.agreeId);
			msgSenderProxy.send_20041(agreeArr);
		}
		
		/**选择平台*/
		protected function onChosPlat(event:IndexChangeEvent):void
		{
			
			if(mainUI.chosPlat.selectedIndex!=0)
			{
				changePlat=true;
				changeName=mainUI.chosPlat.selectedItem.label;
				msgSenderProxy.send_20043();
			}
			else
			{
				changePlat=false;
				msgSenderProxy.send_20043();
			}
		}
		
		protected function get mainUI() : ApplicationPanel
		{
			return viewComponent as ApplicationPanel;
		}

		override public function onRegister() : void
		{
			return;
		}

		override public function listNotificationInterests() : Array
		{
			return [Application_ApplicationFacade.SHOW_MAINUI,Application_ApplicationFacade.RESE_EQUIP,Application_ApplicationFacade.AGREE_APP,
			Application_ApplicationFacade.DISAGREE_APP];
		}

		override public function handleNotification(param1:INotification) : void
		{
			var data:Object = param1.getBody();
			switch(param1.getName())
			{
				case Application_ApplicationFacade.SHOW_MAINUI:
				{
					showMainUi(data);
					break;
				}
				case Application_ApplicationFacade.RESE_EQUIP:
				{
					handleRes(data);
					break;
				}
				case Application_ApplicationFacade.AGREE_APP:
				{
					agreeApplication(data);
					break;
				}
				case Application_ApplicationFacade.DISAGREE_APP:
				{
					disagreeApplication(data);
					break;
				}
				default:
				{
					break;
				}
			}
			return;
		}
		
		private function disagreeApplication(data:Object):void
		{
			if(data.ret==2008)
			{
				Alert.show(Language.NO_PREMISS_OPERATION,Language.TISHI);
				return;
			}
			else if(data.ret==2020)
			{
				Alert.show(Language.SERVER_IP_ERROR,Language.TISHI);
				return;
			}
			msgSenderProxy.send_20043();
			Alert.show(Language.CAOZUOCHENGGONG,Language.TISHI);
		}
		
		private function agreeApplication(data:Object):void
		{
			if(data.ret==2008)
			{
				Alert.show(Language.NO_PREMISS_OPERATION,Language.TISHI);
				return;
			}
			else if(data.ret==2020)
			{
				Alert.show(Language.SERVER_IP_ERROR,Language.TISHI);
				return;
			}
			msgSenderProxy.send_20043();
			Alert.show(Language.CAOZUOCHENGGONG,Language.TISHI);
		}
		
		private function handleRes(data:Object):void
		{
			var arr1:Array=[];
			var arr:Array=[];
			if(changePlat)
			{
				arr1=data.v_info;
				//
				for (var k:int = 0; k < arr1.length; k++) 
				{
					if(changeName==arr1[k].platname)
					{
						arr.push(arr1[k]);
					}
				}
			}
			else
			{
				arr=data.v_info;
			}
			
			var equipBase:EquipBase;
			var toolBase:ToolBase;
			for (var i:int = 0; i < arr.length; i++) 
			{
				var str:String='';
				var date:Date=new Date(arr[i].apply_time*1000);
				arr[i].time=date.getFullYear()+"-"+(date.getMonth()+1)+"-"+date.getDate()+" "+date.toTimeString();
				var obj:Object=arr[i].req;
				if(obj.gold!=0)
				{
					str=Language.MONEY+"："+obj.gold+"；";
				}
				if(obj.money!=0)
				{
					str+=Language.YUANBAO+"："+obj.money+"；";
				}
				var thing:String=obj.equ;
				var listArr:Array=thing.split(";");
				for (var j:int = 0; j < listArr.length-1; j++) 
				{
					equipBase = EquipManager.getInstance().getEquipConfigInfo((listArr[j] as String).split(",")[0]);
					if(equipBase!=null)
					{
						str+=equipBase.name+"："+(listArr[j] as String).split(",")[1]+"；";
					}
					else
					{
						toolBase = ToolManager.getInstance().getToolConfigInfo((listArr[j] as String).split(",")[0]);
						str+=toolBase.name+"："+(listArr[j] as String).split(",")[1]+"；";
					}
				}
				arr[i].list=str;
			}
			
			mainUI.dg.dataProvider=new ArrayList(arr);
		}		
		
		private function get msgSenderProxy() : Application_MsgSendProxy
		{
			if (this._msgSenderProxy == null)
			{
				this._msgSenderProxy = facade.retrieveProxy(Application_MsgSendProxy.NAME) as Application_MsgSendProxy;
			}
			return this._msgSenderProxy;
		}
		
		private function showMainUi(data:Object):void
		{
			changePlat=false;
			msgSenderProxy.send_20043();
			ResizeManager.registerResize(mainUI);
			PipeManager.sendMsg(PipeEvent.ADD_CHILD_TO_MAINUI, mainUI);
		}
	}
}