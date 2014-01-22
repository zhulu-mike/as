package game.config
{
	import com.thinkido.framework.engine.Scene;
	
	import flash.display.Stage;

	public class GameInstance
	{
		public function GameInstance()
		{
		}
		
		public static var scene:Scene;
		
		public static var app:ApplicationBase;
		
		public static var stage:Stage;
	}
}