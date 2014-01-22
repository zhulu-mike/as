package tools.modules.newplayercard.view
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayList;
	import mx.controls.Alert;
	import mx.events.FlexEvent;
	import mx.modules.ModuleManager;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import spark.events.IndexChangeEvent;
	import spark.events.TextOperationEvent;
	
	import tools.events.PipeEvent;
	import tools.managers.PipeManager;
	import tools.managers.ResizeManager;
	import tools.modules.checkcard.view.components.AddCardType;
	import tools.modules.checkcard.view.components.CheckCardType;
	import tools.modules.newplayercard.PlayerCard_ApplicationFacade;
	import tools.modules.newplayercard.model.PlayerCardModel;
	import tools.modules.newplayercard.model.PlayerCard_MsgSendProxy;
	import tools.modules.newplayercard.view.components.MakeCardPanel;
	import tools.modules.newplayercard.view.components.PlayerCardPanel;

	public class PlayerCard_PlayerCardMediator extends Mediator
	{

		private var _msgSenderProxy:PlayerCard_MsgSendProxy;
		public static const NAME:String = "PlayerCard_PlayerCardMediator";
		private var model:PlayerCardModel=PlayerCardModel.getInstance();
		
		private var makeCardPanel:MakeCardPanel;//制作新手卡界面

		private var id:int=0;//制作新手卡数量ID
		private var checkId:int=0;//查询ID；
		private var type:int=0;//查询类型;
		private var page:int=1;//页数
		private var jihuoNum:String='';//激活码

		public function PlayerCard_PlayerCardMediator(viewComponent:Object)
		{
			super(NAME, viewComponent);
			mainUI.addEventListener(FlexEvent.CREATION_COMPLETE, initUI);
		}
		
		protected function initUI(event:FlexEvent):void
		{
			//面板
			//制作新手卡面板
			makeCardPanel=new MakeCardPanel();
			makeCardPanel.x=mainUI.width/2-makeCardPanel.width/2;
			makeCardPanel.y=mainUI.height/2-makeCardPanel.height/2;
			mainUI.addElement(makeCardPanel);
			makeCardPanel.visible=false;
			//按钮
			mainUI.makeCardBtn.addEventListener(MouseEvent.CLICK,onMakeCard);
			makeCardPanel.closeBtn.addEventListener(MouseEvent.CLICK,onCloseMakeCard);
			mainUI.checkCardBtn.addEventListener(MouseEvent.CLICK,onCheckCardBtn);
			makeCardPanel.chosCardType.addEventListener(Event.CHANGE,onChoseCardType);
			makeCardPanel.onSuerMakeBtn.addEventListener(MouseEvent.CLICK,onSureBtn);
			mainUI.onChoseTypeBtn.addEventListener(Event.CHANGE,onChoseTypeBtn);
			mainUI.checkAll.addEventListener(MouseEvent.CLICK,onCheckAll);
			mainUI.prePage.addEventListener(MouseEvent.CLICK,prePage);
			mainUI.goToPage.addEventListener(MouseEvent.CLICK,goToPage);
			mainUI.nextPage.addEventListener(MouseEvent.CLICK,nextPage);
			mainUI.onCheckNum.addEventListener(MouseEvent.CLICK,onCheckNum);
			mainUI.checkNum.addEventListener(Event.CHANGE,listenCheckNum);
			
		}
		
		/**获取激活码*/
		protected function listenCheckNum(event:TextOperationEvent):void
		{
			jihuoNum=mainUI.checkNum.text;
		}
		
		/**根据激活码查询*/
		protected function onCheckNum(event:MouseEvent):void
		{
			var linenumber:int=mainUI.dg.height / mainUI.dg.rowHeight;
			msgSenderProxy.send_20057(1,jihuoNum,0,page,linenumber);
		}
		
		protected function onCheckAll(event:MouseEvent):void
		{
			checkAll();
		}
		
		/**跳转按钮*/
		protected function goToPage(event:MouseEvent):void
		{
			var number:int=int(mainUI.pageNum.text);
			page=number;
			if(number>model.maxPage||number<=0)
			{
				page=model.maxPage;
			}
			checkAll();
		}
		
		/**上一页*/
		protected function prePage(event:MouseEvent):void
		{
			if(page>1)
			{
				page--;
			}
			else
			{
				page=1;
			}
			checkAll();
		}
		
		/**下一页*/
		protected function nextPage(event:MouseEvent):void
		{
			if(page<model.maxPage)
			{
				page++;
			}
			else
			{
				page=model.maxPage;
			}
			checkAll();
		}
		
		/**查询所有*/
		private function checkAll():void
		{
			var linenumber:int=mainUI.dg.height / mainUI.dg.rowHeight;
			msgSenderProxy.send_20057(type,'',checkId,page,linenumber);
			
		}
		
		/**选择查询类型*/
		protected function onChoseTypeBtn(event:IndexChangeEvent):void
		{
			checkId=mainUI.onChoseTypeBtn.selectedItem.data;
			if(checkId==0)
			{
				type=3;
			}
			else
			{
				type=2;
			}
		}
		
		/**确定发送协议*/
		protected function onSureBtn(event:MouseEvent):void
		{
			var num:int=int(makeCardPanel.makeNum.text);
			if(num!=0)
			{
				msgSenderProxy.send_20051(id,num);
			}
			else
			{
				Alert.show(Language.PLEASE_WRITE_NUM,Language.TISHI);
			}
			
		}
		
		protected function onChoseCardType(event:IndexChangeEvent):void
		{
			id=makeCardPanel.chosCardType.selectedItem.data;
		}
		
		protected function onCheckCardBtn(event:MouseEvent):void
		{
			PipeManager.sendMsg(PipeEvent.SHOW_CHECK_CARD_MIANUI);
		}
		
		protected function onCloseMakeCard(event:MouseEvent):void
		{
			makeCardPanel.visible=false;
		}
		
		protected function onMakeCard(event:MouseEvent):void
		{
			makeCardPanel.visible=true;
		}
		
		protected function get mainUI() : PlayerCardPanel
		{
			return viewComponent as PlayerCardPanel;
		}

		override public function onRegister() : void
		{
			return;
		}

		override public function listNotificationInterests() : Array
		{
			return [PlayerCard_ApplicationFacade.SHOW_MAINUI,PlayerCard_ApplicationFacade.CHECK_NEWCARD_TYPE,PlayerCard_ApplicationFacade.MAKE_CARD_NUM,
			PlayerCard_ApplicationFacade.RESP_CHECK_INFO];
		}

		override public function handleNotification(param1:INotification) : void
		{
			var data:Object = param1.getBody();
			switch(param1.getName())
			{
				case PlayerCard_ApplicationFacade.SHOW_MAINUI:
				{
					showMainUi(data);
					break;
				}
				case PlayerCard_ApplicationFacade.CHECK_NEWCARD_TYPE:
				{
					respNewCardType(data);
					break;
				}
				case PlayerCard_ApplicationFacade.MAKE_CARD_NUM:
				{
					respMakeCardNum(data);
					break;
				}
				case PlayerCard_ApplicationFacade.RESP_CHECK_INFO:
				{
					respCheckInfo(data);
					break;
				}
				default:
				{
					break;
				}
			}
			return;
		}
		
		private function respCheckInfo(data:Object):void
		{
			if(data.ret==2028)
			{
				Alert.show(Language.CARD_NO_CUNZAI,Language.TISHI);
				return;
			}
			model.maxPage=data.max_page;
			mainUI.allNum.text=data.num;
			var allArr:Array=model.allCardType;
			var arr:Array=data.v_info;
			var number:int=0;
			for (var i:int = 0; i < arr.length; i++) 
			{
				var date:Date=new Date(arr[i].begin_time*1000);
				var btime:String=date.getFullYear()+"-"+(date.getMonth()+1)+"-"+date.getDate()+" "+date.toLocaleTimeString();
				date=new Date(arr[i].experiation_time*1000);
				var etime:String=date.getFullYear()+"-"+(date.getMonth()+1)+"-"+date.getDate()+" "+date.toLocaleTimeString();
				arr[i].userTime=btime+Language.TO+etime;
				date=new Date(arr[i].create_time*1000);
				arr[i].makeTime=date.getFullYear()+"-"+(date.getMonth()+1)+"-"+date.getDate()+" "+date.toLocaleTimeString();
				if(arr[i].state==0)
				{
					arr[i].jihuo=Language.ACTIVATION;
				}
				else
				{
					arr[i].jihuo=Language.UNACTIVATION;
				}
				for (var j:int = 0; j < allArr.length; j++) 
				{
					if(arr[i].type_id==allArr[j].data)
					{
						arr[i].type_id=allArr[j].label;
					}
				}
				if(arr[i].range==0)
				{
					arr[i].range=Language.ALL_SERVER;
				}
				
			}
			mainUI.dg.dataProvider=new ArrayList(arr);
			mainUI.lblNum.text=page+"/"+data.max_page;
		}
		
		private function respMakeCardNum(data:Object):void
		{
			Alert.show(Language.MAKE_SUCCESS,Language.TISHI);
		}
		
		private function respNewCardType(data:Object):void
		{
			var arr:Array=data.v_info;
			if(arr.length!=model.keepArr.length)
			{
				model.keepArr=arr;
				for (var i:int = 0; i < arr.length; i++) 
				{
					var obj:Object=new Object();
					obj.label=arr[i].name;
					obj.data=arr[i].id;
					model.cardType.push(obj);
				}
				for (var j:int = 0; j < arr.length; j++) 
				{
					var obj1:Object=new Object();
					obj1.label=arr[j].name;
					obj1.data=arr[j].id;
					model.allCardType.push(obj1);
				}
				model.allCardType.splice(0,0,{label:Language.ALL,data:0});
			}
			
		}
		
		private function get msgSenderProxy() : PlayerCard_MsgSendProxy
		{
			if (this._msgSenderProxy == null)
			{
				this._msgSenderProxy = facade.retrieveProxy(PlayerCard_MsgSendProxy.NAME) as PlayerCard_MsgSendProxy;
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