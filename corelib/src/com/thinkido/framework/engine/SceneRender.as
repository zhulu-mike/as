package com.thinkido.framework.engine
{
	import com.thinkido.framework.engine.tools.SceneCache;
	
	import flash.events.Event;
	import flash.utils.getTimer;
	/**
	 * 场景渲染,作为所有需要渲染的入口
	 * @author Administrator
	 * 
	 */
    public class SceneRender extends Object
    {
        private var _scene:Scene;
        private var _isRendering:Boolean = false;
        public static var nowTime:int;

        public function SceneRender(scene:Scene)
        {
            _scene = scene;
        }

        public function get isRendering() : Boolean
        {
            return _isRendering;
        }
		/**
		 *开始渲染 
		 * @param now ture:立刻渲染 ，false:监听帧频渲染
		 * 
		 */
        public function startRender(now:Boolean = false) : void
        {
            if (now)
            {
                render();
            }
            if (!_isRendering)
            {
                _scene.addEventListener(Event.ENTER_FRAME, render);
                _isRendering = true;
            }
        }
		/**
		 * 停止渲染 
		 * 
		 */
        public function stopRender() : void
        {
            if (_isRendering)
            {
                _scene.removeEventListener(Event.ENTER_FRAME, render);
                _isRendering = false;
            }
        }

        private function render(evt:Event = null) : void
        {
            var chara:SceneCharacter = null;
			trace("上帧时间："+(getTimer()-nowTime));
            nowTime = getTimer();
            var charaArr:Array = _scene.sceneCharacters;
			var t:int = nowTime;
            for each (chara in charaArr)
            {
                chara.runWalk();
            }
//			trace("走路时间："+(getTimer()-t));
//			t = getTimer();
            _scene.sceneCamera.run();
//			trace("摄像头时间："+(getTimer()-t));
//			t = getTimer();
            _scene.sceneMapLayer.run();
//			trace("地图时间："+(getTimer()-t));
//			t = getTimer();
            _scene.sceneAvatarLayer.run();
//			trace("绘图时间："+(getTimer()-t));
//			t = getTimer();
            _scene.sceneHeadLayer.run();
//			trace("头顶时间："+(getTimer()-t));
//			t = getTimer();
            SceneCache.checkUninstall();
			trace("总共时间："+(getTimer()-t));
        }

    }
}
