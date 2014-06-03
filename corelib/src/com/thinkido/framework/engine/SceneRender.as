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

		private var frame:int = 0;
		private var lastTime:int = 0;
		
        private function render(evt:Event = null) : void
        {
            var chara:SceneCharacter = null;
            nowTime = getTimer();
            var charaArr:Array = _scene.sceneCharacters;
			var t:int = nowTime;
            for each (chara in charaArr)
            {
                chara.runWalk();
            }
			frame++;
			if ( nowTime - lastTime >= 1000){
				lastTime = nowTime ;
				_scene.fps = frame ;
				frame = 0;
			}
            _scene.sceneCamera.run();
            _scene.sceneMapLayer.run();
            _scene.sceneAvatarLayer.run();
            _scene.sceneHeadLayer.run();
        }

    }
}
