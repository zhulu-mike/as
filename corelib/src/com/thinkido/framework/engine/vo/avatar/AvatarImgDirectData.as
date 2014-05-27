package com.thinkido.framework.engine.vo.avatar
{
	import com.thinkido.framework.common.dispose.DisposeHelper;
	import com.thinkido.framework.engine.utils.FrameUtil;
	
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;

	public class AvatarImgDirectData
	{
		
		private var frameDic:Dictionary;
		private var source:BitmapData;
		private var used:int;
		private var direct:int;
		private var aps:AvatarPartStatus;
		
		public function AvatarImgDirectData(bmd:BitmapData, aps:AvatarPartStatus, dir:int)
		{
			source = bmd;
			direct  = dir;
			this.aps  = aps;
			frameDic = new Dictionary();
		}
		
		public function getFrameBitmapData(frame:int):BitmapData
		{
			if (frameDic[frame])
			{
				return frameDic[frame] as BitmapData;
			}
			makeFrameBMD(frame);
			return frameDic[frame] as BitmapData;
		}
		
		private function makeFrameBMD(frame:int):void
		{
			used++;
			var apd:AvatarPartData = aps.getAvatarPartData(direct,frame);
			if (apd)
			{
				var _bitmapdata:BitmapData = new BitmapData(apd.width, apd.height,true,0);
				_bitmapdata.copyPixels(source,new Rectangle(apd.sx,apd.sy,apd.width, apd.height),new Point());
				frameDic[frame] = _bitmapdata;
			}else{
				frameDic[frame] = true;
			}
			if (used >= aps.frame)
			{
				source.dispose();
				source = null;
			}else if ((used << 1) >= aps.frame)
			{
				FrameUtil.addOneCallLater(madeBitmapData);
			}
		}
		
		private function madeBitmapData():void
		{
			var i:int = 0, len:int = aps.frame;
			for (;i<len;i++)
			{
				if (frameDic[i]){
					continue;
				}
				makeFrameBMD(i);
				return;
			}
		}
		
		public function dispose():void
		{
			if (source)
			{
				DisposeHelper.add(source);
				source = null;
			}
			var key:*;
			for (key in frameDic)
			{
				if (frameDic[key] is BitmapData)
				{
					DisposeHelper.add(frameDic[key]);
				}
				frameDic[key] = null;
				delete frameDic[key];
			}
			this.aps = null;
			this.frameDic = null;
		}
	}
}