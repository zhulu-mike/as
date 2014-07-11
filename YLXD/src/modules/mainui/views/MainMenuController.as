package modules.mainui.views
{
	import configs.GamePattern;
	import configs.GameState;
	
	import core.Controller;
	
	import events.GameEvent;
	
	import managers.LogManager;
	
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class MainMenuController extends Controller
	{
		public function MainMenuController(view:Object)
		{
			super(view);
			initUI();
		}
		
		public function get panel():MainMenu
		{
			return viewComponent as MainMenu;
		}
		
		private function initUI():void
		{
			panel.beginTxt.addEventListener(TouchEvent.TOUCH, onBegin);
			panel.duizhan.addEventListener(TouchEvent.TOUCH, onBegin);
		}
		
		private function onBegin(event:TouchEvent):void
		{
			var touchs:Vector.<Touch> = event.touches;
			var touch:Touch = touchs[0];
			if (touch.phase == TouchPhase.ENDED)
			{
				LogManager.logTrace("开始游戏");
				panel.parent.removeChild(panel);
				var pattern:int = touch.target == panel.duizhan ? GamePattern.FIGHT : GamePattern.PUTONG;
				EventCenter.instance.dispatchGameEvent(GameEvent.GAME_STATE_CHANGE,{state:GameState.RUNNING,pattern:pattern});
			}
		}
	}
}