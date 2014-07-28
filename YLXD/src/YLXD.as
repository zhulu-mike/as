package
{
	import com.freshplanet.ane.AirAlert.AirAlert;
	import com.mike.utils.AdvertiseUtil;
	import com.mike.utils.DeviceUtil;
	import com.mike.utils.FlashStatus;
	import com.mike.utils.NetUtil;
	import com.mike.utils.ResolutionUtil;
	import com.mike.utils.ShareManager;
	import com.mike.utils.TimeUtil;
	
	import flash.desktop.NativeApplication;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageOrientation;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	import flash.ui.Keyboard;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	
	import br.com.stimuli.loading.BulkLoader;
	import br.com.stimuli.loading.BulkProgressEvent;
	
	import configs.GameInstance;
	import configs.GamePattern;
	
	import events.GameEvent;
	
	import infos.data.LocalSO;
	
	import managers.GameUtil;
	import managers.ResManager;
	
	import modules.mainui.views.WorkRoomIntroduce;
	
	import starling.core.Starling;
	
	public class YLXD extends Sprite
	{
		
		private var app:Starling;
		
		[Embed(source="assets/logo.png")]
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
			GameInstance.instance.isIos = DeviceUtil.isIos();
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.frameRate = 30;
			stage.setOrientation(StageOrientation.ROTATED_RIGHT);
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			
			ResolutionUtil.instance.init(new Point(2048,1536));
			AdvertiseUtil.initBaiDu();
			ShareManager.instance.init();
			NativeApplication.nativeApplication.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			
			GameInstance.instance.sceneWidth = Math.max(stage.fullScreenWidth, stage.fullScreenHeight);
			GameInstance.instance.sceneHeight = Math.min(stage.fullScreenWidth, stage.fullScreenHeight);
			GameInstance.instance.scaleRatio = ResolutionUtil.instance.getBestRatio(GameInstance.instance.sceneWidth,GameInstance.instance.sceneHeight);
			GameInstance.DOOR_DIS = GameInstance.DOOR_DIS * GameInstance.instance.scaleRatio;
			GameInstance.INIT_SPEED = GameInstance.INIT_SPEED * GameInstance.instance.scaleRatio;
			GameInstance.WUDISPEED = GameInstance.WUDISPEED * GameInstance.instance.scaleRatio;
			
			GameInstance.instance.LOG_CLASS = LogAsset;
			
			EventCenter.instance.addEventListener(GameEvent.STARLING_CREATE, onStarlingCreated);
			trace(stage.orientation,Capabilities.screenResolutionX,Capabilities.screenResolutionY);
			trace(stage.fullScreenWidth, stage.fullScreenHeight);
			var rect:Rectangle ;
			rect = new Rectangle(0,0,GameInstance.instance.sceneWidth,GameInstance.instance.sceneHeight);
			showIntroduce();
			if (!GameInstance.instance.isIos)
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
			_introduce.resize(GameInstance.instance.sceneWidth,GameInstance.instance.sceneHeight);
			this.addChild(_introduce);
			setTimeout(starGame, 2000);
		}
		
		
		private function initData():void
		{
			GameInstance.instance.so = new LocalSO("com.kunpeng.cainimei");
			if(GameInstance.instance.so.hasKey("pattern_"+GamePattern.PUTONG))
				GameUtil.setMaxScore(GamePattern.PUTONG,int(GameInstance.instance.so.getAt("pattern_"+GamePattern.PUTONG)));
			if(GameInstance.instance.so.hasKey("pattern_"+GamePattern.NIXIANG))
				GameUtil.setMaxScore(GamePattern.NIXIANG,int(GameInstance.instance.so.getAt("pattern_"+GamePattern.NIXIANG)));
			var lastLoginTime:int = int(GameInstance.instance.so.getAt("last_login_time"));
			if (lastLoginTime == 0 || lastLoginTime < TimeUtil.getTodayZeroTime())
			{
				GameInstance.instance.so.setAt("last_login_time",TimeUtil.getNowTime());
				NetUtil.sendLogin(DeviceUtil.getDeviceID());
			}
		}
		
		public function loadRes(e:GameEvent):void
		{
			ResManager.resLoader = new BulkLoader("main");
			
			ResManager.resLoader.add(ResManager.YLXDXML);
			ResManager.resLoader.add(ResManager.YLXD);
			ResManager.resLoader.add(ResManager.YLXDXML2);
			ResManager.resLoader.add(ResManager.YLXD2);
			var comp:Function = function(e:flash.events.Event):void
			{
				ResManager.resLoader.removeEventListener(BulkProgressEvent.COMPLETE, comp);
				GameInstance.instance.resLoadCom = true;
				starGame();
			}
			ResManager.resLoader.addEventListener(BulkProgressEvent.COMPLETE,comp);
			ResManager.resLoader.start();
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