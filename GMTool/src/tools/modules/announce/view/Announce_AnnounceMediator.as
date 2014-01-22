package tools.modules.announce.view
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayList;
	import mx.controls.Alert;
	import mx.events.FlexEvent;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import spark.events.IndexChangeEvent;
	
	import tools.events.PipeEvent;
	import tools.managers.PipeManager;
	import tools.managers.ResizeManager;
	import tools.modules.announce.Announce_ApplicationFacade;
	import tools.modules.announce.model.AnnounceModel;
	import tools.modules.announce.model.Announce_MsgSendProxy;
	import tools.modules.announce.view.components.AnnOperationItem;
	import tools.modules.announce.view.components.AnnouncePanel;
	import tools.modules.announce.view.components.CompilePanel;

	public class Announce_AnnounceMediator extends Mediator
	{

		private var _msgSenderProxy:Announce_MsgSendProxy;
		public static const NAME:String = "Announce_AnnounceMediator";
		private var compilePanel:CompilePanel;
		private var model:AnnounceModel=AnnounceModel.getInstance();

		public function Announce_AnnounceMediator(viewComponent:Object)
		{
			super(NAME, viewComponent);
			mainUI.addEventListener(FlexEvent.CREATION_COMPLETE, initUI);
		}
		
		protected function initUI(event:FlexEvent):void
		{
			//编辑公告面板
			compilePanel=new CompilePanel();
			compilePanel.x=mainUI.width/2-compilePanel.width/2;
			compilePanel.y=mainUI.height/2-compilePanel.height/2;
			mainUI.addElement(compilePanel);
			compilePanel.visible=false;
			//按钮
			mainUI.addAnnounceBtn.addEventListener(MouseEvent.CLICK,onAddAnnounceBtn);
			compilePanel.onCloseBtn.addEventListener(MouseEvent.CLICK,onPanelCloseBtn);
			compilePanel.onSureContent.addEventListener(MouseEvent.CLICK,onSureContent);
			mainUI.selectNum.addEventListener(Event.CHANGE,onSelectNumer);
			mainUI.ifInsertChat.addEventListener(Event.CHANGE,onIfInsertContent);
			mainUI.subminAnnBtn.addEventListener(MouseEvent.CLICK,onSubmit);
			mainUI.dg.addEventListener(AnnOperationItem.DELETE_ANNOUNCE,onDeleteAnnounce);
		}
		
		/**
		 * 发送删除未发送公告协议 
		 * @param event
		 * 
		 */
		protected function onDeleteAnnounce(event:Event):void
		{
			msgSenderProxy.send_20088(model.deleteId);
		}
		
		protected function onSubmit(event:MouseEvent):void
		{
			var eSeconds:Number=int(mainUI.eHours.text)*3600+int(mainUI.eMinute.text)*60+int(mainUI.eSeconds.text);
			var bSeconds:Number=int(mainUI.bHours.text)*3600+int(mainUI.bMinute.text)*60+int(mainUI.bSeconds.text);
			if(mainUI.etime.selectedDate&&mainUI.btime.selectedDate)
			{
				var etime:Number=mainUI.etime.selectedDate.getTime()*0.001+eSeconds;//开始时间
				var btime:Number=mainUI.btime.selectedDate.getTime()*0.001+bSeconds;//结束时间
			}
			
			if(eSeconds<=86400&&bSeconds<=86400&&model.annContent!="")
			{
				msgSenderProxy.send_20082(model.annContent,model.number,1,model.ifInsertContent,btime,etime,0);
				//提交之后清空
				mainUI.showAnnounce.text='';
				mainUI.etime.text='';
				mainUI.btime.text='';
				mainUI.ifInsertChat.selected=false;
				mainUI.selectNum.selectedIndex=0;
				mainUI.eHours.text='0',mainUI.eMinute.text='0',mainUI.eSeconds.text='0';
				mainUI.bHours.text='0',mainUI.bMinute.text='0',mainUI.bSeconds.text='0';
			}
			else
			{
				Alert.show(Language.TIME_MINUTES_SECONDS_WRONG,Language.TISHI);//提示时间输入错误
			}
			
		}
		
		protected function onIfInsertContent(event:Event):void
		{
			if(mainUI.ifInsertChat.selected)
			{
				model.ifInsertContent=1;//是否添加到聊天框
			}
			else
			{
				model.ifInsertContent=0;
			}
		}
		
		protected function onSelectNumer(event:IndexChangeEvent):void
		{
			model.number=mainUI.selectNum.selectedItem.data;
		}
		
		protected function onSureContent(event:MouseEvent):void
		{
			model.annContent=compilePanel.contentText.text;
			mainUI.showAnnounce.text=model.annContent;//显示在input框
//			compilePanel.selectColor.selectedColor;//选择的颜色
			compilePanel.visible=false;
		}
		
		protected function onPanelCloseBtn(event:MouseEvent):void
		{
			compilePanel.visible=false;
		}
		
		protected function onAddAnnounceBtn(event:MouseEvent):void
		{
			compilePanel.visible=true;
		}
		
		protected function get mainUI() : AnnouncePanel
		{
			return viewComponent as AnnouncePanel;
		}

		override public function onRegister() : void
		{
			return;
		}

		override public function listNotificationInterests() : Array
		{
			return [Announce_ApplicationFacade.SHOW_MAINUI,Announce_ApplicationFacade.CREAT_ANNOUNCE,Announce_ApplicationFacade.ANNOUNCE_RESP,
			Announce_ApplicationFacade.DELETE_ANNOUNCE];
		}

		override public function handleNotification(param1:INotification) : void
		{
			var data:Object = param1.getBody();
			switch(param1.getName())
			{
				case Announce_ApplicationFacade.SHOW_MAINUI:
				{
					showMain(data);
					break;
				}
				case Announce_ApplicationFacade.CREAT_ANNOUNCE://创建系统公告返回
				{
					sumbitResp(data);
					break;
				}
				case Announce_ApplicationFacade.ANNOUNCE_RESP://获取公告列表
				{
					announceResp(data);
					break;
				}
				case Announce_ApplicationFacade.DELETE_ANNOUNCE://删除公告
				{
					deleteAnnounce(data);
					break;
				}
				default:
				{
					break;
				}
			}
			return;
		}
		
		private function deleteAnnounce(data:Object):void
		{
			msgSenderProxy.send_20084();
			Alert.show(Language.CAOZUOCHENGGONG,Language.TISHI);
			
		}
		
		private function announceResp(data:Object):void
		{
			var arr:Array=data.v_info;
			for (var i:int = 0; i < arr.length; i++) 
			{
				var date:Date=new Date(arr[i].begin_time*1000);
				var btime:String=date.getFullYear()+"-"+(date.getMonth()+1)+"-"+date.getDate()+" "+date.toLocaleTimeString();
				date=new Date(arr[i].end_time*1000);
				var etime:String=date.getFullYear()+"-"+(date.getMonth()+1)+"-"+date.getDate()+" "+date.toLocaleTimeString();
				arr[i].ctime=btime+"--"+etime;
				if(arr[i].state==0)
				{
					arr[i].zstate=Language.WAIT_SEND;
				}
				else if(arr[i].state==1)
				{
					arr[i].zstate=Language.ALREADY_SEND;
				}
				else if(arr[i].state==2)
				{
					arr[i].zstate=Language.SEND_FAILURE;
				}
				else
				{
					arr[i].zstate=Language.ALREADY_DELETE;
				}
			}
			mainUI.dg.dataProvider=new ArrayList(arr);
		}
		
		private function sumbitResp(data:Object):void
		{
			if(data.ret==2037)
			{
				Alert.show(Language.PLEASE_CHOOSE_RIGHT_TIME,Language.TISHI);
			}
			else
			{
				msgSenderProxy.send_20084();//发送公告协议，刷新列表
				Alert.show(Language.CAOZUOCHENGGONG,Language.TISHI);
			}
			
		}		
		
		private function get msgSenderProxy() : Announce_MsgSendProxy
		{
			if (this._msgSenderProxy == null)
			{
				this._msgSenderProxy = facade.retrieveProxy(Announce_MsgSendProxy.NAME) as Announce_MsgSendProxy;
			}
			return this._msgSenderProxy;
		}
		
		private function showMain(data:Object):void
		{
			ResizeManager.registerResize(mainUI);
			PipeManager.sendMsg(PipeEvent.ADD_CHILD_TO_MAINUI, mainUI);
			msgSenderProxy.send_20084();//发送查看公告列表协议
		}
	}
}