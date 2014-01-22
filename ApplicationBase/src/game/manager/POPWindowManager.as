package game.manager
{
	import com.greensock.TweenLite;
	import com.thinkido.framework.manager.keyBoard.KeyBoardManager;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	
	import game.common.gui.basecontainer.BaseGUIComponent;
	import game.common.gui.basecontainer.BaseSprite;
	import game.config.GameConfig;
	import game.config.GameInstance;
	
	import lm.mui.interfaces.IResize;
	
	public class POPWindowManager implements IResize
	{
		public static var popWindow:POPWindowManager;
		/***/
		public static const SHOW:String = "SHOW";
		/***/
		public static const HIDE:String = "HIDE";
		private static var container:Sprite;
		public static var childMap:Dictionary = new Dictionary();
		
		public function POPWindowManager()
		{
			if (instance)
				throw new Error();
			return;
		}
		
		private static var instance:POPWindowManager;
		public static function getInstance():POPWindowManager
		{
			if (!instance)
				instance = new POPWindowManager();
			return instance;
		}
		
		public function resize(w:Number, h:Number):void
		{
			
		}
		
		
		/**
		 * 添加一个view,显示在舞台中央
		 * @param param1:DisplayObject 要添加的VIEW
		 * @param container:Sprite 要添加VIEW到哪个父容器里
		 * @param mapName:String 要添加的View的所属模块名,XXXX_facade.NAME,如果该窗口是某模块的VIEW，则为模块的NAME，否则不填
		 * @param param2:Boolean default false
		 * @param alone:Boolean 是否移除同一层内其他的view,default:true
		 * 
		 */
		public static function centerWindow(param1:DisplayObject, container:Sprite, mapName:String="", param2:Boolean = false, alone:Boolean = true, alpha:Number=0.5):void
		{
		}
		
		/**
		 * 弹出窗提示,即flex中的Alert
		 * @param text:String 要提示的文字
		 * @param title:String 标题 default ""
		 */
		public static function showAlert(popUp:DisplayObject,parent:Sprite = null,$modal:Boolean = true):void
		{
			/**浏览器缩放时、遮罩未跟随缩放*/
			if(popUp.stage == null)
			{
				parent = parent == null ? LayerManager.alertLayer : parent;
				parent.addChild(popUp);
				popUp.x = (GameConfig.sceneWidth - popUp.width) / 2;
				popUp.y = (GameConfig.sceneHeight - popUp.height) / 2;
				KeyBoardManager.enable = false;
			}
			else
			{
			}
			
		}
		
		/**
		 * 移除一个窗口,这个模式已经改了好几版了，所以逻辑有点乱，需要找个时间重构
		 * @param mapName:String 如果该窗口是某模块的VIEW，则为模块的NAME，否则不填
		 */
		public static function removeSmallWindow(popUp:DisplayObject, mapName:String = ""):void
		{
			if (popUp && popWindow)
			{
				GameInstance.stage.focus = GameInstance.stage ;
				var baseClass:BaseGUIComponent = popUp as BaseGUIComponent;
				if (baseClass && baseClass.removeEffectEnabled)
				{
					childMap[mapName] = null;
					delete childMap[mapName];
					baseClass.playRemoveEffect({onComplete:function():void
					{
					}
					});
					return;
				}
				var baseui:BaseSprite = popUp as BaseSprite;
				if (baseui && baseui.removeEffectEnabled)
				{
					childMap[mapName] = null;
					delete childMap[mapName];
					baseui.playRemoveEffect({x:0,y:0,onComplete:function():void
					{
					}
					});
					return;
				}
				TweenLite.to(popUp, 0.2, {alpha:0, onComplete:function():void{
					if (popUp.parent != null)
						popUp.parent.removeChild(popUp);
					popUp.alpha = 1;
					if (mapName != "" && childMap.hasOwnProperty(mapName) && childMap[mapName] == popUp){
						childMap[mapName] = null;
						delete childMap[mapName];
					}
				}
				});
				
				
			}
		}

		
		/**
		 * 把某一个小窗口提到最顶层
		 */
		public static function topView(view:DisplayObject):void
		{
			if (view && view.parent)
			{
				view.parent.setChildIndex(view, view.parent.numChildren-1);
			}
		}
		
		
		
		/**根据state来显示或者隐藏模块面板*/
		public static function updateModule(module:String, panel:String, param2:Object = null, state:String=SHOW):void
		{
			if (state == SHOW)
			{
				if (FacadeManager.hasFacade(module))
				{
					PipeManager.sendMsg(panel, param2);
				}else{
					FacadeManager.startupFacade(module, {panelKey:panel, data:param2});
				}
			}else{
				if (FacadeManager.hasFacade(module))
				{
					if (childMap[module])
					{
						childMap[module] = null;
						delete childMap[module];
						FacadeManager.killFacade(module);
					}
				}
			}
		}
		
		/***/
		public static function hasModule(name:String):Boolean
		{
			return childMap.hasOwnProperty(name);
		}
		
		
		
	}
}