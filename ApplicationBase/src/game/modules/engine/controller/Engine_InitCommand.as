package game.modules.engine.controller
{
	import com.thinkido.framework.engine.Engine;
	import com.thinkido.framework.engine.Scene;
	
	import game.config.GameConfig;
	import game.config.GameInstance;
	import game.manager.LayerManager;
	import game.manager.ResPathManager;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	/**
	 * 初始化引擎
	 * @author Administrator
	 * 
	 */	
	public class Engine_InitCommand extends SimpleCommand
	{
		
		public function Engine_InitCommand()
		{
			super();
		}
		
		override public function execute(param1:INotification) : void
		{
			Engine.initEngine(GameConfig.baseFileUrl+ResPathManager.MAP_CONFIG+ResPathManager.eName_XML,
				GameConfig.baseFileUrl+ResPathManager.MAP_SMALL_IMAGE,
				GameConfig.baseFileUrl+ResPathManager.MAP_ZONE_DIR,
				GameConfig.baseFileUrl+ResPathManager.AVATAR_MAP_SLIPCOVER+ResPathManager.eName_SWF,
				GameConfig.frameRate,GameConfig.decode,GameConfig.isDebug);
			//创建主场景
			GameInstance.scene = new Scene(GameConfig.sceneWidth,GameConfig.sceneHeight);
			LayerManager.sceneLayer.addChildAt(GameInstance.scene, 0);
			
			
			return;
		}
	}
}