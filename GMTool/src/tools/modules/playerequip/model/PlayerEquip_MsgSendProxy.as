package tools.modules.playerequip.model
{
    import org.puremvc.as3.multicore.patterns.proxy.Proxy;
    
    import tools.managers.NetWorkManager;

    public class PlayerEquip_MsgSendProxy extends Proxy
    {
        public static const NAME:String = "PlayerEquip_MsgSendProxy";

        public function PlayerEquip_MsgSendProxy(param1:String = null, param2:Object = null)
        {
            super(NAME);
            return;
        }
		
		/**
		 * 装备的查询 
		 * @param gameuid
		 * 
		 */
		public function send_20009(gameuid:int,is_main:int,partnerid:int):void
		{
			NetWorkManager.sendMsgData(20009, {gameuid:gameuid,is_main:is_main,partnerid:partnerid});
			return;
		}

    }
}
