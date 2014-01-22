package tools.modules.prop.model
{
    import org.puremvc.as3.multicore.patterns.proxy.Proxy;
    
    import tools.managers.NetWorkManager;

    public class Prop_MsgSendProxy extends Proxy
    {
        public static const NAME:String = "Prop_MsgSendProxy";

        public function Prop_MsgSendProxy(param1:String = null, param2:Object = null)
        {
            super(NAME);
            return;
        }
		
		public function send_20035():void
		{
			NetWorkManager.sendMsgData(20035, {});
			return;
		}

    }
}
