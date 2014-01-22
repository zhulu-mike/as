package tools.modules.passport.view
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	
	import mx.collections.ArrayList;
	import mx.controls.Alert;
	import mx.events.FlexEvent;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import spark.events.TextOperationEvent;
	
	import tools.events.PipeEvent;
	import tools.managers.PipeManager;
	import tools.managers.ResizeManager;
	import tools.modules.passport.Passport_ApplicationFacade;
	import tools.modules.passport.model.PassportModel;
	import tools.modules.passport.model.Passport_MsgSendProxy;
	import tools.modules.passport.view.components.ChangePlat;
	import tools.modules.passport.view.components.ChangePsw;
	import tools.modules.passport.view.components.CreatPassportPanel;
	import tools.modules.passport.view.components.DeletePasspot;
	import tools.modules.passport.view.components.OperationItem;
	import tools.modules.passport.view.components.PassportPanel;
	import tools.modules.passport.view.components.PermissionItem;
	import tools.modules.passport.view.components.PermissionSetItem;

	public class Passport_PassportMediator extends Mediator
	{

		private var _msgSenderProxy:Passport_MsgSendProxy;
		public static const NAME:String = "Passport_PassportMediator";
		private var model:PassportModel=PassportModel.getInstance();
		public static const MAKE_PLAT:String = "MAKE_PLAT";
		private var dp:Array = Global.dp;
		private var arr:Array=[];
		private var arrPerm:Array=[];
		private var tempItem:PermissionSetItem;
		
		private var creatPasspot:CreatPassportPanel;//注册界面
		private var changePsw:ChangePsw;//修改密码界面
		private var deletePass:DeletePasspot;
		private var changPlat:ChangePlat;

		public function Passport_PassportMediator(viewComponent:Object)
		{
			super(NAME, viewComponent);
			mainUI.addEventListener(FlexEvent.CREATION_COMPLETE, initUI);
		}
		
		protected function initUI(event:FlexEvent):void
		{
			//////----面板----
			//注册
			creatPasspot = new CreatPassportPanel();
			creatPasspot.x=mainUI.width/2-creatPasspot.width/2;
			creatPasspot.y=mainUI.height/2-creatPasspot.height/2;
			creatPasspot.visible=false;
			mainUI.addElement(creatPasspot);
			permSetItem();
			//修改密码
			changePsw = new ChangePsw();
			changePsw.x=mainUI.width/2-changePsw.width/2;
			changePsw.y=mainUI.height/2-changePsw.height/2;
			changePsw.visible=false;
			mainUI.addElement(changePsw);
			//删除
			deletePass = new DeletePasspot();
			deletePass.x=mainUI.width/2-deletePass.width/2;
			deletePass.y=mainUI.height/2-deletePass.height/2;
			deletePass.visible=false;
			mainUI.addElement(deletePass);
			mainUI.searchIuput.visible=false;
			//修改平台
//			changPlat = new ChangePlat();
//			changPlat.x=mainUI.width/2-changPlat.width/2;
//			changPlat.y=mainUI.height/2-changPlat.height/2;
//			changPlat.visible=false;
//			mainUI.addElement(changPlat);
			//////----按钮----
			mainUI.searchWay.addEventListener(Event.CHANGE, onSearchWay);
			mainUI.searchBtn.addEventListener(MouseEvent.CLICK, onSearch);		
			creatPasspot.radiogroup1.addEventListener(Event.CHANGE, radioBtn);
			//创建账号
			mainUI.creatPsBtn.addEventListener(MouseEvent.CLICK, onCreatPs);
			creatPasspot.sureBtn.addEventListener(MouseEvent.CLICK, onSureBtn);
			creatPasspot.closeBtn.addEventListener(MouseEvent.CLICK, onPassClose);
			creatPasspot.addPlatBtn.addEventListener(MouseEvent.CLICK,onAddPlatBtn);
			//修改平台
//			mainUI.dg.addEventListener(OperationItem.CHANGE_PLAT,onCHANGE_PLAT);
			//修改权限
			mainUI.dg.addEventListener(PermissionItem.CHANGE_PERMISSION, onCHANGE_PERMISSION);
			//修改密码
			changePsw.closeBtn.addEventListener(MouseEvent.CLICK, onPsdClose);
			mainUI.dg.addEventListener(OperationItem.CHANGE_PASSWORD, onCHANGE_PASSWORD);
			changePsw.lastPsw.addEventListener(Event.CHANGE,onLastPsw);
			changePsw.newPsw.addEventListener(Event.CHANGE,onNewPsw);
			changePsw.sureBtn.addEventListener(MouseEvent.CLICK, onSure);
			//删除出现
			mainUI.dg.addEventListener(OperationItem.DELETE_ID, onDELETE_ID);
			deletePass.sureDeleBtn.addEventListener(MouseEvent.CLICK,onDeletePass);
			deletePass.closeBtn.addEventListener(MouseEvent.CLICK,onClosePanel);
			//修改平台按钮
//			changPlat.onSureBtn.addEventListener(MouseEvent.CLICK,onSureChangePlat);
//			changPlat.onCancelBtn.addEventListener(MouseEvent.CLICK,onCancelChangePlat);
			
		}
		
		protected function onCancelChangePlat(event:MouseEvent):void
		{
			changPlat.visible=false;
		}
		
		/**
		 * 修改平台确定 
		 * @param event
		 * 
		 */
		protected function onSureChangePlat(event:MouseEvent):void
		{
			var newPlat:int=changPlat.platChoose.selectedItem.data;
			msgSenderProxy.send_20031(newPlat,model.delId,model.delLevel);
		}
		
		/**
		 *修改平台 
		 * @param event
		 * 
		 */
		protected function onCHANGE_PLAT(event:Event):void
		{
			changPlat.visible=true;
		}
		
		protected function onNewPsw(event:TextOperationEvent):void
		{
			model.newPsw=changePsw.newPsw.text;
		}
		
		protected function onLastPsw(event:TextOperationEvent):void
		{
			model.lastPsw=changePsw.lastPsw.text;
		}
		
		protected function onAddPlatBtn(event:MouseEvent):void
		{
			//添加平台
			if(creatPasspot.addPlatTxt.text.length>0)
			{
				var plat:String=creatPasspot.addPlatTxt.text;
				msgSenderProxy.send_20023(plat);
			}
		}
		
		private function clickSearch():void
		{
			var cond:String='';
			if(model.buttonType!=0)
			{
				cond=mainUI.searchIuput.text;
				//搜索平台汉字转数字发送
				var platArr:Array=model.platObj;
				for (var i:int = 0; i < platArr.length; i++) 
				{
					if(cond==platArr[i].label)
					{
						cond=platArr[i].data;
					}
				}
				//
				if(model.buttonType==2&&cond!=null)
				{
					if(Global.mainVO.platid==1)
					{
						msgSenderProxy.send_20021(model.buttonType,cond);
					}
					else
					{
						Alert.show(Language.GAI_PASSPORT_UNPLAT,Language.TISHI);
					}
					
				}
				else if(model.buttonType==1&&cond!="")
				{
					msgSenderProxy.send_20021(model.buttonType,cond);
				}
				else if(model.buttonType==3)
				{
					msgSenderProxy.send_20021(model.buttonType,cond);
				}
				
			}
		}
		
		protected function onClosePanel(event:MouseEvent):void
		{
			deletePass.visible=false;
		}
		
		protected function onDeletePass(event:MouseEvent):void
		{
			if(Global.mainVO.group==1)
			{
				msgSenderProxy.send_20029(model.id,model.user_level);
			}
			else
			{
				if(Global.mainVO.group<model.user_level)
				{
					msgSenderProxy.send_20029(model.id,model.user_level);
				}
				else
				{
					Alert.show(Language.PASS_NO_PERMISSON,Language.TISHI);
				}
			}
			deletePass.visible=false;
			
		}
		
		protected function onSureBtn(event:MouseEvent):void
		{
			var permiStr:String='';
			for (var i:int = 0; i < arrPerm.length; i++) 
			{
				if(arrPerm[i].combox.selectedItem.data==3)
				{
					permiStr+=String(arrPerm[i].combox.selectedItem.data);
				}
				else if(arrPerm[i].combox.selectedItem.data==2)
				{
					permiStr+=1;
				}
				else if(arrPerm[i].combox.selectedItem.data==1)
				{
					permiStr+=0;
				}
			}
			
			if(creatPasspot.passText.enabled)
			{
				if(creatPasspot.passText.text.length<6)
				{
					Alert.show(Language.ZHANGHUCHANGDUBUFUHE,Language.TISHI);
				}
				else
				{
					var passport:String=creatPasspot.passText.text;
					var psw:String=creatPasspot.pswText.text;
					var plat:int=creatPasspot.chosPlat.selectedItem.data;
					var level:int=creatPasspot.chosAcount.selectedItem.data;
					if(passport!=null&&psw!=null&&plat!=0&&level!=0)
					{
						msgSenderProxy.send_20003(passport,psw,plat,permiStr,level);
					}
					else
					{
						Alert.show(Language.INFO_UNCOMPLETE,Language.TISHI);
					}
					
				}
				
			}
			else
			{
				msgSenderProxy.send_20025(permiStr,model.id,model.user_level);
			}
			creatPasspot.visible=false;
		}
		
		protected function radioBtn(event:Event):void
		{
			var value:int=int(creatPasspot.radiogroup1.selection.value);
			for (var i:int = 0; i < arrPerm.length; i++) 
			{
				arrPerm[i].combox.selectedIndex = value-1;
			}
			
		}
		
		private function permSetItem():void
		{
			for (var i:int = 0; i < dp.length; i++) 
			{
				arr=arr.concat(dp[i].nodes);
			}
			arr.sort(compare);
			for (var j:int = 0; j < arr.length; j++) 
			{
				tempItem = new PermissionSetItem();
				tempItem.setData(arr[j]);
				creatPasspot.perBc.addElement(tempItem);
				arrPerm.push(tempItem);
			}
			
			
		}
		
		private function compare(obj1:Object,obj2:Object):int
		{
			if(obj1.data>obj2.data) return 1;
			if(obj1.data<obj2.data) return -1;
			return 0;
		}
		
		protected function onDELETE_ID(event:Event):void
		{
			if(Global.mainVO.level<=2)
			{
				deletePass.visible=true;
			}
			else
			{
				Alert.show(Language.PASS_NO_PERMISSON,Language.TISHI);
			}
		}
		
		// 密码确定键
		protected function onSure(event:MouseEvent):void
		{
			//send;
			if(Global.mainVO.level==1)
			{
				msgSenderProxy.send_20027(model.id,model.user_level,model.newPsw,model.lastPsw);
			}
			else if(Global.mainVO.level<model.user_level)
			{
				msgSenderProxy.send_20027(model.id,model.user_level,model.newPsw,model.lastPsw);
			}
			changePsw.visible=false;
		}
		
		protected function onPsdClose(event:MouseEvent):void
		{
			changePsw.visible=false;
		}
		
		protected function onCHANGE_PASSWORD(event:Event):void
		{
			if(Global.mainVO.level<=2)
			{
				changePsw.visible=true;
			}
			else
			{
				Alert.show(Language.NO_PREMISS_CHANGE_PSW,Language.TISHI);
			}
			
		}
		
		private function onCHANGE_PERMISSION(event:Event):void
		{
			if(Global.mainVO.level<=2)
			{
				creatPasspot.showID.text=Language.CHANGE_PERMISSION;
				creatPasspot.passText.enabled=false;
				creatPasspot.pswText.enabled=false;
				creatPasspot.chosPlat.enabled=false;
				creatPasspot.addPlatTxt.enabled=false;
				creatPasspot.chosAcount.enabled=false;
				creatPasspot.visible=true;
				//////
				var str:String=model.permission;
				var arr:Array=[];
				for (var i:int = 0; i < str.length; i++) 
				{
					arr.push(str.substr(i,1));
				}
				for (var j:int = 0; j < arrPerm.length; j++) 
				{
					if(int(arr[j])==0)
					{
						arrPerm[j].combox.selectedIndex=2;
					}
					else if(int(arr[j])==1)
					{
						arrPerm[j].combox.selectedIndex=1;
					}
					else if(int(arr[j])==3)
					{
						arrPerm[j].combox.selectedIndex=0;
					}
				}
				
			}
			else
			{
				Alert.show(Language.ACCOUNT_NO_PERMISSION,Language.TISHI);
			}
			
		}
		
		protected function onPassClose(event:MouseEvent):void
		{
			creatPasspot.visible=false;
		}
		
		protected function onCreatPs(event:MouseEvent):void
		{
			if(Global.mainVO.level<=2)
			{
				creatPasspot.passText.enabled=true;
				creatPasspot.pswText.enabled=true;
				creatPasspot.chosPlat.enabled=true;
				creatPasspot.addPlatTxt.enabled=true;
				creatPasspot.chosAcount.enabled=true;
				creatPasspot.visible=true;
			}
			else
			{
				Alert.show(Language.PASS_NO_PERMISSON,Language.TISHI);
			}
		}
		
		protected function onSearch(event:MouseEvent):void
		{
			clickSearch();
		}
		
		protected function onSearchWay(event:Event):void
		{
			if(mainUI.searchWay.selectedItem)
			{
				model.buttonType = mainUI.searchWay.selectedItem.data;
				if(model.buttonType==3)
				{
					mainUI.searchIuput.visible=false;
					mainUI.searchIuput.text='';
				}
				else
				{
					mainUI.searchIuput.visible=true;
				}
			}
			else
			{
				Alert.show(Language.PLEASE_CHOOSE);
			}
		}
		
		protected function get mainUI() : PassportPanel
		{
			return viewComponent as PassportPanel;
		}

		override public function onRegister() : void
		{
			return;
		}

		override public function listNotificationInterests() : Array
		{
			return [Passport_ApplicationFacade.SHOW_MAINUI,Passport_ApplicationFacade.RESP_PASSPORT,Passport_ApplicationFacade.RESP_MANAGER_PSW,
			Passport_ApplicationFacade.RESP_LOGIN,Passport_ApplicationFacade.RESP_DELETE,Passport_ApplicationFacade.RESP_CREAT_PLAT,
			Passport_ApplicationFacade.RESP_MANAGER_PERIMSS,Passport_ApplicationFacade.RESP_MODIFY_PLAT];
		}

		override public function handleNotification(param1:INotification) : void
		{
			var data:Object = param1.getBody();
			switch(param1.getName())
			{
				case Passport_ApplicationFacade.SHOW_MAINUI:
				{
					showMainUi(data);
					break;
				}
				case Passport_ApplicationFacade.RESP_PASSPORT:
				{
					handleSearchResp(data);
					break;
				}
				case Passport_ApplicationFacade.RESP_MANAGER_PSW:
				{
					checkPsw(data);
					break;
				}
				case Passport_ApplicationFacade.RESP_LOGIN:
				{
					checkLogin(data);
					break;
				}
				case Passport_ApplicationFacade.RESP_DELETE:
				{
					checkDelete(data);
					break;
				}
				case Passport_ApplicationFacade.RESP_CREAT_PLAT:
				{
					keepPlat(data);
					break;
				}
				case Passport_ApplicationFacade.RESP_MANAGER_PERIMSS:
				{
					changePermiss(data);
					break;
				}
				case Passport_ApplicationFacade.RESP_MODIFY_PLAT:
				{
					changePlat(data);
					break;
				}
				default:
				{
					break;
				}
			}
			return;
		}
		
		private function changePlat(data:Object):void
		{
			Alert.show(Language.CAOZUOCHENGGONG,Language.TISHI);
		}
		
		private function changePermiss(data:Object):void
		{
			if(data.ret!=2008)
			{
				Alert.show(Language.CHANGE_PERMISSION_SUCCESS,Language.TISHI);
			}
			else
			{
				Alert.show(Language.NO_PREMISS_OPERATION,Language.TISHI);
			}
			
		}
		
		private function keepPlat(data:Object):void
		{
			//获取平台数组
			var arr:Array=data.v_info;
			model.platObj=arr;
			var arr1:Array=[];
			for (var i:int = 0; i < arr.length; i++) 
			{
				var obj:Object=new Object();
				obj.label=arr[i].plat_name;
				obj.data=arr[i].plat_id;
				arr1.push(obj);
			}
			makePlat(arr1);
			creatPasspot.chosPlat.dataProvider=new ArrayList(model.platChossArr);
		}
		
		private function checkDelete(data:Object):void
		{
			if(data.ret==0)
			{
				Alert.show(Language.DELETE_SUCCESS,Language.TISHI);
				clickSearch();
			}
			else if(data.ret==2008)
			{
				Alert.show(Language.NO_PREMISS_OPERATION,Language.TISHI);
			}
		}
		
		private function checkLogin(data:Object):void
		{
			if(data.ret==2001)
			{
				Alert.show(Language.REG_USERNAME_NULL,Language.TISHI);
			}
			else if(data.ret==2002)
			{
				Alert.show(Language.REG_PSW_NULL,Language.TISHI);
			}
			else if(data.ret==2006)
			{
				Alert.show(Language.REG_FAULER,Language.TISHI);
			}
			else if(data.ret==2008)
			{
				Alert.show(Language.NO_PREMISS_OPERATION,Language.TISHI);
			}
			else if(data.ret==2017)
			{
				Alert.show(Language.PASSPORT_IS_REGISED,Language.TISHI);
			}
			else
			{
				Alert.show(Language.CAOZUOCHENGGONG,Language.TISHI);
				clickSearch();
			}
		}
		
		private function checkPsw(data:Object):void
		{
			if(data.ret==0)
			{
				Alert.show(Language.CAOZUOCHENGGONG,Language.TISHI);
			}
			else if(data.ret==2018)
			{
				Alert.show(Language.YUANMIMACUOWU,Language.TISHI);
			}
			else if(data.ret==2008)
			{
				Alert.show(Language.ACCOUNT_NO_PERMISSION,Language.TISHI);
			}
		}
		
		private function handleSearchResp(data:Object):void
		{
			if(data.ret==2014)
			{
				Alert.show(Language.NO_CUNZAI,Language.TISHI);
			}
			else if(data.ret==2015)
			{
				Alert.show(Language.NO_CUNZAI,Language.TISHI);
			}
			else if(data.ret==2038)
			{
				Alert.show(Language.MANAGER_NO_EXIST,Language.TISHI);
			}
			else
			{
				var platArr:Array=model.platObj;
				var arr1:Array=data.v_manager;
				var arr:Array=[];
				for (var b:int = 0; b < arr1.length; b++) 
				{
					for (var c:int = 0; c < platArr.length; c++) 
					{
						if(arr1[b].platid==platArr[c].data)
						{
							arr.push(arr1[b]);
						}
					}
					
				}
				for (var i:int = 0; i < arr.length; i++) 
				{
					if(arr[i].level==1)
					{
						arr[i].account_level=Language.ZONG_ADMIN;
					}  
					else if(arr[i].level==2)
					{
						arr[i].account_level=Language.ONE_LEVEL_ADMIN;
					}
					else if(arr[i].level==3)
					{
						arr[i].account_level=Language.TWO_LEVEL_ADMIN;
					}
					else if(arr[i].level==4)
					{
						arr[i].account_level=Language.THREE_LEVEL_ADMIN;
					}
				}
				//平台汉化处理
//				var platArr:Array=Global.mainVO.plantObj;
				for (var k:int = 0; k < arr.length; k++) 
				{
					for (var a:int = 0; a < platArr.length; a++) 
					{
						if(arr[k].platid==platArr[a].data)
						{
							arr[k].platName=platArr[a].label;
						}
					}
					
				}
				//
				var otherArr:Array=[];
				if(Global.mainVO.platid==1)//---------关于平台
				{
					mainUI.dg.dataProvider = new ArrayList(arr);
				}
				else
				{
					for (var j:int = 0; j < arr.length; j++) 
					{
						if(arr[j].platid==Global.mainVO.platid)
						{
							otherArr.push(arr[j]);
						}
					}
					mainUI.dg.dataProvider = new ArrayList(otherArr);
				}
				
			}
		}
		
		private function makePlat(arr:Array):void
		{
			model.platChossArr=arr;
			model.platObj=arr;
		}
		
		private function get msgSenderProxy() : Passport_MsgSendProxy
		{
			if (this._msgSenderProxy == null)
			{
				this._msgSenderProxy = facade.retrieveProxy(Passport_MsgSendProxy.NAME) as Passport_MsgSendProxy;
			}
			return this._msgSenderProxy;
		}
		
		private function showMainUi(data:Object):void
		{
			ResizeManager.registerResize(mainUI);
			PipeManager.sendMsg(PipeEvent.ADD_CHILD_TO_MAINUI, mainUI);
			clickSearch();
			makePlat(Global.mainVO.platChosArr);
//			mainUI.dg.dataProvider = new ArrayList([{passport:11, platid:4399,  level:1}]);
		}
		

	}
}