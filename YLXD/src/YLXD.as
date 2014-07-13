package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageOrientation;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	
	import br.com.stimuli.loading.BulkLoader;
	import br.com.stimuli.loading.loadingtypes.LoadingItem;
	import br.com.stimuli.loading.loadingtypes.XMLItem;
	
	import configs.GameInstance;
	
	import events.GameEvent;
	
	import infos.data.LocalSO;
	
	import managers.LogManager;
	import managers.ResManager;
	
	import so.cuo.platform.baidu.BaiDu;
	import so.cuo.platform.baidu.BaiDuAdEvent;
	import so.cuo.platform.baidu.RelationPosition;
	
	import starling.core.Starling;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import starling.utils.AssetManager;
	
	public class YLXD extends Sprite
	{
		
		private var app:Starling;
		
		[Embed(source="assets/ylxd.png")]
		public var YlxdBmd:Class;
		
		public function YLXD()
		{
			super();
			
			if (stage){
				init(null);
			}else{
				addEventListener(Event.ADDED_TO_STAGE, init);
			}
		}
		
		protected function onResize(event:Event):void
		{
			trace(stage.stageWidth, stage.stageHeight);
		}
		
		private function init(event:Event=null):void
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.frameRate = 60;
			stage.setOrientation(StageOrientation.ROTATED_RIGHT);
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			GameInstance.instance.YLXD_CLASS = YlxdBmd;
			
			ResManager.resLoader = new BulkLoader("main");
			LogManager.logTrace(Multitouch.inputMode);
			LogManager.logTrace(Multitouch.maxTouchPoints);
			LogManager.logTrace(Capabilities.screenResolutionX+"-"+Capabilities.screenResolutionY);
			var rect:Rectangle = new Rectangle(0,0,Capabilities.screenResolutionX,Capabilities.screenResolutionY);
			app = new Starling(Game,stage,rect,null,"auto","auto");
			app.start();
			EventCenter.instance.addEventListener(GameEvent.STARLING_CREATE, loadRes);
			GameInstance.instance.so = new LocalSO("ylxd_game");
		}
		
		protected function onAD(event:BaiDuAdEvent):void
		{
			trace(event.data);
		}
		
		public function loadRes(e:GameEvent):void
		{
			
			if (BaiDu.getInstance().supportDevice)
			{
				BaiDu.getInstance().setKeys("debug","debug");// BaiDu.getInstance().setKeys("appsid","计费id");
				BaiDu.getInstance().showInterstitial();
				BaiDu.getInstance().showBanner(BaiDu.BANNER,RelationPosition.MIDDLE_CENTER);
				BaiDu.getInstance().addEventListener(BaiDuAdEvent.onBannerFailedReceive, onAD);
				BaiDu.getInstance().addEventListener(BaiDuAdEvent.onBannerReceive, onAD);
				BaiDu.getInstance().addEventListener(BaiDuAdEvent.onBannerDismiss, onAD);
				BaiDu.getInstance().addEventListener(BaiDuAdEvent.onBannerLeaveApplication, onAD);
				BaiDu.getInstance().addEventListener(BaiDuAdEvent.onBannerPresent, onAD);
				BaiDu.getInstance().addEventListener(BaiDuAdEvent.onInterstitialDismiss, onAD);
				BaiDu.getInstance().addEventListener(BaiDuAdEvent.onInterstitialFailedReceive, onAD);
				BaiDu.getInstance().addEventListener(BaiDuAdEvent.onInterstitialLeaveApplication, onAD);
				BaiDu.getInstance().addEventListener(BaiDuAdEvent.onInterstitialPresent, onAD);
				BaiDu.getInstance().addEventListener(BaiDuAdEvent.onInterstitialReceive, onAD);
			}
			var loadData:LoadingItem = ResManager.resLoader.add(ResManager.YLXDXML);
			var comp:Function = function(e:flash.events.Event):void
			{
				loadData.removeEventListener(flash.events.Event.COMPLETE, comp);
				var am:AssetManager = new AssetManager();
				ResManager.assetsManager = am;
				var ta:TextureAtlas = new TextureAtlas(Texture.fromEmbeddedAsset(GameInstance.instance.YLXD_CLASS), (loadData as XMLItem).content);
				am.addTextureAtlas(ResManager.YLXD_NAME,ta);
				EventCenter.instance.dispatchEvent(new GameEvent(GameEvent.START_GAME));
			}
			loadData.addEventListener(flash.events.Event.COMPLETE, comp);
			ResManager.resLoader.loadNow(loadData);
		}
		
	}
}