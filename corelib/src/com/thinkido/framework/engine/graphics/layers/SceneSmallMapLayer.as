package com.thinkido.framework.engine.graphics.layers
{
    
    import com.thinkido.framework.engine.Scene;
    import com.thinkido.framework.utils.SystemUtil;
    
    import flash.display.Sprite;
	/**
	 * 场景马赛克地图层 
	 * @author Administrator
	 * 
	 */
    public class SceneSmallMapLayer extends Sprite
    {
        private var _scene:Scene;

        public function SceneSmallMapLayer(value1:Scene)
        {
            this._scene = value1;
            mouseEnabled = false;
            mouseChildren = false;
            return;
        }

        public function dispose() : void
        {
            SystemUtil.clearChildren(this, false, false);
            return;
        }

    }
}
