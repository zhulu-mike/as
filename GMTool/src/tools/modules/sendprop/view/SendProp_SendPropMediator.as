package tools.modules.sendprop.view
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
	
	import spark.events.IndexChangeEvent;
	
	import tools.common.vo.EquipBase;
	import tools.common.vo.ToolBase;
	import tools.events.PipeEvent;
	import tools.managers.EquipManager;
	import tools.managers.PipeManager;
	import tools.managers.ResizeManager;
	import tools.managers.ToolManager;
	import tools.modules.sendprop.SendProp_ApplicationFacade;
	import tools.modules.sendprop.model.SendPropModel;
	import tools.modules.sendprop.model.SendProp_MsgSendProxy;
	import tools.modules.sendprop.view.components.AddPropTitle;
	import tools.modules.sendprop.view.components.ChooseServerPanel;
	import tools.modules.sendprop.view.components.DeleteApplication;
	import tools.modules.sendprop.view.components.MakeSendList;
	import tools.modules.sendprop.view.components.SendPropPanel;

	public class SendProp_SendPropMediator extends Mediator
	{

		private var _msgSenderProxy:SendProp_MsgSendProxy;
		public static const NAME:String = "SendProp_SendPropMediator";
		private var model:SendPropModel=SendPropModel.getInstance();
		private var chooseServerPanel:ChooseServerPanel;
		private var makeSendListPanel:MakeSendList;
		private var addPropTitle:AddPropTitle;
//		private var servers:Array = ServerManager.getServerList();
		private var servers:Array = Global.mainVO.serverArr;
		private var platArr:Array=Global.mainVO.platChosArr;
		private var arrSer:Array=[];
		private var clickNum:int=0;
		private var arr:Array=[];
		private var appArr:Array=[];

		public function SendProp_SendPropMediator(viewComponent:Object)
		{
			super(NAME, viewComponent);
			mainUI.addEventListener(FlexEvent.CREATION_COMPLETE, initUI);
		}
		
		protected function initUI(event:FlexEvent):void
		{
			//选择服务器面板
			chooseServerPanel=new ChooseServerPanel();
			chooseServerPanel.x=mainUI.width/2-chooseServerPanel.width/2;
			chooseServerPanel.y=mainUI.height/2-chooseServerPanel.height/2;
			chooseServerPanel.visible=false;
			mainUI.addElement(chooseServerPanel);
			model.arrLength=servers.length;
			chooseServerPanel.serlist.dataProvider=new ArrayList(servers);
			model.checkArr=servers;
			//发送清单面板
			makeSendListPanel=new MakeSendList();
			makeSendListPanel.x=mainUI.width/2-makeSendListPanel.width/2;
			makeSendListPanel.y=mainUI.height/2-makeSendListPanel.height/2;
			makeSendListPanel.visible=false;
			mainUI.addElement(makeSendListPanel);
			mainUI.areaTips.visible=false;
			//编辑发送道具面板
			addPropTitle=new AddPropTitle();
			addPropTitle.x=mainUI.width/2-addPropTitle.width/2;
			addPropTitle.y=mainUI.height/2-addPropTitle.height/2;
			addPropTitle.visible=false;
			mainUI.addElement(addPropTitle);
			//按钮
			mainUI.choRange.addEventListener(Event.CHANGE,onChoRange);//发送范围选择
			mainUI.choSendWay.addEventListener(Event.CHANGE,onChoSendWay);//发送方式选择
			mainUI.choServer.addEventListener(MouseEvent.CLICK,onChooseServe);
			mainUI.makeList.addEventListener(MouseEvent.CLICK,onMakeList);
			mainUI.finalSend.addEventListener(MouseEvent.CLICK,onFinalSend);//发送
			mainUI.dg.addEventListener(DeleteApplication.DELETE_APP,onDELETE_APP);
			mainUI.titleInput.addEventListener(MouseEvent.CLICK,onOpenTitle);
			//
			chooseServerPanel.closeBtn.addEventListener(MouseEvent.CLICK,onClose);
			chooseServerPanel.sureBtn.addEventListener(MouseEvent.CLICK,onServList);
			//
			addPropTitle.onSureBtn.addEventListener(MouseEvent.CLICK,onTitileSure);
			addPropTitle.onCancleBtn.addEventListener(MouseEvent.CLICK,onCancleBtn);
			//
			makeSendListPanel.onClose.addEventListener(MouseEvent.CLICK,onMakeSeLiPaClose);
			makeSendListPanel.addPropBtn.addEventListener(MouseEvent.CLICK,onAddProp);
			makeSendListPanel.addEquipBtn.addEventListener(MouseEvent.CLICK,onAddEquip);
			makeSendListPanel.sureBtn.addEventListener(MouseEvent.CLICK,onSureSend);
			//关于权限
			if(model.permiss<3)
			{
				mainUI.finalSend.label=Language.APPLICATION;
				mainUI.dg.visible=true;
				mainUI.dg2.visible=false;
				msgSenderProxy.send_20049();
			}
			else
			{
				var obj1:Object=new Object();
				obj1.icon=0;
				obj1.gold=0;
				obj1.money=0;
				obj1.aura=0,obj1.exp=0;
				obj1.ptg=0,obj1.md=0;
				obj1.ttw=0,obj1.time=0;
				obj1.cream=0,obj1.immdew=0;
				obj1.souldew=0,obj1.immsand=0;
				obj1.starshards=0,obj1.name='';
				obj1.item=0;
				obj1.equ='';
				msgSenderProxy.send_20037(0,0,"",obj1);
			}
			
		}
		
		protected function onCancleBtn(event:MouseEvent):void
		{
			addPropTitle.visible=false;
		}
		
		protected function onOpenTitle(event:MouseEvent):void
		{
			addPropTitle.visible=true;
		}
		
		protected function onTitileSure(event:MouseEvent):void
		{
			model.titleTxt=addPropTitle.titleInput.text;
			addPropTitle.visible=false;
		}
		
		private function changeArr(arr:Array):Array
		{
			var arr1:Array=[];
			for (var i:int = 0; i < arr.length; i++) 
			{
				arr1.push(arr[i].data+arr[i].label);
			}
			return arr1;
		}
		
		/**删除申请*/
		protected function onDELETE_APP(event:Event):void
		{
			var deleteArr:Array=new Array();
			deleteArr.push(model.deleteId);
			msgSenderProxy.send_20047(deleteArr);
		}
		
		protected function onServList(event:MouseEvent):void
		{
			mainUI.choServer.text=model.range;
			chooseServerPanel.visible=false;
		}
		
		protected function onFinalSend(event:MouseEvent):void
		{
			//发送数据收集
			var rang:String='';
			var obj:Object=new Object();
			obj.icon=0;
			obj.gold=model.tongqian;
			obj.money=model.yuanbao;
			obj.aura=0,obj.exp=0;
			obj.ptg=0,obj.md=0;
			obj.ttw=0,obj.time=0;
			obj.cream=0,obj.immdew=0;
			obj.souldew=0,obj.immsand=0;
			obj.starshards=0,obj.name=model.titleTxt;
			obj.item=model.propList;
			obj.equ='';
			if(mainUI.sendRangeInput.visible)
			{
				rang=model.simplePlayer;//范围
			}
			else if(mainUI.sendInputMuch.visible)
			{
				rang=model.morePlayer;
			}
			else
			{
				rang=model.rangeNum;
			}
			if(obj.name=="")
			{
				Alert.show(Language.PLEASE_WRITE_TITLE,Language.TISHI);
				return ;
			}
			//--------------
			if(obj.item!=""||obj.gold!=0||obj.monet!=0)
			{
				if(mainUI.finalSend.label==Language.APPLICATION&&rang!=Language.NO_CHOOSE_SERVER)
				{
					msgSenderProxy.send_20045(model.type,model.range_type,rang,obj);
				}
				else if(mainUI.finalSend.label==Language.SEND&&rang!=Language.NO_CHOOSE_SERVER)
				{
					msgSenderProxy.send_20037(model.type,model.range_type,rang,obj);
				}
			}
			else
			{
				Alert.show(Language.NO_PROP_NO_SERVER,Language.TISHI);
			}
			
			//-------清除记录-----------------------
			makeSendListPanel.yuanbaoInput.text='';
			makeSendListPanel.tongMonInput.text='';
			makeSendListPanel.bpInput.text='';
			mainUI.sendThingList.text='';
			mainUI.sendRangeInput.text='';
			addPropTitle.titleInput.text='';
			model.titleTxt='';
			
		}
		
		/**
		 * 发送方式选择
		 * @param event
		 */
		protected function onChoSendWay(event:IndexChangeEvent):void
		{
			if(mainUI.choSendWay.selectedItem!=null)
			{
				model.type=mainUI.choSendWay.selectedItem.data;
			}
		}
		
		
		/**制作清单面板确定*/
		protected function onSureSend(event:MouseEvent):void
		{
			var str:String='',str1:String='',str2:String='',str3:String='';   //str为数字 ，str1为文字
			for (var i:int = 0; i < model.arrProp.length; i++) 
			{
				str+=model.arrProp[i].id+","+model.arrProp[i].proNum+";";
				str1+=model.arrProp[i].name+","+model.arrProp[i].proNum+";";
			}
			for (var j:int = 0; j < model.arrEqup.length; j++) 
			{
				str2+=model.arrEqup[j].id+","+model.arrEqup[j].equiNum+";";
				str3+=model.arrEqup[j].name+","+model.arrEqup[j].equiNum+";";
			}
			if(str1.indexOf("undefined")!=-1||str3.indexOf("undefined")!=-1)
			{
				Alert.show(Language.INPUT_THING_NUM,Language.TISHI);
			}
			else
			{
				model.propList=str+str2;//item
				model.yuanbao=int(makeSendListPanel.yuanbaoInput.text);
				model.tongqian=int(makeSendListPanel.tongMonInput.text);
				model.tili=int(makeSendListPanel.bpInput.text);
				mainUI.sendThingList.text= Language.TITLE+"："+model.titleTxt+"  "+str1+str3+Language.YUANBAO+model.yuanbao+","+Language.TONG_MONEY+model.tongqian+","+Language.TILI+model.tili;
				model.arrProp=[];
				model.arrEqup=[];
			}
			makeSendListPanel.visible=false;
		}
		
		
		/**制作清单面板道具添加*/
		protected function onAddProp(event:MouseEvent):void
		{
			var item:*=(makeSendListPanel.sysPropList.selectedItem);
			if(item!=null&&model.arrProp.indexOf(item)==-1)
			{
				model.arrProp.push(item);
				makeSendListPanel.addPropList.dataProvider=new ArrayList(model.arrProp);
			}
		}
		
		/**制作清单面板装备添加*/
		protected function onAddEquip(event:MouseEvent):void
		{
			var item:*=(makeSendListPanel.sysEquipList.selectedItem);
			if(item!=null&&model.arrEqup.indexOf(item)==-1)
			{
				model.arrEqup.push(item);
				makeSendListPanel.addEquipList.dataProvider=new ArrayList(model.arrEqup);
			}
		}
		
		
		/**---制作清单面板关闭*/
		protected function onMakeSeLiPaClose(event:MouseEvent):void
		{
			makeSendListPanel.visible=false;
		}
		
		
		/**制作清单面板打开，并且获得数据*/
		protected function onMakeList(event:MouseEvent):void
		{
			makeSendListPanel.title.text=Language.SEND_PROP_TITLE+"："+model.titleTxt;
			var dealEquip:Array=EquipManager.getInstance().getAllEquipInfo();
			var toolarr:Array=ToolManager.getInstance().getAllToolInfo();
			for (var i:int = 0; i < dealEquip.length; i++) 
			{
				dealEquip[i].equiNum=1;
			}
			for (var j:int = 0; j < toolarr.length; j++) 
			{
				toolarr[j].proNum=1;
			}
			makeSendListPanel.sysPropList.dataProvider=new ArrayList(toolarr);
			makeSendListPanel.sysEquipList.dataProvider=new ArrayList(dealEquip);
			makeSendListPanel.visible=true;
		}
		
		
		/**选择服务器面板开关*/
		protected function onClose(event:MouseEvent):void
		{
			chooseServerPanel.visible=false;
		}
		
		protected function onChooseServe(event:MouseEvent):void
		{
			chooseServerPanel.visible=true;
		}

		
		/**
		 * 发送范围选择 
		 * @param event
		 */
		protected function onChoRange(event:IndexChangeEvent):void
		{
			var type:int=mainUI.choRange.selectedItem.data;
			if(type==1)
			{
				model.range_type=1;
				mainUI.areaTips.visible=false;
				mainUI.sendRangeInput.visible=true;
				mainUI.sendInputMuch.visible=false;
				mainUI.choServer.visible=false;
			}
			else if(type==2)
			{
				model.range_type=2;
				mainUI.areaTips.visible=true;
				mainUI.sendRangeInput.visible=false;
				mainUI.sendInputMuch.visible=true;
				mainUI.choServer.visible=false;
			}
			else
			{
				model.range_type=3;
				mainUI.areaTips.visible=false;
				mainUI.sendRangeInput.visible=false;
				mainUI.sendInputMuch.visible=false;
				mainUI.choServer.visible=true;
			}
		}
		
		protected function get mainUI() : SendPropPanel
		{
			return viewComponent as SendPropPanel;
		}

		override public function onRegister() : void
		{
			return;
		}

		override public function listNotificationInterests() : Array
		{
			return [SendProp_ApplicationFacade.SHOW_MAINUI,SendProp_ApplicationFacade.PROP_RESEARCH,SendProp_ApplicationFacade.SEND_RESEARCH,
			SendProp_ApplicationFacade.APP_LIST_RES,SendProp_ApplicationFacade.DELETE_APP,SendProp_ApplicationFacade.LOOK_MINE_APP,
			SendProp_ApplicationFacade.SERVER_RESP];
		}

		override public function handleNotification(param1:INotification) : void
		{
			var data:Object = param1.getBody();
			switch(param1.getName())
			{
				case SendProp_ApplicationFacade.SHOW_MAINUI:
				{
					showMainUi(data);
					break;
				}
				case SendProp_ApplicationFacade.PROP_RESEARCH: //系统道具返回
				{
					handleReceiveProp(data);
					break;
				}
				case SendProp_ApplicationFacade.APP_LIST_RES: //没有权限的管理员申请返回
				{
					handleAppList(data);
					break;
				}
				case SendProp_ApplicationFacade.SEND_RESEARCH: //有权限的管理员发送返回
				{
					receiveSend(data);
					break;
				}
				case SendProp_ApplicationFacade.DELETE_APP: //删除返回
				{
					deleteAppResp(data);
					break;
				}
				case SendProp_ApplicationFacade.LOOK_MINE_APP: //查看自己申请的道具
				{
					receiveMineApp(data);
					break;
				}
				case SendProp_ApplicationFacade.SERVER_RESP: //查看自己申请的道具
				{
					serverResp(data);
					break;
				}
				default:
				{
					break;
				}
			}
			return;
		}
		
		private function deleteAppResp(data:Object):void
		{
			if(data.ret==2008)
			{
				Alert.show(Language.NO_PREMISS_OPERATION,Language.TISHI);
				return;
			}
			else if(data.ret==2022)
			{
				Alert.show(Language.SEND_TYPE_ERROR,Language.TISHI);
				return;
			}
			Alert.show(Language.CAOZUOCHENGGONG,Language.TISHI);
			msgSenderProxy.send_20049();
		}
		
		private function serverResp(data:Object):void
		{
			model.serverList=[];
			var arr:Array=data.v_info;
			model.arrLength=arr.length;
			if(chooseServerPanel)
			{
				chooseServerPanel.serlist.dataProvider=new ArrayList(data.v_info);
				model.checkArr=data.v_info;
			}
			
		}
		
		private function receiveSend(data:Object):void
		{
			var arr:Array=data.v_info;
			var str:String='';
			var equipBase:EquipBase;
			var toolBase:ToolBase;
			for (var i:int = 0; i < arr.length; i++) 
			{
				var date:Date=new Date(arr[i].apply_time*1000);
				arr[i].time=date.getFullYear()+"-"+(date.getMonth()+1)+"-"+date.getDate()+" "+date.toLocaleTimeString();
				if(arr[i].gold!=0)
				{
					str=Language.MONEY+"："+arr[i].gold+"；";
				}
				if(arr[i].money!=0)
				{
					str+=Language.YUANBAO+"："+arr[i].money+"；";
				}
				var thing:String=arr[i].item;
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
				str='';
			}
			var dataArr:ArrayCollection=new ArrayCollection(arr);
			dataArr.sort=new Sort();
			dataArr.sort.fields=[new SortField("time",false,true)];
			dataArr.refresh();
			mainUI.dg2.dataProvider =dataArr;
		}
		
		private function receiveMineApp(data:Object):void
		{
			var arr:Array=data.v_info;
			var equipBase:EquipBase;
			var toolBase:ToolBase;
			
			for (var i:int = 0; i < arr.length; i++) 
			{
				var str:String='';
				var date:Date=new Date(arr[i].apply_time*1000);
				arr[i].time=date.getFullYear()+"-"+(date.getMonth()+1)+"-"+date.getDate()+" "+date.toLocaleTimeString();;
				var obj:Object=arr[i].req;
				if(obj.gold!=0)
				{
					str=Language.MONEY+"："+obj.gold+"；";
				}
				if(obj.money!=0)
				{
					str+=Language.YUANBAO+"："+obj.money+"；";
				}
				var thing:String=obj.item;
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
			var dataArr:ArrayCollection=new ArrayCollection(arr);
			dataArr.sort=new Sort();
			dataArr.sort.fields=[new SortField("time",false,true)];
			dataArr.refresh();
			mainUI.dg.dataProvider =dataArr;			
		}
		
		private function handleAppList(data:Object):void
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
			else if(data.ret==2022)
			{
				Alert.show(Language.SEND_TYPE_ERROR,Language.TISHI);
				return;
			}
			Alert.show(Language.ALREADY_SEND_APP,Language.TISHI);
			//发送查看申请表的协议
			msgSenderProxy.send_20049();
		}
		
		/**
		 * 接受道具数据 
		 * @param data
		 */
		private function handleReceiveProp(data:Object):void
		{
			clickNum++;
			if(clickNum<2)
			{
				model.propData=data;
			}
			
		}
		
		private function get msgSenderProxy() : SendProp_MsgSendProxy
		{
			if (this._msgSenderProxy == null)
			{
				this._msgSenderProxy = facade.retrieveProxy(SendProp_MsgSendProxy.NAME) as SendProp_MsgSendProxy;
			}
			return this._msgSenderProxy;
		}
		
		private function showMainUi(data:Object):void
		{
			if(data!=3)
			{
				model.permiss=data.permission;
			}
			else
			{
				model.permiss=int(data);
			}
			ResizeManager.registerResize(mainUI);
			PipeManager.sendMsg(PipeEvent.ADD_CHILD_TO_MAINUI, mainUI);
			
			/**========================================================*/
			
		}
	}
}