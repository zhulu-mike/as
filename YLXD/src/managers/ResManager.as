package managers
{
	import br.com.stimuli.loading.BulkLoader;
	
	import starling.utils.AssetManager;

	public class ResManager
	{
		public function ResManager()
		{
		}
		
		public static const BASE:String = "assets/";
		
		public static const YLXD:String = BASE + "ylxd.png";
		
		public static const YLXDXML:String = BASE + "ylxd.xml";
		
		public static var assetsManager:AssetManager;
		
		public static var resLoader:BulkLoader;
		
		public static var YLXD_NAME:String = "ylxd";
		
		public static const PASS_SOUND:String = BASE + "pass.mp3";
		
		public static const BEYOND_MAX:String = BASE + "win.mp3";
		public static const GAME_OVER:String = BASE + "gameover.mp3";
	}
}