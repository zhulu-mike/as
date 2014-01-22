package tools.modules.checkcard.view
{
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayList;
	import mx.controls.Alert;
	import mx.events.FlexEvent;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import tools.common.vo.EquipBase;
	import tools.common.vo.ToolBase;
	import tools.events.PipeEvent;
	import tools.managers.EquipManager;
	import tools.managers.PipeManager;
	import tools.managers.ResizeManager;
	import tools.managers.ToolManager;
	import tools.modules.checkcard.CheckCardType_ApplicationFacade;
	import tools.modules.checkcard.model.CheckCardModel;
	import tools.modules.checkcard.model.CheckCardType_MsgSendProxy;
	import tools.modules.checkcard.view.components.AddCardType;
	import tools.modules.checkcard.view.components.CheckCardType;

	public class CheckCardType_CheckCardTypeMediator extends Mediator
	{

		private var _msgSenderProxy:CheckCardType_MsgSendProxy;
		public static const NAME:String = "CheckCardType_CheckCardTypeMediator";
		private var model:CheckCardModel=CheckCardModel.getInstance();
		private var addCardType:AddCardType;

		public function CheckCardType_CheckCardTypeMediator(viewComponent:Object)
		{
			super(NAME, viewComponent);
			mainUI.addEventListener(FlexEvent.CREATION_COMPLETE, initUI);
		}
		
		protected function initUI(event:FlexEvent):void
		{
			//添加一种新手卡
			addCardType=new AddCardType();
			addCardType.x=mainUI.width/2-addCardType.width/2;
			addCardType.y=mainUI.height/2-addCardType.height/2;
			mainUI.addElement(addCardType);
			addCardType.visible=false;
			//按钮
			mainUI.addPlayerCard.addEventListener(MouseEvent.CLICK,onAddCardBtn);
			addCardType.onCloseBtn.addEventListener(MouseEvent.CLICK,onCloseAddPanel);
			addCardType.onAddEquip.addEventListener(MouseEvent.CLICK,onAddEquipBtn);
			addCardType.onAddProp.addEventListener(MouseEvent.CLICK,onAddPropBtn);
			addCardType.onSureBtn.addEventListener(MouseEvent.CLICK,onSureListBtn);
		}
		
		/**
		 * 制作新手卡类型 
		 * @param event
		 */
		protected function onSureListBtn(event:MouseEvent):void
		{
			var str:String='',str1:String='',str2:String='',str3:String='';   //str,2为数字 ，str1,3为文字
			for (var i:int = 0; i < model.arrProp.length; i++) 
			{
				str+=model.arrProp[i].id+","+model.arrProp[i].proNum+";";
			}
			for (var j:int = 0; j < model.arrEqup.length; j++) 
			{
				str2+=model.arrEqup[j].id+","+model.arrEqup[j].equiNum+";";
			}
			
			var obj:Object=new Object();
			obj.icon=0;
			obj.gold=int(addCardType.tongMonInput.text);
			obj.money=int(addCardType.yuanbaoInput.text);
			obj.aura=0,obj.exp=0;
			obj.ptg=0,obj.md=0;
			obj.ttw=0,obj.time=0;
			obj.cream=0,obj.immdew=0;
			obj.souldew=0,obj.immsand=0;
			obj.starshards=0,obj.name='';
			obj.item=str1+str2;
			obj.equ='';
			var cardNum:int=int(addCardType.cardNumber.text);//新手卡位数
			var cardName:String=addCardType.cardName.text;//新手卡名称
			if(addCardType.etime.selectedDate&&addCardType.btime.selectedDate)
			{
				var etime:Number=addCardType.etime.selectedDate.getTime()*0.001;//新手卡开始时间
				var btime:Number=addCardType.btime.selectedDate.getTime()*0.001;//新手卡无效时间
			}
			else
			{
				Alert.show(Language.PLEASE_CHOOSE_TIME,Language.TISHI);
				return 
			}
			var serverLimited:String=addCardType.severLimit.text;//服务器限制
			if(cardName!=""&&cardNum!=0&&etime!=0&&btime!=0)
			{
				msgSenderProxy.send_20053(cardName,cardNum,0,obj,serverLimited,btime,etime);
			}
			else
			{
				Alert.show(Language.PLEASE_WRITE_WHOLE_INFO,Language.TISHI);
			}
			
		}
		
		/**制作清单面板道具添加*/
		protected function onAddPropBtn(event:MouseEvent):void
		{
			var item:*=(addCardType.sysPropList.selectedItem);
			if(item!=null&&model.arrProp.indexOf(item)==-1)
			{
				model.arrProp.push(item);
				addCardType.addPropList.dataProvider=new ArrayList(model.arrProp);
			}
		}
		
		/**制作清单面板装备添加*/
		protected function onAddEquipBtn(event:MouseEvent):void
		{
			var item:*=(addCardType.sysEquipList.selectedItem);
			if(item!=null&&model.arrEqup.indexOf(item)==-1)
			{
				model.arrEqup.push(item);
				addCardType.addEquipList.dataProvider=new ArrayList(model.arrEqup);
			}
		}
		
		/**关闭面板*/
		protected function onCloseAddPanel(event:MouseEvent):void
		{
			model.arrProp=[];
			model.arrEqup=[];
			addCardType.visible=false;
		}
		
		/**制作清单面板打开，并且获得数据*/
		protected function onAddCardBtn(event:MouseEvent):void
		{
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
			addCardType.sysPropList.dataProvider=new ArrayList(toolarr);
			addCardType.sysEquipList.dataProvider=new ArrayList(dealEquip);
			addCardType.visible=true;
		}
		
		protected function get mainUI() : CheckCardType
		{
			return viewComponent as CheckCardType;
		}

		override public function onRegister() : void
		{
			return;
		}

		override public function listNotificationInterests() : Array
		{
			return [CheckCardType_ApplicationFacade.SHOW_MAINUI,CheckCardType_ApplicationFacade.MAKE_NEWCARD_TYPE,CheckCardType_ApplicationFacade.CHECK_NEWCARD_TYPE];
		}

		override public function handleNotification(param1:INotification) : void
		{
			var data:Object = param1.getBody();
			switch(param1.getName())
			{
				case CheckCardType_ApplicationFacade.SHOW_MAINUI:
				{
					showMainUi(data);
					break;
				}
				case CheckCardType_ApplicationFacade.MAKE_NEWCARD_TYPE:
				{
					makeNewCardType(data);
					break;
				}
				case CheckCardType_ApplicationFacade.CHECK_NEWCARD_TYPE:
				{
					checkNewCardType(data);
					break;
				}
				default:
				{
					break;
				}
			}
			return;
		}
		
		private function checkNewCardType(data:Object):void
		{
			//查看新手卡类型返回
			var arr:Array=data.v_info;
			var equipBase:EquipBase;
			var toolBase:ToolBase;
			var str:String='';
			for (var i:int = 0; i < arr.length; i++) 
			{
				var date:Date=new Date(arr[i].begin_time*1000);
				var btime:String=date.getFullYear()+"-"+(date.getMonth()+1)+"-"+date.getDate()+" "+date.toTimeString();
				date=new Date(arr[i].expiration_time*1000);
				var etime:String=date.getFullYear()+"-"+(date.getMonth()+1)+"-"+date.getDate()+" "+date.toTimeString();
				arr[i].userTime=btime+Language.TO+etime;
				if(arr[i].state==0)
				{
					arr[i].state=Language.ACTIVATION;
				}
				else
				{
					arr[i].state=Language.UNACTIVATION;
				}
				if(arr[i].range==0)
				{
					arr[i].range=Language.ALL_SERVER;
				}
				var obj:Object=arr[i].req;
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
				arr[i].list=Language.YUANBAO+"："+obj.money+Language.TONG_MONEY+"："+obj.gold+" "+str;
			}
			mainUI.dt.dataProvider=new ArrayList(arr);
			
		}
		
		private function makeNewCardType(data:Object):void
		{
			//制作新手卡类型返回
			if(data.ret==2029)
			{
				Alert.show(Language.NEW_CARD_TYPE_ALLIVE,Language.TISHI);
			}
			addCardType.visible=false;
			model.arrProp=[];
			model.arrEqup=[];
			msgSenderProxy.send_20055();
		}
		
		private function get msgSenderProxy() : CheckCardType_MsgSendProxy
		{
			if (this._msgSenderProxy == null)
			{
				this._msgSenderProxy = facade.retrieveProxy(CheckCardType_MsgSendProxy.NAME) as CheckCardType_MsgSendProxy;
			}
			return this._msgSenderProxy;
		}
		
		private function showMainUi(data:Object):void
		{
			ResizeManager.registerResize(mainUI);
			PipeManager.sendMsg(PipeEvent.ADD_CHILD_TO_MAINUI, mainUI);
			msgSenderProxy.send_20055();
		}
	}
}