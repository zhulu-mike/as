package tools.modules.addserver.view
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayList;
	import mx.controls.Alert;
	import mx.events.FlexEvent;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import spark.events.IndexChangeEvent;
	
	import tools.events.PipeEvent;
	import tools.managers.PipeManager;
	import tools.managers.ResizeManager;
	import tools.modules.addserver.AddServer_ApplicationFacade;
	import tools.modules.addserver.model.AddServer_MsgSendProxy;
	import tools.modules.addserver.view.components.AddServerPanel;
	import tools.modules.addserver.view.components.ChangeServerPanel;
	import tools.modules.addserver.view.components.PlatServerItem;

	public class AddServer_AddServerMediator extends Mediator
	{

		private var _msgSenderProxy:AddServer_MsgSendProxy;
		public static const NAME:String = "AddServer_AddServerMediator";
		private var changeServerPanel:ChangeServerPanel;

		public function AddServer_AddServerMediator(viewComponent:Object)
		{
			super(NAME, viewComponent);
			mainUI.addEventListener(FlexEvent.CREATION_COMPLETE, initUI);
		}
		
		protected function initUI(event:FlexEvent):void
		{
			//修改查看服务器面板
			changeServerPanel=new ChangeServerPanel();
			changeServerPanel.x=mainUI.width/2-changeServerPanel.width/2;
			changeServerPanel.y=mainUI.height/2-changeServerPanel.height/2;
			mainUI.addElement(changeServerPanel);
			changeServerPanel.visible=false;
			//按钮
			mainUI.onSureBtn.addEventListener(MouseEvent.CLICK,onSureBtn);
//			mainUI.platChoose.addEventListener(Event.CHANGE,onPlatChoose);
			mainUI.lt.addEventListener(PlatServerItem.CHANGE_SERVER,onChangeServerBtn);
			changeServerPanel.onSureBtn.addEventListener(MouseEvent.CLICK,onChangeSureBtn);
			changeServerPanel.onCloseBtn.addEventListener(MouseEvent.CLICK,onCloseBtn);
		}
		
		protected function onCloseBtn(event:MouseEvent):void
		{ 
			changeServerPanel.visible=false;
		}
		
		/**
		 *修改服务器请求 
		 * @param event
		 */
		protected function onChangeSureBtn(event:MouseEvent):void
		{
			changeServerPanel.visible=false;
			var id:int=mainUI.lt.selectedItem.serverid;//服务器id
			var serverName:String=changeServerPanel.serverName.text;//服务器名称
			var platId:int=int(changeServerPanel.platId.text);//平台id
			var platIp:String=changeServerPanel.platIp.text;//平台ip
			var port:int=int(changeServerPanel.platPort.text);//平台端口号
			var dbhost:String=changeServerPanel.dbhost.text;//服务器数据库地址
			var dbuser:String=changeServerPanel.dbuser.text;//服务器数据库用户名
			var dbpwd:String=changeServerPanel.dbpwd.text;//服务器数据库密码
			var dbname:String=changeServerPanel.dbname.text;//服务器数据库名
			var dbport:int=int(changeServerPanel.dbport.text);//服务器数据库端口号
			var maindbhost:String=changeServerPanel.maindbhost.text;//服务器数据库主地址
			var maindbuser:String=changeServerPanel.maindbuser.text;//服务器数据库主用户名
			var maindbpwd:String=changeServerPanel.maindbpwd.text;//服务器主数据库密码
			var maindbname:String=changeServerPanel.maindbname.text;//服务器主数据库名
			var maindbport:int=int(changeServerPanel.maindbport.text);//服务器主数据库端口号
			msgSenderProxy.send_20071(id,serverName,platId,platIp,port,dbhost,dbuser,dbpwd,dbname,dbport,maindbhost,maindbuser,maindbpwd,maindbname,maindbport);
		}
		
		/**
		 * 弹出查看修改服务器界面 
		 * @param event
		 * 
		 */
		protected function onChangeServerBtn(event:Event):void
		{
			msgSenderProxy.send_20073(mainUI.lt.selectedItem.serverid);
			changeServerPanel.visible=true;
		}
		
		protected function onPlatChoose(event:IndexChangeEvent):void
		{
//			var value:int=mainUI.platChoose.selectedItem.data;
//			if(value!=0)
//			{
//				msgSenderProxy.send_20067(value);
//			}
//			
		}
		
		/**
		 * 确定创建发送服务器信息 
		 * @param event
		 * 
		 */
		protected function onSureBtn(event:MouseEvent):void
		{
			var serverName:String=mainUI.serverName.text;//服务器名称
			var platId:int=int(mainUI.platId.text);//平台id
			var platIp:String=mainUI.platIp.text;//平台ip
			var port:int=int(mainUI.platPort.text);//平台端口号
			var dbhost:String=mainUI.dbhost.text;//服务器数据库地址
			var dbuser:String=mainUI.dbuser.text;//服务器数据库用户名
			var dbpwd:String=mainUI.dbpwd.text;//服务器数据库密码
			var dbname:String=mainUI.dbname.text;//服务器数据库名
			var dbport:int=int(mainUI.dbport.text);//服务器数据库端口号
			var maindbhost:String=mainUI.maindbhost.text;//服务器数据库主地址
			var maindbuser:String=mainUI.maindbuser.text;//服务器数据库主用户名
			var maindbpwd:String=mainUI.maindbpwd.text;//服务器主数据库密码
			var maindbname:String=mainUI.maindbname.text;//服务器主数据库名
			var maindbport:int=int(mainUI.maindbport.text);//服务器主数据库端口号
			msgSenderProxy.send_20069(serverName,platId,platIp,port,dbhost,dbuser,dbpwd,dbname,dbport,maindbhost,maindbuser,maindbpwd,maindbname,maindbport);
		}
		
		protected function get mainUI() : AddServerPanel
		{
			return viewComponent as AddServerPanel;
		}

		override public function onRegister() : void
		{
			return;
		}

		override public function listNotificationInterests() : Array
		{
			return [AddServer_ApplicationFacade.SHOW_MAINUI,AddServer_ApplicationFacade.RESP_ADD_SERVER,AddServer_ApplicationFacade.RESP_CHOOSE_SERVER,AddServer_ApplicationFacade.RESP_SERVER_LIST];
		}

		override public function handleNotification(param1:INotification) : void
		{
			var data:Object = param1.getBody();
			switch(param1.getName())
			{
				case AddServer_ApplicationFacade.SHOW_MAINUI:
				{
					showMainUi(data);
					break;
				}
				case AddServer_ApplicationFacade.RESP_CHOOSE_SERVER:
				{
					handleChooseServer(data);
					break;
				}
				case AddServer_ApplicationFacade.RESP_ADD_SERVER:
				{
					handleRespAddServer(data);
					break;
				}
				case AddServer_ApplicationFacade.RESP_SERVER_LIST:
				{
					checkSelectServerInfo(data);
					break;
				}
				default:
				{
					break;
				}
			}
			return;
		}
		
		private function checkSelectServerInfo(data:Object):void
		{
			data=data.body;
			changeServerPanel.serverName.text=data.name;//服务器名称
			changeServerPanel.platId.text=data.platid;//平台id
			changeServerPanel.platIp.text=data.ip;//平台ip
			changeServerPanel.platPort.text=data.port;//平台端口号
			changeServerPanel.dbhost.text=data.dbhost;//服务器数据库地址
			changeServerPanel.dbuser.text=data.dbuser;//服务器数据库用户名
			changeServerPanel.dbpwd.text=data.dbpwd;//服务器数据库密码
			changeServerPanel.dbname.text=data.dbname;//服务器数据库名
			changeServerPanel.dbport.text=data.dbport;//服务器数据库端口号
			changeServerPanel.maindbhost.text=data.maindbhost;//服务器数据库主地址
			changeServerPanel.maindbuser.text=data.maindbuser;//服务器数据库主用户名
			changeServerPanel.maindbpwd.text=data.maindbpwd;//服务器主数据库密码
			changeServerPanel.maindbname.text=data.maindbname;//服务器主数据库名
			changeServerPanel.maindbport.text=data.maindbport;//服务器主数据库端口号
		}
		
		private function handleChooseServer(data:Object):void
		{
			mainUI.lt.dataProvider=new ArrayList(data.v_info);
		}
		
		private function handleRespAddServer(data:Object):void
		{
			if(data.ret==2035)
			{
				Alert.show(Language.DATA_CANT_NULL,Language.TISHI);
			}
			else if(data.ret==2032)
			{
				Alert.show(Language.SERVER_NAME_EXIT,Language.TISHI);
			}
			else if(data.ret==2033)
			{
				Alert.show(Language.IP_ADDRESS_ERROR,Language.TISHI);
			}
			else
			{
				////
				Alert.show(Language.CAOZUOCHENGGONG,Language.TISHI);
			}
			
		}
		
		private function get msgSenderProxy() : AddServer_MsgSendProxy
		{
			if (this._msgSenderProxy == null)
			{
				this._msgSenderProxy = facade.retrieveProxy(AddServer_MsgSendProxy.NAME) as AddServer_MsgSendProxy;
			}
			return this._msgSenderProxy;
		}
		
		private function showMainUi(data:Object):void
		{
			msgSenderProxy.send_20067(1);
			ResizeManager.registerResize(mainUI);
			PipeManager.sendMsg(PipeEvent.ADD_CHILD_TO_MAINUI, mainUI);
		}
	}
}