package com.thinkido.framework.common.sound.vo
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	/**
	 * 声音类数据，包含了sound 相关的信息 
	 * @author thinkido
	 * 
	 */
    public class SoundData extends EventDispatcher
    {
		/**
		 * 声音类 
		 */		
        public var sound:Sound;
        private var _channel:SoundChannel;
        private var _loopNum:int;
        private var _mute:Boolean = false;
        private var _pause:Boolean = false;
        private var _volume:Number = 1;
		/**
		 * 循环完成 
		 */		
        public static const LOOP_COMPLETE:String = "SoundData.LOOP_COMPLETE";
		/**
		 *  
		 * @param $sound sound 类
		 * @param $channel SoundChannel
		 * @param $loopNum 循环次数
		 * 
		 */
        public function SoundData($sound:Sound, $channel:SoundChannel, $loopNum:int = 0)
        {
            this.sound = $sound;
            this._channel = $channel;
            this._loopNum = $loopNum;
            this._volume = this._channel.soundTransform.volume;
            this._channel.addEventListener(Event.SOUND_COMPLETE, this.soundCompleteHandler);
            return;
        }

        public function getVolume() : Number
        {
            return this._volume;
        }

        public function setVolume(value1:Number) : void
        {
            this._volume = value1;
            this._channel.soundTransform = new SoundTransform(this._volume);
            return;
        }

        public function getMute() : Boolean
        {
            return this._mute;
        }

        public function setMute($mute:Boolean) : void
        {
            this._mute = $mute;
            if (this._mute)
            {
                this._channel.soundTransform = new SoundTransform(0);
            }
            else
            {
                this.setVolume(this.getVolume());
            }
            return;
        }

        public function getPause() : Boolean
        {
            return this._pause;
        }

        public function setPause($pause:Boolean) : void
        {
            var _pos:Number = NaN;
            this._pause = $pause;
            if (this._pause)
            {
                _pos = this._channel.position;
                this._channel.stop();
            }
            else
            {
                this._channel.removeEventListener(Event.SOUND_COMPLETE, this.soundCompleteHandler);
                this._channel = this.sound.play(this._channel.position, 0, this._channel.soundTransform);
                this._channel.addEventListener(Event.SOUND_COMPLETE, this.soundCompleteHandler);
            }
            return;
        }

        private function soundCompleteHandler(event:Event) : void
        {
            this._channel.removeEventListener(Event.SOUND_COMPLETE, this.soundCompleteHandler);
            if (this._loopNum > 0)
            {
				_loopNum -=1 ;
                this._channel = this.sound.play(0, 0, this._channel.soundTransform);
				if (_channel)
                	this._channel.addEventListener(Event.SOUND_COMPLETE, this.soundCompleteHandler);
            }
            else
            {
                this.dispatchEvent(new Event(LOOP_COMPLETE));
            }
            return;
        }
		/**
		 * 停止播放 
		 */
        public function stopAndDispose() : void
        {
            this._channel.removeEventListener(Event.SOUND_COMPLETE, this.soundCompleteHandler);
            this._channel.stop();
            this._loopNum = 0;
            return;
        }

    }
}
