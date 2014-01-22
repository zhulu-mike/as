package tools.modules.login.controller
{
	
	import flash.sampler.NewObjectSample;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	import tools.managers.NetWorkManager;
	import tools.modules.login.model.Login_MsgSenderProxy;
	
	public class Login_ConnectCommand extends SimpleCommand
	{
		public function Login_ConnectCommand()
		{
			super();
		}
		override public function execute(param1:INotification) : void
		{
			//登陆
			var data:Object = param1.getBody();
			var msg:Login_MsgSenderProxy = facade.retrieveProxy(Login_MsgSenderProxy.NAME) as Login_MsgSenderProxy;
			if (NetWorkManager.mainSocket.connected == false)
			{
				NetWorkManager.connectMain(Global.mainServerIP, Global.mainServerPort);
			}
	
			msg.send_20001(data.id, data.psd);
			return;
		}
	}
}