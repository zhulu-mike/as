package tools.modules.consum.view
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.collections.Sort;
	import mx.collections.SortField;
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
	import tools.modules.consum.Consum_ApplicationFacade;
	import tools.modules.consum.model.ConsumModel;
	import tools.modules.consum.model.Consum_MsgSendProxy;
	import tools.modules.consum.view.components.ConsumPanel;

	public class Consum_ConsumMediator extends Mediator
	{

		private var _msgSenderProxy:Consum_MsgSendProxy;
		public static const NAME:String = "Consum_ConsumMediator";
		private var model:ConsumModel=ConsumModel.getInstance();
		public var nowPage:int=1;

		public function Consum_ConsumMediator(viewComponent:Object)
		{
			super(NAME, viewComponent);
			mainUI.addEventListener(FlexEvent.CREATION_COMPLETE, initUI);
		}
		
		protected function initUI(event:FlexEvent):void
		{
			mainUI.radiogroup1.addEventListener(Event.CHANGE, onTabIndexChange);
			mainUI.radiogroup2.addEventListener(Event.CHANGE, onTabIndexChange2);
			
			mainUI.chooseWay.addEventListener(Event.CHANGE,onSelectChoose);
			mainUI.searchBtn.addEventListener(MouseEvent.CLICK, searchUser);
			mainUI.nextBtn.addEventListener(MouseEvent.CLICK, nextPage);
			mainUI.preBtn.addEventListener(MouseEvent.CLICK, prePage);
			mainUI.go.addEventListener(MouseEvent.CLICK, goToPage);
			searchBtn();
		}
		
		/**
		 * 选择查询金钱/铜钱类型 
		 * @param event
		 * 
		 */
		protected function onSelectChoose(event:IndexChangeEvent):void
		{
			model.moneyType=mainUI.chooseWay.selectedItem.data;
		}
		
		/**
		 *  根据条件搜索
		 */
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
			msgSenderProxy.send_20065(model.moneyType,choseWay,strData,btime,etime,linenumber,nowPage);
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
		
		protected function get mainUI() : ConsumPanel
		{
			return viewComponent as ConsumPanel;
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
				mainUI.userName.text='';
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

		override public function onRegister() : void
		{
			return;
		}

		override public function listNotificationInterests() : Array
		{
			return [Consum_ApplicationFacade.SHOW_MAINUI,Consum_ApplicationFacade.CONSUM_RESP];
		}

		override public function handleNotification(param1:INotification) : void
		{
			var data:Object = param1.getBody();
			switch(param1.getName())
			{
				case Consum_ApplicationFacade.SHOW_MAINUI:
				{
					showMainUi(data);
					break;
				}
				case Consum_ApplicationFacade.CONSUM_RESP:
				{
					checkUserMoney(data);
					break;
				}
				default:
				{
					break;
				}
			}
			return;
		}
		
		private function checkUserMoney(data:Object):void
		{
			var equipBase:EquipBase;
			var toolBase:ToolBase;
			var strAll:String='';
			if(model.moneyType==1)
			{
				mainUI.allCharge.text=data.total_num+Language.YUANBAO;
			}
			else
			{
				mainUI.allCharge.text=data.total_num+Language.TONG_MONEY;
			}
			mainUI.allCount.text=data.total_record;
			model.maxPage=data.page_num;
			mainUI.labelNum.text=nowPage+"/"+data.page_num;
			////
			var arr:Array=data.v_info;
			for (var i:int = 0; i < arr.length; i++) 
			{
				var date:Date=new Date(arr[i].time*1000);
				arr[i].ctime=date.getFullYear()+"-"+(date.getMonth()+1)+"-"+date.getDate()+" "+date.toLocaleTimeString();
				/////
				var str:String=arr[i].detail;
				var arr1:Array=str.split("；");
				for (var j:int = 0; j < arr1.length; j++) 
				{
					var arr2:Array=(arr1[j] as String).split(",");
					if(arr2[0]==2)
					{
						toolBase = ToolManager.getInstance().getToolConfigInfo(arr2[1]);
						if(toolBase!=null)
						{
							strAll+= toolBase.name+"："+arr2[2]+"；";
						}
						
					}
					else if(arr2[0]==1)
					{
						equipBase = EquipManager.getInstance().getEquipConfigInfo(arr2[1]);
						if(equipBase!=null)
						{
							strAll+= equipBase.name+"："+arr2[2]+"；";
						}
					}
				}
				arr[i].str=strAll;
			}
			var dataArr:ArrayCollection=new ArrayCollection(arr);
			dataArr.sort=new Sort();
			dataArr.sort.fields=[new SortField("consume_num",false,true)];
			dataArr.refresh();
			mainUI.dg.dataProvider =dataArr;
		}
		
		private function get msgSenderProxy() : Consum_MsgSendProxy
		{
			if (this._msgSenderProxy == null)
			{
				this._msgSenderProxy = facade.retrieveProxy(Consum_MsgSendProxy.NAME) as Consum_MsgSendProxy;
			}
			return this._msgSenderProxy;
		}
		
		private function showMainUi(data:Object):void
		{
			ResizeManager.registerResize(mainUI);
			PipeManager.sendMsg(PipeEvent.ADD_CHILD_TO_MAINUI, mainUI);
		}
	}
}