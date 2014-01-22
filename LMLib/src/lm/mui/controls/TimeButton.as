package lm.mui.controls
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import lm.mui.interfaces.IDispose;
	

    public class TimeButton extends GButton implements IDispose
    {
        private var _timeCount:int;
        private var _timer:Timer;
        private var _templabel:String;
        private var _isClickTrigger:Boolean;
//        private var _freezingEffect:FreezingEffect;
        private var _type:String;
//        private var _cdItemData:CDItemData;
        public static const COUNDDOWN:String = "countDown";
        public static const CD:String = "cd";
		public static const TIME_OVER:String = 'TIME_OVER';
		
		public var tog:Boolean = false;  		//true	CD期间鼠标事件有效

        public function TimeButton(param1:int = 5, param2:Boolean = true, param3:String = "countDown")
        {
            this._timeCount = param1;
            this._isClickTrigger = param2;
            this._type = param3;
            if (this._type == COUNDDOWN)
            {
                this._timer = new Timer(1000, this._timeCount);
            }
            if (this._type == CD)
            {
//                this._freezingEffect = new FreezingEffect();
//                this._freezingEffect.setMaskSize(33, 22);
            }
            this.addListeners();
            return;
        }

        private function addListeners() : void
        {
            this.addEventListener(MouseEvent.CLICK, this.clickHandler);
            return;
        }

        private function clickHandler(event:MouseEvent) : void
        {
            if (this._isClickTrigger)
            {
                this.trigger();
            }
            return;
        }

        public function trigger() : void
        {
            if (this._type == COUNDDOWN)
            {
                this.triggerByCoundDown();
            }
            if (this._type == CD)
            {
                this.triggerByCD();
            }
            return;
        }

        private function triggerByCoundDown() : void
        {
            if (!this._timer.running)
            {
                this._templabel = this.label;
            }
            this._timer.reset();
            this._timer.start();
            this.addCountDownListeners();
            this.label =this._templabel + '(' + this._timeCount.toString() + ')';
			
			if(this.tog == false)
			{
				this.enabled = false;
			}
            
            return;
        }

        private function addCountDownListeners() : void
        {
            this._timer.addEventListener(TimerEvent.TIMER, this.showTextHandler);
            this._timer.addEventListener(TimerEvent.TIMER_COMPLETE, this.complete_Handler);
            return;
        }

        private function removeCountDownListeners() : void
        {
            this._timer.removeEventListener(TimerEvent.TIMER, this.showTextHandler);
            this._timer.removeEventListener(TimerEvent.TIMER_COMPLETE, this.complete_Handler);
            return;
        }

        private function showTextHandler(event:TimerEvent) : void
        {
            this.label = this._templabel + '(' + (this._timer.repeatCount - this._timer.currentCount).toString() + ')';
            return;
        }

        private function complete_Handler(event:TimerEvent) : void
        {
			this.dispatchEvent(new Event(TIME_OVER));
            this.label = this._templabel;
            this.enabled = true;
            this.removeCountDownListeners();
            return;
        }

        private function triggerByCD() : void
        {
           /* if (!this._cdItemData)
            {
                this._cdItemData = new CDItemData();
                this._cdItemData.totalTime = this._timeCount;
            }
            this._freezingEffect.cdTime = this._cdItemData;
            this.enabled = false;
            this._freezingEffect.x = this.width / 2;
            this._freezingEffect.y = this.height / 2;
            this.addChild(this._freezingEffect);
            this._cdItemData.startCoolDown();
            this._freezingEffect.addEventListener(Event.COMPLETE, this.completeHandler);*/
            return;
        }

        private function completeHandler(event:Event) : void
        {
            this.enabled = true;
           /* if (this._freezingEffect.parent)
            {
                this._freezingEffect.parent.removeChild(this._freezingEffect);
            }*/
            return;
        }
		
		public function stop():void
		{
			if(this._timer)
			{
				this._timer.stop();
			}
		}

        public function dispose(param1:Boolean = true) : void
        {
            if (this._timer)
            {
                this.removeCountDownListeners();
                this._timer.stop();
                this._timer = null;
            }
            return;
        }

    }
}
