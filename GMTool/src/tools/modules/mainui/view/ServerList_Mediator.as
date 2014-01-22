package tools.modules.mainui.view
{
    import flash.events.Event;
    import flash.events.MouseEvent;
    
    import mx.collections.ArrayCollection;
    import mx.controls.Alert;
    import mx.events.FlexEvent;
    import mx.events.ListEvent;
    
    import org.puremvc.as3.multicore.interfaces.*;
    import org.puremvc.as3.multicore.patterns.mediator.*;
    
    import spark.events.IndexChangeEvent;
    
    import tools.managers.LayerManager;
    import tools.managers.ResizeManager;
    import tools.managers.ServerManager;
    import tools.modules.load.view.components.LoaderBar;
    import tools.modules.mainui.MainUI_ApplicationFacade;
    import tools.modules.mainui.model.MainUI_MsgSendProxy;
    import tools.modules.mainui.view.components.ServerListPanel;

    public class ServerList_Mediator extends Mediator
    {
		
        public static const NAME:String = "ServerList_Mediator";
        private var _msgSenderProxy:MainUI_MsgSendProxy;
		private var isCreate:Boolean = false;
		private var isShow:Boolean = false;

		private var sid:int;

		private var sname:String;

//        public function ServerList_Mediator(param1:Object = null)
//        {
//            super(NAME, param1);
//			mainUI.addEventListener(FlexEvent.CREATION_COMPLETE, initUI);
//            return;
//        }
//		
//		protected function get mainUI():ServerListPanel
//		{
//			return viewComponent as ServerListPanel;
//		}
//
//        override public function onRegister() : void
//        {
//            return;
//        }
//
//        override public function onRemove() : void
//        {
//            return;
//        }
//
//
//        private function get msgSenderProxy() : MainUI_MsgSendProxy
//        {
//            if (this._msgSenderProxy == null)
//            {
//                this._msgSenderProxy = facade.retrieveProxy(MainUI_MsgSendProxy.NAME) as MainUI_MsgSendProxy;
//            }
//            return this._msgSenderProxy;
//        }
//
//        override public function listNotificationInterests() : Array
//        {
//            return [MainUI_ApplicationFacade.SHOW_SERVER_MAINUI,
//			MainUI_ApplicationFacade.SERVER_RESP,MainUI_ApplicationFacade.RESP_SERVER_LIST];
//        }
//
//        override public function handleNotification(param1:INotification) : void
//        {
//			var data:* = param1.getBody();
//			switch (param1.getName())
//			{
//				case MainUI_ApplicationFacade.SHOW_SERVER_MAINUI:
//					showMain();
//					break;
//				case MainUI_ApplicationFacade.SERVER_RESP:
//					changeSuccess(data);
//					break;
//				case MainUI_ApplicationFacade.RESP_SERVER_LIST:
//					respServerList(data);
//					break;
//			}
//            return;
//        }
//		
//		private function respServerList(data:Object):void
//		{
//			var arr:Array=data.v_info;
//			for (var i:int = 0; i < arr.length; i++) 
//			{
//				arr[i].id=arr[i].serverid;
//			}
//			mainUI.list.dataProvider = new ArrayCollection(arr);
//		}
//		
//		/**
//		 * 显示主界面
//		 * 
//		 */		
//		public function showMain():void
//		{
//			if (isCreate == false)
//			{
//				isShow = true;
//				LayerManager.higherLayer.addElement(mainUI);
//				return;
//			}
////			var servers:Array = ServerManager.getServerList();
////			mainUI.list.dataProvider = new ArrayCollection(servers);
//			msgSenderProxy.send_20067(1);
//			LayerManager.higherLayer.addElement(mainUI);
//			ResizeManager.registerResize(mainUI);
//		}
//		
//		/**
//		 * 初始化
//		 * 
//		 */		
//		private function initUI(e:FlexEvent):void
//		{
//			isCreate = true;
//			mainUI.list.addEventListener(Event.CHANGE, onItemClick);
//			mainUI.closeBtn.addEventListener(MouseEvent.CLICK, closePanel);
//			mainUI.platChoose.addEventListener(Event.CHANGE,onChoosePlat);
//			if(Global.mainVO.platid!=1&&Global.mainVO.level>2)
//			{
//				mainUI.platChoose.enabled=false;
//			}
//			if (isShow)
//			{
//				showMain();
//				isShow = false;
//			}
//		}
//		
//		/**
//		 * 选择平台 
//		 * @param event
//		 * 
//		 */
//		protected function onChoosePlat(event:IndexChangeEvent):void
//		{
//			 var value:int=mainUI.platChoose.selectedItem.data;
//			 var name:String=mainUI.platChoose.selectedItem.label;
//			 Global.mainVO.adminPlatId=value;
//			 Global.mainVO.adminPlatName=name;
//			 msgSenderProxy.send_20067(value);
//		}
//		
//		/**
//		 * 关闭服务器选择列表
//		 * @param event
//		 * 
//		 */		
//		private function closePanel(event:MouseEvent):void
//		{
//			ResizeManager.unRegisterResize(mainUI);
//			LayerManager.higherLayer.removeElement(mainUI);
//		}
//
//		/**
//		 * 选择某一个服务器
//		 * @param event
//		 * 
//		 */		
//		private function onItemClick(event:Event):void
//		{
//			sid = mainUI.list.selectedItem.id;
//			sname = mainUI.list.selectedItem.name;
//			LoaderBar.getInstance().show();
//			LoaderBar.getInstance().setText(Language.CON_SERV_ING);
//			msgSenderProxy.send_20039(sid);
//		}
//
//		private function changeSuccess(data:Object):void
//		{
//			LoaderBar.getInstance().close();
//			if (data.ret == 0)
//			{
//				closePanel(null);
//				sendNotification(MainUI_ApplicationFacade.SERVER_CHANGE,{id:sid, name:sname});
//			}else{
//				Alert.show(Language.CON_BREAK);
//			}
//		}
		
    }
}
