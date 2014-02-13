package com.thinkido.framework.engine.vo.avatar
{
	import com.thinkido.framework.common.dispose.DisposeHelper;
	
	import flash.utils.Dictionary;

	/**
	 * 状态 
	 * @author thinkido
	 * 对应<s k="death" t="110" a="8" f="4">
	    <p a="0" f="0" sx="0" sy="182" w="129" h="123" tx="86" ty="84" ox="0" oy="0"/>
	    <p a="0" f="1" sx="0" sy="0" w="65" h="182" tx="41" ty="143" ox="0" oy="0"/>
	  </s>
	 */
    public class AvatarPartStatus extends Object
    {
		/**
		 * 每帧播放时间 
		 */		
		public var fullSourchPath:String;
		public var frame:int;
		/**
		 * 用以区分老旧资源，现在已经无用 
		 */		
		public var angle:int;
		public var time:int;
		private var _apd_dict:Dictionary;
		
		/**
		 *  
		 * 
		 */
		public function AvatarPartStatus($fullSourchPath:String, $xml:XML)
		{
			var _apdXml:XML = null;
			var _apd:AvatarPartData = null;
			var _tempAngle:int = 0;
			var _angle:int = 0;
			var _frame:int = 0;
			var _sysApd:AvatarPartData = null;
			this.fullSourchPath = $fullSourchPath;
			this.frame = $xml.@f;
			this.angle = $xml.@a;
			if (this.angle != 1)
			{
				this.angle = 8;
			}
			this.time = $xml.@t;
			this._apd_dict = new Dictionary();
			for each (_apdXml in $xml.children())
			{
				_apd = new AvatarPartData(_apdXml);
				this._apd_dict[_apd.angle + "_" + _apd.frame] = _apd;
			}
			if (this.angle != 1)
			{
				_tempAngle = 1;
				while (_tempAngle <= 3)
				{
					_angle = _tempAngle;
					if (_tempAngle == 1)
					{
						_angle = 7;
					}
					else if (_tempAngle == 2)
					{
						_angle = 6;
					}
					else if (_tempAngle == 3)
					{
						_angle = 5;
					}
					_frame = 0;
					while (_frame < this.frame)
					{
						_sysApd = this.getAvatarPartData(_angle, _frame);
						if (_sysApd != null)
						{
							_apdXml = new XML("<p a=\"" + _tempAngle + "\" f=\"" + _frame + "\" sx=\"0\" sy=\"0\" w=\"" + _sysApd.width + "\" h=\"" + _sysApd.height + "\" tx=\"" + (_sysApd.width - _sysApd.tx) + "\" ty=\"" + _sysApd.ty + "\" ox=\"0\" oy=\"0\"/>");
							_apd = new AvatarPartData(_apdXml);
							DisposeHelper.add(_apdXml);
							_apdXml = null;
							this._apd_dict[_apd.angle + "_" + _apd.frame] = _apd;
						}
						_frame++;
					}
					_tempAngle++;
				}
			}
			return;
		}

		
		/**
		 * 获取某个方向的某一帧的图片数据
		 * @param $angle
		 * @param $frame
		 * @return 
		 * 
		 */		
        public function getAvatarPartData($angle:int, $frame:int) : AvatarPartData
        {
            var key:String = $angle + "_" +  $frame ;
            if (this._apd_dict != null && this._apd_dict.hasOwnProperty(key))
            {
                return this._apd_dict[key] as AvatarPartData;
            }
            return null;
        }

    }
}
