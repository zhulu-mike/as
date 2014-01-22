package com.thinkido.framework.engine.graphics.layers
{
    import com.thinkido.framework.common.events.EventDispatchCenter;
    import com.thinkido.framework.common.vo.StyleData;
    import com.thinkido.framework.engine.Scene;
    import com.thinkido.framework.engine.SceneCharacter;
    import com.thinkido.framework.engine.events.SceneEvent;
    import com.thinkido.framework.engine.events.SceneEventAction_interactive;
    import com.thinkido.framework.engine.vo.map.MapTile;
    import com.thinkido.framework.utils.DrawUtil;
    
    import flash.display.Sprite;
    import flash.events.MouseEvent;
    import flash.geom.Point;
    import flash.utils.getTimer;
	/**
	 * 引擎鼠标加护层,捕获分析处理鼠标事件 
	 * @author Administrator
	 * 
	 */
    public class SceneInteractiveLayer extends Sprite
    {
        private var _scene:Scene;
        private var _fristMouseDownTime:int = -1;
        private var _fristMouseDownPos:Point = null;
        private static const DOUBLE_CLICK_TIME:int = 500;
        private static const DOUBLE_CLICK_DIS:Number = 100;

        public function SceneInteractiveLayer($scene:Scene)
        {
            this._scene = $scene;
            doubleClickEnabled = false;
            return;
        }
		/**
		 * 初始化场景交互区域 
		 * 
		 */
        public function initRange() : void
        {
            DrawUtil.drawRect(this, new Point(0, 0), new Point(this._scene.mapConfig.width, this._scene.mapConfig.height), new StyleData(0, 0, 0, 0, 0), true);
            return;
        }
		/**
		 * 监听场景鼠标事件 
		 * 
		 */
        public function enableInteractiveHandle() : void
        {
            this.addEventListener(MouseEvent.MOUSE_DOWN, this.mouseHandle);
            this.addEventListener(MouseEvent.MOUSE_MOVE, this.mouseHandle);
            this.addEventListener(MouseEvent.MOUSE_OUT, this.mouseHandle);
			if(stage != null){
				stage.addEventListener(MouseEvent.MOUSE_UP, this.mouseHandle);
			}else{
				trace("enableInteractiveHandle warn!");
			}
			return;
        }
		/**
		 * 取消监听鼠标事件 
		 * 
		 */
        public function disableInteractiveHandle() : void
        {
            this.removeEventListener(MouseEvent.MOUSE_DOWN, this.mouseHandle);
            this.removeEventListener(MouseEvent.MOUSE_MOVE, this.mouseHandle);
            this.removeEventListener(MouseEvent.MOUSE_OUT, this.mouseHandle);
			if(stage != null){
				stage.removeEventListener(MouseEvent.MOUSE_UP, this.mouseHandle);
			}else{
				trace("disableInteractiveHandle warn!");
			}
			return;
        }

        private function mouseHandle(event:MouseEvent) : void
        {
            var targetsArr:Array = null;
            var sEvt:SceneEvent = null;
            var sc:SceneCharacter = null;
            var mapTile:MapTile = null;
            var scArr:Array = null;
            var hitScArr:Array = null;
            var nowTime:int = 0;
            var targetPoint:Point = new Point(this.mouseX, this.mouseY);
            switch(event.type)
            {
                case MouseEvent.MOUSE_MOVE:
                {
                    targetsArr = this._scene.getSceneObjectsUnderPoint(targetPoint);
                    mapTile = targetsArr[0];
                    scArr = targetsArr[1];
                    hitScArr = targetsArr[2];
                    if (mapTile != null)
                    {
                        if (scArr.length > 0)
                        {
                            sc = scArr[0];
                        }
                        else if (hitScArr.length > 0)
                        {
                            sc = this.getHitSceneCharacter(hitScArr, targetPoint);
                        }
                        sEvt = new SceneEvent(SceneEvent.INTERACTIVE, SceneEventAction_interactive.MOUSE_MOVE, [event, sc, mapTile]);
                        EventDispatchCenter.getInstance().dispatchEvent(sEvt);
                    }
                    break;
                }
                case MouseEvent.MOUSE_DOWN:
                {
                    targetsArr = this._scene.getSceneObjectsUnderPoint(targetPoint);
                    mapTile = targetsArr[0];
                    scArr = targetsArr[1];
                    hitScArr = targetsArr[2];
                    if (mapTile != null)
                    {
                        if (scArr.length > 0)
                        {
                            sc = scArr[0];
                        }
                        else if (hitScArr.length > 0)
                        {
                            sc = this.getHitSceneCharacter(hitScArr, targetPoint);
                        }
                        nowTime = getTimer();
                        if (this._fristMouseDownTime == -1 || nowTime - this._fristMouseDownTime > DOUBLE_CLICK_TIME || this._fristMouseDownPos == null || (this._fristMouseDownPos.x - targetPoint.x) * (this._fristMouseDownPos.x - targetPoint.x) + (this._fristMouseDownPos.y - targetPoint.y) * (this._fristMouseDownPos.y - targetPoint.y) > DOUBLE_CLICK_DIS * DOUBLE_CLICK_DIS)
                        {
                            this._fristMouseDownTime = nowTime;
                            this._fristMouseDownPos = targetPoint;
                            sEvt = new SceneEvent(SceneEvent.INTERACTIVE, SceneEventAction_interactive.MOUSE_DOWN, [event, sc, mapTile]);
                            EventDispatchCenter.getInstance().dispatchEvent(sEvt);
                        }
                        else
                        {
                            this._fristMouseDownTime = -1;
                            this._fristMouseDownPos = null;
                            sEvt = new SceneEvent(SceneEvent.INTERACTIVE, SceneEventAction_interactive.DOUBLE_CLICK, [event, sc, mapTile]);
                            EventDispatchCenter.getInstance().dispatchEvent(sEvt);
                        }
                    }
                    break;
                }
                case MouseEvent.MOUSE_UP:
                {
                    sEvt = new SceneEvent(SceneEvent.INTERACTIVE, SceneEventAction_interactive.MOUSE_UP, [event, null, null]);
                    EventDispatchCenter.getInstance().dispatchEvent(sEvt);
                    break;
                }
                case MouseEvent.MOUSE_OUT: 
                {
                    sEvt = new SceneEvent(SceneEvent.INTERACTIVE, SceneEventAction_interactive.MOUSE_OUT, [event, null, null]);
                    EventDispatchCenter.getInstance().dispatchEvent(sEvt);
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }

        private function getHitSceneCharacter(scs:Array, testPoint:Point) : SceneCharacter
        {
            var sc:SceneCharacter = null;
            for each (sc in scs)
            {
                if (sc.hitPoint(testPoint))
                {
                    return sc;
                }
            }
            return null;
        }

    }
}
