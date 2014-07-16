package
{
	import flash.desktop.NativeApplication;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageOrientation;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	import flash.ui.Keyboard;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import flash.utils.getTimer;
	
	import br.com.stimuli.loading.BulkLoader;
	import br.com.stimuli.loading.loadingtypes.LoadingItem;
	import br.com.stimuli.loading.loadingtypes.XMLItem;
	
	import cn.sharesdk.ane.PlatformID;
	import cn.sharesdk.ane.ShareSDKExtension;
	
	import configs.GameInstance;
	import configs.GamePattern;
	
	import events.GameEvent;
	
	import infos.data.LocalSO;
	
	import managers.GameUtil;
	import managers.LogManager;
	import managers.ResManager;
	
	import so.cuo.platform.baidu.BaiDu;
	import so.cuo.platform.baidu.BaiDuAdEvent;
	
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
//			trace(getTimer());
			if (stage){
				init(null);
			}else{
				addEventListener(Event.ADDED_TO_STAGE, init);
			}
		}
		
		private function onKeyDown(e:KeyboardEvent):void
		{
			if (e.keyCode == Keyboard.BACK)
			{
				NativeApplication.nativeApplication.exit();
			}
		}
		
		private function init(event:Event=null):void
		{
//			trace(getTimer());
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.frameRate = 60;
			stage.setOrientation(StageOrientation.ROTATED_RIGHT);
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			
			NativeApplication.nativeApplication.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			
			GameInstance.instance.YLXD_CLASS = YlxdBmd;
			if (BaiDu.getInstance().supportDevice)
			{
				BaiDu.getInstance().setKeys("b9a6ee49","b9a6ee49");// BaiDu.getInstance().setKeys("appsid","计费id");
				BaiDu.getInstance().cacheInterstitial();
			}
			ResManager.resLoader = new BulkLoader("main");
			LogManager.logTrace(Multitouch.inputMode);
			LogManager.logTrace(Multitouch.maxTouchPoints);
			LogManager.logTrace(Capabilities.screenResolutionX+"-"+Capabilities.screenResolutionY);
			var rect:Rectangle = new Rectangle(0,0,Capabilities.screenResolutionX,Capabilities.screenResolutionY);
			Starling.handleLostContext = true;
			app = new Starling(Game,stage,rect,null,"auto","auto");
			app.start();
			EventCenter.instance.addEventListener(GameEvent.STARLING_CREATE, loadRes);
			GameInstance.instance.so = new LocalSO("ylxd_game");
			if(GameInstance.instance.so.hasKey("pattern_"+GamePattern.PUTONG))
				GameUtil.setMaxScore(GamePattern.PUTONG,int(GameInstance.instance.so.getAt("pattern_"+GamePattern.PUTONG)));
			if(GameInstance.instance.so.hasKey("pattern_"+GamePattern.NIXIANG))
				GameUtil.setMaxScore(GamePattern.NIXIANG,int(GameInstance.instance.so.getAt("pattern_"+GamePattern.NIXIANG)));
//			trace(getTimer());
		}
		
		protected function onAD(event:BaiDuAdEvent):void
		{
			trace(event.data);
		}
		
		public function loadRes(e:GameEvent):void
		{
			
			var loadData:LoadingItem = ResManager.resLoader.add(ResManager.YLXDXML);
			var comp:Function = function(e:flash.events.Event):void
			{
				loadData.removeEventListener(flash.events.Event.COMPLETE, comp);
				var am:AssetManager = new AssetManager();
				ResManager.assetsManager = am;
				var ta:TextureAtlas = new TextureAtlas(Texture.fromEmbeddedAsset(GameInstance.instance.YLXD_CLASS), (loadData as XMLItem).content);
				am.addTextureAtlas(ResManager.YLXD_NAME,ta);
				EventCenter.instance.dispatchEvent(new GameEvent(GameEvent.START_GAME));
//				trace(getTimer());
			}
			loadData.addEventListener(flash.events.Event.COMPLETE, comp);
			ResManager.resLoader.loadNow(loadData);
//			trace(getTimer());
		}
		
	}
}