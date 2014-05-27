package com.thinkido.framework.engine
{
    import com.thinkido.framework.common.events.EventDispatchCenter;
    import com.thinkido.framework.common.pool.IPoolClass;
    import com.thinkido.framework.common.utils.ZMath;
    import com.thinkido.framework.engine.config.SceneConfig;
    import com.thinkido.framework.engine.events.SceneEvent;
    import com.thinkido.framework.engine.events.SceneEventAction_status;
    import com.thinkido.framework.engine.graphics.avatar.Avatar;
    import com.thinkido.framework.engine.graphics.avatar.AvatarPart;
    import com.thinkido.framework.engine.graphics.tagger.BaseCustomFace;
    import com.thinkido.framework.engine.graphics.tagger.HeadFace;
    import com.thinkido.framework.engine.graphics.tagger.ShadowShape;
    import com.thinkido.framework.engine.helper.MagicHelper;
    import com.thinkido.framework.engine.helper.MoveHelper;
    import com.thinkido.framework.engine.helper.TaggerHelper;
    import com.thinkido.framework.engine.move.WalkStep;
    import com.thinkido.framework.engine.staticdata.RestType;
    import com.thinkido.framework.engine.tools.SceneCache;
    import com.thinkido.framework.engine.tools.ScenePool;
    import com.thinkido.framework.engine.utils.Transformer;
    import com.thinkido.framework.engine.vo.BaseElement;
    import com.thinkido.framework.engine.vo.avatar.AvatarParamData;
    import com.thinkido.framework.engine.vo.avatar.AvatarPlayCondition;
    import com.thinkido.framework.engine.vo.map.MapTile;
    import com.thinkido.framework.engine.vo.move.MoveCallBack;
    import com.thinkido.framework.engine.vo.move.MoveData;
    
    import flash.display.DisplayObject;
    import flash.display.IBitmapDrawable;
    import flash.display.Sprite;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.utils.ByteArray;

	/**
	 * 场景中所有显示对象均为 SceneCharacter对象
	 * @author thinkido
	 * 
	 */	
    public class SceneCharacter extends BaseElement implements IPoolClass
    {
        public var usable:Boolean = false;
        public var visible:Boolean = true;
        public var updateNow:Boolean = false;
        private var _oldData:Object;
        public var scene:Scene;
        public var type:int;
        public var avatar:Avatar;
        public var headFace:HeadFace;
        private var _moveData:MoveData;
        public var specilize_x:Number = 0;
        public var specilize_y:Number = 0;
        public var showIndex:int = 0;
        public var showAttack:Function;
        public var oldMouseRect:Rectangle;
		public var bodyPosition:int = 0;
        public var mouseRect:Rectangle;
        public var isMouseOn:Boolean;
        public var isSelected:Boolean;
        public var restStatus:int;
		private var shadowShape:ShadowShape;
		/**是否可以使用实时影子*/
		private var _enabledShadow:Boolean = false;
		/**是否需要更新实时影子*/
		private var _needUpdateShadow:Boolean = false;
		private var _alpha:Number = 1 ;
		public var isInView:Boolean = false;
		/**装avatar的容器*/
		public var container:Sprite;

        public function SceneCharacter($type:int, $scene:Scene, $tile_x:int = 0, $tile_y:int = 0, $showIndex:int = 0)
        {
			container = new Sprite();
            this.reSet([$type, $scene, $tile_x, $tile_y, $showIndex]);
            return;
        }

        public function get moveData() : MoveData
        {
            if (this._moveData == null)
            {
                this._moveData = new MoveData();
            }
            return this._moveData;
        }

        public function get isInMask() : Boolean
        {
			var tile:MapTile = SceneCache.mapTiles[tile_x + "_" + tile_y] as MapTile;
            return tile != null && tile.isMask;
        }

        public function faceTo($pixelX:Number, $pixelY:Number) : void
        {
            if (pixel_x == $pixelX && pixel_y == $pixelY)
            {
                return;
            }
            var angle:Number = ZMath.getTowPointsAngle(new Point(pixel_x, pixel_y), new Point($pixelX, $pixelY));
            this.setAngle(angle);
            return;
        }

        public function faceToTile($x:Number, $y:Number) : void
        {
            var point:Point = Transformer.transTilePoint2PixelPoint(new Point($x, $y));
            this.faceTo(point.x, point.y);
            return;
        }

        public function faceToCharacter(sc:SceneCharacter) : void
        {
            this.faceTo(sc.pixel_x, sc.pixel_y);
            return;
        }

        public function setXY($pixelX:Number, $pixelY:Number) : void
        {
            pixel_x = $pixelX;
            pixel_y = $pixelY;
            return;
        }

        public function setTileXY($tileX:Number, $tileY:Number) : void
        {
            tile_x = $tileX;
            tile_y = $tileY;
            return;
        }

        public function reviseTileXY($tileX:Number, $tileY:Number) : void
        {
            this.setTileXY($tileX, $tileY);
            MoveHelper.reviseMove(this);
            return;
        }

        public function setSpeed($walkSpeed:Number) : void
        {
            this.moveData.walk_speed = $walkSpeed;
            return;
        }

        public function getSpeed() : Number
        {
            return this.moveData.walk_speed;
        }

        public function setStatus($status:String) : void
        {
            if (this.getStatus() == $status)
            {
                return;
            }
            this.playTo($status, -1, -1);
            return;
        }

        public function getStatus() : String
        {
            return this.avatar.status;
        }

        public function setAngle(value1:Number) : void
        {
            var temp:int = Transformer.transAngle2LogicAngle(value1);
            this.setLogicAngle(temp);
            return;
        }

        public function setLogicAngle($angle:int) : void
        {
            if (this.getLogicAngle() == $angle)
            {
                return;
            }
            this.playTo(null, $angle, -1);
            return;
        }

        public function getLogicAngle() : int
        {
            return this.avatar.logicAngle;
        }

        public function get logicAnglePRI() : int
        {
			if (this.avatar == null)
				return 0;
            if (this.avatar.logicAngle == 0)
            {
                return 0;
            }
            if (this.avatar.logicAngle == 1)
            {
                return 1;
            }
            if (this.avatar.logicAngle == 7)
            {
                return 2;
            }
            if (this.avatar.logicAngle == 2)
            {
                return 3;
            }
            if (this.avatar.logicAngle == 6)
            {
                return 4;
            }
            if (this.avatar.logicAngle == 3)
            {
                return 5;
            }
            if (this.avatar.logicAngle == 5)
            {
                return 6;
            }
            if (this.avatar.logicAngle == 4)
            {
                return 7;
            }
            return 0;
        }

        public function setRotation(value1:Number) : void
        {
            this.playTo(null, -1, value1);
            return;
        }

        public function playTo($status:String = null, $angle:int = -1, $rotation:int = -1, $condition:AvatarPlayCondition = null) : void
        {
            this.avatar.playTo($status, $angle, $rotation, $condition);
            return;
        }

        public function stopMove(value1:Boolean = true, value2:Boolean = false) : void
        {
            MoveHelper.stopMove(this, value1, value2);
            return;
        }

        public function jump(value1:Point, value2:Number = -1, value3:Number = -1, value4:MoveCallBack = null, value5:Boolean = false) : void
        {
            MoveHelper.jump(this, value1, value2, value3, value4, value5);
            return;
        }

        public function breakJump(value1:Boolean = false, value2:Boolean = false) : void
        {
            MoveHelper.breakJump(this, value1, value2);
            return;
        }

        public function lineTo(value1:Point, value2:Number, value3:Boolean = false, value4:MoveCallBack = null) : void
        {
            MoveHelper.lineTo(this, value1, value2, value3, value4);
            return;
        }

        public function lineToPiexl(value1:Point, value2:Number, value3:Function = null) : void
        {
            MoveHelper.lineToPiexl(this, value1, value2, value3);
            return;
        }

        public function walk($targetTileP:Point, $speed:Number = -1, $standDis:Number = 0, $MoveCallBack:MoveCallBack = null) : void
        {
            MoveHelper.walk(this, $targetTileP, $speed, $standDis, $MoveCallBack);
            return;
        }

        public function walk0($pathArr:Array, $targetP:Point = null, $speed:Number = -1, $standDis:Number = 0, $MoveCallBack:MoveCallBack = null) : void
        {
            MoveHelper.walk0(this, $pathArr, $targetP, $speed, $standDis, $MoveCallBack);
            return;
        }

        public function walk1(value1:ByteArray, value2:Point = null, value3:Number = -1, value4:Number = 0, value5:MoveCallBack = null) : void
        {
            MoveHelper.walk1(this, value1, value2, value3, value4, value5);
            return;
        }

        public function set isOnMount(value1:Boolean) : void
        {
            this.avatar.isOnMount = value1;
            return;
        }

        public function get isOnMount() : Boolean
        {
            return this.avatar.isOnMount;
        }

        public function hasTypeAvatarParts(value1:String) : Boolean
        {
            return this.avatar.hasTypeAvatarParts(value1);
        }

        public function hasIDAvatarPart(value1:String) : Boolean
        {
            return this.avatar.hasIDAvatarPart(value1);
        }

        public function hasSameAvatarPart(apd:AvatarParamData) : Boolean
        {
            return this.avatar.hasSameAvatarPart(apd);
        }

        public function loadAvatarPart(apd:AvatarParamData = null) : void
        {
			this.avatar.addAvatarPartByApd(apd);
            return;
        }

        public function showAvatarPart(value1:AvatarPart) : void
        {
            this.avatar.showAvatarPart(value1);
            return;
        }

        public function hideAvatarPart(value1:AvatarPart) : void
        {
            this.avatar.hideAvatarPart(value1);
            return;
        }

        public function getTypeAvatarPartsVisible(value1:String) : Boolean
        {
            return this.avatar.getTypeAvatarPartsVisible(value1);
        }

        public function showAvatarPartsByType(value1:String) : void
        {
            this.avatar.showAvatarPartsByType(value1);
            return;
        }

        public function hideAvatarPartsByType(value1:String) : void
        {
            this.avatar.hideAvatarPartsByType(value1);
            return;
        }

        public function getIDAvatarPartVisible(value1:String) : Boolean
        {
            return this.avatar.getIDAvatarPartVisible(value1);
        }

        public function showAvatarPartByID(value1:String) : void
        {
            this.avatar.showAvatarPartByID(value1);
            return;
        }

        public function hideAvatarPartByID(value1:String) : void
        {
            this.avatar.hideAvatarPartByID(value1);
            return;
        }

        public function addAvatarPartByApd(apd:AvatarParamData) : AvatarPart
        {
            return this.avatar.addAvatarPartByApd(apd);
        }
        public function addAvatarPart(ap:AvatarPart, isOverride:Boolean = false) : void
        {
            this.avatar.addAvatarPart(ap, isOverride);
            return;
        }

        public function removeAvatarPart(value1:AvatarPart, value2:Boolean = false) : void
        {
            this.avatar.removeAvatarPart(value1, value2);
            return;
        }

        public function removeAllAvatarParts(value1:Boolean = true) : void
        {
            this.avatar.removeAllAvatarParts();
            return;
        }

        public function removeAvatarPartsByType(value1:String, value2:Boolean = true) : void
        {
            this.avatar.removeAvatarPartsByType(value1, value2);
            return;
        }

        public function removeAvatarPartByID(value1:String, value2:Boolean = true) : void
        {
            this.avatar.removeAvatarPartByID(value1, value2);
            return;
        }

        public function getAvatarPartsByType(value1:String) : Array
        {
            return this.avatar.getAvatarPartsByType(value1);
        }

        public function getAvatarPartByID(value1:String) : AvatarPart
        {
            return this.avatar.getAvatarPartByID(value1);
        }
		/**
		 * @see MagicHelper#showMagic_from1passNtoN
		 * 
		 */
        public function showMagic_from1passNtoN(value1:Array, value2:AvatarParamData = null, value3:AvatarParamData = null, value4:AvatarParamData = null) : void
        {
            MagicHelper.showMagic_from1passNtoN(this, value1, value2, value3, value4);
            return;
        }
		/**
		 * @see MagicHelper#showMagic_from1pass1toPointArea
		 * 
		 */
        public function showMagic_from1pass1toPointArea($toP:Point, $fromApd:AvatarParamData = null, $toApd:AvatarParamData = null, $passApd:AvatarParamData = null) : void
        {
            MagicHelper.showMagic_from1pass1toPointArea(this, $toP, $fromApd, $toApd, $passApd);
            return;
        }
		
		/**
		 * @see MagicHelper#showMagic_from1pass1toPointArea
		 * 
		 */
        public function showMagic_from1pass1toPoint_NoPath($toP:Point, $fromApd:AvatarParamData = null, $toApd:AvatarParamData = null, $passApd:AvatarParamData = null) : void
        {
            MagicHelper.showMagic_from1pass1toPoint_NoPath(this, $toP, $fromApd, $toApd, $passApd);
            return;
        }

        public function showMagic_from1pass1toRectArea(value1:Point, value2:int, value3:int, value4:int = 1, value5:Boolean = true, value6:AvatarParamData = null, value7:AvatarParamData = null, value8:AvatarParamData = null) : void
        {
            MagicHelper.showMagic_from1pass1toRectArea(this, value1, value2, value3, value4, value5, value6, value7, value8);
            return;
        }

        public function showMagic_from1passNtoRectArea(value1:Point, value2:int, value3:int, value4:int = 0, value5:Boolean = true, value6:AvatarParamData = null, value7:AvatarParamData = null, value8:AvatarParamData = null) : void
        {
			value4 = value4 ==0 ? SceneConfig.TILE_WIDTH : value4 ;
            MagicHelper.showMagic_from1passNtoRectArea(this, value1, value2, value3, value4, value5, value6, value7, value8);
            return;
        }

        public function showMagic_from1pass1toCircleArea(value1:Point, value2:int, value3:int = 10, value4:int = 0, value5:Boolean = true, value6:AvatarParamData = null, value7:AvatarParamData = null, value8:AvatarParamData = null) : void
        {
			value4 = value4 ==0 ? SceneConfig.TILE_WIDTH : value4 ;
			MagicHelper.showMagic_from1pass1toCircleArea(this, value1, value2, value3, value4, value5, value6, value7, value8);
            return;
        }

        public function showMagic_from1passNtoCircleArea(value1:Point, value2:int, value3:int = 10, value4:int = 0, value5:Boolean = true, value6:AvatarParamData = null, value7:AvatarParamData = null, value8:AvatarParamData = null) : void
        {
			value4 = value4 ==0 ? SceneConfig.TILE_WIDTH : value4 ;
			 MagicHelper.showMagic_from1passNtoCircleArea(this, value1, value2, value3, value4, value5, value6, value7, value8);
            return;
        }

        public function showMagic_from1pass0toCircleArea_byQueue(value1:Point, value2:int, value3:int = 10, value4:int = 0, value5:Boolean = true, value6:AvatarParamData = null, value7:AvatarParamData = null, value8:AvatarParamData = null, value9:int = 10) : void
        {
			value4 = value4 ==0 ? SceneConfig.TILE_WIDTH : value4 ;
			MagicHelper.showMagic_from1pass0toCircleArea_byQueue(this, value1, value2, value3, value4, value5, value6, value7, value8, value9);
            return;
        }

        public function showMagic_from1passNtoSectorEdge(value1:Point, value2:Number = 30, value3:int = 10, value4:AvatarParamData = null, value5:AvatarParamData = null, value6:AvatarParamData = null) : void
        {
            MagicHelper.showMagic_from1passNtoSectorEdge(this, value1, value2, value3, value4, value5, value6);
            return;
        }

        public function showHeadFace(value1:String = "", value2:uint = 16777215, value3:String = "", value4:DisplayObject = null, value5:DisplayObject = null) : void
        {
            TaggerHelper.showHeadFace(this, value1, value2, value3, value4, value5);
            return;
        }

        public function setHeadFaceNickNameVisible(value1:Boolean) : void
        {
            if (this.headFace == null)
            {
                this.showHeadFace();
            }
            this.headFace.setHeadFaceNickNameVisible(value1);
            return;
        }

        public function setHeadFaceCustomTitleVisible(value1:Boolean) : void
        {
            if (this.headFace == null)
            {
                this.showHeadFace();
            }
            this.headFace.setHeadFaceCustomTitleVisible(value1);
            return;
        }

        public function setHeadFaceLeftIcoVisible(value1:Boolean) : void
        {
            if (this.headFace == null)
            {
                this.showHeadFace();
            }
            this.headFace.setHeadFaceLeftIcoVisible(value1);
            return;
        }

        public function setHeadFaceTopIcoVisible(value1:Boolean) : void
        {
            if (this.headFace == null)
            {
                this.showHeadFace();
            }
            this.headFace.setHeadFaceTopIcoVisible(value1);
            return;
        }

        public function setHeadFaceBarVisible(value1:Boolean) : void
        {
            if (this.headFace == null)
            {
                this.showHeadFace();
            }
            this.headFace.setHeadFaceBarVisible(value1);
            return;
        }

        public function setHeadFaceNickName(value1:String = "", value2:uint = 16777215) : void
        {
            if (this.headFace == null)
            {
                this.showHeadFace();
            }
            this.headFace.setHeadFaceNickName(value1, value2);
            return;
        }

        public function setHeadFaceCustomTitleHtmlText(value1:String = "") : void
        {
            if (this.headFace == null)
            {
                this.showHeadFace();
            }
            this.headFace.setHeadFaceCustomTitleHtmlText(value1);
            return;
        }

        public function setHeadFaceLeftIco(value1:DisplayObject = null) : void
        {
            if (this.headFace == null)
            {
                this.showHeadFace();
            }
            this.headFace.setHeadFaceLeftIco(value1);
            return;
        }

        public function setHeadFaceTopIco(value1:DisplayObject = null) : void
        {
            if (this.headFace == null)
            {
                this.showHeadFace();
            }
            this.headFace.setHeadFaceTopIco(value1);
            return;
        }
		/**
		 * @see  HeadFace#setHeadFaceBar
		 * @param value1
		 * @param value2
		 * @param useTween 是否使用缓动
		 */
        public function setHeadFaceBar(value1:int, value2:int, useTween:Boolean=false) : void
        {
            if (this.headFace == null)
            {
                this.showHeadFace();
            }
            this.headFace.setHeadFaceBar(value1, value2, useTween);
            return;
        }

        public function setHeadFaceTalkText(value1:String = "", value2:uint = 0xffffff, value3:int = 8000) : void
        {
            if (this.headFace == null)
            {
                this.showHeadFace();
            }
            this.headFace.setHeadFaceTalkText(value1, value2, value3);
            return;
        }

        public function getHeadFaceNickName() : String
        {
            if (this.headFace == null)
            {
                return name;
            }
            return this.headFace.nickName;
        }

        public function getHeadFaceNickNameColor() : uint
        {
            if (this.headFace == null)
            {
                return 0;
            }
            return this.headFace.nickNameColor;
        }

        public function showAttackFace(value1:String = "", value2:Number = 0, value3:String = "", value4:uint = 0, value5:uint = 0) : void
        {
            TaggerHelper.showAttackFace(this, value1, value2, value3, value4, value5);
            return;
        }

        public function getCustomFaceByName(value1:String) : DisplayObject
        {
            return TaggerHelper.getCustomFaceByName(this, value1);
        }

        public function addCustomFace(value1:DisplayObject) : void
        {
            TaggerHelper.addCustomFace(this, value1);
            return;
        }

		public function addCustomHeadFace(value:BaseCustomFace):void
		{
			if (this.headFace == null)
			{
				this.showHeadFace();
			}
			this.headFace.addCustomHeadFace(value);
			return;
		}
		
		
		public function hasCustomHeadFace(name:String):Boolean
		{
			if (this.headFace == null)
				return false;
			return this.headFace.hasCustomHeadFace(name);
		}
		
		public function removeCustomHeadFaceByName(value:String):void
		{
			if (this.headFace)
				this.headFace.removeCustomHeadFaceByName(value);
			return;
		}
		
		/**
		 * 人物名称左边添加N个图标
		 * @param value
		 * 
		 */		
		public function addHeadFaceNickNameLeftIcon(value:Array):void
		{
			if (this.headFace == null)
			{
				this.showHeadFace();
			}
			this.headFace.addHeadFaceNickNameLeftIcon(value);
			return;
		}
		
		/**
		 * 人物左边图标列表中是否已经有了某个图标
		 * @param name
		 * @return 
		 * 
		 */		
		public function hasNickLeftIcon(name:String):Boolean
		{
			if (this.headFace == null)
				return false;
			return this.headFace.hasNickLeftIcon(name);
		}
		
		public function removeNickLeftIconByName(value:String):void
		{
			if (this.headFace)
				this.headFace.removeNickLeftIconByName(value);
			return;
		}
		
        public function removeCustomFace(value1:DisplayObject) : void
        {
            TaggerHelper.removeCustomFace(this, value1);
            return;
        }

        public function removeCustomFaceByName(value1:String) : void
        {
            TaggerHelper.removeCustomFaceByName(this, value1);
            return;
        }

        public function isMainChar() : Boolean
        {
            return this.scene != null ? (this.scene.mainChar == this) : (false);
        }

		private var _lastInView:Boolean = false ;
		private var _currInView:Boolean = false ;
		public function inViewDistance() : Boolean
		{
			if (this.scene == null){
				isInView = true;
				return true;
			}
			_lastInView = _currInView ;
			_currInView = this.scene.sceneCamera.canSee(this);
			isInView = _currInView;
			var sEvt:SceneEvent ;
			if( _lastInView == false && _currInView ){
				//				2013-11-22 添加一个功能，接受非同屏数据时不加载。进入屏幕时在加载。
				sEvt = new SceneEvent(SceneEvent.STATUS, SceneEventAction_status.INVIEW_CHECKANDLOAD,[this,true]);
				EventDispatchCenter.getInstance().dispatchEvent(sEvt);
			}else if (_lastInView && !_currInView)
			{
				//离开视野范围内时，移除avatar
				sEvt = new SceneEvent(SceneEvent.STATUS, SceneEventAction_status.INVIEW_CHECKANDLOAD,[this,false]);
				EventDispatchCenter.getInstance().dispatchEvent(sEvt);
			}
			return _currInView;
		}
		
        public function isJumping() : Boolean
        {
            return this.moveData.isJumping;
        }

        public function on2Jumping() : Boolean
        {
            return this.moveData.on2Jumping;
        }

        public function correctAvatarPosition() : void
        {
            this.avatar.correctAvatarPosition();
            return;
        }

        public function getNowAvatarFaceList() : Array
        {
            return this.avatar.getNowAvatarFaceList();
        }

        public function hitPoint(value1:Point) : Boolean
        {
            return this.visible && this.avatar.hitPoint(value1);
        }

        public function clearMe() : void
        {
            this.avatar.clearMe();
            return;
        }

        public function dispose() : void
        {
			alpha = 1 ;
            this.usable = false;
			_lastInView = false ;
			_currInView = false ;
			isInView = false;
            SceneCache.removeWaitingAvatar(this);
			ShadowShape.recycleShadowShape(this.shadowShape);
            Avatar.recycleAvatar(this.avatar);
            if (this.headFace != null)
            {
                if (this.headFace.parent)
                {
                    this.headFace.parent.removeChild(this.headFace);
                }
                HeadFace.recycleHeadFace(this.headFace);
            }
			if (this.container.parent)
			{
				this.container.parent.removeChild(this.container);
			}
            this.visible = true;
            this.updateNow = false;
            this._oldData = null;
            this.scene = null;
            this.type = -1;
            this.avatar = null;
            this.headFace = null;
            this._moveData = null;
            this.specilize_x = 0;
            this.specilize_y = 0;
            this.showIndex = 0;
            this.showAttack = null;
            this.oldMouseRect = null;
            this.mouseRect = null;
            this.isSelected = false;
            this.isMouseOn = false;
            this.restStatus = RestType.COMMON;
            id = 0;
            name = "";
            data = null;
            disableContainer();
            return;
        }

        public function reSet(value1:Array) : void
        {
            this.type = value1[0];
            this.scene = value1[1];
            tile_x = value1[2];
            tile_y = value1[3];
            this.showIndex = value1[4];
			this.shadowShape = ShadowShape.createShadowShape(this);
            this.avatar = Avatar.createAvatar(this);
            if (this.scene != null)
            {
                this.avatar.visible = this.scene.isAlwaysShowChar(this) || this.scene.getCharAvatarVisible(this.type);
				this.scene.sceneAvatarLayer.addChild(container);
            }
            this._oldData = {visible:true, inViewDistance:false, isMouseOn:false, isSelected:false, pos:new Point(), spPos:new Point(), restStatus:this.restStatus};
            this.usable = true;
            return;
        }

        public function runWalk() : void
        {
            WalkStep.step(this);
            return;
        }
		/**
		 * 播放显示对象， 
		 * @param frameIndex 第几帧， -1 ：默认继续播放
		 * 存储旧数据
		 */
        public function runAvatar(frameIndex:int = -1) : void
        {
            var posX:int = Math.round(pixel_x);
            var posY:int = Math.round(pixel_y);
            if (this._oldData.pos.x != posX || this._oldData.pos.y != posY)
            {
                this._oldData.pos.x = posX;
                this._oldData.pos.y = posY;
                this.updateNow = true;
            }
            posX = Math.round(this.specilize_x);
            posY = Math.round(this.specilize_y);
            if (this._oldData.spPos.x != posX || this._oldData.spPos.y != posY)
            {
                this._oldData.spPos.x = posX;
                this._oldData.spPos.y = posY;
                this.updateNow = true;
            }
            if (this._oldData.isMouseOn != this.isMouseOn)
            {
                this._oldData.isMouseOn = this.isMouseOn;
                this.updateNow = true;
            }
            if (this._oldData.visible != this.visible)
            {
                this._oldData.visible = this.visible;
                this.updateNow = true;
            }
            var inView:Boolean = this.inViewDistance();
			if( showContainer ){
				if( inView ){
					showContainer.visible = true ;
				}else{
					showContainer.visible = false ;
				}
			}
            if (this._oldData.inViewDistance != inView)
            {
                this._oldData.inViewDistance = inView;
                this.updateNow = true;
            }
            if (this._oldData.restStatus != this.restStatus)
            {
                this._oldData.restStatus = this.restStatus;
                this.updateNow = true;
            }
            this.mouseRect = null;
            this.avatar.run(frameIndex);
            if (this.mouseRect != null)
            {
                this.oldMouseRect = this.mouseRect.clone();
            }
			//画影子
//			if (this.needUpdateShadow)
//				this.shadowShape.drawShadow(this);
			if (this.isInMask)
				this.container.alpha = 0.5;
			else
				this.container.alpha = this.alpha;
			this.needUpdateShadow = false;
            this.updateNow = false;
            return;
        }
		/**
		 * @see AvatarPart#draw
		 * @param ibd
		 * 
		 */
        public function drawAvatar(ibd:IBitmapDrawable) : void
        {
            this.avatar.draw(ibd);
            return;
        }
		/**
		 * 欢迎效果使用 
		 * @param ibd
		 * 
		 */		
		public function drawAvatarCurrentBitmap(ibd:IBitmapDrawable):void
		{
			this.avatar.drawCurrentBitmap(ibd);
		}
        public static function createSceneCharacter(param1:int, $scene:Scene, param3:int = 0, param4:int = 0, param5:int = 0) : SceneCharacter
        {
            return ScenePool.sceneCharacterPool.createObj(SceneCharacter, param1, $scene, param3, param4, param5) as SceneCharacter;
        }

        public static function recycleSceneCharacter(sc:SceneCharacter) : void
        {
            ScenePool.sceneCharacterPool.disposeObj(sc);
            return;
        }

		/**
		 * 设置实时阴影是否可用
		 * @return 
		 * 
		 */		
		public function get enabledShadow():Boolean
		{
			return _enabledShadow;
		}

		public function set enabledShadow(value:Boolean):void
		{
			if (_enabledShadow != value)
			{
				_enabledShadow = value;
				_needUpdateShadow = true;
			}
		}

		/**
		 * 设置是否需要更新影子
		 * @return 
		 * 
		 */		
		public function get needUpdateShadow():Boolean
		{
			return _needUpdateShadow;
		}

		public function set needUpdateShadow(value:Boolean):void
		{
			_needUpdateShadow = value;
		}

		override public function set pixel_x($x:Number):void
		{
			super.pixel_x = $x;
			container.x = $x;
		}
		
		override public function set pixel_y($y:Number):void
		{
			super.pixel_y = $y;
			container.y = $y;
		}
		
		override public function set tile_x(value1:int):void
		{
			super.tile_x = value1;
			container.x = pixel_x;
		}
		
		override public function set tile_y(value1:int):void
		{
			super.tile_y = value1;
			container.y = pixel_y;
		}

		public function get alpha():Number
		{
			return _alpha;
		}

		public function set alpha(value:Number):void
		{
			_alpha = value;
			this.container.alpha = value;
		}

    }
}
