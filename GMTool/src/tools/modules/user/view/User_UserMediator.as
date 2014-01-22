package tools.modules.user.view
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.collections.Sort;
	import mx.collections.SortField;
	import mx.events.FlexEvent;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import tools.events.PipeEvent;
	import tools.managers.PipeManager;
	import tools.managers.ResizeManager;
	import tools.modules.user.User_ApplicationFacade;
	import tools.modules.user.model.UserModel;
	import tools.modules.user.model.User_MsgSendProxy;
	import tools.modules.user.view.components.RegisterUserPanel;

	public class User_UserMediator extends Mediator
	{

		private var _msgSenderProxy:User_MsgSendProxy;
		public static const NAME:String = "User_UserMediator";
		private var model:UserModel=UserModel.getInstance();
		public var nowPage:int=1;

		public function User_UserMediator(viewComponent:Object)
		{
			super(NAME, viewComponent);
			mainUI.addEventListener(FlexEvent.CREATION_COMPLETE, initUI);
		}
		
		private function initUI(e:FlexEvent):void
		{
			mainUI.radiogroup1.addEventListener(Event.CHANGE,onTabIndexChange);
			mainUI.searchBtn.addEventListener(MouseEvent.CLICK, searchUser);
			mainUI.nextBtn.addEventListener(MouseEvent.CLICK, nextPage);
			mainUI.preBtn.addEventListener(MouseEvent.CLICK, prePage);
			mainUI.go.addEventListener(MouseEvent.CLICK, goToPage);
			searchBtn();
		}
		
		private function searchBtn():void
		{
			var value:int=0;
			if(mainUI.radiogroup1.selection!=null)
			{
				value= int(mainUI.radiogroup1.selection.value);
			}
			var btime:Number = 0, date:Date, etime:Number;
			switch (value)
			{
				case 0://今天
					date = new Date();
					btime = date.getTime()-date.getHours()*3600*1000-date.getSeconds()*60*1000;//今天0点时间
					etime = btime + 86400*1000;//今天24点时间
					btime = btime*0.001;
					etime = etime*0.001;
					break;
				case 1://昨天
					date = new Date;
					btime = date.getTime()-date.getHours()*3600*1000-date.getSeconds()*60*1000-86400*1000;//昨天0点时间
					etime = btime + 86400*1000;//昨天24点时间
					btime = btime*0.001;
					etime = etime*0.001;
					break;
				case 2://本周第一天0点时间
					date = new Date;
					btime = date.getTime()-(date.getDay()-1)*86400*1000-date.getHours()*3600*1000-date.getSeconds()*60*1000;//本周0点时间
					etime = btime + 86400*1000*7;//本周最后一天24点时间
					btime = btime*0.001;
					etime = etime*0.001;
					break;
				case 3://本月
					date = new Date;
					btime = date.setFullYear(date.getFullYear(),date.getMonth(),1)*0.001;//当月开始时间
					date = new Date;
					etime =date.getTime()*0.001;//当前时间
					break;
				case 4://全部
					btime = 0;
					etime = 0;
					break;
				case 5://选择时间
					date = new Date;
					if(mainUI.btime.selectedDate!=null)
					{
						btime=mainUI.btime.selectedDate.getTime()*0.001;
						etime=mainUI.etime.selectedDate.getTime()*0.001;
					}
					break;
			}
			var linenumber:int=mainUI.dg.height / mainUI.dg.rowHeight;
			if(value==5&&btime!=0&&etime!=0)
			{
				msgSenderProxy.send_20005(btime,etime,nowPage,linenumber);
			}
			else if(value!=5)
			{
				msgSenderProxy.send_20005(btime,etime,nowPage,linenumber);
			}
			
		}
		
		protected function goToPage(event:MouseEvent):void
		{
			var number:int=int(mainUI.pageNum.text);
			nowPage=number;
			if(number>model.maxPage||number<=0)
			{
				nowPage=model.maxPage;
			}
			searchBtn();
		}
		
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
			searchBtn();
		}
		
		protected function nextPage(event:MouseEvent):void
		{
			if(nowPage<model.maxPage)
			{
				nowPage++;
			}
			else
			{
				nowPage=model.maxPage;
			}
			searchBtn();
		}
		
		/**
		 * 选择时间然后查询 
		 * @param event
		 */
		private function searchUser(event:MouseEvent):void
		{
			searchBtn();
		}
		
		/**
		 * 点击其他时，时间的选择 
		 * @param event
		 */
		protected function onTabIndexChange(event:Event):void
		{
			if(mainUI.radiogroup1.selection.value == 5)
			{
				mainUI.otherTime.visible = true;
			}
			else
			{
				mainUI.otherTime.visible = false;
			}
		}
		
		protected function get mainUI() : RegisterUserPanel
		{
			return viewComponent as RegisterUserPanel;
		}

		override public function onRegister() : void
		{
			return;
		}

		override public function listNotificationInterests() : Array
		{
			return [User_ApplicationFacade.SHOW_MAINUI,User_ApplicationFacade.RESEARCH];
		}

		override public function handleNotification(param1:INotification) : void
		{
			var data:Object = param1.getBody();
			switch(param1.getName())
			{
				case User_ApplicationFacade.SHOW_MAINUI:
				{
					showMain(data);
					break;
				}
				case User_ApplicationFacade.RESEARCH:
				{
					handleSearchResp(data);
					break;
				}
				default:
				{
					break;
				}
			}
			return;
		}
		
		private function handleSearchResp(data:Object):void
		{
			var arr:Array=data.v_user;
			var dataArr:ArrayCollection=new ArrayCollection(arr);
			dataArr.sort=new Sort();
			dataArr.sort.fields=[new SortField("id",false,true)];
			dataArr.refresh();
			mainUI.dg.dataProvider =dataArr;
			mainUI.labelNum.text=nowPage+"/"+data.max_page;
			model.maxPage=data.max_page;
			mainUI.allCount.text=String(data.num);////????
		}
		
		private function get msgSenderProxy() : User_MsgSendProxy
		{
			if (this._msgSenderProxy == null)
			{
				this._msgSenderProxy = facade.retrieveProxy(User_MsgSendProxy.NAME) as User_MsgSendProxy;
			}
			return this._msgSenderProxy;
		}
		
		private function showMain(data:Object):void
		{
			model.data = data.data;
			ResizeManager.registerResize(mainUI);
			PipeManager.sendMsg(PipeEvent.ADD_CHILD_TO_MAINUI, mainUI);
		}
	}
}