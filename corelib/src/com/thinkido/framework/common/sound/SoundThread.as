package com.thinkido.framework.common.sound
{
    import com.thinkido.framework.common.sound.vo.*;
    import com.thinkido.framework.manager.RslLoaderManager;
    import com.thinkido.framework.manager.SoundManager;
    
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.media.Sound;
    import flash.media.SoundChannel;
    import flash.media.SoundTransform;
    import flash.net.URLRequest;
    
	/**
	 * 声音线程，可以同时控制播放多个声音文件
	 * @author thinkido
	 * 
	 */
    public class SoundThread extends Object
    {
        private var _soundArr:Array;
        private var _mute:Boolean = false;
        private var _pause:Boolean = false;
        private var _volume:Number = 1;

        public function SoundThread()
        {
            this._soundArr = [];
            return;
        }
		/**
		 * 获取声音数目 
		 * @return  声音数
		 * 
		 */
        public function getSoundsNum() : int
        {
            return this._soundArr.length;
        }
		/**
		 * 获取音量 
		 * @return 
		 * 
		 */
        public function getVolume() : Number
        {
            return this._volume;
        }
		/**
		 *  设置音量
		 * @param value
		 * 
		 */
        public function setVolume(value:Number) : void
        {
            var _sd:SoundData = null;
            if (value < 0)
            {
                value = 0;
            }
            if (value > 1)
            {
                value = 1;
            }
            if (this._volume != value)
            {
                this._volume = value;
                for each (_sd in this._soundArr)
                {
                    
                    _sd.setVolume(this._volume);
                }
            }
            return;
        }
		/**
		 * 是否静音 
		 * @return 
		 * 
		 */
        public function getMute() : Boolean
        {
            return this._mute;
        }
		/**
		 * 设置静音
		 * @param $mute
		 * 
		 */
        public function setMute(value:Boolean) : void
        {
            var _sd:SoundData = null;
            if (this._mute != value)
            {
                this._mute = value;
                for each (_sd in this._soundArr)
                {
                    
                    _sd.setMute(this._mute);
                }
            }
            return;
        }
		/**
		 * 是否暂停 
		 * @return 
		 * 
		 */
        public function getPause() : Boolean
        {
            return this._pause;
        }
		/**
		 * 设置暂停 
		 * @param value
		 * 
		 */
        public function setPause(value:Boolean) : void
        {
            var _sd:SoundData = null;
            if (this._pause != value)
            {
                this._pause = value;
                for each (_sd in this._soundArr)
                {
                    _sd.setPause(this._pause);
                }
            }
            return;
        }
		/**
		 * 判断是否有某个声音 
		 * @param $sd
		 * @return 
		 * 
		 */
        public function hasSound($sd:SoundData) : Boolean
        {
            return this._soundArr.indexOf($sd) != -1;
        }
		/**
		 * 删除 $sd 制定的声音
		 * @param $sd
		 * 
		 */
        public function removeSound($sd:SoundData) : void
        {
            var _sd:SoundData = null;
            for each (_sd in this._soundArr)
            {
                
                if (_sd == $sd)
                {
                    _sd.removeEventListener(SoundData.LOOP_COMPLETE, this.soundLoopCompleteHandler);
                    _sd.stopAndDispose();
                    this._soundArr.splice(this._soundArr.indexOf(_sd), 1);
                    break;
                }
            }
            return;
        }
		/**
		 * 删除所有声音 
		 */
        public function removeAllSounds() : void
        {
            var _sd:SoundData = null;
            for each (_sd in this._soundArr)
            {
                _sd.removeEventListener(SoundData.LOOP_COMPLETE, this.soundLoopCompleteHandler);
                _sd.stopAndDispose();
            }
            this._soundArr = [];
            return;
        }
		/**
		 * 播放声音 
		 * @param $sound 类名或 url 
		 * @param $startTime 开始时间
		 * @param $loops 循环
		 * @param $selfVolume 音量
		 * @return 声音类
		 */
        public function playSound($sound:String, $startTime:Number = 0, $loops:int = 0, $selfVolume:Number = -1) : SoundData
        {
            var sd:SoundData;
            var sound:Sound;
            var re1:RegExp;
            var re2:RegExp;
            var str1True:Boolean;
            var str2True:Boolean;
            var selfVolume:Number;
            var nowSoundTransform:SoundTransform;
            var channel:SoundChannel;
            if (SoundManager.soundCache.has($sound))
            {
                sound = SoundManager.soundCache.get($sound) as Sound;
            }
            else
            {
                sound = RslLoaderManager.getInstance($sound) as Sound;
                if (sound)
                {
                    SoundManager.soundCache.push(sound, $sound);
                }
                else
                {
//                    $sound = $sound.toLowerCase();
                    re1 = new RegExp("^.+.mp3");
                    re2 = new RegExp("^.+.wmv");
                    str1True = re1.test($sound);
                    str2True = re2.test($sound);
                    if (str1True || str2True)
                    {
                        sound = new Sound();
                        sound.addEventListener(Event.COMPLETE, this.soundLoadHandler);
                        sound.addEventListener(IOErrorEvent.IO_ERROR, this.soundLoadHandler);
                        sound.load(new URLRequest($sound));
                    }
                }
            }
            if (sound == null)
            {
                return sd;
            }
            try
            {
                selfVolume = $selfVolume >= 0 && $selfVolume <= 1 ? ($selfVolume) : (this._volume);
                nowSoundTransform = new SoundTransform(selfVolume);
                channel = sound.play($startTime, 0, nowSoundTransform);
                if (channel != null)
                {
                    sd = new SoundData(sound, channel, ($loops - 1));
                    sd.addEventListener(SoundData.LOOP_COMPLETE, this.soundLoopCompleteHandler);
                    this._soundArr.push(sd);
                    if (this._mute)
                    {
                        sd.setMute(true);
                    }
                    if (this._mute)
                    {
                        sd.setPause(true);
                    }
                }
            }
            catch (e:Error)
            {
            }
            return sd;
        }

        private function soundLoadHandler($loadData:*) : void
        {
            var _sd:SoundData = null;
            var _data:* = $loadData.currentTarget;
            switch($loadData.type)
            {
                case Event.COMPLETE:
                {
                    SoundManager.soundCache.push(_data, _data.url);
                    break;
                }
                case IOErrorEvent.IO_ERROR:
                {
                    for each (_sd in this._soundArr)
                    {
                        
                        if (_sd.sound == _data)
                        {
                            _sd.removeEventListener(SoundData.LOOP_COMPLETE, this.soundLoopCompleteHandler);
                            _sd.stopAndDispose();
                            this._soundArr.splice(this._soundArr.indexOf(_sd), 1);
                        }
                    }
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }

        private function soundLoopCompleteHandler(event:Event) : void
        {
            var _sd:SoundData = null;
            var _loadSD:SoundData = event.currentTarget as SoundData;
            for each (_sd in this._soundArr)
            {
                if (_sd == _loadSD)
                {
                    _sd.removeEventListener(SoundData.LOOP_COMPLETE, this.soundLoopCompleteHandler);
                    _sd.stopAndDispose();
                    this._soundArr.splice(this._soundArr.indexOf(_sd), 1);
                    break;
                }
            }
            return;
        }

    }
}
