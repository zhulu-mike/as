package tools.modules.supgas.model
{
    import org.puremvc.as3.multicore.patterns.proxy.Proxy;
    
    import tools.managers.NetWorkManager;

    public class SuperGas_MsgSendProxy extends Proxy
    {
        public static const NAME:String = "SuperGas_MsgSendProxy";

        public function SuperGas_MsgSendProxy(param1:String = null, param2:Object = null)
        {
            super(NAME);
            return;
        }
		
		public function send_20015(gameuid:int,is_main:int,partnerid:int):void
		{
			NetWorkManager.sendMsgData(20015, {id:gameuid,is_main:is_main,partnerid:partnerid});
			return;
		}

    }
}
