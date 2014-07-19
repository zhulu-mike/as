package
{
	import com.freshplanet.ane.AirAlert.AirAlert;
	import com.mike.utils.FlashStatus;
	import com.mike.utils.ShareManager;
	
	import flash.desktop.NativeApplication;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageOrientation;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.StageOrientationEvent;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	import flash.system.System;
	import flash.ui.Keyboard;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	
	import br.com.stimuli.loading.BulkLoader;
	import br.com.stimuli.loading.loadingtypes.LoadingItem;
	import br.com.stimuli.loading.loadingtypes.XMLItem;
	
	import configs.GameInstance;
	import configs.GamePattern;
	
	import events.GameEvent;
	
	import infos.data.LocalSO;
	
	import managers.GameUtil;
	import managers.ResManager;
	
	import modules.mainui.views.WorkRoomIntroduce;
	
	import so.cuo.platform.baidu.BaiDu;
	
	import starling.core.Starling;
	
	public class YLXD extends Sprite
	{
		
		private var app:Starling;
		
		[Embed(source="assets/ylxd.png")]
		public var YlxdBmd:Class;
		
		[Embed(source="assets/icon_128x128.png")]
		public var LogAsset:Class;
		
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
				e.preventDefault();
				var okFunc:Function = function():void
				{
					NativeApplication.nativeApplication.exit();
				};
				var cancelFunc:Function = function():void
				{
					e.preventDefault();
				};
				AirAlert.getInstance().showAlert(Language.EXIT_DESC,"",Language.QUEDING,okFunc,Language.QUXIAO,cancelFunc);
			}
		}
		
		private var _introduce:WorkRoomIntroduce;
		
		private function init(event:Event=null):void
		{
//			trace(getTimer());
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.frameRate = 60;
			stage.setOrientation(StageOrientation.ROTATED_RIGHT);
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			ShareManager.instance.init();
			GameInstance.instance.LOG_CLASS = LogAsset;
			showIntroduce();
			NativeApplication.nativeApplication.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			GameInstance.instance.YLXD_CLASS = YlxdBmd;
			if (BaiDu.getInstance().supportDevice)
			{
				BaiDu.getInstance().setKeys("ac15d8a4","ac15d8a4");// BaiDu.getInstance().setKeys("appsid","计费id");
				BaiDu.getInstance().cacheInterstitial();
			}
			EventCenter.instance.addEventListener(GameEvent.STARLING_CREATE, onStarlingCreated);
			trace(stage.orientation,Capabilities.screenResolutionX,Capabilities.screenResolutionY);
			var rect:Rectangle ;
			if (stage.orientation != StageOrientation.ROTATED_RIGHT)
				rect = new Rectangle(0,0,Capabilities.screenResolutionY,Capabilities.screenResolutionX);
			else
				rect = new Rectangle(0,0,Capabilities.screenResolutionX,Capabilities.screenResolutionY);
			Starling.handleLostContext = true;
			app = new Starling(Game,stage,rect,null,"auto","auto");
			app.start();
			loadRes(null);
			initData();
			var fs:FlashStatus = new FlashStatus();
			addChild(fs);
			fs.init(stage);
			trace(getTimer());
		}
		
		protected function onStarlingCreated(event:GameEvent):void
		{
			GameInstance.instance.haveStarlingCreate = true;
			starGame();
		}
		/**
		 * 显示工作室简介
		 * 
		 */		
		private function showIntroduce():void
		{
			_introduce = new WorkRoomIntroduce();
			_introduce.resize(Capabilities.screenResolutionX,Capabilities.screenResolutionY);
			this.addChild(_introduce);
			setTimeout(starGame, 2000);
		}
		
		
		private function initData():void
		{
			GameInstance.instance.so = new LocalSO("ylxd_game");
			if(GameInstance.instance.so.hasKey("pattern_"+GamePattern.PUTONG))
				GameUtil.setMaxScore(GamePattern.PUTONG,int(GameInstance.instance.so.getAt("pattern_"+GamePattern.PUTONG)));
			if(GameInstance.instance.so.hasKey("pattern_"+GamePattern.NIXIANG))
				GameUtil.setMaxScore(GamePattern.NIXIANG,int(GameInstance.instance.so.getAt("pattern_"+GamePattern.NIXIANG)));
		}
		
		public function loadRes(e:GameEvent):void
		{
			ResManager.resLoader = new BulkLoader("main");
			var loadData:LoadingItem = ResManager.resLoader.add(ResManager.YLXDXML);
			var comp:Function = function(e:flash.events.Event):void
			{
				loadData.removeEventListener(flash.events.Event.COMPLETE, comp);
				GameInstance.instance.YLXD_XML =  (loadData as XMLItem).content;
				GameInstance.instance.resLoadCom = true;
				starGame();
			}
			loadData.addEventListener(flash.events.Event.COMPLETE, comp);
			ResManager.resLoader.loadNow(loadData);
		}
		
		private function starGame():void
		{
			if (_introduce.parent == null)
				return;
			if (GameInstance.instance.resLoadCom && GameInstance.instance.haveStarlingCreate && (getTimer()-GameInstance.instance.introduceTime >= 2000))
			{
				this.removeChild(_introduce);
				EventCenter.instance.dispatchEvent(new GameEvent(GameEvent.START_GAME));
			}
		}
		
	}
}