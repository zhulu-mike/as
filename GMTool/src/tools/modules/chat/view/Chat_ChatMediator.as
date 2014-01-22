package tools.modules.chat.view
{
	import flash.events.Event;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import tools.events.PipeEvent;
	import tools.managers.PipeManager;
	import tools.managers.ResizeManager;
	import tools.modules.chat.Chat_ApplicationFacade;
	import tools.modules.chat.model.ChatModel;
	import tools.modules.chat.model.Chat_MsgSendProxy;
	import tools.modules.chat.view.components.ChatPanel;

	public class Chat_ChatMediator extends Mediator
	{

		private var _msgSenderProxy:Chat_MsgSendProxy;
		public static const NAME:String = "Chat_ChatMediator";
		private var model:ChatModel = ChatModel.getInstance();

		public function Chat_ChatMediator(viewComponent:Object)
		{
			super(NAME, viewComponent);
			initUI();
		}
		
		private function initUI():void
		{
			mainUI.addEventListener(Event.REMOVED_FROM_STAGE, removeHandle);
		}

		private function removeHandle(event:Event):void
		{
			ResizeManager.unRegisterResize(mainUI);
		}

		protected function get mainUI() : ChatPanel
		{
			return viewComponent as ChatPanel;
		}

		override public function onRegister() : void
		{
			return;
		}

		override public function listNotificationInterests() : Array
		{
			return [Chat_ApplicationFacade.SHOW_MAINUI];
		}

		override public function handleNotification(param1:INotification) : void
		{
			var data:Object = param1.getBody();
			switch(param1.getName())
			{
				case Chat_ApplicationFacade.SHOW_MAINUI:
				{
					showMainUI(data);
					break;
				}
				default:
				{
					break;
				}
			}
			return;
		}

		private function get msgSenderProxy() : Chat_MsgSendProxy
		{
			if (this._msgSenderProxy == null)
			{
				this._msgSenderProxy = facade.retrieveProxy(Chat_MsgSendProxy.NAME) as Chat_MsgSendProxy;
			}
			return this._msgSenderProxy;
		}
		
		private function showMainUI(data:Object):void
		{
			model.data = data.data;
			model.permission = data.permission;
			PipeManager.sendMsg(PipeEvent.ADD_CHILD_TO_MAINUI, mainUI);
			ResizeManager.registerResize(mainUI);
		}
	}
}