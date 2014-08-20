package
{
	import com.mike.utils.AdvertiseUtil;
	import com.mike.utils.DeviceUtil;
	import com.mike.utils.LanUtil;
	import com.mike.utils.NetUtil;
	import com.mike.utils.PlatType;
	import com.mike.utils.PlatUtil;
	import com.mike.utils.ResolutionUtil;
	import com.mike.utils.ShareManager;
	import com.mike.utils.TimeUtil;
	
	import flash.desktop.NativeApplication;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	
	import br.com.stimuli.loading.BulkLoader;
	import br.com.stimuli.loading.BulkProgressEvent;
	import br.com.stimuli.loading.loadingtypes.LoadingItem;
	
	import configs.GameConfig;
	import configs.GameInstance;
	
	import events.GameEvent;
	
	import infos.data.LocalSO;
	
	import managers.ResManager;
	
	import modules.mainui.views.WorkRoomIntroduce;
	
	import starling.core.Starling;
	
	public class DrunkPlane extends Sprite
	{
		
		private var app:Starling;
		
		[Embed(source="assets/logo.png")]
		public var LogAsset:Class;
		
		public function DrunkPlane()
		{
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
				if (PlatUtil.isCertainPlat(PlatType.ANDROID_4399))
				{
					AdvertiseUtil.showExitScreen();
					return;
				}
				e.preventDefault();
				var okFunc:Function = function():void
				{
					NativeApplication.nativeApplication.exit();
				};
				var cancelFunc:Function = function():void
				{
					e.preventDefault();
				};
				//				AirAlert.getInstance().showAlert(Language.getString("EXIT_DESC"),"",Language.getString("QUEDING"),okFunc,Language.getString("QUXIAO"),cancelFunc);
			}
		}
		private var _introduce:WorkRoomIntroduce;
		
		private function init(event:Event=null):void
		{
			DeviceUtil.isIos();
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.frameRate = 30;
			//stage.setOrientation(StageOrientation.ROTATED_RIGHT);
			Multitouch.inputMode = MultitouchInputMode.GESTURE;
			Starling.multitouchEnabled = false;
			
			
			ResolutionUtil.instance.init(new Point(640,960));
			PlatUtil.initPlat(PlatType.BAUDU);
			AdvertiseUtil.initBaiDu(stage);
			ShareManager.instance.init();
			NativeApplication.nativeApplication.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			
			GameInstance.instance.sceneWidth = Math.min(stage.fullScreenWidth, stage.fullScreenHeight);
			GameInstance.instance.sceneHeight = Math.max(stage.fullScreenWidth, stage.fullScreenHeight);
			GameInstance.instance.scaleRatio = 1;//ResolutionUtil.instance.getBestRatio(GameInstance.instance.sceneWidth,GameInstance.instance.sceneHeight);
			GameInstance.INIT_SPEED = GameInstance.INIT_SPEED * GameInstance.instance.scaleRatio;
			
			GameInstance.instance.LOG_CLASS = LogAsset;
			
			EventCenter.instance.addEventListener(GameEvent.STARLING_CREATE, onStarlingCreated);
			var rect:Rectangle ;
			rect = new Rectangle(0,0,GameInstance.instance.sceneWidth,GameInstance.instance.sceneHeight);
			showIntroduce();
			if (!GameInstance.instance.isIos)
				Starling.handleLostContext = true;
			app = new Starling(Game,stage,rect,null,"auto","auto");
			app.stage.stageWidth = 640;
			app.stage.stageHeight = 960;
			app.showStats = true;
			app.start();
			loadRes(null);
			initData();
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
			_introduce.addEventListener(MouseEvent.CLICK, onClick);
			this.addChild(_introduce);
			var t:int = getTimer();
			setTimeout(timeOut, 2000);
		}
		
		protected function onClick(event:MouseEvent):void
		{
			starGame();
		}
		
		private var timeBool:Boolean = false;
		private function timeOut():void
		{
			timeBool = true;
			starGame();
		}
		
		
		private function initData():void
		{
			GameInstance.instance.so = new LocalSO("com.kunpeng.drunkplane");
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
			var item:LoadingItem = ResManager.resLoader.add(ResManager.BASE + LanUtil.getCurrentLangeFile());
			var lanFunc:Function = function(e:flash.events.Event):void
			{
				item.removeEventListener(flash.events.Event.COMPLETE, lanFunc);
				Language.parse(item.content);
			};
			item.addEventListener(flash.events.Event.COMPLETE,lanFunc);
			var comp:Function = function(e:BulkProgressEvent):void
			{
				ResManager.resLoader.removeEventListener(BulkProgressEvent.COMPLETE, comp);
				GameInstance.instance.resLoadCom = true;
				starGame();
			};
			ResManager.resLoader.addEventListener(BulkProgressEvent.COMPLETE,comp);
			ResManager.resLoader.start();
		}
		
		private function starGame():void
		{
			if (_introduce.parent == null)
				return;
			_introduce.removeEventListener(MouseEvent.CLICK, onClick);
			trace(GameInstance.instance.resLoadCom,GameInstance.instance.haveStarlingCreate,timeBool);
			if (GameInstance.instance.resLoadCom && GameInstance.instance.haveStarlingCreate && timeBool)
			{
				this.removeChild(_introduce);
				EventCenter.instance.dispatchEvent(new GameEvent(GameEvent.START_GAME));
			}
		}
	}
}