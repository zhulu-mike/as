package com.thinkido.framework.common
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	/**
	 * 游戏、程序基类 
	 * @author Administrator
	 * 做基本的init和 stage.align 的设置
	 */
    public class Application extends Sprite
    {

        public function Application()
        {
            if (stage)
            {
                this.init();
            }
            else
            {
                this.addEventListener(Event.ADDED_TO_STAGE, this.init);
            }
            return;
        }

        private function init(event:Event = null) : void
        {
            Global.instance.initStage(this.stage);
            Global.application = this;
            this.initApp();
			stage.align = StageAlign.TOP_LEFT ;
			stage.scaleMode = StageScaleMode.NO_SCALE ;
            return;
        }

        protected function initApp() : void
        {
            return;
        }

    }
}
