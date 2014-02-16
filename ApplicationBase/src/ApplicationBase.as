package
{
	import com.thinkido.framework.manager.SharedObjectManager;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.system.Security;
	
	import game.config.GameConfig;
	import game.config.GameInstance;
	import game.events.PipeEvent;
	import game.manager.FacadeManager;
	import game.manager.GameManager;
	import game.manager.ImportManager;
	import game.manager.LayerManager;
	import game.manager.NetWorkManager;
	import game.manager.ResizeManager;
	import game.manager.SkinStyleManager;
	import game.utils.PreventAccelerateUtil;
	
	import lm.mui.display.toolTip.Tooltip;
	import lm.mui.interfaces.IResize;
	import lm.mui.manager.DragManager;
	import lm.mui.manager.ToolTipsManager;
	
	import org.osflash.thunderbolt.Logger;
	
	public class ApplicationBase extends Sprite implements IResize
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
			startup();
			FacadeManager.startupFacade(PipeEvent.STARTUP_ENGINE);
			
			stage.addEventListener(MouseEvent.CLICK, onClick);
		}
		
		protected function onClick(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			var arr:Array = ["stand","attack","walk","injured"];
			var i:int = Math.random()*3;
			
			GameInstance.scene.mainChar.playTo("walk");
		}
		
		public function resize(w:Number, h:Number):void
		{
			// TODO Auto-generated method stub
			if (GameInstance.scene)
			{
				GameInstance.scene.reSize(stage.stageWidth, stage.stageHeight);
			}
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
			GameInstance.stage = stage;
			
			LayerManager.init(stage);
			PreventAccelerateUtil.init(stage);
			SkinStyleManager.initSkin();
			ToolTipsManager.init(LayerManager.toolTipLayer);
			ToolTipsManager.defaultRenderClass = Tooltip;
			DragManager.init(LayerManager.dragLayer);
			ImportManager.init() ;
			ResizeManager.init(stage);
			ResizeManager.registerResize(this);
			NetWorkManager.init(stage);
<<<<<<< HEAD
			GameManager.init();
//			Logger.isOpen = false;
=======
			Logger.isOpen = false;
>>>>>>> 14e09aaa6082961360fade11cea9638efd32014c
		}
		
		private function startup():void
		{
			var obj:Object = stage.loaderInfo.parameters;
			var param:Object = {};
			GameConfig.baseFileUrl = param.baseDir = obj.baseDir;
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
		}
	}
}