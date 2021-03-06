﻿package com.thinkido.framework.engine.graphics.avatar
{
    import com.thinkido.framework.common.enum.EnumValue;
    import com.thinkido.framework.common.handler.helper.HandlerHelper;
    import com.thinkido.framework.common.pool.IPoolClass;
    import com.thinkido.framework.common.utils.ZMath;
    import com.thinkido.framework.common.vo.Bounds;
    import com.thinkido.framework.engine.SceneCharacter;
    import com.thinkido.framework.engine.SceneRender;
    import com.thinkido.framework.engine.graphics.layers.SceneAvatarLayer;
    import com.thinkido.framework.engine.loader.AvatarPartLoader;
    import com.thinkido.framework.engine.staticdata.AvatarPartID;
    import com.thinkido.framework.engine.staticdata.AvatarPartType;
    import com.thinkido.framework.engine.staticdata.CharStatusType;
    import com.thinkido.framework.engine.staticdata.RestType;
    import com.thinkido.framework.engine.staticdata.SceneCharacterType;
    import com.thinkido.framework.engine.tools.SceneCache;
    import com.thinkido.framework.engine.tools.ScenePool;
    import com.thinkido.framework.engine.vo.avatar.AvatarFaceData;
    import com.thinkido.framework.engine.vo.avatar.AvatarImgData;
    import com.thinkido.framework.engine.vo.avatar.AvatarParamData;
    import com.thinkido.framework.engine.vo.avatar.AvatarPartData;
    import com.thinkido.framework.engine.vo.avatar.AvatarPartStatus;
    import com.thinkido.framework.engine.vo.avatar.AvatarPlayCallBack;
    import com.thinkido.framework.engine.vo.avatar.AvatarPlayCondition;
    import com.thinkido.framework.engine.vo.avatar.XmlImgData;
    import com.thinkido.framework.engine.vo.avatar.DynamicPosition.IDynamicPosition;
    import com.thinkido.framework.manager.TimerManager;
    
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.IBitmapDrawable;
    import flash.filters.GlowFilter;
    import flash.geom.Matrix;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.utils.getTimer;
    
	/**
	 * 对应一个swf，一个AvatarParamData
	 * @author thinkido.com
	 */
    public class AvatarPart extends Object implements IPoolClass
    {
		public var sceneCharacter:SceneCharacter;
		public var sceneAvatarLayer:SceneAvatarLayer;
		private var _resReady:Boolean = false;
		private var _uniqueID:Number = 0;
		private static var UNIQUE_ID:Number = 0;


        public var usable:Boolean = false;
        private var _enablePlay:Boolean = false;
        private var _visible:Boolean = true;
        public var updateNow:Boolean = false;
        private var _oldData:Object = null;
        public var avatar:Avatar;
        private var _avatarParamData:AvatarParamData;
		/**
		 * 场景中的位置 
		 */		
        private var _sceneCharacterPosition:Point = null;
        public var cutRect:Rectangle = null;
        private var _sourcePoint:Point = null;
        public var id:String;
        public var type:String;
        private var _classNamePrefix:String;
        private var _repeat:int = 0;
        public var _depth:int = int.MAX_VALUE;
        private var _offsetX:int = 0;
        private var _offsetY:int = 0;
        private var _offsetOnMountX:int = 0;
        private var _offsetOnMountY:int = 0;
        private var _dynamicPosition:IDynamicPosition = null;
        private var _sleepTime:int = 0;
        private var _onAdd:Function;
        private var _onRemove:Function;
        private var _onPlayBeforeStart:Function;
        private var _onPlayStart:Function;
        private var _onPlayUpdate:Function;
        private var _onPlayComplete:Function;
        private var _avatarImgData:AvatarImgData;
        private var _drawSourceBitmapData:BitmapData;
        private var _rotationDrawSourceBitmapData:BitmapData;
        private var _inMaskDrawSourceBitmapData:BitmapData;
        private var _currentStatus:String = "";
		private var _currentFullSourchPath:String = null;
		private var _currentAvatarPartStatus:AvatarPartStatus;
        private var _currentFrame:int = 0;
        private var _currentLogicAngel:int = 0;
        private var _currentRotation:Number = 0;
        private var _playCondition:AvatarPlayCondition;
        private var _playCount:int = 0;
        private var _playBeforeStart:Boolean = false;
        private var _playStart:Boolean = false;
        private var _playComplete:Boolean = false;
        private var _lastTime:int = 0;
        private var _lastPlayCompleteTime:int = 0;
        private var _only1Frame:Boolean = false;
        private var _only1LogicAngel:Boolean = false;
        private var _only1Repeat:Boolean = false;
        private var _autoRecycle:Boolean = false;
        private var _autoToStand:Boolean = false;
        private var _useSpecilizeXY:Boolean = true;
        private var _drawMouseOn:Boolean = true;
        private var _callBackAttack:Boolean = false;
        private static const MOUSE_ON_GLOWFILTER:GlowFilter = new GlowFilter(0xffffff, 0.7, 7, 7, 4, 1);
		private var cacheObject:Object = {};
		private var _enableShadow:Boolean = true;
		
		
		private var _bitmapFilters:Array;
		/**
		 * 播放速度,百分比 
		 */		
		public var speed:Number = 1;
		
		/**人物头顶位置是否需要更新*/
		private var _bodyPositionUpdate:Boolean = true;
		private var _bodyPositionY:Number = 0;
		public var bitmap:Bitmap;
		
        public function AvatarPart(ap:Avatar,apd:AvatarParamData)
        {
			this.cutRect = new Rectangle();
			this._sourcePoint = new Point();
			this._bitmapFilters = [];
			this.bitmap = new Bitmap();
            this.reSet([ap,apd]);
            return;
        }

		public function get uniqueID() : Number
		{
			return this._uniqueID;
		}
		
		private function changeUniqueID() : void
		{
			this._uniqueID = UNIQUE_ID + 1;
			return;
		}
		
        public function get avatarParamData() : AvatarParamData
        {
            return this._avatarParamData;
        }

        private function get avatarImg() : BitmapData
        {
            if (this._avatarImgData != null)
            {
                return this._avatarImgData.getBitmapData(this._currentLogicAngel, this._currentFrame);
            }
            return null;
        }

        public function get currentFrame() : int
        {
            return this._currentFrame;
        }

        public function get totalFrame() : int
        {
            return this._currentAvatarPartStatus != null ? (this._currentAvatarPartStatus.frame) : (1);
        }
		
		public function setAvatarPartStatus(aps:AvatarPartStatus) : void
		{
			if (aps.fullSourchPath != this._currentFullSourchPath)
			{
				return;
			}
			this._currentAvatarPartStatus = aps;
			this._avatarImgData = (SceneCache.avatarCountShare.installShareData(this._currentAvatarPartStatus.fullSourchPath,this) as XmlImgData).aid;
			this._resReady = true;
			updateNow = true;
			this.onAdd();
			return;
		}

		public function getStatus() : String
		{
			return this._currentStatus;
		}
		/**
		 * 设置动作状态 
		 * @param $status 动作
		 * 
		 */		
		public function setStatus($status:String) : void
		{
			var _apcb:AvatarPlayCallBack = null;
			if (!this.avatar || !this.sceneCharacter)
			{
				return;
			}
			if (this._currentStatus == $status)
			{
				return;
			}
			this._currentStatus = $status;
			if (this._currentFullSourchPath != null)
			{
				if (this._currentAvatarPartStatus == null)
				{
					SceneCache.removeWaitingAvatar(this.sceneCharacter, id, type, this._currentFullSourchPath, false);
				}
				else
				{
					SceneCache.avatarCountShare.uninstallShareData(this._currentFullSourchPath);
				}
			}
			this._currentFullSourchPath = null;
			this._currentAvatarPartStatus = null;
			this._avatarImgData = null;
			this._resReady = false;
			this._currentFrame = 0;
			this._playCount = 0;
			this._lastTime = 0;
			this._lastPlayCompleteTime = 0;
			this._playBeforeStart = true;
			this._playStart = true;
			this._playComplete = false;
			this.clearMe();
			updateNow = true;
			if (this.avatarParamData.hasStatus(this._currentStatus))
			{
				this._currentFullSourchPath = this.avatarParamData.getFullSourcePath(this._currentStatus);
				_apcb = this.avatarParamData.getPlayCallBack(this._currentStatus);
				if (_apcb != null)
				{
					this._onPlayBeforeStart = _apcb.onBeforeStart;
					this._onPlayStart = _apcb.onStart;
					this._onPlayUpdate = _apcb.onUpdate;
					this._onPlayComplete = _apcb.onComplete;
					this._onAdd = _apcb.onAdd;
					this._onRemove = _apcb.onRemove;
				}
				else
				{
					this._onPlayBeforeStart = null;
					this._onPlayStart = null;
					this._onPlayUpdate = null;
					this._onPlayComplete = null;
					this._onAdd = null;
					this._onRemove = null;
				}
				AvatarPartLoader.loadAvatarPart(this, this._currentStatus);
			}
			return;
		}
		
        public function playTo($status:String = null, $angle:int = -1, $rotation:int = -1, $apc:AvatarPlayCondition = null) : void
        {
            if (!this.avatar || !this.avatar.sceneCharacter)
            {
                return;
            }
			var _tempClassName:String = null;
			var _loc_17:Object = null;
            if ($rotation != -1)
            {
                $rotation = ($rotation % 360 + 360) % 360;
            }
            var _changed:Boolean = false;
            var _tempStatus:String = this._currentStatus;
            var _tempLogicAngel:int = this._currentLogicAngel;
            var _tempRotation:Number = this._currentRotation;
			var _tempInView:Boolean = this._oldData.inView;
            var _tempNamePrefix:String = this._classNamePrefix;
			var _tempViewChanged:Boolean = false;
            this._only1Frame = false;
            this._autoRecycle = false;
            this._autoToStand = false;
            this._drawMouseOn = true;
            this._callBackAttack = false;
            this._only1LogicAngel = false;
            this._only1Repeat = false;
			if ($status != null && this.id == AvatarPartID.BLANK)
				$status = CharStatusType.STAND;
			else if ($status != null && this.avatar.sceneCharacter.type == SceneCharacterType.TRANSPORT)
				$status = CharStatusType.STAND;
			else if ($status != null && this.type == AvatarPartType.MOUNT && $status != CharStatusType.DEATH)
			{
				$status = CharStatusType.STAND;
			}
            if ($status != null && $status != this._currentStatus)
            {
                if( type == AvatarPartType.MOUNT || type == AvatarPartType.BODY || type == AvatarPartType.WEAPON  ){
					if ($status != CharStatusType.JUMP)
						this.setStatus( $status );
					else
						this.setStatus(CharStatusType.STAND);
				}else if (type == AvatarPartType.WING)
				{
					if ( $status != CharStatusType.DEATH)
						setStatus( CharStatusType.STAND );
					else
						setStatus( $status);
				}else if( _currentStatus != CharStatusType.STAND ){
					setStatus( CharStatusType.STAND );
				}
            }
            if ($angle != -1 && $angle != this._currentLogicAngel)
            {
                this._currentLogicAngel = $angle;
            }
            if ($rotation != -1 && $rotation != this._currentRotation)
            {
                this._currentRotation = $rotation;
            }
            if ($apc != null)
            {
                this._playCondition = $apc;
            }
            else if (this._playCondition == null)
            {
                this._playCondition = new AvatarPlayCondition();
            }
            
			if (this.id == AvatarPartID.BLANK)
			{
				this._currentStatus = CharStatusType.STAND;
				this._currentLogicAngel = 0;
				this._only1LogicAngel = true;
			}
            if (this.avatar.sceneCharacter.type == SceneCharacterType.TRANSPORT)
            {
                this._currentStatus = CharStatusType.STAND;
                this._currentLogicAngel = 0;
                this._only1LogicAngel = true;
            }
            if (this.type == AvatarPartType.MAGIC_RING || this.type == AvatarPartType.MAGIC_PASS || this.type == AvatarPartType.MAGIC)
            {
                this._currentStatus = CharStatusType.STAND;
                this._currentLogicAngel = 0;
                this._only1LogicAngel = true;
            }
            if (this.type == AvatarPartType.BODY && this._currentStatus == CharStatusType.ATTACK)
            {
                this._callBackAttack = true;
            }
            if (this.type == AvatarPartType.MOUNT)
            {
                if (this._currentStatus == CharStatusType.JUMP)
                {
                    this._currentStatus = CharStatusType.WALK;
                }
                else if (this._currentStatus != CharStatusType.STAND && this._currentStatus != CharStatusType.DEATH)
                {
//                    this._currentStatus = CharStatusType.MOUNT_ATTACK;     //御剑修改
                    this._currentStatus = CharStatusType.STAND;
                }
            }
			if (_currentStatus == CharStatusType.WALK)
			{
				speed = EnumValue.getMoveAvatarPlaySpeed(sceneCharacter.getSpeed());
			}
			else if (CharStatusType.getIsFight(_currentStatus) || _currentStatus == CharStatusType.INJURED)
			{
				speed = EnumValue.getAttackAvatarPlaySpeed(sceneCharacter.getSpeed());
			}
            if (this._currentStatus == CharStatusType.DEATH)
            {
                this._only1LogicAngel = false ;
            }
            if (CharStatusType.isOnly1Repeat(this._currentStatus))
            {
                this._only1Repeat = true;
            }
            if (this.type == AvatarPartType.MAGIC_PASS || this.type == AvatarPartType.MAGIC)
            {
                this._autoRecycle = true;
            }
            if (this.type == AvatarPartType.MAGIC_RING || this.type == AvatarPartType.MAGIC_PASS || this.type == AvatarPartType.MAGIC || this.type == AvatarPartType.WING)
            {
                this._drawMouseOn = false;
            }
            if (this.type == AvatarPartType.BODY)
            {
                this._autoToStand = true;
            }
            var _avatarPlayBeginCondi:Array = [AvatarPartType.BODY, AvatarPartType.WEAPON, AvatarPartType.BOW, AvatarPartType.MOUNT];
            var _statusPlayBeginCondi:Array = [CharStatusType.JUMP, CharStatusType.ATTACK, CharStatusType.MOUNT_ATTACK, CharStatusType.INJURED, CharStatusType.DEATH];
            var _avatarStayEndCondi:Array = [AvatarPartType.BODY, AvatarPartType.WEAPON, AvatarPartType.BOW, AvatarPartType.MOUNT];
            var _statusStayEndCondi:Array = [CharStatusType.JUMP, CharStatusType.DEATH];
            var _avatarShowEndCondi:Array = [AvatarPartType.BODY, AvatarPartType.WEAPON, AvatarPartType.BOW, AvatarPartType.MOUNT];
            var _statusShowEndCondi:Array = [CharStatusType.DEATH];
            this._playCondition.playAtBegin = this._playCondition.playAtBegin && _avatarPlayBeginCondi.indexOf(this.type) != -1 && _statusPlayBeginCondi.indexOf(this._currentStatus) != -1 ? (true) : (false);
            this._playCondition.stayAtEnd = this._playCondition.stayAtEnd && _avatarStayEndCondi.indexOf(this.type) != -1 && _statusStayEndCondi.indexOf(this._currentStatus) != -1 ? (true) : (false);
            this._playCondition.showEnd = this._playCondition.showEnd && _avatarShowEndCondi.indexOf(this.type) != -1 && _statusShowEndCondi.indexOf(this._currentStatus) != -1 ? (true) : (false);
            if (_tempStatus != this._currentStatus)
            {
				this._bodyPositionUpdate = true;
                _changed = true;
            }
            if (_tempLogicAngel != this._currentLogicAngel)
            {
                _changed = true;
            }
            if (_tempRotation != this._currentRotation)
            {
                _changed = true;
            }
            if (_changed)
            {
                if (_tempStatus != this._currentStatus)
                {
                    this._lastTime = 0;
                    this._playCount = 0;
                    this._playBeforeStart = true;
                    this._playStart = true;
                    this._playComplete = false;
                }
                this._enablePlay = true;
                this.updateNow = true;
            }
            if (this._playCondition.playAtBegin)
            {
                this.updateNow = true;
                this._lastTime = 0;
                this._playCount = 0;
                this._playBeforeStart = true;
                this._playStart = true;
                this._playComplete = false;
            }
            if (this._playCondition.showEnd)
            {
                this.updateNow = true;
                this._playCount = 0;
                this._playBeforeStart = false;
                this._playStart = false;
                this._playComplete = false;
            }
            if (this._avatarParamData.depth == 0)
            {
                this.depth = AvatarPartType.getDefaultDepth(this.type, this.avatar.logicAngle);
            }
            return;
        }

        public function onAdd() : void
        {
            if (this._onAdd != null)
            {
                this._onAdd(this.avatar != null ? (this.avatar.sceneCharacter) : (null), this);
            }
            return;
        }

        public function onRemove() : void
        {
            if (this._onRemove != null)
            {
                this._onRemove(this.avatar != null ? (this.avatar.sceneCharacter) : (null), this);
            }
            return;
        }

        public function run(frameIndex:int = -1) : void
        {
            if (!this._enablePlay)
            {
                return;
            }
            var inSleep:Boolean = false;
            var nowTime:uint = SceneRender.nowTime;
            if (this._sleepTime > 0 && this._lastPlayCompleteTime > 0 && nowTime - this._lastPlayCompleteTime <= this._sleepTime)
            {
                inSleep = true;
            }
            if (this._oldData.inSleep != inSleep)
            {
                this._oldData.inSleep = inSleep;
                this.updateNow = true;
            }
			
            if (this._currentAvatarPartStatus != null)
            {
                if (!inSleep)
                {
                    if (frameIndex >= 0)
                    {
                        this._currentFrame = frameIndex;
                        this.updateNow = true;
                    }
                    else if (this._playCondition.showEnd)
                    {
						if (this._currentFrame != this.totalFrame - 1){
                        	this._currentFrame = this.totalFrame - 1;
							this.updateNow = true;
						}
                    }
                    else
                    {
						var pastTime:int = nowTime - this._lastTime;
                        if (pastTime >= this._currentAvatarPartStatus.time/speed)
                        {
							var isEnd:Boolean = false;
                            this._lastTime = nowTime;
							_currentFrame ++ ;
                            if (this._currentFrame >= this.totalFrame)
                            {
                                if (this._sleepTime > 0)
                                {
                                    this._lastPlayCompleteTime = nowTime;
                                    inSleep = true;
                                    this._currentFrame = -1;
                                }
                                else
                                {
                                    this._currentFrame = 0;
									this.updateNow = true;
                                }
                                if (this._playCondition.stayAtEnd)
                                {
                                    this._currentFrame = this.totalFrame - 1;
                                    isEnd = true;
                                }
                                else
                                {
									var repeatNum:int = this._only1Repeat ? (1) : (this._repeat);
									_playCount ++;
                                    if (repeatNum != 0 && this._playCount >= repeatNum)
                                    {
                                        this._currentFrame = this.totalFrame - 1;
                                        this._playComplete = true;
                                    }
                                }
                            }
                            if (!isEnd && this.totalFrame > 1)
                            {
                                this.updateNow = true;
                            }
                        }
                    }
                }
            }else{
				return;
			}
			var targetPoint:Point = null;
			var apd:AvatarPartData = null;
			
            if (this.updateNow)
            {
				if (this._only1Frame)
				{
					this._currentFrame = 0;
				}
				var hasAvatarImg:BitmapData = this.avatarImg;
				this.sceneCharacter.needUpdateShadow = true;
				apd = this._currentAvatarPartStatus.getAvatarPartData(this._currentLogicAngel, this._currentFrame);
                if (apd)
                {
                    targetPoint = this.getTargetPosition();
                    if (this._dynamicPosition != null)
                    {
                        if (this._sceneCharacterPosition.x != -int.MAX_VALUE || this._sceneCharacterPosition.y != -int.MAX_VALUE)
                        {
                            targetPoint = this._dynamicPosition.updateDynamicTargetPosition(this._sceneCharacterPosition, targetPoint, this.sceneCharacter.getLogicAngle());
                        }
                    }
                    this._sceneCharacterPosition.x = targetPoint.x;
                    this._sceneCharacterPosition.y = targetPoint.y;
                        this.cutRect.width = apd.width;
                        this.cutRect.height = apd.height;
                        this.cutRect.x = apd.tx;
                        this.cutRect.y = apd.ty;
                        this._sourcePoint.x = 0;
                        this._sourcePoint.y = 0;
                        if (this._currentRotation > 0)
                        {
							var bdWidth:int = NaN;
							var bdHeight:int = NaN;
							var matrix:Matrix = null;
							var tt:int = getTimer();
							var temp:Object = cacheObject[int(_currentRotation) + "_" + _currentFrame ] ;
							if( !temp ){
								var p1:Point = null;
								var p2:Point = null;
								var p3:Point = null;
								var p4:Point = null;
								this._oldData.oldDrawRotation = this._currentRotation;
                                p1 = ZMath.getRotPoint(new Point(0, 0), new Point(apd.tx, apd.ty), this._currentRotation);
                                p2 = ZMath.getRotPoint(new Point(apd.width, 0), new Point(apd.tx, apd.ty), this._currentRotation);
                                p3 = ZMath.getRotPoint(new Point(apd.width, apd.height), new Point(apd.tx, apd.ty), this._currentRotation);
                                p4 = ZMath.getRotPoint(new Point(0, apd.height), new Point(apd.tx, apd.ty), this._currentRotation);
								bdWidth = Math.max(Math.abs(p3.x - p1.x), Math.abs(p4.x - p2.x));
								bdHeight = Math.max(Math.abs(p3.y - p1.y), Math.abs(p4.y - p2.y));
								this._oldData.oldOffsetX = Math.min(p1.x, p2.x, p3.x, p4.x);
								this._oldData.oldOffsetY = Math.min(p1.y, p2.y, p3.y, p4.y);
								cacheObject[int(_currentRotation) + "_" + _currentFrame ] = {"bdWidth":bdWidth,"bdHeight":bdHeight,"oldOffsetX":_oldData.oldOffsetX,"oldOffsetY":_oldData.oldOffsetY};
							}else{
								bdWidth = temp.bdWidth ;
								bdHeight = temp.bdHeight ;
								this._oldData.oldOffsetX = temp.oldOffsetX;
								this._oldData.oldOffsetY = temp.oldOffsetY;
							}
                            matrix = new Matrix();
							matrix.translate( - apd.tx,  - apd.ty);
							matrix.rotate(this._currentRotation * Math.PI / 180);
							matrix.translate( apd.tx,  apd.ty);								
                            matrix.translate(-this._oldData.oldOffsetX, -this._oldData.oldOffsetY);
							_drawSourceBitmapData = new BitmapData(bdWidth, bdHeight, true, 0);
							_rotationDrawSourceBitmapData = new BitmapData( apd.width , apd.height , true, 0);
							_rotationDrawSourceBitmapData.copyPixels(hasAvatarImg, new Rectangle(this._sourcePoint.x, this._sourcePoint.y, apd.width, apd.height), new Point(0,0), null, null, true);
							this._drawSourceBitmapData.draw(_rotationDrawSourceBitmapData, matrix  );
							_rotationDrawSourceBitmapData.dispose();
							this.cutRect.x = (apd.tx - this._oldData.oldOffsetX);
                            this.cutRect.y = (apd.ty - this._oldData.oldOffsetY);
                            this.cutRect.width = this._drawSourceBitmapData.width;
                            this.cutRect.height = this._drawSourceBitmapData.height;
//							trace("旋转用时："+(getTimer()-tt));
                        }
                        else if (this._drawMouseOn && this.sceneCharacter.isMouseOn)//如果为true，加滤镜
                        {
                            this._drawSourceBitmapData = new BitmapData(apd.width, apd.height, true, 0);
                            this._drawSourceBitmapData.copyPixels(hasAvatarImg, new Rectangle(this._sourcePoint.x, this._sourcePoint.y, apd.width, apd.height), new Point(0, 0), null, null, true);
                            this._drawSourceBitmapData.applyFilter(this._drawSourceBitmapData, new Rectangle(0, 0, apd.width, apd.height), new Point(), MOUSE_ON_GLOWFILTER);
                        }
                        else
                        {
                            this._drawSourceBitmapData = hasAvatarImg;
                        }
						if (this._inMaskDrawSourceBitmapData != null)
                        {
                            this._inMaskDrawSourceBitmapData.dispose();
                            this._inMaskDrawSourceBitmapData = null;
                        }
						this.bitmap.bitmapData = _drawSourceBitmapData || _inMaskDrawSourceBitmapData;
						this.bitmap.x = -this.cutRect.x;
						this.bitmap.y = -this.cutRect.y;
                }
                else
                {
                    this.cutRect.setEmpty();
                    this._sourcePoint.x = 0;
                    this._sourcePoint.y = 0;
                }
                this._oldData.oldCutRect.x = this.cutRect.x;
                this._oldData.oldCutRect.y = this.cutRect.y;
                this._oldData.oldCutRect.width = this.cutRect.width;
                this._oldData.oldCutRect.height = this.cutRect.height;
				if( this.avatarParamData.type == AvatarPartType.BODY && apd){
					if (this._bodyPositionUpdate)
						_bodyPositionY = apd.ty;
					if (!this.sceneCharacter.visible)
					{
						targetPoint = this.getTargetPosition();
						this._sceneCharacterPosition.x = targetPoint.x;
						this._sceneCharacterPosition.y = targetPoint.y;
					}
					this.sceneCharacter.bodyPosition = this._sceneCharacterPosition.y - _bodyPositionY;
					this._bodyPositionUpdate = false;
				}
            }
            if (this._drawMouseOn && !this.cutRect.isEmpty() && this.type != AvatarPartType.WING)
            {
                if (this.sceneCharacter.mouseRect != null)
                {
                    this.sceneCharacter.mouseRect = this.sceneCharacter.mouseRect.union(this.cutRect);
                }
                else
                {
                    this.sceneCharacter.mouseRect = this.cutRect;
                }
            }
            return;
        }
		/**
		 * 
		 * @param ibmdable
		 * 
		 */
        public function draw(ibmdable:IBitmapDrawable) : void
        {
            if (!this.updateNow)
            {
                return;
            }
            this.updateNow = false;
            if (this._playBeforeStart)
            {
                this._playBeforeStart = false;
                if (this._onPlayBeforeStart != null)
                {
                    this._onPlayBeforeStart(this.avatar != null ? (this.avatar.sceneCharacter) : (null), this);
                }
            }
			var bmd:BitmapData = null;
			var rec:Rectangle = null;
			var showAttackFun:Function = null;
            if (!this._enablePlay)
            {
                return;
            }
            if (!this.avatar || !this.avatar.sceneCharacter)
            {
                return;
            }
            if (this.visible && this.avatar.visible && this.avatar.sceneCharacter.isInView && this.sceneCharacter.visible)
            {
                bmd = this._inMaskDrawSourceBitmapData || this._drawSourceBitmapData;
				this.bitmap.bitmapData = bmd;
				this.bitmap.x = -this.cutRect.x;
				this.bitmap.y = -this.cutRect.y;
//                if (bmd != null)
//                {
//                    for each (rec in this.renderRectArr)
//                    {
//                        if (!rec.isEmpty())
//                        {
//                            this.copyToAvatarBD(ibmdable, bmd, this._sourcePoint.x + (rec.x - this.cutRect.x), this._sourcePoint.y + (rec.y - this.cutRect.y), rec.width, rec.height, rec.x, rec.y);
//						}
//                    }
//                }
            }
            if (this._playStart)
            {
                this._playStart = false;
                if (this._onPlayStart != null)
                {
					if( this._avatarParamData.useDelay ){
						TimerManager.createOneOffTimer(this.avatarParamData.startDelay, 1, _onPlayStart,[this.avatar != null ? (this.sceneCharacter) : (null) , this ], null, null, true);
					}else{
						this._onPlayStart(this.avatar != null ? (this.sceneCharacter) : (null) , this);
					}
                }
            }
            if (this._onPlayUpdate != null)
            {
                this._onPlayUpdate(this.avatar != null ? (this.sceneCharacter) : (null), this);
            }
//			动作播放到最后3帧时、触发攻击函数
            if (this._callBackAttack)
            {
                if (this.sceneCharacter.showAttack != null && this._currentFrame >= Math.max(this.totalFrame - 3, 0))
                {
                    this._callBackAttack = false;
                    showAttackFun = this.sceneCharacter.showAttack;
                    this.sceneCharacter.showAttack = null;
                    HandlerHelper.execute(showAttackFun);
                }
            }
            if (this._playComplete)
            {
                this._playComplete = false;
                this._enablePlay = false;
                if (this._onPlayComplete != null)
                {
                    this._onPlayComplete(this.avatar != null ? (this.sceneCharacter) : (null), this);
                }
//				不删除就站立
                if (this._autoRecycle && this.avatar)
                {
                    this.avatar.removeAvatarPart(this);
                }
                else if (this._autoToStand && this.avatar)
                {
                    this.avatar.playTo(CharStatusType.STAND);
                }
            }
            return;
        }
		/**
		 * 绘制幻影 
		 * @param ibmdable
		 * 
		 */
		public function drawCurrentBitmap(ibmdable:IBitmapDrawable):void
		{
			var bmd:BitmapData = null;
			var rec:Rectangle = null;
			if (this.visible && this.avatar.visible && this.avatar.sceneCharacter.visible && this.avatarImg)
			{
				bmd = this._inMaskDrawSourceBitmapData || this._drawSourceBitmapData;
				if (bmd != null)
				{
//					for each (rec in this.renderRectArr)
//					{
//						
//						if (!rec.isEmpty())
//						{
//							this.copyToAvatarBD(ibmdable, bmd, this._sourcePoint.x + (rec.x - this.cutRect.x), this._sourcePoint.y + (rec.y - this.cutRect.y), rec.width, rec.height, rec.x, rec.y);
//						}
//					}
				}
			}
		}
		/**
		 * 纯渲染。将图像绘制到 sceneAvatarLayer上， 
		 * @param sal 画板
		 * @param $bmd 源图像
		 * @param $x
		 * @param $y
		 * @param $w
		 * @param $h
		 * @param $px
		 * @param $py
		 * 
		 */
        private function copyToAvatarBD(sal:IBitmapDrawable, $bmd:BitmapData, $x:int, $y:int, $w:int, $h:int, $px:int, $py:int) : void
        {
            if (!$bmd)
            {
                return;
            }
            if (sal is SceneAvatarLayer)
            {
                (sal as SceneAvatarLayer).copyImage($bmd, $x, $y, $w, $h, $px, $py);
            }
            else if (sal is BitmapData)
            {
                $px = $px + (sal as BitmapData).width / 2;
                $py = $py + (sal as BitmapData).height / 2;
                (sal as BitmapData).copyPixels($bmd, new Rectangle($x, $y, $w, $h), new Point($px, $py), null, null, true);
            }
            return;
        }
		/**
		 * 获取sceneCharacter x,y point ,包换偏移量
		 * @return 
		 * 
		 */
        private function getTargetPosition() : Point
        {
            var _x:Number = NaN;
            var _y:Number = NaN;
            if (this._useSpecilizeXY && (this.sceneCharacter.isJumping() || this.sceneCharacter.restStatus == RestType.DOUBLE_SIT))
            {
                _x = Math.round(this.sceneCharacter.specilize_x);
                _y = Math.round(this.sceneCharacter.specilize_y);
            }
            else
            {
                _x = Math.round(this.sceneCharacter.pixel_x);
                _y = Math.round(this.sceneCharacter.pixel_y);
            }
            _x += this._offsetX;
            _y += this._offsetY;
            return new Point(_x, _y);
        }
		/**
		 * 更新位置 
		 * 
		 */
        public function correctAvatarPosition() : void
        {
            if (this.avatar == null || this.avatar.sceneCharacter == null)
            {
                return;
            }
            var p:Point = this.getTargetPosition();
            this._sceneCharacterPosition.x = p.x;
            this._sceneCharacterPosition.y = p.y;
            this.updateNow = true;
            return;
        }

        public function getNowAvatarFaceData() : AvatarFaceData
        {
            if (!this.usable)
            {
                return null;
            }
            if (!this.visible && !this.avatar.visible && !this.avatar.sceneCharacter.visible)
            {
                return null;
            }
            var _apd:AvatarFaceData = new AvatarFaceData();
            _apd.sourceBitmapData = this._inMaskDrawSourceBitmapData || this._drawSourceBitmapData;
            _apd.cutRect = this.cutRect;
            _apd.sourcePoint = this._sourcePoint;
            _apd.id = this.id;
            _apd.type = this.type;
			_apd.ap = this;
            if (!_apd.isGood())
            {
                return null;
            }
            return _apd;
        }
		/**
		 * 测试点是否具有颜色 
		 * @param $p
		 * @return 
		 * 
		 */
        public function hitPoint($p:Point) : Boolean
        {
            var _color:uint = 0;
            if (!this.visible)
            {
                return false;
            }
            var bd:BitmapData = this._inMaskDrawSourceBitmapData || this._drawSourceBitmapData;
            if (bd != null)
            {
                try{
					_color = bd.getPixel32($p.x - this.cutRect.x + this._sourcePoint.x, $p.y - this.cutRect.y + this._sourcePoint.y);
				}catch(e:Error){
					trace("what's reason cause error!");
				}
				if (_color != 0)
                {
                    return true;
                }
            }
            return false;
        }

        public function clearMe() : void
        {
            this.bitmap.bitmapData = null;
            return;
        }

        public function dispose() : void
        {
            this.usable = false;
            this.clearMe();
			if (this._currentStatus != null && this._currentStatus != "")
			{
				var cname:String = this.avatarParamData.getFullSourcePath(this._currentStatus);
				SceneCache.avatarCountShare.uninstallShareData(cname);
			}
			if (this.bitmap.parent)
			{
				this.bitmap.bitmapData = null;
				this.bitmap.parent.removeChild(this.bitmap);
			}
			this.speed = 1;
			this.cacheObject = {} ;
            this._enablePlay = false;
            this.visible = true;
            this.updateNow = false;
            this._oldData = null;
            this.avatar = null;
            this._avatarParamData = null;
            this._sceneCharacterPosition = null;
            this.cutRect = null;
            this._sourcePoint = null;
            this.id = "";
            this.type = "";
            this._classNamePrefix = "";
            this._repeat = 0;
            this._depth = int.MAX_VALUE;
            this._offsetX = 0;
            this._offsetY = 0;
            this._offsetOnMountX = 0;
            this._offsetOnMountY = 0;
            this._dynamicPosition = null;
            this._sleepTime = 0;
            this._onAdd = null;
            this._onRemove = null;
            this._onPlayBeforeStart = null;
            this._onPlayStart = null;
            this._onPlayUpdate = null;
            this._onPlayComplete = null;
            this._avatarImgData = null;
            if (this._drawSourceBitmapData)
            {
                this._drawSourceBitmapData = null;
            }
            if (this._inMaskDrawSourceBitmapData)
            {
                this._inMaskDrawSourceBitmapData.dispose();
                this._inMaskDrawSourceBitmapData = null;
            }
            this._currentStatus = "";
            this._currentAvatarPartStatus = null;
            this._currentFrame = 0;
            this._currentLogicAngel = 0;
            this._currentRotation = 0;
            this._playCondition = null;
            this._playCount = 0;
            this._playBeforeStart = false;
            this._playStart = false;
            this._playComplete = false;
            this._lastTime = 0;
            this._lastPlayCompleteTime = 0;
            this._only1Frame = false;
            this._only1LogicAngel = false;
            this._only1Repeat = false;
            this._autoRecycle = false;
            this._autoToStand = false;
            this._useSpecilizeXY = true;
            this._drawMouseOn = true;
            this._callBackAttack = false;
			this._currentFullSourchPath = null;
			this._bodyPositionUpdate = true;
			this._bodyPositionY = 0;
			this._enableShadow = true;
			this.sceneCharacter = null;
            return;
        }

        public function reSet(value1:Array) : void
        {
			this.avatar = value1[0];
			this._avatarParamData = value1[1];
			this.sceneCharacter = this.avatar.sceneCharacter;
			this.sceneCharacter.container.addChild(this.bitmap);
            this.id = this._avatarParamData.id;
            this.type = this._avatarParamData.type || AvatarPartType.BODY;
            this._repeat = this._avatarParamData.repeat;
            this.depth = this._avatarParamData.depth;
            this._offsetX = this._avatarParamData.offsetX;
            this._offsetY = this._avatarParamData.offsetY;
            this._offsetOnMountX = this._avatarParamData.offsetOnMountX;
            this._offsetOnMountY = this._avatarParamData.offsetOnMountY;
            this._dynamicPosition = this._avatarParamData.dynamicPosition;
			this._currentRotation = this._avatarParamData.rotation ;
            this._sleepTime = this._avatarParamData.sleepTime;
            this._useSpecilizeXY = this._avatarParamData.useSpecilizeXY;
            var apcb:AvatarPlayCallBack = this._avatarParamData.playCallBack;
            if (apcb != null)
            {
                this._onAdd = apcb.onAdd;
                this._onRemove = apcb.onRemove;
                this._onPlayBeforeStart = apcb.onBeforeStart;
                this._onPlayStart = apcb.onStart;
                this._onPlayUpdate = apcb.onUpdate;
                this._onPlayComplete = apcb.onComplete;
            }
            this.updateNow = true;
            this._oldData = {inView:false, visible:true, oldCutRect:new Rectangle(), oldDrawRotation:-1, oldOffsetX:0, oldOffsetY:0, inSleep:false, hasAvatarImg:false};
            this._sceneCharacterPosition = new Point(-int.MAX_VALUE, -int.MAX_VALUE);
            this.cutRect = new Rectangle();
            this._sourcePoint = new Point();
            this.usable = true;
            return;
        }

        public static function createAvatarPart(ap:Avatar,apd:AvatarParamData) : AvatarPart
        {
            return ScenePool.avatarPartPool.createObj(AvatarPart, ap, apd) as AvatarPart;
        }

        public static function recycleAvatarPart(ap:AvatarPart) : void
        {
            ScenePool.avatarPartPool.disposeObj(ap);
            return;
        }
		
		public function get offsetOnMountX():int
		{
			return _offsetOnMountX;
		}
		
		public function get offsetOnMountY():int
		{
			return _offsetOnMountY;
		}
		
		public function set offsetOnMountX(value:int):void
		{
			_offsetOnMountX = value;
		}
		
		public function set offsetOnMountY(value:int):void
		{
			_offsetOnMountY = value;
		}

		public function get enableShadow():Boolean
		{
			return _enableShadow;
		}

		public function set depth($depth:int) : void
		{
			if (_depth != $depth)
			{
				_depth = $depth;
				this.avatar.needSort = true;
			}
			return;
		}
		
		public function get depth():int{
			return _depth;
		}
		
		/**
		 * 是否使用阴影
		 * @param value
		 * 
		 */		
		public function set enableShadow(value:Boolean):void
		{
			_enableShadow = value;
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
				this.bitmap.visible = value;
			}
		}

		public function setChildIndex(index:int):void
		{
			if (bitmap.parent.getChildIndex(bitmap) != index)
			{
				bitmap.parent.setChildIndex(bitmap,index);
			}
		}
    }
}
