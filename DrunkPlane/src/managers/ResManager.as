package managers
{
	import flash.display.BitmapData;
	
	import br.com.stimuli.loading.BulkLoader;
	
	import starling.utils.AssetManager;

	public class ResManager
	{
		public function ResManager()
		{
		}
		
		public static const BASE:String = "assets/";
		
		public static const YLXD:String = BASE + "drunkplane.png";
		
		public static const YLXDXML:String = BASE + "drunkplane.xml";
		public static const YLXD2:String = BASE + "drunkplane2.png";
		
		public static const YLXDXML2:String = BASE + "drunkplane2.xml";
		
		public static var assetsManager:AssetManager;
		
		public static var resLoader:BulkLoader;
		
		public static var YLXD_NAME:String = "ylxd";
		public static var YLXD_NAME2:String = "ylxd2";
		
		public static const PASS_SOUND:String = BASE + "pass.mp3";
		
		public static const BEYOND_MAX:String = BASE + "win.mp3";
		public static const GAME_OVER:String = BASE + "gameover.mp3";
		public static var backGroundBmd:BitmapData;
	}
}