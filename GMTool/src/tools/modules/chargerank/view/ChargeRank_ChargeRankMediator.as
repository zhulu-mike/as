package tools.modules.chargerank.view
{
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.collections.Sort;
	import mx.collections.SortField;
	import mx.controls.Alert;
	import mx.events.FlexEvent;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import tools.events.PipeEvent;
	import tools.managers.PipeManager;
	import tools.managers.ResizeManager;
	import tools.modules.chargerank.ChargeRank_ApplicationFacade;
	import tools.modules.chargerank.model.ChargeRankModel;
	import tools.modules.chargerank.model.ChargeRank_MsgSendProxy;
	import tools.modules.chargerank.view.components.ChargeRankPanel;

	public class ChargeRank_ChargeRankMediator extends Mediator
	{

		private var _msgSenderProxy:ChargeRank_MsgSendProxy;
		public static const NAME:String = "ChargeRank_ChargeRankMediator";
		private var model:ChargeRankModel=ChargeRankModel.getInstance();
		public var nowPage:int=1;

		public function ChargeRank_ChargeRankMediator(viewComponent:Object)
		{
			super(NAME, viewComponent);
			mainUI.addEventListener(FlexEvent.CREATION_COMPLETE, initUI);
		}
		
		protected function initUI(event:FlexEvent):void
		{
			//按钮
			mainUI.submitBtn.addEventListener(MouseEvent.CLICK,onSubmit);
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
		
		private function searchBtn():void
		{
			var eSeconds:Number=int(mainUI.eHours.text)*3600+int(mainUI.eMinute.text)*60+int(mainUI.eSeconds.text);
			var bSeconds:Number=int(mainUI.bHours.text)*3600+int(mainUI.bMinute.text)*60+int(mainUI.bSeconds.text);
			var etime:Number=mainUI.etime.selectedDate.getTime()*0.001+eSeconds;//开始时间
			var btime:Number=mainUI.btime.selectedDate.getTime()*0.001+bSeconds;//结束时间
			var linenumber:int=mainUI.dg.height / mainUI.dg.rowHeight;
			if(eSeconds<=86400&&bSeconds<=86400)
			{
				msgSenderProxy.send_20086(nowPage,linenumber,btime,etime);
//				mainUI.etime.text='';
//				mainUI.btime.text='';
//				mainUI.eHours.text='0',mainUI.eMinute.text='0',mainUI.eSeconds.text='0';
//				mainUI.bHours.text='0',mainUI.bMinute.text='0',mainUI.bSeconds.text='0';
			}
			else
			{
				Alert.show(Language.TIME_MINUTES_SECONDS_WRONG,Language.TISHI);
			}
		}
		
		protected function onSubmit(event:MouseEvent):void
		{
			searchBtn();
		}
		
		
		protected function get mainUI() : ChargeRankPanel
		{
			return viewComponent as ChargeRankPanel;
		}

		override public function onRegister() : void
		{
			return;
		}

		override public function listNotificationInterests() : Array
		{
			return [ChargeRank_ApplicationFacade.SHOW_MAINUI,ChargeRank_ApplicationFacade.CHARGE_RANK_RESP];
		}

		override public function handleNotification(param1:INotification) : void
		{
			var data:Object = param1.getBody();
			switch(param1.getName())
			{
				case ChargeRank_ApplicationFacade.SHOW_MAINUI:
				{
					showMain(data);
					break;
				}
				case ChargeRank_ApplicationFacade.CHARGE_RANK_RESP:
				{
					chargeRankResp(data);
					break;
				}
				default:
				{
					break;
				}
			}
			return;
		}
		
		private function chargeRankResp(data:Object):void
		{
			model.maxPage=data.page_num;
			mainUI.allCount.text=data.record_num;
			mainUI.labelNum.text=nowPage+"/"+data.page_num;
			var arr:Array=data.v_info;
			for (var i:int = 0; i < arr.length; i++) 
			{
				var date:Date=new Date(arr[i].first_time*1000);
				arr[i].first_time=date.getFullYear()+"-"+(date.getMonth()+1)+"-"+date.getDate()+" "+date.toTimeString();
				date=new Date(arr[i].last_time*1000);
				arr[i].last_time=date.getFullYear()+"-"+(date.getMonth()+1)+"-"+date.getDate()+" "+date.toTimeString();
			}
			var dataArr:ArrayCollection=new ArrayCollection(arr);
			dataArr.sort=new Sort();
			dataArr.sort.fields=[new SortField("money",false,true)];
			dataArr.refresh();
			mainUI.dg.dataProvider =dataArr;
		}		
		
		private function get msgSenderProxy() : ChargeRank_MsgSendProxy
		{
			if (this._msgSenderProxy == null)
			{
				this._msgSenderProxy = facade.retrieveProxy(ChargeRank_MsgSendProxy.NAME) as ChargeRank_MsgSendProxy;
			}
			return this._msgSenderProxy;
		}
		
		private function showMain(data:Object):void
		{
			ResizeManager.registerResize(mainUI);
			PipeManager.sendMsg(PipeEvent.ADD_CHILD_TO_MAINUI, mainUI);
		}
	}
}