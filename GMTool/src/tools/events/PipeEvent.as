package tools.events
{
	public class PipeEvent
	{
		public function PipeEvent()
		{
		}
		
		public static const STARTUP_LOGIN:String = "tools.modules.login.Login_ApplicationFacade";
		
		public static const LOGIN_CONNECT:String = "LOGIN_CONNECT";
		
		public static const STARTUP_MAINUI:String = "tools.modules.mainui.MainUI_ApplicationFacade";
		
		public static const SHOW_MAINUI:String = "SHOW_MAINUI";
		
		/**添加一个模块界面到主界面操作区域*/
		public static const ADD_CHILD_TO_MAINUI:String = "ADD_CHILD_TO_MAINUI";
		
		/**充值*/
		public static const STARTUP_CHARGE:String = "tools.modules.charge.Charge_ApplicationFacade";
		public static const SHOW_CHARGE_MAINUI:String = "SHOW_CHARGE_MAINUI";
		
		/**加载*/
		public static const STARTUP_LOADRES:String = "tools.modules.load.LoadRes_ApplicationFacade";
		
		public static const SHOW_USER_MAINUI:String = "SHOW_USER_MAINUI";
		
		public static const SHOW_PLAYER_MAINUI:String = "SHOW_PALYER_MAINUI";
		
		public static const SHOW_PLAYER_EQUIP_MAINUI:String = "SHOW_PLAYER_EQUIP_MAINUI";
		
		public static const SHOW_PALYER_PACKAGE_MAINUI:String = "SHOW_PALYER_PACKAGE_MAINUI";
		
		public static const SHOW_SUPER_GAS_MAINUI:String = "SHOW_SUPER_GAS_MAINUI";
		
		public static const SHOW_FIGHTER_SPIRIT_MAINUI:String = "SHOW_FIGHTER_SPIRIT_MAINUI";
		
		public static const SHOW_CHAT_MAINUI:String = "SHOW_CHAT_MAINUI";
		
		public static const SHOW_PASSPORT_MAINUI:String = "SHOW_PASSPORT_MAINUI";
		
		public static const SHOW_PROP_MAINUI:String = "SHOW_PROP_MAINUI";
		
		public static const SHOW_SEND_PROP_MAINUI:String = "SHOW_SEND_PROP_MAINUI";
		
		public static const SHOW_EQUIP_MANAGE_MAINUI:String = "SHOW_EQUIP_MANAGE_MAINUI";
		
		public static const SHOW_APPLICATION_MAINUI:String = "SHOW_APPLICATION_MAINUI";
		
		public static const SHOW_PLAYER_CARD_MAINUI:String = "SHOW_PLAYER_CARD_MAINUI";
		
		public static const SHOW_CHECK_CARD_MIANUI:String = "SHOW_CHECK_CARD_MIANUI";
		
		public static const SHOW_PLAYER_ONLINE_MAINUI:String = "SHOW_PLAYER_ONLINE_MAINUI";
		
		public static const SHOW_CONSUM_ONLINE_MAINUI:String = "SHOW_CONSUM_ONLINE_MAINUI";
		
		public static const SHOW_ADD_SERVER_LIST_MAINUI:String = "SHOW_ADD_SERVER_LIST_MAINUI";
		
		public static const SHOW_ANNOUNCE_MANAGER_MAINUI:String = "SHOW_ANNOUNCE_MANAGER_MAINUI";
		
		public static const SHOW_CHARGE_RANK_MAINUI:String = "SHOW_CHARGE_RANK_MAINUI";
		
		public static const SHOW_CHARGE_COUNT:String = "SHOW_CHARGE_COUNT";
		
		public static const SHOW_VIP_CAREER:String = "SHOW_VIP_CAREER";
		
		public static const SHOW_PLAYER_LEVEL_MAINUI:String = "SHOW_PLAYER_LEVEL_MAINUI";
	}
}