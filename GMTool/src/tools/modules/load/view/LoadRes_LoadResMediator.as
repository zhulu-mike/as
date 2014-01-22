package tools.modules.load.view
{
	import tools.modules.load.model.LoadRes_MsgSendProxy;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;

	public class LoadRes_LoadResMediator extends Mediator
	{

		private var _msgSenderProxy:LoadRes_MsgSendProxy;
		public static const NAME:String = "LoadRes_LoadResMediator";

		public function LoadRes_LoadResMediator(viewComponent:Object)
		{
			super(NAME, viewComponent);
		}

		protected function get mainUI() : Object
		{
			return viewComponent as Object;
		}

		override public function onRegister() : void
		{
			return;
		}

		override public function listNotificationInterests() : Array
		{
			return [];
		}

		override public function handleNotification(param1:INotification) : void
		{
			switch(param1.getName())
			{
				default:
				{
					break;
				}
			}
			return;
		}

		private function get msgSenderProxy() : LoadRes_MsgSendProxy
		{
			if (this._msgSenderProxy == null)
			{
				this._msgSenderProxy = facade.retrieveProxy(LoadRes_MsgSendProxy.NAME) as LoadRes_MsgSendProxy;
			}
			return this._msgSenderProxy;
		}
	}
}