package com.thinkido.framework.manager
{
	import com.thinkido.framework.common.cache.Cache;
	import com.thinkido.framework.common.sound.SoundThread;
	import com.thinkido.framework.common.sound.vo.SoundData;
	/**
	 * 声音管理类，统一管理存储声音类 
	 * @author thinkido
	 * 
	 */
	public class SoundManager
	{
		private static var instance : SoundManager;
		public static var soundCache:Cache = CacheManager.creatNewCache("soundCache", 50);
		private static var _defaultSoundThread:SoundThread = new SoundThread();
		private static var _soundThreadArr:Array = [_defaultSoundThread];

		
	    public function SoundManager()
	    {   
      		if ( instance != null )
	        {
				throw new Error("ResourceManager is singleton" );
	        }
	       instance = this;
	    }
	    
	    public static function getInstance() : SoundManager 
	    {
	       if ( instance == null )
		           instance = new SoundManager();
	           
		       return instance;
	    }
		
		public static function getSoundThreadsNum() : int
		{
			return _soundThreadArr.length;
		}
		
		public static function getSoundsNum() : int
		{
			var _st:SoundThread = null;
			var _num:Number = 0;
			for each (_st in _soundThreadArr)
			{
				_num = _num + _st.getSoundsNum();
			}
			return _num;
		}
		
		public static function creatNewSoundThread() : SoundThread
		{
			var _st:SoundThread = new SoundThread();
			_soundThreadArr[_soundThreadArr.length] = new SoundThread();
			return _st;
		}
		
		public static function playSound($sound:String, $startTime:Number = 0, $loop:int = 0, $selfVolume:Number = -1, $st:SoundThread = null) : SoundThread
		{
			var _st:SoundThread = null;
			if ($st != null)
			{
				_st = $st;
				if (!hasSoundThread(_st))
				{
					_soundThreadArr.push(_st);
				}
			}
			else
			{
				_st = _defaultSoundThread;
			}
			_st.playSound($sound, $startTime, $loop, $selfVolume);
			return _st;
		}
		/**
		 * 设置音量 
		 * @param value
		 * 
		 */		
		public static function setVolume(value:Number) : void
		{
			var _st:SoundThread = null;
			for each (_st in _soundThreadArr)
			{
				_st.setVolume(value);
			}
			return;
		}
		/**
		 * 静音 
		 * @param $mute true：静音
		 * 
		 */		
		public static function setMute($mute:Boolean) : void
		{
			var _st:SoundThread = null;
			for each (_st in _soundThreadArr)
			{
				_st.setMute($mute);
			}
			return;
		}
		/**
		 * 暂停 
		 * @param value
		 * 
		 */		
		public static function setPause(value:Boolean) : void
		{
			var _st:SoundThread = null;
			for each (_st in _soundThreadArr)
			{
				_st.setPause(value);
			}
			return;
		}
		
		public static function getDefaultSoundThread() : SoundThread
		{
			return _defaultSoundThread;
		}
		
		public static function removeAllSoundThreads() : void
		{
			removeAllSounds();
			_soundThreadArr = [];
			return;
		}
		/**
		 * 删除所有声音 
		 */		
		public static function removeAllSounds() : void
		{
			var _st:SoundThread = null;
			for each (_st in _soundThreadArr)
			{
				_st.removeAllSounds();
			}
			return;
		}
		
		public static function removeSoundThread($st:SoundThread) : void
		{
			var _st:SoundThread = null;
			if (!$st)
			{
				return;
			}
			for each (_st in _soundThreadArr)
			{
				if (_st == $st)
				{
					_st.removeAllSounds();
					_soundThreadArr.splice(_soundThreadArr.indexOf(_st), 1);
					break;
				}
			}
			return;
		}
		/**
		 * 删除声音 
		 * @param $sd 需要删除的声音
		 */		
		public static function removeSound($sd:SoundData) : void
		{
			var _st:SoundThread = null;
			if ($sd == null)
			{
				return;
			}
			for each (_st in _soundThreadArr)
			{
				_st.removeSound($sd);
			}
			return;
		}
		
		public static function hasSoundThread($st:SoundThread) : Boolean
		{
			return _soundThreadArr.indexOf($st) != -1;
		}
		
		public static function hasSound($sd:SoundData) : Boolean
		{
			var _st:SoundThread = null;
			for each (_st in _soundThreadArr)
			{
				if (_st.hasSound($sd))
				{
					return true;
				}
			}
			return false;
		}
		
//		播放
//		播放单个声音可重复
//		播放单个声音不可重复，即该声音重头开始播放
//		播放多个声音，分（背景音乐，特效音乐）
//		按序列播放声音，完成后回调
//		同时播放声音，完成后回调
		
//		停止
		/**
		 *立即停止 
		 */		
	}
}