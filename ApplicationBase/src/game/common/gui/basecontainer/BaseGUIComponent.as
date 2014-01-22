package game.common.gui.basecontainer
{
	import com.thinkido.framework.common.events.EventDispatchCenter;
	import com.thinkido.framework.common.observer.Notification;
	import com.thinkido.framework.events.DataEvent;
	import com.thinkido.framework.manager.keyBoard.KeyBoardManager;
	
	import fl.controls.Button;
	import fl.controls.SelectableList;
	import fl.events.ListEvent;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import game.common.gui.interfaces.IGuide;
	import game.common.vos.GuideCondition;
	import game.common.vos.GuideInfo;
	import game.common.vos.GuideVO;
	import game.events.PipeEvent;
	import game.manager.GuideAssistantManager;
	import game.manager.POPWindowManager;
	import game.manager.PipeManager;
	import game.utils.DisplayUtil;
	
	import lm.mui.controls.GTabBar;
	import lm.mui.controls.GUIComponent;
	import lm.mui.events.MuiEvent;
	import lm.mui.interfaces.IEffect;
	import lm.mui.interfaces.IResize;
	import lm.mui.manager.IDragDrop;
	
	public class BaseGUIComponent extends GUIComponent implements IResize, IGuide, IDragDrop
	{
		public var GUIDE_NAME:String = "";  
		
		private var _stage:Stage;
		
		/**
		 * 是否禁用下面显示列表的鼠标点击事件 
		 */		
		private var _otherMouseEnabled:Boolean = true;
		
		/**
		 * 是否禁用键盘事件,true表示禁用键盘事件
		 */		
		private var _keyboardEnabled:Boolean = true;
		
		private var _escEnabeld:Boolean = false;
		
		private var _showEffectEnabled:Boolean = false;
		
		private var _showEffect:IEffect;
		
		private var _removeEffect:IEffect;
		
		private var _removeEffectEnabled:Boolean = false;
		
		
		public function BaseGUIComponent()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(event:Event):void
		{
			_stage = stage;
			resetOtherMouseEnabled();
			resetKeyBoardEnabled();
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}
		
		private function onRemovedFromStage(event:Event):void
		{
			if(GUIDE_NAME != '')
			{
				EventDispatchCenter.getInstance().dispatchEvent(new Event(GUIDE_NAME));
			}
			this.removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			if (!_otherMouseEnabled)
			{
				cancelOtherMouseControl();
			}
			if (!_keyboardEnabled)
			{
				KeyBoardManager.instance.addListener();
			}
		}
		
		/**
		 * 重定位坐标
		 * @param w
		 * @param h
		 * 
		 */		
		public function resize(w:Number, h:Number):void
		{
			
		}
		
		/**
		 * 是否禁用下面显示列表的鼠标点击事件 
		 */	
		public function set otherMouseEnabled(value:Boolean):void
		{
			if (_otherMouseEnabled != value)
			{
				_otherMouseEnabled = value;
				if (stage){
					resetOtherMouseEnabled();
				}
			}
		}
		
		public function get otherMouseEnabled():Boolean
		{
			return _otherMouseEnabled;
		}
		
		private function resetOtherMouseEnabled():void
		{
			if (!_otherMouseEnabled)
				addOtherMouseControl();
			else
				cancelOtherMouseControl();
		}
		
		protected function addOtherMouseControl():void
		{
			_stage.addEventListener(MouseEvent.CLICK, onStageClick, true);
			_stage.addEventListener(MouseEvent.MOUSE_DOWN, onStageClick, true);
		}
		
		private function onStageClick(event:MouseEvent):void
		{
			var rect:Rectangle = this.getBounds(this.stage);
			if(event.stageX && !rect.contains(event.stageX, event.stageY))
			{
				event.stopPropagation();
			}
		}
		
		protected function cancelOtherMouseControl():void
		{
			this._stage.removeEventListener(MouseEvent.CLICK, onStageClick,true);
			this._stage.removeEventListener(MouseEvent.MOUSE_DOWN, onStageClick, true);
		}
		
		/**是否响应ESC按键*/
		public function get escEnabeld():Boolean
		{
			return _escEnabeld;
		}
		
		/**
		 * @private
		 */
		public function set escEnabeld(value:Boolean):void
		{
			_escEnabeld = value;
		}
		
		/**添加到舞台上时，是否应用动画效果*/
		public function get showEffectEnabled():Boolean
		{
			return _showEffectEnabled;
		}
		
		/**
		 * @private
		 */
		public function set showEffectEnabled(value:Boolean):void
		{
			_showEffectEnabled = value;
		}
		
		/**移除舞台时是否应用动画效果*/
		public function get removeEffectEnabled():Boolean
		{
			return _removeEffectEnabled;
		}
		
		/**
		 * @private
		 */
		public function set removeEffectEnabled(value:Boolean):void
		{
			_removeEffectEnabled = value;
		}
		
		/**
		 * 设置显示动画
		 * @param value
		 * 
		 */		
		public function set showEffect(value:IEffect):void
		{
			_showEffect = value;
		}
		
		/**
		 * 设置显示动画
		 * @param value
		 * 
		 */		
		public function get showEffect():IEffect
		{
			return _showEffect;
		}
		
		/**
		 * 播放显示时的动画
		 * @param data
		 * @return 
		 * 
		 */	
		public function playShowEffect(data:Object=null):void
		{
			if (_showEffectEnabled && _showEffect)
				_showEffect.play(this,data);
		}
		
		/**
		 * 移除舞台时的动画
		 * @param value
		 * 
		 */		
		public function set removeEffect(value:IEffect):void
		{
			_removeEffect = value;
		}
		
		/**
		 * 移除舞台时的动画
		 * @param value
		 * 
		 */		
		public function get removeEffect():IEffect
		{
			return _removeEffect;
		}
		
		/**
		 * 播放移除时的动画
		 * @param data
		 * @return 
		 * 
		 */		
		public function playRemoveEffect(data:Object=null):void
		{
			if (this.parent)
				this.parent.removeChild(this);
			if (_removeEffectEnabled && _removeEffect)
				_removeEffect.play(this,data);
		}
		
		protected function registerGuide():void
		{
			if (GUIDE_NAME != "")
			{
				GuideAssistantManager.registerPanel(GUIDE_NAME, this);
			}
		}
		
		/**
		 * 新手引导调用
		 * @param vo
		 * 
		 */		
		public function guideToDo(vo:GuideVO):void
		{
			var guideContanier:DisplayObjectContainer;
			var guideData:GuideInfo = new GuideInfo();
			guideData.gid = vo.id;
			guideData.dir = vo.dir;
			//取箭头父容器
			guideContanier = this;
			guideContanier = guideData.container = DisplayUtil.getObjectByExpress(guideContanier, vo.container) as DisplayObjectContainer;
			//取坐标参照物
			var posComponent:DisplayObject;
			var isSame:Boolean = false;
			if (vo.posReferComponent.length > 0){
				posComponent = this;
				posComponent = DisplayUtil.getObjectByExpress(this, vo.posReferComponent);
			}else{
				isSame = true;
				posComponent = guideContanier;
			}
			var p:Point = new Point(0,0);
			if (vo.posReferComponent.length > 0){
				p.x = posComponent.x;
				p.y = posComponent.y;
				var tindex:int; 
				var containArr:Array; 
				var arrParam:Array ;
				if (posComponent is GTabBar)
				{
					containArr= vo.posReferComponent.split(".");
					arrParam =  containArr[containArr.length-1].split("-");
					tindex = arrParam.length <= 1 ? 0 : arrParam[1];
					p.x += tindex * (posComponent as GTabBar).buttonWidth;
				}
			}
			p = GuideAssistantManager.getArrowPosition(p, guideData.dir, posComponent,isSame);
			if (vo.offsetX != 0)
				p.x = posComponent.x + vo.offsetX;
			if (vo.offsetY != 0)
				p.y = posComponent.y + vo.offsetY;
			if (posComponent != this && posComponent != null && guideContanier.stage && vo.offsetX == 0 && vo.offsetY == 0 && posComponent != guideContanier)
			{
				var localP:Point = posComponent.parent.localToGlobal(p);
				p = guideContanier.globalToLocal(localP);
//				if (guideContanier is GWindow)//guidepanel和mainui里面不需要这个
//					p.y = p.y - 30;
			}
			guideData.x = p.x;
			guideData.y = p.y;
			guideData.text = vo.text;
			
			var closeHandle:Function;
			var appproxy:EventDispatcher = this;
			if (vo.endTpye == 0)
			{
				GuideAssistantManager.completeAssistant(vo.id);
			}else if (vo.endTpye == 2)
			{
				GuideAssistantManager.completeAssistant(vo.id);
				if (posComponent is Button)
				{
					posComponent.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
				}
				return;
			}
			if (vo.endCondition.length > 0)
			{
				var con:GuideCondition = vo.endCondition[0];
				if (con.type == 1)
				{
					var endHandler:Function = function(e:Notification):void
					{
						PipeManager.removeMsg(con.data, this);
						if (vo.endTpye == 0)
							GuideAssistantManager.guideEnd(vo.id);
						else
							GuideAssistantManager.completeAssistant(vo.id);
					};
					PipeManager.registerMsg(con.data, endHandler, this);
				}
			}else{
				if (posComponent is SelectableList)
				{
					closeHandle = function(e:ListEvent):void
					{
						var containTabbar:Array = vo.posReferComponent.split(".");
						var tabbarParam:Array =  containTabbar[containTabbar.length-1].split("-");
						var index:int = tabbarParam.length <= 1 ? -1 : tabbarParam[1];
						if (index >= 0 && e.index != index)
							return;
						posComponent.removeEventListener(ListEvent.ITEM_CLICK, closeHandle);
						if (vo.endTpye == 0)
							GuideAssistantManager.guideEnd(vo.id);
						else
							GuideAssistantManager.completeAssistant(vo.id);
					};
					posComponent.addEventListener(ListEvent.ITEM_CLICK, closeHandle);
				}else if (posComponent is GTabBar)
				{
					closeHandle = function(e:MuiEvent):void
					{
						var containTabbar:Array = vo.posReferComponent.split(".");
						var tabbarParam:Array =  containTabbar[containTabbar.length-1].split("-");
						var index:int = tabbarParam.length <= 1 ? -1 : tabbarParam[1];
						if (index >= 0 && e.selectedIndex != index)
							return;
						posComponent.removeEventListener(MuiEvent.GTABBAR_SELECTED_CHANGE, closeHandle);
						if (vo.endTpye == 0)
							GuideAssistantManager.guideEnd(vo.id);
						else
							GuideAssistantManager.completeAssistant(vo.id);
					};
					posComponent.addEventListener(MuiEvent.GTABBAR_SELECTED_CHANGE, closeHandle);
				}else
				{
					closeHandle = function(e:MouseEvent):void
					{
						posComponent.removeEventListener(MouseEvent.CLICK, closeHandle);
						if (vo.endTpye == 0)
							GuideAssistantManager.guideEnd(vo.id);
						else
							GuideAssistantManager.completeAssistant(vo.id);
					};
					posComponent.addEventListener(MouseEvent.CLICK, closeHandle);
				}
			}
			POPWindowManager.updateModule(PipeEvent.STARTUP_ASSISTANT, PipeEvent.SHOW_ASSISTANT_MAINUI, guideData);
		}
		
		public function get isDragAble() : Boolean
		{
			return false;
		}
		
		public function get isDropAble() : Boolean
		{
			return true;
		}
		
		public function get isThrowAble() : Boolean
		{
			return false;
		}
		
		public function get dragSource() : Object
		{
			return {};
		}
		
		public function set dragSource(param1:Object) : void
		{
			return;
		}
		
		public function canDrop(param1:IDragDrop, param2:IDragDrop) : Boolean
		{
			return true;
		}
		
		/**
		 * 是否禁用键盘事件
		 */
		public function get keyboardEnabled():Boolean
		{
			return _keyboardEnabled;
		}
		
		/**
		 * @private
		 */
		public function set keyboardEnabled(value:Boolean):void
		{
			if (_keyboardEnabled != value)
			{
				_keyboardEnabled = value;
				if (stage){
					resetKeyBoardEnabled();
				}
			}
		}
		
		private function resetKeyBoardEnabled():void
		{
			if (!_keyboardEnabled)
				KeyBoardManager.instance.cancelListener();
			else
				KeyBoardManager.instance.addListener();
		}
	}
}