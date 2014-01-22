package tools.modules.mainui.view
{
    import flash.events.Event;
    import flash.events.MouseEvent;
    
    import mx.collections.ArrayList;
    import mx.controls.Alert;
    import mx.core.IVisualElement;
    import mx.events.CloseEvent;
    import mx.events.FlexEvent;
    import mx.events.ListEvent;
    
    import org.puremvc.as3.multicore.interfaces.*;
    import org.puremvc.as3.multicore.patterns.mediator.*;
    
    import spark.events.IndexChangeEvent;
    
    import tools.events.PipeEvent;
    import tools.managers.BrowseManager;
    import tools.managers.LayerManager;
    import tools.managers.ModuleManager;
    import tools.managers.ResizeManager;
    import tools.modules.mainui.MainUI_ApplicationFacade;
    import tools.modules.mainui.model.MainUI_MsgSendProxy;
    import tools.modules.mainui.model.ServerModel;
    import tools.modules.mainui.view.components.MainUIPanel;
    import tools.utils.SysUtil;

    public class MainUI_Mediator extends Mediator
    {
		private var dp:Array = Global.dp;
        private var avatar_zizeng:int = 0;
        private var _msgSenderProxy:MainUI_MsgSendProxy;
        public static const NAME:String = "MainUI_Mediator";
		private var model:ServerModel=ServerModel.getInstance();

        public function MainUI_Mediator(param1:Object = null)
        {
            super(NAME, param1);
			initUI();
            return;
        }
		
		protected function get mainUI():MainUIPanel
		{
			return viewComponent as MainUIPanel;
		}

        override public function onRegister() : void
        {
            return;
        }

        override public function onRemove() : void
        {
            return;
        }

		private function get msgSenderProxy() : MainUI_MsgSendProxy
		{
			if (this._msgSenderProxy == null)
			{
				this._msgSenderProxy = facade.retrieveProxy(MainUI_MsgSendProxy.NAME) as MainUI_MsgSendProxy;
			}
			return this._msgSenderProxy;
		}

        override public function listNotificationInterests() : Array
        {
            return [MainUI_ApplicationFacade.SHOW_MAINUI,
			MainUI_ApplicationFacade.ADD_CHILD_TO_MAINUI,
			MainUI_ApplicationFacade.SERVER_CHANGE,
			MainUI_ApplicationFacade.SERVER_RESP,MainUI_ApplicationFacade.RESP_SERVER_LIST,
			MainUI_ApplicationFacade.KICK_OUT_REFRESH];
        }

        override public function handleNotification(param1:INotification) : void
        {
			var data:* = param1.getBody();
			switch (param1.getName())
			{
				case MainUI_ApplicationFacade.SHOW_MAINUI:
					showMain();
					break;
				case MainUI_ApplicationFacade.ADD_CHILD_TO_MAINUI:
					addChildToMainUI(data);
					break;
//				case MainUI_ApplicationFacade.SERVER_CHANGE:
//					serverChange(data);
//					break;
				case MainUI_ApplicationFacade.SERVER_RESP:
					break;
				case MainUI_ApplicationFacade.RESP_SERVER_LIST:
					respServerList(data);
					break;
				case MainUI_ApplicationFacade.KICK_OUT_REFRESH:
					kickOutRefresh(data);
					break;
			}
            return;
        }
		
		private function kickOutRefresh(data:*):void
		{
			if(data.reason==1)
			{
				Alert.show(Language.PLEASE_LOGIN_AGAIN,Language.TISHI,Alert.OK,null,refreshAll);
			}
			else
			{
				Alert.show(Language.SYSTEM_MAINTAIN,Language.TISHI,Alert.OK,null,refreshAll);
			}
		}
		
		private function refreshAll(e:CloseEvent):void
		{
			BrowseManager.refresh();
		}
		
		/**
		 * 选择平台之后返回
		 * @param data
		 * 
		 */
		private function respServerList(data:*):void
		{
			var arr:Array=data.v_info;
			for (var i:int = 0; i < arr.length; i++) 
			{
				arr[i].data=arr[i].serverid;
				arr[i].label=arr[i].name;
				arr[i].icon = {};
			}
			model.serverArr=arr;
			Global.mainVO.serverArr=arr;
			mainUI.serverChooser.dataProvider=new ArrayList(arr);
			if(arr.length!=0)
			{
				msgSenderProxy.send_20039(arr[0].data);
			}
			mainUI.serverChooser.selectedIndex=0;
		}
		
		
		/**
		 * 显示主界面
		 * 
		 */		
		public function showMain():void
		{
			if(Global.mainVO.platid!=1&&Global.mainVO.level>2)
			{
				mainUI.platChoseLabel.visible=false;//只有总代理和一级管理员才能选择其他平台的服务器进行管理
				mainUI.platChoose.visible=false;
				mainUI.serverChooseLabel.visible=false;
				mainUI.serverChooser.visible=false;
			}
			LayerManager.uiLayer.addElement(mainUI);
			mainUI.userName.text = Global.mainVO.userName;
			//////
			if(Global.mainVO.lastLogintTime==0)
			{
				mainUI.lastLoginTime.text=Language.NO_JILU;
			}
			else
			{
				var date:Date=new Date(Global.mainVO.lastLogintTime*1000);
				mainUI.lastLoginTime.text=date.getFullYear()+"-"+(date.getMonth()+1)+"-"+date.getDate();
			}
			mainUI.userGroup.text = SysUtil.getAdminGroupName(Global.mainVO.group);
			createOperateGroupList(Global.mainVO.permission);
			msgSenderProxy.send_20067(Global.mainVO.platid);
		}
		
		/**
		 * 初始化
		 * 
		 */		
		private function initUI():void
		{
			ResizeManager.registerResize(mainUI);
			mainUI.allExpand.addEventListener(Event.CHANGE, onAllOpen);
			mainUI.tree.addEventListener(ListEvent.ITEM_CLICK, onTreeSelect);
			//此时还未生成userName，原因暂且不清楚，待查
//			mainUI.userName.text = Global.mainVO.userName;
			mainUI.addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
		}

		private function onCreationComplete(event:FlexEvent):void
		{
//			mainUI.serverList.addEventListener(MouseEvent.CLICK, showServerList);
//			sendNotification(MainUI_ApplicationFacade.SHOW_SERVER_MAINUI);
			mainUI.platChoose.addEventListener(Event.CHANGE,onChoosePlat);
			mainUI.serverChooser.addEventListener(Event.CHANGE,onChooseServer);
		}
		
		protected function onChooseServer(event:IndexChangeEvent):void
		{
			if((model.serverArr as Array).indexOf(mainUI.serverChooser.selectedItem)!=-1)
			{
				var id:int=mainUI.serverChooser.selectedItem.data;
				msgSenderProxy.send_20039(id);
				Global.mainVO.serverId=id;
			}
		}
		
		protected function onChoosePlat(event:IndexChangeEvent):void
		{
			if((model.platArr as Array).indexOf(mainUI.platChoose.selectedItem)!=-1)
			{
				var id:int=mainUI.platChoose.selectedItem.data;
				msgSenderProxy.send_20067(id);
				Global.mainVO.adminPlatId=id;
			}
			
		}
		
//		/**显示服务器列表面板*/
//		private function showServerList(event:MouseEvent):void
//		{
//			sendNotification(MainUI_ApplicationFacade.SHOW_SERVER_MAINUI);
//		}
		
		/**
		 * 根据权限，生成可操作列表 
		 * @param permission:int 
		 */
		private function createOperateGroupList(permission:String):void
		{
			var xml:XML = <data></data>;
			var i:int = 0, len:int = dp.length;
			var j:int = 0, llen:int = 0, pnode:Object, node:Object;
			var pxml:XML, nxml:XML;
			var availableNodes:Array = [], allNodes:Array = [];
			for (;i<len;i++)
			{
				pnode = dp[i];
				pxml = null;
				llen = pnode.nodes.length;
				for (j=0;j<llen;j++)
				{
					node = pnode.nodes[j];
					if (int(permission.substr(node.data - 1,1))  <= 0)
						continue;
					if (pxml == null)
					{
						pxml = <pnode/>;
						pxml.@label = pnode.label;
						xml.appendChild(pxml);
					}
					nxml = <node/>;
					nxml.@label = node.label;
					nxml.@data  = node.data;
					pxml.appendChild(nxml);
				}
			}
			mainUI.moduleData = xml;
			mainUI.tree.dataProvider = xml;
			mainUI.tree.validateNow();
			mainUI.tree.expandChildrenOf(xml,true);
		}

		
		/**
		 * 添加一个模块界面到主界面操作区域
		 * 
		 */
        private function addChildToMainUI(param1:IVisualElement) : void
        {
			mainUI.operateCanvas.removeAllElements();
			mainUI.operateCanvas.addElement(param1);
		}

		/**
		 * 是否展开所有节点
		 * @param e
		 * 
		 */		
		private function onAllOpen(e:Event):void
		{
			var value:Boolean = mainUI.allExpand.selected;
			mainUI.tree.expandChildrenOf(mainUI.moduleData,value);
		}
		
		/**
		 *  选中某个管理项
		 */
		private function onTreeSelect(e:ListEvent):void
		{
			var item:Object = mainUI.tree.selectedItem;
			if (mainUI.tree.dataDescriptor.isBranch(item))
			{
				if (mainUI.tree.isItemOpen(item))
					mainUI.tree.expandChildrenOf(item,false);
				else
					mainUI.tree.expandChildrenOf(item,true);
				return;
			}
			var da:int = item.@data;
			var per:int = int(Global.mainVO.permission.substr(da - 1,1));
			var data:Object = {data:da, permission:per};
			switch (da)
			{
				case 1:
					//XX模块
					ModuleManager.showModule(PipeEvent.STARTUP_CHARGE, PipeEvent.SHOW_CHARGE_MAINUI, data);
					break;
				case 2:
					//XX模块
					ModuleManager.showModule(PipeEvent.STARTUP_CHARGE, PipeEvent.SHOW_CHARGE_RANK_MAINUI, data);
					break;
				case 3:
					//XX模块
					ModuleManager.showModule(PipeEvent.STARTUP_CHARGE, PipeEvent.SHOW_CHARGE_COUNT, data);
					break;
				case 4:
					//XX模块
					ModuleManager.showModule(PipeEvent.STARTUP_CHARGE, PipeEvent.SHOW_PLAYER_MAINUI, data);
					break;
				case 5:
					ModuleManager.showModule(PipeEvent.STARTUP_CHARGE, PipeEvent.SHOW_USER_MAINUI, data);
					break;
				case 6:
					ModuleManager.showModule(PipeEvent.STARTUP_CHARGE, PipeEvent.SHOW_FIGHTER_SPIRIT_MAINUI, data);
					break;
				case 7:
					ModuleManager.showModule(PipeEvent.STARTUP_CHARGE, PipeEvent.SHOW_PASSPORT_MAINUI, data);
					break;
				case 8:
					ModuleManager.showModule(PipeEvent.STARTUP_CHARGE, PipeEvent.SHOW_PROP_MAINUI, data);
					break;
				case 9:
					ModuleManager.showModule(PipeEvent.STARTUP_CHARGE, PipeEvent.SHOW_SEND_PROP_MAINUI, data);
					break;
				case 10:
					ModuleManager.showModule(PipeEvent.STARTUP_CHARGE, PipeEvent.SHOW_EQUIP_MANAGE_MAINUI, data);
					break;
				case 11:
					ModuleManager.showModule(PipeEvent.STARTUP_CHARGE, PipeEvent.SHOW_APPLICATION_MAINUI, data);
					break;
				case 12:
					ModuleManager.showModule(PipeEvent.STARTUP_CHARGE, PipeEvent.SHOW_CONSUM_ONLINE_MAINUI, data);
					break;
				case 13:
					ModuleManager.showModule(PipeEvent.STARTUP_CHARGE, PipeEvent.SHOW_PLAYER_CARD_MAINUI, data);
					break;
				case 14:
					ModuleManager.showModule(PipeEvent.STARTUP_CHARGE, PipeEvent.SHOW_CHECK_CARD_MIANUI, data);
					break;
				case 15:
					ModuleManager.showModule(PipeEvent.STARTUP_CHARGE, PipeEvent.SHOW_PLAYER_ONLINE_MAINUI, data);
					break;
				case 16:
					ModuleManager.showModule(PipeEvent.STARTUP_CHARGE, PipeEvent.SHOW_ADD_SERVER_LIST_MAINUI, data);
					break;
				case 17:
					ModuleManager.showModule(PipeEvent.STARTUP_CHARGE, PipeEvent.SHOW_ANNOUNCE_MANAGER_MAINUI, data);
					break;
				case 18:
					ModuleManager.showModule(PipeEvent.STARTUP_CHARGE, PipeEvent.SHOW_VIP_CAREER, data);
					break;
				case 19:
					ModuleManager.showModule(PipeEvent.STARTUP_CHARGE, PipeEvent.SHOW_PLAYER_LEVEL_MAINUI, data);
					break;
			}
		}
		
		/**
		 * 服务器改变
		 * @param data
		 * 
		 */		
		private function serverChange(data:Object):void
		{
			// TODO Auto Generated method stub
//			mainUI.serverList.text = data.id + data.name;
//			mainUI.platChose.text = Global.mainVO.adminPlatName;
		}
    }
}
