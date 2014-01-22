package tools.modules.player.model
{
    import org.puremvc.as3.multicore.patterns.proxy.Proxy;
    
    import tools.managers.NetWorkManager;

    public class Player_MsgSendProxy extends Proxy
    {
        public static const NAME:String = "Player_MsgSendProxy";

        public function Player_MsgSendProxy(param1:String = null, param2:Object = null)
        {
            super(NAME);
            return;
        }
		/**
		 * 1:按角色名查询   2:按平台id查询 
		 * @param type
		 * @param condition
		 * 
		 */
		public function send_20007(type:int, condition:String, page:int, linenum:int):void
		{
			NetWorkManager.sendMsgData(20007, {type:type, condition:condition, page:page, linenum:linenum});
			return;
		}
		
		public function send_20011(uid:int):void
		{
			NetWorkManager.sendMsgData(20011, {uid:uid});
			return;
		}
		
		public function send_20017(main_id:int):void
		{
			NetWorkManager.sendMsgData(20017, {partner_id:main_id});
			return;
		}
		
		/**
		 *踢玩家下线 
		 * @param id
		 * @param reason
		 * 
		 */
		public function send_20075(id:int,reason:int):void
		{
			NetWorkManager.sendMsgData(20075, {id:id,reason:reason});
			return;
		}
		
		/**
		 *玩家禁言 
		 * @param id
		 * 
		 */
		public function send_20076(id:int):void
		{
			NetWorkManager.sendMsgData(20076, {id:id});
			return;
		}
		
		/**
		 *封号处理请求 
		 * @param id
		 * 
		 */
		public function send_20077(id:int):void
		{
			NetWorkManager.sendMsgData(20077, {id:id});
			return;
		}
		
		/**
		 *解除封号请求 
		 * @param id
		 * 
		 */
		public function send_20079(id:int):void
		{
			NetWorkManager.sendMsgData(20079, {id:id});
			return;
		}
		
		
		/**
		 *解除禁言请求 
		 * @param id
		 * 
		 */
		public function send_20081(id:int):void
		{
			NetWorkManager.sendMsgData(20081, {id:id});
			return;
		}
		

    }
}
