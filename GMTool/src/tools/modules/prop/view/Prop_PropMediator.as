package tools.modules.prop.view
{
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
	import tools.managers.ToolManager;
	import tools.modules.prop.Prop_ApplicationFacade;
	import tools.modules.prop.model.PropModel;
	import tools.modules.prop.model.Prop_MsgSendProxy;
	import tools.modules.prop.view.components.PropManagerPanel;

	public class Prop_PropMediator extends Mediator
	{

		private var _msgSenderProxy:Prop_MsgSendProxy;
		public static const NAME:String = "Prop_PropMediator";
		private var clickNum:int=0;
		private var model:PropModel=PropModel.getInstance();

		public function Prop_PropMediator(viewComponent:Object)
		{
			super(NAME, viewComponent);
			mainUI.addEventListener(FlexEvent.CREATION_COMPLETE, initUI);
		}
		
		protected function initUI(event:FlexEvent):void
		{
			mainUI.sendBtn.addEventListener(MouseEvent.CLICK,onSend);
		}
		
		protected function onSend(event:MouseEvent):void
		{
			PipeManager.sendMsg(PipeEvent.SHOW_SEND_PROP_MAINUI,model.permiss);
		}
		
		protected function get mainUI() : PropManagerPanel
		{
			return viewComponent as PropManagerPanel;
		}

		override public function onRegister() : void
		{
			return;
		}

		override public function listNotificationInterests() : Array
		{
			return [Prop_ApplicationFacade.SHOW_MAINUI,Prop_ApplicationFacade.PROP_RESEARCH];
		}

		override public function handleNotification(param1:INotification) : void
		{
			var data:Object = param1.getBody();
			switch(param1.getName())
			{
				case Prop_ApplicationFacade.SHOW_MAINUI:
				{
					showMainUi(data);
					break;
				}
				case Prop_ApplicationFacade.PROP_RESEARCH:
				{
					handleProp(data);
					break;
				}
				default:
				{
					break;
				}
			}
			return;
		}
		
		private function handleProp(data:Object):void
		{
			//
		}
		
		private function get msgSenderProxy() : Prop_MsgSendProxy
		{
			if (this._msgSenderProxy == null)
			{
				this._msgSenderProxy = facade.retrieveProxy(Prop_MsgSendProxy.NAME) as Prop_MsgSendProxy;
			}
			return this._msgSenderProxy;
		}
		
		
		private function showMainUi(data:Object):void
		{
			model.permiss=data.permission;
			
			ResizeManager.registerResize(mainUI);
			PipeManager.sendMsg(PipeEvent.ADD_CHILD_TO_MAINUI, mainUI);
			
			var toolarr:Array=ToolManager.getInstance().getAllToolInfo();
			var dataArr:ArrayCollection=new ArrayCollection(toolarr);
			dataArr.sort=new Sort();
			dataArr.sort.fields=[new SortField("consume_num",false,true)];
			dataArr.refresh();
			mainUI.dg.dataProvider =dataArr;
			
		}
	}
}