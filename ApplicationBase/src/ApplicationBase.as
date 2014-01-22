package
{
	import com.thinkido.framework.manager.SharedObjectManager;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.system.Security;
	
	import game.config.GameConfig;
	import game.events.PipeEvent;
	import game.manager.FacadeManager;
	import game.manager.ImportManager;
	import game.manager.LayerManager;
	import game.manager.SkinStyleManager;
	import game.utils.PreventAccelerateUtil;
	
	import lm.mui.display.toolTip.Tooltip;
	import lm.mui.manager.DragManager;
	import lm.mui.manager.ToolTipsManager;
	
	public class ApplicationBase extends Sprite
	{
		public function ApplicationBase()
		{
			if (stage)
				onAddedToStage(null);
			else
				addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}

		private function onAddedToStage(event:Event):void
		{
			initApp();
			FacadeManager.startupFacade(PipeEvent.STARTUP_ENGINE);
		}
		
		/**
		 * 初始化
		 * 
		 */		
		private function initApp():void
		{
			Security.allowDomain("*");
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.tabChildren = false;
			stage.stageFocusRect = false;			
			stage.frameRate = GameConfig.frameRate;
			
			LayerManager.init(stage);
			PreventAccelerateUtil.init(stage);
			SkinStyleManager.initSkin();
			ToolTipsManager.init(LayerManager.toolTipLayer);
			ToolTipsManager.defaultRenderClass = Tooltip;
			DragManager.init(LayerManager.dragLayer);
			ImportManager.init() ;
		}
		
		private function startup():void
		{
			var obj:Object = stage.loaderInfo.parameters;
			var param:Object = {};
			param.baseDir = obj.baseDir;
			SharedObjectManager.baseHttpUrl = obj.baseDir;
			param.mainServerIP = obj.mainServerIP;
			param.mainServerPort = obj.mainServerPort;
			param.config = obj.config;
			param.program = obj.program;
			param.tileWidth = obj.tileWidth;
			param.tileHeight = obj.tileHeight;
			param.platuid = obj.platuid;
			param.plat = obj.plat;
			param.ukey = obj.ukey;
			param.release = obj.release;
			param.alone = obj.alone;
			param.isLoadXML = obj.hasOwnProperty("isLoadXML") ? obj.isLoadXML : true;
			FacadeManager.startupFacade(PipeEvent.STARTUP_SHELL, {parameters:param, decode:null});
		}
	}
}