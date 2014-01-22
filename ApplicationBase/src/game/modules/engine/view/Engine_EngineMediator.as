package game.modules.engine.view
{
	import game.modules.engine.model.Engine_MsgSendProxy;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;

	public class Engine_EngineMediator extends Mediator
	{

		private var _msgSenderProxy:Engine_MsgSendProxy;
		public static const NAME:String = "Engine_EngineMediator";

		public function Engine_EngineMediator(viewComponent:Object)
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

		private function get msgSenderProxy() : Engine_MsgSendProxy
		{
			if (this._msgSenderProxy == null)
			{
				this._msgSenderProxy = facade.retrieveProxy(Engine_MsgSendProxy.NAME) as Engine_MsgSendProxy;
			}
			return this._msgSenderProxy;
		}
	}
}