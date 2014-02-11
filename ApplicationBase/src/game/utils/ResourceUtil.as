package game.utils
{
	import game.config.GameConfig;
	import game.manager.ResPathManager;
	import game.manager.VersionManager;

	public class ResourceUtil
	{
		public function ResourceUtil()
		{
		}
		
		public static function getAvatarPath(mid:int):String
		{
			return  VersionManager.getUrlWithPath(GameConfig.baseFileUrl+ResPathManager.AVATAR_SC_PATH.replace("$",mid)+ResPathManager.eName_SWF);
		}
	}
}