package com.thinkido.framework.manager
{
    import com.thinkido.framework.common.cd.*;
    import com.thinkido.framework.common.pool.*;
    
    import flash.events.*;
	/**
	 *  另却管理器
	 @example  类使用方法
	<listing version="3.0"> 
		CDFaceManager.registerItemFace(itemface);
		CDFaceManager.cdPlay(skill.getID(), skill.getCoolingtime(), 0, skill.getPublicCoolingtime(), 0, [skill.getPublicCoolingtimeClass()]);
	</listing>
	 */	
    public class CDFaceManager extends Object
    {
        private static var itemFaces:Array = [];
        private static var parentCDFaces:Array = [];
        private static var cdFacePool:Pool = PoolManager.creatPool("cdFacePool", 100);

        public function CDFaceManager()
        {
            throw new Event("静态类");
        }

        public static function registerItemFace_batch(value:Array) : void
        {
            var itemFace:IItemFace = null;
            if (value == null || value.length == 0)
            {
                return;
            }
            var _update:Boolean = false;
            for each (itemFace in value)
            {
                
                if (itemFaces.indexOf(itemFace) == -1)
                {
                    itemFaces.push(itemFace);
                    _update = true;
                }
            }
            if (_update)
            {
                updateCDFaces();
            }
            return;
        }

        public static function registerItemFace($itemFace:IItemFace) : void
        {
            if (itemFaces.indexOf($itemFace) != -1)
            {
                return;
            }
            itemFaces.push($itemFace);
            updateCDFaces();
            return;
        }

        public static function removeItemFace($itemFace:IItemFace) : void
        {
            var cdFace:CDFace = null;
            var parentCdFace:CDFace = null;
            var index:int = itemFaces.indexOf($itemFace);
            if (index != -1)
            {
                itemFaces.splice(index, 1);
                cdFace = $itemFace.getCDFace();
                parentCdFace = cdFace.parentCDFace;
                if (parentCdFace != null)
                {
                    parentCdFace.removeBindingChild(cdFace);
                }
            }
            return;
        }

        public static function isCooling($itemId:*) : Boolean
        {
            var cdFace:CDFace = null;
            for each (cdFace in parentCDFaces)
            {
                
                if (cdFace.userData.itemID == $itemId)
                {
                    if (cdFace.getLosttime() > 0)
                    {
                        return true;
                    }
                    return false;
                }
            }
            return false;
        }
        public static function getLosttimeById($itemId:*) : int
        {
            var cdFace:CDFace = null;
            for each (cdFace in parentCDFaces)
            {
                if (cdFace.userData.itemID == $itemId)
                {
                    return cdFace.getLosttime();
                }
            }
            return 0;
        }

		public static function cdPlay($itemID:*, _cdtime:int, _start:int, _pcdTime:int=0, _pstart:int=0, _pCTClass:Array=null, _publicExceptItems:Array=null):void
		{
			var _itemFace:IItemFace;
			var _item:IItem;
			var _face:CDFace;
			var _id:*;
			var _cdFace:CDFace = cdFacePool.createObj(CDFace, 1, 1, cdComplete) as CDFace;
			_cdFace.userData = {
				itemID:$itemID,
				publicIncidence:[],
				publicExceptItems:[$itemID]
			};
			var _cdFace1:CDFace = cdFacePool.createObj(CDFace, 1, 1, cdComplete) as CDFace;
			_cdFace1.userData = {
				itemID:null,
				publicIncidence:_pCTClass,
				publicExceptItems:[$itemID]
			};
			for each (_itemFace in itemFaces)
			{
				_item = _itemFace.getItem();
				_face = _itemFace.getCDFace();
				_id = _item.getID();
				if (_cdtime > 0 && _id != null && _id == $itemID)
				{
					_cdFace.addBindingChild(_face);
				}
				else if (_pcdTime > 0 && (!_pCTClass || _pCTClass.indexOf(_item.getPublicCoolingtimeClass()) != -1) && (!_publicExceptItems || _publicExceptItems.indexOf(_id) == -1) && _face.getLosttime() <= (_pcdTime - _pstart) / 1000)
				{
					_cdFace1.addBindingChild(_face);
				};
			};
			if (_cdtime > 0 && _cdFace.userData.itemID != null)
			{
				cdStart(_cdFace, (_cdtime / 1000), (_start / 1000), false);
			};
			if (_pcdTime > 0 && (_cdFace1.userData.publicIncidence == null || _cdFace1.userData.publicIncidence.length > 0))
			{
				cdStart(_cdFace1, (_pcdTime / 1000), (_pstart / 1000), true);
			};
		}

        private static function updateCDFaces() : void
        {
            if (!parentCDFaces || parentCDFaces.length == 0)
            {
                return;
            }
            parentCDFaces.forEach(function (param1:*, param2:int, param3:Array) : void
	            {
	                param1.stop(false);
	                return;
	            }
            );
            var tempArr:Array = parentCDFaces;
            parentCDFaces = [];
            tempArr.forEach(function (param1:*, param2:int, param3:Array) : void
            {
                cdPlay(param1.userData.itemID, param1.cd * 1000, param1.now * 1000, param1.cd * 1000, param1.now * 1000, param1.userData.publicIncidence, param1.userData.publicExceptItems);
                cdFacePool.disposeObj(param1);
                return;
            }
            );
            return;
        }

        private static function cdStart($cdFace:CDFace, $cdTime:Number, $start:Number = 0, param4:Boolean = false) : void
        {
            var _index:int = 0;
            var _cdFace:CDFace = null;
            if (!param4)
            {
                _index = parentCDFaces.length;
                while (_index-- > 0)
                {
                    
                    _cdFace = parentCDFaces[_index];
                    if (_cdFace.userData.itemID == $cdFace.userData.itemID)
                    {
                        cdComplete(_cdFace);
                    }
                }
            }
            if (parentCDFaces.indexOf($cdFace) == -1)
            {
                parentCDFaces.push($cdFace);
            }
            $cdFace.play($cdTime, $start);
            return;
        }

        private static function cdComplete(param1:CDFace) : void
        {
            var _loc_2:* = parentCDFaces.indexOf(param1);
            if (_loc_2 != -1)
            {
                parentCDFaces.splice(_loc_2, 1);
            }
            cdFacePool.disposeObj(param1);
            return;
        }

    }
}
