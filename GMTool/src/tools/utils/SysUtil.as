package tools.utils
{
	public class SysUtil
	{
		public function SysUtil()
		{
		}
		
		
		/**
		 * 获取管理员的组别名。EG：高级管理员
		 * 
		 */
		public static function getAdminGroupName(group:int):String
		{
			var name:String = Language.GROUP_NAME;
			switch (group)
			{
				case 1:
					name=Language.ZONG_ADMIN;
					break;
				case 2:
					name=Language.ONE_LEVEL_ADMIN;
					break;
				case 3:
					name=Language.TWO_LEVEL_ADMIN;
					break;
				case 4:
					name=Language.THREE_LEVEL_ADMIN;
					break;
			}
			return name;
		}
	}
}