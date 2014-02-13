package com.thinkido.framework.engine.vo.avatar
{
	import com.thinkido.framework.common.share.CountShareData;
	
	
	public class XmlImgData extends CountShareData
	{
		public var aid:AvatarImgData;
		
		public function XmlImgData()
		{
			return;
		}
		
		override public function destroy() : void
		{
			if (this.aid != null)
			{
				this.aid.dispose();
				this.aid = null;
			}
			count = 0;
			return;
		}
		
	}
}