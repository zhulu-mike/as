package tools.modules.charge.view
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.collections.ArrayList;
	import mx.collections.Sort;
	import mx.controls.Alert;
	import mx.events.FlexEvent;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import spark.collections.SortField;
	
	import tools.events.PipeEvent;
	import tools.managers.PipeManager;
	import tools.managers.ResizeManager;
	import tools.modules.charge.Charge_ApplicationFacade;
	import tools.modules.charge.model.ChargeModel;
	import tools.modules.charge.model.Charge_MsgSendProxy;
	import tools.modules.charge.view.components.ChargePanel;

	public class Charge_ChargeMediator extends Mediator
	{

		private var _msgSenderProxy:Charge_MsgSendProxy;
		public static const NAME:String = "Charge_ChargeMediator";
		private var model:ChargeModel = ChargeModel.getInstance();
		public var nowPage:int=1;

		public function Charge_ChargeMediator(viewComponent:Object)
		{
			super(NAME, viewComponent);
			mainUI.addEventListener(FlexEvent.CREATION_COMPLETE, initUI);
		}
		
		private function initUI(e:FlexEvent):void
		{
			mainUI.radiogroup1.addEventListener(Event.CHANGE, onTabIndexChange);
			mainUI.radiogroup2.addEventListener(Event.CHANGE, onTabIndexChange2);
			
			mainUI.searchBtn.addEventListener(MouseEvent.CLICK, searchUser);
			mainUI.nextBtn.addEventListener(MouseEvent.CLICK, nextPage);
			mainUI.preBtn.addEventListener(MouseEvent.CLICK, prePage);
			mainUI.go.addEventListener(MouseEvent.CLICK, goToPage);
			searchBtn();
		}
		
		/**根据条件进行搜素*/
		private function searchBtn():void
		{
			var value:int=0;
			var strData:String=mainUI.userName.text;
			if(mainUI.radiogroup2.selection!=null)
			{
				value= int(mainUI.radiogroup2.selection.value);
			}
			var choseWay:int=0;
			if(mainUI.radiogroup1.selection!=null)
			{
				if(mainUI.radiogroup1.selection.value==0)
				{
					choseWay=3;
				}
				else
				{
					choseWay= int(mainUI.radiogroup1.selection.value);
				}
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
					btime=mainUI.btime.selectedDate.getTime()*0.001;
					etime=mainUI.etime.selectedDate.getTime()*0.001;
					break;
			}
			var linenumber:int=mainUI.dg.height / mainUI.dg.rowHeight;
			msgSenderProxy.send_20063(choseWay,strData,btime,etime,linenumber,nowPage);
		}
		
		/**跳转按钮*/
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
			searchBtn();
		}
		
		/**下一页*/
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

		protected function get mainUI() : ChargePanel
		{
			return viewComponent as ChargePanel;
		}

		override public function onRegister() : void
		{
			return;
		}

		override public function listNotificationInterests() : Array
		{
			return [Charge_ApplicationFacade.SHOW_MAINUI,Charge_ApplicationFacade.RESP_CHARGE_NUMBER];
		}

		override public function handleNotification(param1:INotification) : void
		{
			var data:Object = param1.getBody();
			switch(param1.getName())
			{
				case Charge_ApplicationFacade.SHOW_MAINUI:
				{
					showMain(data);
					break;
				}
				case Charge_ApplicationFacade.RESP_CHARGE_NUMBER:
				{
					respChargeNum(data);
					break;
				}
				default:
				{
					break;
				}
			}
			return;
		}
		
		private function respChargeNum(data:Object):void
		{
			if(data.ret==2039)
			{
				Alert.show(Language.NO_CHARGE_LIST,Language.TISHI);
				return;
			}
			var arr:Array=data.v_info;
			for (var i:int = 0; i < arr.length; i++) 
			{
				var date:Date=new Date(arr[i].time*1000);
				var ctime:String=date.getFullYear()+"-"+(date.getMonth()+1)+"-"+date.getDate()+" "+date.toLocaleTimeString();
				arr[i].ctime=ctime;
			}
			var dataArr:ArrayCollection=new ArrayCollection(arr);
			dataArr.sort=new Sort();
			dataArr.sort.fields=[new SortField("recharge_num",false,true)];
			dataArr.refresh();
			mainUI.dg.dataProvider =dataArr;
			mainUI.allCharge.text=data.total_num;
			model.maxPage=data.page_num;
			mainUI.allCount.text=String(data.total_record);
			
		}
		
		private function get msgSenderProxy() : Charge_MsgSendProxy
		{
			if (this._msgSenderProxy == null)
			{
				this._msgSenderProxy = facade.retrieveProxy(Charge_MsgSendProxy.NAME) as Charge_MsgSendProxy;
			}
			return this._msgSenderProxy;
		}
		
		/**
		 * 用户选择
		 * @param event
		 * 
		 */		
		private function onTabIndexChange(event:Event):void
		{
			if (mainUI.radiogroup1.selection.value != 0)
			{
				mainUI.userName.visible = true;
			}else{
				mainUI.userName.visible = false;
			}
		}
		
		/**
		 * 时间选择
		 * @param event
		 * 
		 */		
		private function onTabIndexChange2(event:Event):void
		{
			if (mainUI.radiogroup2.selection.value == 5)
			{
				mainUI.otherTime.visible = true;
			}else{
				mainUI.otherTime.visible = false;
			}
		}
		
		private function showMain(data:Object):void
		{
			ResizeManager.registerResize(mainUI);
			PipeManager.sendMsg(PipeEvent.ADD_CHILD_TO_MAINUI, mainUI);
		}
		
	}
}