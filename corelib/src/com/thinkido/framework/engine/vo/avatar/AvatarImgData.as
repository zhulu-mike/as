package com.thinkido.framework.engine.vo.avatar
{
    import com.thinkido.framework.common.dispose.DisposeHelper;
    import com.thinkido.framework.manager.RslLoaderManager;
    
    import flash.display.BitmapData;
    import flash.geom.Matrix;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.utils.Dictionary;
    
	/**
	 * 场景中物体图片数据对象 
	 * @author thinkido.com
	 * 
	 */
    public class AvatarImgData extends Object
    {
		private var _aps:AvatarPartStatus;
		private var _dir07654:Dictionary;
		private var _dir123Dict:Dictionary;
		private var _status:String;
		private var _baseClassName:String;
		
		public function AvatarImgData(aps:AvatarPartStatus, status:String, className:String)
		{
			this._aps = aps;
			this._status = status;
			this._baseClassName = className;
			_dir07654 = new Dictionary();
			return;
		}
		
		public function getBitmapData(angle:int, frame:int) : BitmapData
		{
			var _key:String = "";
			var _angle:int = 0;
			var _apd:AvatarPartData = null;
			var _w:Number = NaN;
			var _h:Number = NaN;
			var i:int = 0;
			var _matrix:Matrix = null;
			var _bitmapdata:BitmapData = null;
			var _tempBMD:BitmapData;
			var className:String = _baseClassName + _status;
			var key:String = className + angle;
			_key = angle + "_" + frame;
		
			if (angle == 0 || angle >= 4)
			{
				if (_dir07654[key] == null)
				{
					_tempBMD = RslLoaderManager.getInstance(key,0,0) as BitmapData;
					_dir07654[key] = new AvatarImgDirectData(_tempBMD,_aps,angle);
				}
				return (_dir07654[key] as AvatarImgDirectData).getFrameBitmapData(frame);
			}
			
			if (this._dir07654 != null && this._aps.angle == 8)
			{
				this._dir123Dict = this._dir123Dict || new Dictionary();
				if (this._dir123Dict[_key])
				{
					return this._dir123Dict[_key] as BitmapData;
				}
				_angle = angle;
				if (angle == 1)
				{
					_angle = 7;
				}
				else if (angle == 2)
				{
					_angle = 6;
				}
				else if (angle == 3)
				{
					_angle = 5;
				}
				key = className + _angle;
				_apd = this._aps.getAvatarPartData(_angle, frame);
				if (_apd != null)
				{
					_w = _apd.width;
					_h = _apd.height;
					_matrix = new Matrix();
					_matrix.scale(-1, 1);
					_matrix.translate(_w, 0);
					_bitmapdata = new BitmapData(_w, _h, true, 0);
					if (this._dir07654[key] == null)
					{
						_tempBMD = RslLoaderManager.getInstance(key,0,0) as BitmapData;
						_dir07654[key] = new AvatarImgDirectData(_tempBMD,_aps,angle);
					}
					_bitmapdata.draw((this._dir07654[key] as AvatarImgDirectData).getFrameBitmapData(frame), _matrix, null, null, new Rectangle(0, 0, _w, _h));
					this._dir123Dict[_key] = _bitmapdata;
					return this._dir123Dict[_key] as BitmapData;
				}
			}
			return null;
		}
		
		public function dispose() : void
		{
			var _key:String = null;
			var _bmd:BitmapData = null;
			var direct:AvatarImgDirectData;
			this._aps = null;
			if (this._dir07654 != null)
			{
				for (_key in this._dir07654)
				{
					direct = this._dir07654[_key];
					direct.dispose();
				}
				this._dir07654 = null;
			}
			if (this._dir123Dict != null)
			{
				for (_key in this._dir123Dict)
				{
					_bmd = this._dir123Dict[_key];
					DisposeHelper.add(_bmd);
					_bmd = null;
				}
				this._dir123Dict = null;
			}
			return;
		}

    }
}
