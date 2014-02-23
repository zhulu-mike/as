package com.thinkido.framework.common.share
{
	import com.thinkido.framework.common.timer.Tick;
	import com.thinkido.framework.engine.graphics.avatar.AvatarPart;
	import com.thinkido.framework.engine.tools.SceneCache;
	import com.thinkido.framework.engine.vo.avatar.AvatarImgData;
	import com.thinkido.framework.engine.vo.avatar.XmlImgData;
	
	import flash.sampler.getSize;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;

    public class CountShare extends Object
    {
        private var _shareDataDict:Dictionary;
        private var _waitingDestroyShareDataDict:Dictionary;
        private var _destroyDelay:int;
        private var _count:int = 0;
        private var count:int = 0;

        public function CountShare(param1:int)
        {
            this._destroyDelay = param1;
            this._shareDataDict = new Dictionary();
            this._waitingDestroyShareDataDict = new Dictionary();
            Tick.addCallback(this.checkUninstall);
			Tick.start();
            return;
        }

        public function hasShareData(param1:String) : Boolean
        {
            return this._shareDataDict[param1] != null;
        }

        public function getShareData(param1:String) : CountShareData
        {
            return this._shareDataDict[param1] as CountShareData;
        }

        public function addShareData(param1:String, param2:CountShareData) : void
        {
            var _loc_3:CountShareData = this.getShareData(param1);
            if (!_loc_3)
            {
                this._shareDataDict[param1] = param2;
                this._count++;
            }
            return;
        }

        public function removeShareData(param1:String) : void
        {
            var _loc_2:CountShareData = this.getShareData(param1);
            if (_loc_2 != null)
            {
                _loc_2.destroy();
            }
            this._shareDataDict[param1] = null;
            delete this._shareDataDict[param1];
            this._waitingDestroyShareDataDict[param1] = null;
            delete this._waitingDestroyShareDataDict[param1];
			this._count--;
            return;
        }

        public function installShareData(param1:String, part:AvatarPart) : CountShareData
        {
			var _loc_2:CountShareData;
			if (this._shareDataDict[param1] == null)
			{
				var shareData:XmlImgData = new XmlImgData();
				var aid:AvatarImgData = new AvatarImgData(SceneCache.avatarXmlCache.get(param1).data,part.getStatus(),part.avatarParamData.baseClassName);
				shareData.aid = aid;
				addShareData(param1,shareData);
			}
			_loc_2 = this._shareDataDict[param1] as CountShareData;
	        _loc_2.count++;
			if (this._waitingDestroyShareDataDict[param1] != null)
			{
				this._waitingDestroyShareDataDict[param1] = null;
				delete this._waitingDestroyShareDataDict[param1];
			}
            return _loc_2;
        }

        public function uninstallShareData(param1:String) : void
        {
            var _loc_2:CountShareData = this._shareDataDict[param1] as CountShareData;
            if (_loc_2)
            {
                _loc_2.count--;
                if (_loc_2.count <= 0)
                {
                    if (this._waitingDestroyShareDataDict[param1] == null)
                    {
                        this._waitingDestroyShareDataDict[param1] = getTimer();
                    }
                }
            }
            return;
        }

        private function checkUninstall() : void
        {
            var _loc_3:String = null;
            var _loc_4:CountShareData = null;
            if (++this.count < 700 && !Tick.isSleepMode)
            {
                return;
            }
            this.count = this.count % 700;
            var _loc_1:int = getTimer();
            var _loc_2:uint = 0;
            for (_loc_3 in this._waitingDestroyShareDataDict)
            {
                
                _loc_2++;
                if (_loc_1 - this._waitingDestroyShareDataDict[_loc_3] > this._destroyDelay)
                {
                    this._waitingDestroyShareDataDict[_loc_3] = null;
                    delete this._waitingDestroyShareDataDict[_loc_3];
                    _loc_4 = this._shareDataDict[_loc_3] as CountShareData;
                    if (_loc_4)
                    {
                        if (_loc_4.count <= 0)
                        {
                            _loc_4.destroy();
                            this._shareDataDict[_loc_3] = null;
                            delete this._shareDataDict[_loc_3];
							this._count--;
                        }
                    }
                }
            }
            return;
        }

        public function uninstallAll() : void
        {
            var _loc_1:String = null;
            var _loc_2:CountShareData = null;
            this._waitingDestroyShareDataDict = new Dictionary();
            for (_loc_1 in this._shareDataDict)
            {
                
                _loc_2 = this._shareDataDict[_loc_1] as CountShareData;
                if (_loc_2)
                {
                    _loc_2.destroy();
                    this._shareDataDict[_loc_1] = null;
                    delete this._shareDataDict[_loc_1];
					this._count--;
                }
            }
            return;
        }

        public function uninstallAllWait() : void
        {
            var _loc_1:String = null;
            var _loc_2:CountShareData = null;
            for (_loc_1 in this._waitingDestroyShareDataDict)
            {
                
                this._waitingDestroyShareDataDict[_loc_1] = null;
                delete this._waitingDestroyShareDataDict[_loc_1];
                _loc_2 = this._shareDataDict[_loc_1] as CountShareData;
                if (_loc_2)
                {
                    if (_loc_2.count <= 0)
                    {
                        _loc_2.destroy();
                        this._shareDataDict[_loc_1] = null;
                        delete this._shareDataDict[_loc_1];
						this._count--;
                    }
                }
            }
            return;
        }

    }
}
