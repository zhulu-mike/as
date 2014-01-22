package
{
	import tools.vos.MainVO;

	public class Global
	{
		public function Global()
		{
		}
		
		/**
		 * 管理员的数据
		 * 
		 */
		public static var mainVO:MainVO = new MainVO();
		
		
		public static var fileBaseFolder:String = "";
		
		public static var mainServerIP:String = "";
		
		public static var mainServerPort:int = 0;
		
		public static var ins:GMTool;
		
		public static const STAGE_WIDTH:Number = 1000;
		public static const STAGE_HEIGHT:Number = 600;
		
		/**模块UI的宽高,与主界面的操作区域宽高保持一致*/
		public static const MODULE_WIDTH:Number = 770;
		public static const MODULE_HEIGHT:Number = 582;
		
		public static var stageScaleX:Number = 1;
		public static var stageScaleY:Number = 1;
		
		public static var systemProp:Array=[];
		
		/**
		 * dp是管理模块的数据源,一个object表示一个大的节点
		 * label是节点名,nodes里面是节点下面的小节点,data是小节点
		 * 的唯一标识，用户点击小节点时，用data来区分点的是哪一个。
		 * 
		 */		
		public static var dp:Array = [
			{label:Language.CHARGE_MANAGER, nodes:[{label:Language.CHARGE_RECORD,data:1},{label:Language.CHARGE_RANK,data:2},{label:Language.CHARGE_COUNT,data:3}]},
			{label:Language.USER_MANAGER, nodes:[{label:Language.PLAYER_INFO_CHECK,data:4},{label:Language.REGISTER_CHECK,data:5},{label:Language.FIGHTER_SOULE_CHECK,data:6}]},
			{label:Language.PASSPORT_MANAGER, nodes:[{label:Language.PASSPORT_MANAGER,data:7}]},
			{label:Language.PROP_EQUIP_MANAGER, nodes:[{label:Language.PROP_MANAGER,data:8},{label:Language.PROP_SEND,data:9},{label:Language.EQUIP_MANAGER,data:10},{label:Language.PROP_APPLICATION,data:11},{label:Language.CONSUM_RECORD_CHECK,data:12}]},
			{label:Language.CARD_NUM_MANAGER, nodes:[{label:Language.NWE_CARD_MANAGER,data:13},{label:Language.CHECK_NEW_CARD_TYPE,data:14}]},
			{label:Language.YUNYING_MANAGER, nodes:[{label:Language.PLAYER_ONLINE_CHECK,data:15},{label:Language.SERVER_MANAGER,data:16},{label:Language.ANNOUNCE_MANAGER,data:17},{label:Language.VIP_CAREER_MANAGER,data:18},{label:Language.PLAYER_LEVEL_FENBU,data:19}]}
		];
		
		/**
		 * 当舞台大小改变时，会改变的宽度
		 * @return 
		 * 
		 */		
		public static function getChangeWidth():Number
		{
			return STAGE_WIDTH * (stageScaleX - 1);
		}
		
		/**
		 * 当舞台大小改变时，会改变的高度
		 * @return 
		 * 
		 */	
		public static function getChangeHeight():Number
		{
			return STAGE_HEIGHT * (stageScaleY - 1);
		}
		
	}
}