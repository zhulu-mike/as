package tools.modules.chat.model
{
    import org.puremvc.as3.multicore.patterns.proxy.Proxy;
    
    import tools.managers.NetWorkManager;

    public class Chat_MsgSendProxy extends Proxy
    {
        public static const NAME:String = "Chat_MsgSendProxy";

        public function Chat_MsgSendProxy(param1:String = null, param2:Object = null)
        {
            super(NAME);
            return;
        }
		
    }
}
