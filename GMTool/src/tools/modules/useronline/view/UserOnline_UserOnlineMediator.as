package tools.modules.useronline.view
{
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayList;
	import mx.controls.Alert;
	import mx.events.FlexEvent;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import tools.events.PipeEvent;
	import tools.managers.PipeManager;
	import tools.managers.ResizeManager;
	import tools.modules.useronline.UserOnline_ApplicationFacade;
	import tools.modules.useronline.model.UserOnlineModel;
	import tools.modules.useronline.model.UserOnline_MsgSendProxy;
	import tools.modules.useronline.view.components.UserOnlinePanel;

	public class UserOnline_UserOnlineMediator extends Mediator
	{

		private var _msgSenderProxy:UserOnline_MsgSendProxy;
		private var model:UserOnlineModel=UserOnlineModel.getInstance();
		public static const NAME:String = "UserOnline_UserOnlineMediator";
		private var linenumber:int=0;
		private var allPage:int=1;
		public var nowPage:int=1;

		public function UserOnline_UserOnlineMediator(viewComponent:Object)
		{
			super(NAME, viewComponent);
			mainUI.addEventListener(FlexEvent.CREATION_COMPLETE, initUI);
		}
		
		protected function initUI(event:FlexEvent):void
		{
			mainUI.nextBtn.addEventListener(MouseEvent.CLICK, nextPage);
			mainUI.preBtn.addEventListener(MouseEvent.CLICK, prePage);
			mainUI.go.addEventListener(MouseEvent.CLICK, goToPage);
			mainUI.refresh.addEventListener(MouseEvent.CLICK,onRefresh);
			mainUI.refresh1.addEventListener(MouseEvent.CLICK,onRefresh1);
		}
		
		protected function onRefresh1(event:MouseEvent):void
		{
			msgSenderProxy.send_20061();
		}
		
		/**查询*/
		protected function onRefresh(event:MouseEvent):void
		{
			var serverId:int=Global.mainVO.serverId,platId:int=Global.mainVO.adminPlatId;
			var date:Date = new Date();
			var bTimeDay:Number = mainUI.btime.selectedDate.getTime()*0.001;
			var eTimeDay:Number = mainUI.etime.selectedDate.getTime()*0.001;
			var bTime:Number=int(mainUI.bHours.text)*3600+int(mainUI.bMinute.text)*60+int(mainUI.bSeconds.text);
			var eTime:Number=int(mainUI.eHours.text)*3600+int(mainUI.eMinute.text)*60+int(mainUI.eSeconds.text);
			if(bTime<86400||eTime<86400)
			{
				msgSenderProxy.send_20096(platId,serverId,bTime+bTimeDay,eTime+eTimeDay);
			}
			else
			{
				Alert.show(Language.CHECK_TIME_OVER_RANGE,Language.TISHI);
			}
			
		}
		
		/**跳转*/
		protected function goToPage(event:MouseEvent):void
		{
			var number:int=int(mainUI.pageNum.text);
			nowPage=number;
			if(number>allPage||number<=0)
			{
				nowPage=allPage;
			}
			showPageData(nowPage);
		}
		
		/**上一页*/
		protected function prePage(event:MouseEvent):void
		{
			if(nowPage>1)
			{
				nowPage--;
			}
			else
			{
				nowPage=1;
			}
			showPageData(nowPage);
		}
		
		/**下一页*/
		protected function nextPage(event:MouseEvent):void
		{
			if(nowPage<allPage)
			{
				nowPage++;
			}
			else
			{
				nowPage=allPage;
			}
			showPageData(nowPage);
		}
		
		/**将数据处理显示在datagrid中*/
		private function showPageData(page:int):void
		{
			var arr:Array=[];
			mainUI.labelNum.text=nowPage+"/"+allPage;
			if(page==1)
			{
				arr=model.onlineData.slice((page-1)*linenumber,page*linenumber+1);
			}
			else
			{
				arr=model.onlineData.slice(page*linenumber,model.onlineData.length+1);
			}
			mainUI.dg.dataProvider=new ArrayList(arr);
		}		
		
		
		protected function get mainUI() : UserOnlinePanel
		{
			return viewComponent as UserOnlinePanel;
		}

		override public function onRegister() : void
		{
			return;
		}

		override public function listNotificationInterests() : Array
		{
			return [UserOnline_ApplicationFacade.SHOW_MAINUI,UserOnline_ApplicationFacade.SHOW_ONLINE_NUM,UserOnline_ApplicationFacade.SHOW_ONLINE_ALL_NUM];
		}

		override public function handleNotification(param1:INotification) : void
		{
			var data:Object = param1.getBody();
			switch(param1.getName())
			{
				case UserOnline_ApplicationFacade.SHOW_MAINUI:
				{
					showMain(data);
					break;
				}
				case UserOnline_ApplicationFacade.SHOW_ONLINE_NUM:
				{
					respOnlineNum(data);
					break;
				}
				case UserOnline_ApplicationFacade.SHOW_ONLINE_ALL_NUM:
				{
					respOnlineAllNum(data);
					break;
				}
				default:
				{
					break;
				}
			}
			return;
		}
		
		private function respOnlineAllNum(data:Object):void
		{
			var arr:Array=data.v_info;
			for (var i:int = 0; i < arr.length; i++) 
			{
				arr[i].time=(arr[i].time%86400)/3600;
			}
			mainUI.playerOnline.dataProvider=new ArrayList(arr);
		}
		
		private function respOnlineNum(data:Object):void
		{
			var arr:Array=data.v_info;
			model.onlineData=arr;
			linenumber=mainUI.dg.height / mainUI.dg.rowHeight;
			if(arr.length%linenumber==0)
			{
				allPage=arr.length/linenumber;
			}
			else
			{
				allPage=arr.length/linenumber+1;
			}
			mainUI.onlineNum.text=String(arr.length);
			showPageData(nowPage);
		}
		
		private function get msgSenderProxy() : UserOnline_MsgSendProxy
		{
			if (this._msgSenderProxy == null)
			{
				this._msgSenderProxy = facade.retrieveProxy(UserOnline_MsgSendProxy.NAME) as UserOnline_MsgSendProxy;
			}
			return this._msgSenderProxy; 
		}
		
		private function showMain(data:Object):void
		{
			ResizeManager.registerResize(mainUI);
			PipeManager.sendMsg(PipeEvent.ADD_CHILD_TO_MAINUI, mainUI);
			msgSenderProxy.send_20061();
		}
	}
}