package game.modules.engine.controller
{
	import com.thinkido.framework.engine.Engine;
	import com.thinkido.framework.engine.Scene;
	import com.thinkido.framework.engine.staticdata.AvatarPartType;
	import com.thinkido.framework.engine.staticdata.CharStatusType;
	import com.thinkido.framework.engine.staticdata.SceneCharacterType;
	import com.thinkido.framework.engine.vo.avatar.AvatarParamData;
	import com.thinkido.framework.engine.vo.avatar.AvatarPartStatus;
	
	import game.config.GameConfig;
	import game.config.GameInstance;
	import game.manager.LayerManager;
	import game.manager.ResPathManager;
	import game.utils.ResourceUtil;
	
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
			GameInstance.scene.switchScene(1001,"taiyixianjing");
			var apd:AvatarParamData = new AvatarParamData(ResourceUtil.getAvatarPath(569));
			GameInstance.scene.mainChar.loadAvatarPart(apd);
			GameInstance.scene.mainChar.setTileXY(100,110);
			GameInstance.scene.mainChar.playTo(CharStatusType.STAND);
			GameInstance.scene.reSize(GameInstance.stage.stageWidth, GameInstance.stage.stageHeight);
			return;
		}
	}
}