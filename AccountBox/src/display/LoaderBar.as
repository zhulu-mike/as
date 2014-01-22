package display
{
	import interfaces.IResize;
	
	import manager.ResizeManager;
	
	import spark.components.Group;
	import spark.components.Label;
	import spark.core.SpriteVisualElement;
	
	public class LoaderBar extends Group implements IResize
	{
		
		private var circle:CircleLoopEffect;
		private var label:Label;
		public function LoaderBar()
		{
			super();
			
			circle = new CircleLoopEffect(20,8);
			var gs:SpriteVisualElement = new SpriteVisualElement();
			gs.addChild(circle);
			this.addElement(gs);
			
			label = new Label();
			label.width = 400;
//			label.setStyle("textFormat", new TextFormat(null,20,0xffffff,null,null,null,null,null,"center"));
			label.text = Language.TIP5;
			label.styleName = "loaderBar";
			addElement(label);
			label.y = circle.height + 10;
			
		}
		
		public function setText(txt:String):void
		{
			label.text = txt;
		}
		
		public function resize(w:Number, h:Number):void
		{
			_instance.graphics.clear();
			_instance.graphics.beginFill(0x000000,0.5);
			_instance.graphics.drawRect(0,0,w,h);
			_instance.graphics.endFill();
			label.x = (w - label.width) >> 1;
			label.y = (h - label.height) >> 1;
			
			circle.x = w >> 1;
			circle.y = label.y - circle.height+20;
		}
		
		public function show():void
		{
			AppInstance.topLayer.addElement(_instance);
			ResizeManager.registerResize(_instance);
			circle.start();
		}
		
		public function close():void
		{
			ResizeManager.unRegisterResize(_instance);
			AppInstance.topLayer.removeElement(_instance);
			circle.stop();
		}
		
		private static var _instance:LoaderBar;
		
		public static function getInstance():LoaderBar
		{
			if (_instance == null)
				_instance = new LoaderBar();
			return _instance;
		}
	}
}