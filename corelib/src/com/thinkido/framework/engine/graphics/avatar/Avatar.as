package com.thinkido.framework.engine.graphics.avatar
{
    import com.thinkido.framework.common.events.EventDispatchCenter;
    import com.thinkido.framework.common.handler.helper.HandlerHelper;
    import com.thinkido.framework.common.pool.IPoolClass;
    import com.thinkido.framework.engine.SceneCharacter;
    import com.thinkido.framework.engine.events.SceneEvent;
    import com.thinkido.framework.engine.events.SceneEventAction_status;
    import com.thinkido.framework.engine.staticdata.AvatarPartID;
    import com.thinkido.framework.engine.staticdata.AvatarPartType;
    import com.thinkido.framework.engine.staticdata.CharStatusType;
    import com.thinkido.framework.engine.staticdata.SceneCharacterType;
    import com.thinkido.framework.engine.tools.SceneCache;
    import com.thinkido.framework.engine.tools.ScenePool;
    import com.thinkido.framework.engine.vo.avatar.AvatarFaceData;
    import com.thinkido.framework.engine.vo.avatar.AvatarParamData;
    import com.thinkido.framework.engine.vo.avatar.AvatarPlayCondition;
    
    import flash.display.IBitmapDrawable;
    import flash.display.Sprite;
    import flash.geom.Point;
    
    
	/**
	 * 人物总的 avatar 类，包含各部分 avatarpart.如武器,坐骑,衣服 
	 * @author Administrator
	 */
    public class Avatar extends Object implements IPoolClass
    {
        public var usable:Boolean = false;
        private var _visible:Boolean = true;
        public var updateNow:Boolean = false;
        private var _oldData:Object;
        public var sceneCharacter:SceneCharacter;
        public var status:String = "stand";
        public var logicAngle:int = 0;
        public var playCondition:AvatarPlayCondition;
        private var _isOnMount:Boolean;
        private var _hideAvatarPartTypes:Array;
        private var _hideAvatarPartIds:Array;
        private var avatarParts:Array;
		public var needSort:Boolean = false;
		public var avatarContainer:Sprite;

        public function Avatar(sc:SceneCharacter)
        {
			avatarContainer = new Sprite();
            this._hideAvatarPartTypes = [];
            this._hideAvatarPartIds = [];
            this.avatarParts = [];
            this.reSet([sc]);
            return;
        }
		/**
		 * 是否在坐骑上
		 * @param value
		 * 
		 */
        public function set isOnMount(value:Boolean) : void
        {
            this._isOnMount = value;
            this.updateDefaultAvatar();
            return;
        }

        public function get isOnMount() : Boolean
        {
            return this._isOnMount;
        }

        private function updateDefaultAvatar() : void
        {
			if (!this._isOnMount)
            {
                if (!this.hasTypeAvatarParts(AvatarPartType.BODY))
                {
                    if (this.sceneCharacter.scene && this.sceneCharacter.scene.blankAvatarParamData != null)
                    {
                        if (this.sceneCharacter.type != SceneCharacterType.DUMMY && this.sceneCharacter.type != SceneCharacterType.BAG)
                        {
//                            this.sceneCharacter.loadAvatarPart(this.sceneCharacter.scene.blankAvatarParamData);
                        }
                    }
                }
            }
            return;
        }

        public function hasTypeAvatarParts($type:String) : Boolean
        {
            var ap:AvatarPart = null;
            for each (ap in this.avatarParts)
            {
                if (ap.type == $type)
                {
                    return true;
                }
            }
            return false;
        }

        public function hasIDAvatarPart($id:String) : Boolean
        {
            var ap:AvatarPart = null;
            for each (ap in this.avatarParts)
            {
                if (ap.id == $id)
                {
                    return true;
                }
            }
            return false;
        }

        public function hasSameAvatarPart(apd:AvatarParamData) : Boolean
        {
            var ap:AvatarPart = null;
            for each (ap in this.avatarParts)
            {
                if (ap.avatarParamData != null && ap.avatarParamData.equals(apd))
                {
                    return true;
                }
            }
            return false;
        }

        public function loadAvatarPart(apd:AvatarParamData = null) : void
        {
//            AvatarPartLoader.loadAvatarPart(this.sceneCharacter, apd);
			if( apd == null ){
				return ;
			}
			var ap:AvatarPart = AvatarPart.createAvatarPart(this, apd );
			addAvatarPart(ap);
            return;
        }

        public function showAvatarPart(ap:AvatarPart) : void
        {
            ap.visible = true;
            return;
        }

        public function hideAvatarPart(ap:AvatarPart) : void
        {
            ap.visible = true;
            return;
        }

        public function getTypeAvatarPartsVisible($type:String) : Boolean
        {
            return this._hideAvatarPartTypes.indexOf($type) == -1;
        }

        public function showAvatarPartsByType($type:String) : void
        {
            var ap:AvatarPart = null;
            var temp:int = this._hideAvatarPartTypes.indexOf($type);
            if (temp != -1)
            {
                this._hideAvatarPartTypes.splice(temp, 1);
            }
            for each (ap in this.avatarParts)
            {
                if (ap.type == $type)
                {
                    ap.visible = true;
                }
            }
            return;
        }

        public function hideAvatarPartsByType($type:String) : void
        {
            var ap:AvatarPart = null;
            if (this._hideAvatarPartTypes.indexOf($type) == -1)
            {
                this._hideAvatarPartTypes.push($type);
            }
            for each (ap in this.avatarParts)
            {
                
                if (ap.type == $type)
                {
                    ap.visible = false;
                }
            }
            return;
        }

        public function getIDAvatarPartVisible(value1:String) : Boolean
        {
            return this._hideAvatarPartIds.indexOf(value1) == -1;
        }

        public function showAvatarPartByID(value1:String) : void
        {
            var _loc_2:* = this._hideAvatarPartIds.indexOf(value1);
            if (_loc_2 != -1)
            {
                this._hideAvatarPartIds.splice(_loc_2, 1);
            }
            var _loc_3:* = this.getAvatarPartByID(value1);
            if (_loc_3 != null)
            {
                _loc_3.visible = true;
            }
            return;
        }

        public function hideAvatarPartByID(value1:String) : void
        {
            if (this._hideAvatarPartIds.indexOf(value1) == -1)
            {
                this._hideAvatarPartIds.push(value1);
            }
            var _loc_2:* = this.getAvatarPartByID(value1);
            if (_loc_2 != null)
            {
                _loc_2.visible = false;
            }
            return;
        }

        public function addAvatarPartByApd(apd:AvatarParamData) : AvatarPart
        {
			if(apd ==null){
				return null;
			}
			apd = apd.clone();
			if (apd.clearSameType)
			{
				this.removeAvatarPartsByType(apd.type);
			}
			this.removeAvatarPartByID(apd.id);
			var ap:AvatarPart = AvatarPart.createAvatarPart(this, apd);
			ap.visible = this._hideAvatarPartTypes.indexOf(ap.type) == -1 && this._hideAvatarPartIds.indexOf(ap.id) == -1;
			ap.updateNow = true;
			ap.type = apd.type ? apd.type :"" ;
			this.avatarParts.push(ap);
			this.needSort = true;
			ap.playTo(this.status,this.logicAngle);
			return ap ;
		}
        public function addAvatarPart(ap:AvatarPart, isOverride:Boolean = false) : void
        {
            var tempAp:AvatarPart = null;
            if (isOverride)
            {
                this.removeAvatarPartsByType(ap.type, false);
            }
            if (this.avatarParts.indexOf(ap) != -1)
            {
                return;
            }
            if (ap.id != null && ap.id != "")
            {
                tempAp = this.getAvatarPartByID(ap.id);
                if (tempAp != null)
                {
                    this.removeAvatarPart(tempAp, false);
                }
            }
            ap.visible = this._hideAvatarPartTypes.indexOf(ap.type) == -1;
            ap.avatar = this;
            ap.updateNow = true;
            if (ap.depth == 0)
            {
                ap.depth = AvatarPartType.getDefaultDepth(ap.type, this.logicAngle);
            }
            this.avatarParts.push(ap);
            this.sortAvatarParts();
            ap.onAdd();
            return;
        }

        public function sortAvatarParts() : void
        {
            this.avatarParts.sortOn("depth", Array.NUMERIC);
            return;
        }

        public function removeAvatarPartByID(partId:String, immediately:Boolean = true) : void
        {
            var _ap:AvatarPart = null;
            if (partId == null || partId == "")
            {
                return;
            }
            SceneCache.removeWaitingAvatar(this.sceneCharacter, partId);
            for each (_ap in this.avatarParts)
            {
                
                if (_ap.id == partId)
                {
                    _ap.onRemove();
                    this.avatarParts.splice(this.avatarParts.indexOf(_ap), 1);
                    AvatarPart.recycleAvatarPart(_ap);
                    break;
                }
            }
            if (immediately)
            {
                this.updateDefaultAvatar();
            }
            return;
        }

        public function removeAvatarPartsByType($type:String, immediately:Boolean = true) : void
        {
            var ap:AvatarPart = null;
            SceneCache.removeWaitingAvatar(this.sceneCharacter, null, $type);
            for each (ap in this.avatarParts)
            {
                if (ap.type == $type)
                {
                    ap.onRemove();
                    this.avatarParts.splice(this.avatarParts.indexOf(ap), 1);
                    AvatarPart.recycleAvatarPart(ap);
                }
            }
            if (immediately)
            {
                this.updateDefaultAvatar();
            }
            return;
        }

		public function removeAvatarPart(ap:AvatarPart, clearType:Boolean = false) : void
		{
			var _index:int = 0;
			if (clearType)
			{
				this.removeAvatarPartsByType(ap.type);
			}
			else
			{
				if (ap.id != null && ap.id != "")
				{
					SceneCache.removeWaitingAvatar(this.sceneCharacter, ap.id);
				}
				_index = avatarParts.indexOf(ap);
				if (_index == -1)
				{
					return;
				}
				this.avatarParts.splice(_index, 1);
				ap.onRemove();
				AvatarPart.recycleAvatarPart(ap);
			}
			return;
		}
		
        public function removeAllAvatarParts() : void
        {
            var ap:AvatarPart = null;
            SceneCache.removeWaitingAvatar(this.sceneCharacter);
            for each (ap in this.avatarParts)
            {
                
                ap.onRemove();
                AvatarPart.recycleAvatarPart(ap);
            }
            this.avatarParts.length = 0;
            return;
        }

        public function getAvatarPartByID(partId:String) : AvatarPart
        {
            var ap:AvatarPart = null;
            for each (ap in this.avatarParts)
            {
                
                if (ap.id == partId)
                {
                    return ap;
                }
            }
            return null;
        }

        public function getAvatarPartsByType(value1:String) : Array
        {
            var ap:AvatarPart = null;
            var tempArr:Array = [];
            for each (ap in this.avatarParts)
            {
                
                if (ap.type == value1)
                {
                    tempArr.push(ap);
                }
            }
            return tempArr;
        }
		/**
		 *  
		 * @param $status 状态
		 * @param $angle 顺时针方向 6点钟开始 0 1 2 3 4 5 6 7 
		 * @param $rotation 旋转
		 * @param apCondition 播放条件
		 * 
		 */
        public function playTo($status:String = null, $angle:int = -1, $rotation:int = -1, apCondition:AvatarPlayCondition = null) : void
        {
            var ap:AvatarPart = null;
            var fun:Function = null;
            var sEvt:SceneEvent = null;
			if( status == CharStatusType.SIT && status != $status ){
				removeAvatarPartByID( "SIT" );   //直接写字符串不好，需要整理调整优化
			}
            if ($status != null)
            {
                this.status = $status;
            }
            if ($angle != -1)
            {
                this.logicAngle = $angle;
            }
            if (apCondition != null)
            {
                this.playCondition = apCondition;
            }
            else if (this.playCondition == null)
            {
                this.playCondition = new AvatarPlayCondition();
            }
            for each (ap in this.avatarParts)
            {
                ap.playTo($status, $angle, $rotation, this.playCondition.clone());
            }
            this.sortAvatarParts();
            if (this.sceneCharacter.showAttack != null)
            {
                fun = this.sceneCharacter.showAttack;
                this.sceneCharacter.showAttack = null;
                HandlerHelper.execute(fun);
                if ($status == CharStatusType.ATTACK && this.status != CharStatusType.ATTACK)
                {
                    this.playTo(CharStatusType.ATTACK);
                }
            }
            if (this.sceneCharacter.scene && this.sceneCharacter == this.sceneCharacter.scene.mainChar && status != this.status)
            {
                sEvt = new SceneEvent(SceneEvent.STATUS, SceneEventAction_status.CHANGED, [this.sceneCharacter, this.status]);
                EventDispatchCenter.getInstance().dispatchEvent(sEvt);
            }
            return;
        }
		/**
		 * @see AvatarPart#run
		 * @param frameIndex
		 * 存储旧数据，visible
		 */
        public function run(frameIndex:int = -1) : void
        {
            var ap:AvatarPart = null;
            if (this._oldData.visible != this.visible)
            {
                this._oldData.visible = this.visible;
				this.sceneCharacter.needUpdateShadow = true;
            }
			var offMountX:int = 0;
			var offMountY:int = 0;
			if (this.sceneCharacter.isOnMount)
			{
				var bodys:Array = this.getAvatarPartsByType(AvatarPartType.BODY);
				if (bodys.length > 0)
				{
					var body:AvatarPart , i:int = 0, len:int = bodys.length;
					for (;i<len;i++)
					{
						body = bodys[i];
						if (body.id != AvatarPartID.BLANK){
							offMountX = body.offsetOnMountX;
							offMountY = body.offsetOnMountY;
							break;
						}
					}
				}
			}
            for each (ap in this.avatarParts)
            {
				if (ap.type == AvatarPartType.BODY || ap.type == AvatarPartType.MAGIC || ap.type == AvatarPartType.WING || ap.type == AvatarPartType.MAGIC_PASS || (ap.type == AvatarPartType.MAGIC_RING && ap.avatarParamData.id != AvatarPartID.SHADOW)){
					ap.offsetOnMountX = offMountX;
					ap.offsetOnMountY = offMountY;
				}
                ap.run(frameIndex);
            }
            return;
        }
		/**
		 * @sed AvatarPart#draw
		 * @param ibd
		 * 
		 */
		public function draw(ibd:IBitmapDrawable) : void
        {
            var ap:AvatarPart = null;
			if (this.needSort)
			{
				this.needSort = false;
				this.avatarParts.sortOn("depth", Array.NUMERIC);
			}
			for each (ap in this.avatarParts)
            {
                ap.draw(ibd);
            }
            return;
        }
		/**
		 * 绘制幻影 
		 * @param ibd
		 * 
		 */		
		public function drawCurrentBitmap(ibd:IBitmapDrawable):void
		{
			var ap:AvatarPart = null;
			for each (ap in this.avatarParts)
			{
				ap.drawCurrentBitmap(ibd);
			}
			return;
		}
        public function correctAvatarPosition() : void
        {
            var ap:AvatarPart = null;
            for each (ap in this.avatarParts)
            {
                ap.correctAvatarPosition();
            }
            return;
        }

        public function getNowAvatarFaceList() : Array
        {
            var ap:AvatarPart = null;
            var afd:AvatarFaceData = null;
            var tempArr:Array = [];
            for each (ap in this.avatarParts)
            {
                afd = ap.getNowAvatarFaceData();
				if (afd && afd.ap == null)
					afd.ap = ap;
                if (afd != null)
                {
                    tempArr.push(afd);
                }
            }
            return tempArr;
        }

        public function hitPoint($point:Point) : Boolean
        {
            var ap:AvatarPart = null;
            if (!this.visible)
            {
                return false;
            }
            for each (ap in this.avatarParts)
            {
                if (ap.type != AvatarPartType.MAGIC_RING && ap.type != AvatarPartType.MAGIC_PASS && ap.type != AvatarPartType.MAGIC && ap.hitPoint($point))
                {
                    return true;
                }
            }
            return false;
        }

        public function clearMe() : void
        {
            var ap:AvatarPart = null;
            for each (ap in this.avatarParts)
            {
                ap.clearMe();
            }
            return;
        }

        public function dispose() : void
        {
            this.usable = false;
            this.removeAllAvatarParts();
            this.visible = true;
            this.updateNow = false;
            this._oldData = null;
            this.sceneCharacter = null;
            this.status = CharStatusType.STAND;
            this.logicAngle = 0;
            this.playCondition = null;
            this._isOnMount = false;
            this._hideAvatarPartTypes.length = 0;
            this._hideAvatarPartIds.length = 0;
			this.needSort = false;
			this.avatarParts.length = 0;
			if (avatarContainer.parent)
				 avatarContainer.parent.removeChild(avatarContainer);
            return;
        }
		
		public function get avatarPartsLen():int{
			return avatarParts.length ;
		}

        public function reSet(value1:Array) : void
        {
            this.sceneCharacter = value1[0];
//			if (this.sceneCharacter)
//				this.sceneCharacter.container.addChild(avatarContainer);
            this._oldData = {visible:true};
            this.usable = true;
            return;
        }

        public static function createAvatar(sc:SceneCharacter) : Avatar
        {
            return ScenePool.avatarPool.createObj(Avatar, sc) as Avatar;
        }

        public static function recycleAvatar(avatar:Avatar) : void
        {
            ScenePool.avatarPool.disposeObj(avatar);
            return;
        }

		public function get visible():Boolean
		{
			return _visible;
		}

		public function set visible(value:Boolean):void
		{
			if (_visible != value)
			{
				_visible = value;
				avatarContainer.visible = value;
			}
		}


    }
}
