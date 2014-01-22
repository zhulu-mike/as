package game.manager
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	
	import game.common.gui.layers.Layer;

	public class LayerManager
	{
		
		public function LayerManager()
		{
		}
		
		/**
		 * 场景绘制层
		 */		
		public static var sceneLayer:Layer;
		
		/**
		 * 主界面层
		 */		
		public static var uiLayer:Layer;
		
		/**
		 * 弹出窗口层
		 */		
		public static var popupLayer:Layer;
		
		/**
		 * 系统信息层
		 */		
		public static var msgTipLayer:Layer;
		
		/**
		 * TIP层
		 */		
		public static var toolTipLayer:Layer;
		
		/**
		 * 动画效果层
		 */		
		public static var effectLayer:Layer;
		
		/**
		 * 拖拽层
		 */		
		public static var dragLayer:Layer;
		
		/**
		 * ALERT层
		 */		
		public static var alertLayer:Layer;
		
		
		public static function init(container:DisplayObjectContainer):void
		{
			sceneLayer = new Layer();
			sceneLayer.tabChildren = false;
			sceneLayer.name = "sceneLayer";
			container.addChild(sceneLayer);
			
			uiLayer = new Layer();
			uiLayer.name = "uiLayer";
			container.addChild(uiLayer);
			
			popupLayer = new Layer();
			popupLayer.name = "popupLayer";
			container.addChild(popupLayer);
			
			msgTipLayer = new Layer();
			msgTipLayer.name = "msgTipLayer";
			container.addChild(msgTipLayer);
			
			toolTipLayer = new Layer();
			toolTipLayer.tabChildren = false;
			toolTipLayer.name = "toolTipLayer";
			container.addChild(toolTipLayer);
			
			effectLayer = new Layer();
			effectLayer.tabChildren = false;
			effectLayer.name = "effectLayer";
			container.addChild(effectLayer);
			
			dragLayer = new Layer();
			dragLayer.tabChildren = false;
			dragLayer.name = "dragLayer";
			container.addChild(dragLayer);
			
			alertLayer = new Layer();
			alertLayer.name = "alertLayer";
			container.addChild(alertLayer);
			
			
		}
		
		
	}
}