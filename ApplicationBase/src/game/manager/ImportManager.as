package game.manager
{
	import game.modules.engine.Engine_ApplicationFacade;

	/**
	 * 用于在主APP中嵌入某些类
	 * @author Administrator
	 * 
	 */	
	public class ImportManager
	{
		public function ImportManager()
		{
		}
		
		public static function init():void
		{
			Engine_ApplicationFacade;
		}
	}
}