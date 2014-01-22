package tools.modules.fightspirit.model
{
    import org.puremvc.as3.multicore.patterns.proxy.Proxy;
    
    import tools.managers.NetWorkManager;

    public class FightSpirit_MsgSendProxy extends Proxy
    {
        public static const NAME:String = "FightSpirit_MsgSendProxy";

        public function FightSpirit_MsgSendProxy(param1:String = null, param2:Object = null)
        {
            super(NAME);
            return;
        }
		
		public function send_20019(type:int,condition:String):void
		{
			NetWorkManager.sendMsgData(20019, {type:type,condition:condition});
			return;
		}

    }
}
