package com.thinkido.framework.engine
{
    import com.greensock.TweenLite;
    import com.thinkido.framework.common.vo.StyleData;
    import com.thinkido.framework.engine.config.MapConfig;
    import com.thinkido.framework.engine.config.SceneConfig;
    import com.thinkido.framework.engine.graphics.layers.SceneAvatarLayer;
    import com.thinkido.framework.engine.graphics.layers.SceneHeadLayer;
    import com.thinkido.framework.engine.graphics.layers.SceneInteractiveLayer;
    import com.thinkido.framework.engine.graphics.layers.SceneMapLayer;
    import com.thinkido.framework.engine.graphics.layers.SceneShadowLayer;
    import com.thinkido.framework.engine.graphics.layers.SceneSmallMapLayer;
    import com.thinkido.framework.engine.loader.MapLoader;
    import com.thinkido.framework.engine.staticdata.AvatarPartID;
    import com.thinkido.framework.engine.staticdata.AvatarPartType;
    import com.thinkido.framework.engine.staticdata.SceneCharacterType;
    import com.thinkido.framework.engine.tools.SceneCache;
    import com.thinkido.framework.engine.vo.ShowContainer;
    import com.thinkido.framework.engine.vo.avatar.AvatarParamData;
    import com.thinkido.framework.utils.DrawUtil;
    
    import flash.display.BitmapData;
    import flash.display.Shape;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.geom.Point;
    import flash.utils.getTimer;
    
    import org.osflash.thunderbolt.Logger;

	/**
	 * 场景类,引擎关键类，
	 * @author Administrator
	 * 
	 */	
    public class Scene extends Sprite
    {
        public var sceneConfig:SceneConfig;
        public var mapConfig:MapConfig;
        public var sceneCamera:SceneCamera;
        public var sceneRender:SceneRender;
        public var sceneSmallMapLayer:SceneSmallMapLayer;
		public var mapGrid:Sprite ;
        public var sceneMapLayer:SceneMapLayer;
        public var sceneAvatarLayer:SceneAvatarLayer;
        public var sceneHeadLayer:SceneHeadLayer;
        public var sceneEffectLayer:Sprite;
        public var sceneInteractiveLayer:SceneInteractiveLayer;
		public var sceneShadowLayer:SceneShadowLayer;
        public var customLayer:Sprite;
        private var _mask:Shape;
        public var mainChar:SceneCharacter;
        private var _mouseChar:SceneCharacter;
        private var _mouseOnCharacter:SceneCharacter;
        private var _selectedCharacter:SceneCharacter;
        public var renderCharacters:Array;
        public var sceneCharacters:Array;
        private var _sceneDummies:Array;
        private var _selectedAvatarParamData:AvatarParamData;
        public var blankAvatarParamData:AvatarParamData;
        public var shadowAvatarParamData:AvatarParamData;
        private var _always_show_char_types:Array;
        private var _always_show_chars:Array;
        private var _charVisible:Boolean = true;
        private var _charHeadVisible:Boolean = true;
        private var _charAvatarVisible:Boolean = true;
		private var _gridVisible:Boolean = false ;
        private static const floor:Function = Math.floor;
        private static const TILE_WIDTH:Number = SceneConfig.TILE_WIDTH;
        private static const TILE_HEGHT:Number = SceneConfig.TILE_HEIGHT;
        private static const MAX_AVATARBD_WIDTH:Number = SceneAvatarLayer.MAX_AVATARBD_WIDTH;
        private static const MAX_AVATARBD_HEIGHT:Number = SceneAvatarLayer.MAX_AVATARBD_HEIGHT;

        public function Scene($width:Number, $height:Number)
        {
            this.renderCharacters = [];
            this.sceneCharacters = [];
            this._sceneDummies = [];
            this._always_show_char_types = [SceneCharacterType.DUMMY, SceneCharacterType.BAG, SceneCharacterType.MONSTER, SceneCharacterType.NPC, SceneCharacterType.TRANSPORT];
            this._always_show_chars = [];
            if (!Engine.engineReady)
            {
                throw new Error("引擎尚未初始化！");
            }
            this.sceneConfig = new SceneConfig($width, $height);
            this.sceneSmallMapLayer = new SceneSmallMapLayer(this);
            addChild(this.sceneSmallMapLayer);
            this.sceneMapLayer = new SceneMapLayer(this);
            addChild(this.sceneMapLayer);
			mapGrid = new Sprite();
			addChild(mapGrid);
			mapGrid.mouseEnabled = false ;
			
			this.sceneShadowLayer = new SceneShadowLayer(this);
			addChild(this.sceneShadowLayer);
            this.sceneAvatarLayer = new SceneAvatarLayer(this);
            addChild(this.sceneAvatarLayer);
			
			
            this.sceneHeadLayer = new SceneHeadLayer(this);
            addChild(this.sceneHeadLayer);
			
			
            this.sceneEffectLayer = new Sprite();
			sceneEffectLayer.mouseChildren = false ;
			sceneEffectLayer.tabEnabled = false ;
            addChild(this.sceneEffectLayer);
            this.sceneInteractiveLayer = new SceneInteractiveLayer(this);
            addChild(this.sceneInteractiveLayer);
            this.customLayer = new Sprite();
            this.customLayer.mouseChildren = false;
            this.customLayer.mouseEnabled = false;
            addChild(this.customLayer);
            this.sceneCamera = new SceneCamera(this);
            this.sceneRender = new SceneRender(this);
            this.mainChar = this.createSceneCharacter(SceneCharacterType.PLAYER);
            this.addAlwaysShowChar(this.mainChar);
            this._mouseChar = this.createSceneCharacter(SceneCharacterType.DUMMY);
            this.hideMouseChar();
            this.addEventListener(Event.ADDED_TO_STAGE, this.onAddToStage);
            return;
        }

        private function updateCharsVisible() : void
        {
            this.setCharVisible(this._charVisible);
            this.setCharHeadVisible(this._charHeadVisible);
            this.setCharAvatarVisible(this._charAvatarVisible);
            return;
        }

        public function isAlwaysShowCharType($type:int) : Boolean
        {
            return this._always_show_char_types.indexOf($type) != -1;
        }

        public function addAlwaysShowCharType(charType:int) : void
        {
            var temp:int = this._always_show_char_types.indexOf(charType);
            if (temp == -1)
            {
                this._always_show_char_types.push(charType);
                this.updateCharsVisible();
            }
            return;
        }

        public function removeAlwaysShowCharType(charType:int) : void
        {
			var temp:int = this._always_show_char_types.indexOf(charType);
            if (temp != -1)
            {
                this._always_show_char_types.splice(temp, 1);
                this.updateCharsVisible();
            }
            return;
        }

        public function isAlwaysShowChar(chara:SceneCharacter) : Boolean
        {
            return this._always_show_chars.indexOf(chara) != -1;
        }
		/**
		 * 添加一直显示的对象
		 * @param chara 需要显示的对象（角色）
		 * 
		 */
        public function addAlwaysShowChar(chara:SceneCharacter) : void
        {
			var temp:int = this._always_show_chars.indexOf(chara);
            if (temp == -1)
            {
                this._always_show_chars.push(chara);
                this.updateCharsVisible();
            }
            return;
        }

        public function removeAlwaysShowChar(chara:SceneCharacter) : void
        {
            var temp:int = this._always_show_chars.indexOf(chara);
            if (temp != -1)
            {
                this._always_show_chars.splice(temp, 1);
                this.updateCharsVisible();
            }
            return;
        }

        public function getCharVisible(charType:int) : Boolean
        {
            return this.isAlwaysShowCharType(charType) || this._charVisible;
        }
		/**
		 * 显示隐藏其他玩家 
		 * @param value
		 * 
		 */
        public function setCharVisible(value:Boolean = false) : void
        {
            var chara:SceneCharacter = null;
            this._charVisible = value;
            for each (chara in this.sceneCharacters)
            {
                
                if (this._charVisible || this.isAlwaysShowCharType(chara.type) || this.isAlwaysShowChar(chara))
                {
                    chara.visible = true;
                    if (chara.useContainer)
                    {
                        chara.showContainer.visible = true;
                    }
                    continue;
                }
                chara.visible = false;
                if (chara.useContainer)
                {
                    chara.showContainer.visible = false;
                }
            }
            return;
        }

        public function getCharHeadVisible($type:int) : Boolean
        {
            return this.isAlwaysShowCharType($type) || this._charHeadVisible;
        }

        public function setCharHeadVisible(value:Boolean = false) : void
        {
            var chara:SceneCharacter = null;
            this._charHeadVisible = value;
            for each (chara in this.sceneCharacters)
            {
                
                if (this._charHeadVisible || this.isAlwaysShowCharType(chara.type) || this.isAlwaysShowChar(chara))
                {
                    if (chara.useContainer)
                    {
                        chara.showContainer.showHeadFaceContainer();
                    }
                    continue;
                }
                if (chara.useContainer)
                {
                    chara.showContainer.hideHeadFaceContainer();
                }
            }
            return;
        }

        public function getCharAvatarVisible($type:int) : Boolean
        {
            return this.isAlwaysShowCharType($type) || this._charAvatarVisible;
        }

        public function setCharAvatarVisible(value:Boolean = false) : void
        {
            var chara:SceneCharacter = null;
            this._charAvatarVisible = value;
            for each (chara in this.sceneCharacters)
            {
                
                if (this._charAvatarVisible || this.isAlwaysShowCharType(chara.type) || this.isAlwaysShowChar(chara))
                {
                    chara.avatar.visible = true;
                    if (chara.useContainer)
                    {
                        chara.showContainer.showAttackFaceContainer();
                        chara.showContainer.showCustomFaceContainer();
                    }
                    continue;
                }
                chara.avatar.visible = false;
                if (chara.useContainer)
                {
                    chara.showContainer.hideAttackFaceContainer();
                    chara.showContainer.hideCustomFaceContainer();
                }
            }
            return;
        }
		/**
		 * 
		 * @param $ids  好友、敌人id 列表
		 * @param $num  最高显示玩家数量。数量为 当前显示玩家、怪。
		 * 同屏显示最高数量，用于降低渲染压力。
		 * 同类方法有,setCharVisible(false);
		 */		
		public function setCharsShow($ids:Array = null ,$num:int = 100 ):void{
			$ids = $ids || [];
			var chara:SceneCharacter = null;
			var len:int = $ids.length ;
			var _num:int = 0 ;
			for each (chara in this.sceneCharacters)
			{
				if ( this.isAlwaysShowCharType(chara.type) || this.isAlwaysShowChar(chara))
				{
					chara.visible = true;
					if (chara.useContainer)
					{
						chara.showContainer.showAttackFaceContainer();
						chara.showContainer.showCustomFaceContainer();
					}
					if( ( chara.type == SceneCharacterType.MONSTER || chara.type == SceneCharacterType.PLAYER ) && chara.inViewDistance() ){
						_num ++ ;
					}
					continue ;
				}
				chara.visible = false;
				if (chara.useContainer)
				{
					chara.showContainer.visible = false;
				}
			}
			for (var i:int = 0; i < len ; i++) 
			{
				chara = getCharByID($ids[i],SceneCharacterType.PLAYER);
				if(!chara || !chara.inViewDistance() ){
					continue ;
				}
				chara.visible = true;
				if (chara.useContainer)
				{
					chara.showContainer.showAttackFaceContainer();
					chara.showContainer.showCustomFaceContainer();
				}
				_num ++ ;
			}
			for each (chara in this.sceneCharacters)
			{
				if ( chara.visible == false && chara.inViewDistance())
				{
					chara.visible = true;
					if (chara.useContainer)
					{
						chara.showContainer.showAttackFaceContainer();
						chara.showContainer.showCustomFaceContainer();
					}
					_num ++ ;
				}
				if( _num >= $num ){
					break ;
				}
			}
			return;
		}

        private function onAddToStage(event:Event) : void
        {
            this.removeEventListener(Event.ADDED_TO_STAGE, this.onAddToStage);
            if (!this._mask)
            {
                this._mask = new Shape();
                DrawUtil.drawRect(this._mask, new Point(0, 0), new Point(1, 1));
                this.parent.addChild(this._mask);
                this.mask = this._mask;
            }
            this.reSize(this.sceneConfig.width, this.sceneConfig.height);
            this.enableInteractiveHandle();
            return;
        }

        public function reSize($width:Number, $height:Number) : void
        {
            this.sceneConfig.width = $width;
            this.sceneConfig.height = $height;
            this._mask.x = 0;
            this._mask.y = 0;
            this._mask.width = this.sceneConfig.width;
            this._mask.height = this.sceneConfig.height;
            this.sceneCamera.updateRangeXY();
            this.updateCameraNow();
            return;
        }
		/**
		 * 
		 * @param mapId 小地图id
		 * @param mapCongUrl 大地图文件夹
		 * @param compFun 加载完成function
		 * @param updateFun 加载进度function
		 * 
		 */
        public function switchScene(mapId:int, mapCongUrl:String, compFun:Function = null, updateFun:Function = null) : void
        {
			var scene:Scene;
			var newOnComplete:Function;
            var $mapID:int = mapId;
            var $mapConfigUrl:String = mapCongUrl;
            var $onComplete:Function = compFun;
            var $onUpdate:Function = updateFun;
            newOnComplete = function ($mapConfig:MapConfig, $mapTile:Object, $mapSolid:Object) : void
            {
                var slipcover:Object = null;
                var sc:SceneCharacter = null;
                mapConfig = $mapConfig;
                SceneCache.mapTiles = $mapTile;
                SceneCache.mapSolids = $mapSolid;
                if (mapConfig.slipcovers != null && mapConfig.slipcovers.length > 0)
                {
                    for each (slipcover in mapConfig.slipcovers)
                    {
                        sc = createSceneCharacter(SceneCharacterType.DUMMY);
                        sc.pixel_x = slipcover.pixel_x;
                        sc.pixel_y = slipcover.pixel_y;
                        sc.loadAvatarPart(new AvatarParamData(slipcover.sourcePath));
                    }
                }
//                MapLoader.loadSmallMap(scene);
                sceneMapLayer.initMapZones();
                sceneAvatarLayer.initAvatarBD();
                sceneInteractiveLayer.initRange();
                if (mainChar)
                {
                    mainChar.stopMove();
                    mainChar.correctAvatarPosition();
                    mainChar.updateNow = true;
                    sceneCamera.lookAt(mainChar);
                }
                _mouseChar.visible = false;
                sceneRender.startRender(true);
                enableInteractiveHandle();
				if( _gridVisible ){
					drawGrid();
				}else{
					mapGrid.graphics.clear();
					mapGrid.visible = false ;
				}
                if ($onComplete != null)
                {
                    $onComplete();
                }
                return;
            }
            ;
			trace("进入场景，dispose前："+getTimer());
            this.disableInteractiveHandle();
            this.sceneRender.stopRender();
            this.dispose();
            MapLoader.loadMapConfig($mapID, $mapConfigUrl, this, newOnComplete, $onUpdate);
			scene = this ;
            return;
        }
		/**
		 * 设置角色幽灵模式，加载资源 
		 * @param apd
		 * 
		 */
        public function setBlankAvatarParamData(apd:AvatarParamData) : void
        {
            var chara:SceneCharacter = null;
            apd.id_noCheckValid = AvatarPartID.BLANK;
            apd.type = AvatarPartType.BODY;
            apd.repeat = AvatarPartType.getDefaultRepeat(AvatarPartType.BODY);
            apd.useType = 0;
            apd.clearSameType = false;
            this.blankAvatarParamData = apd;
            for each (chara in this.sceneCharacters)
            {
                
                if (chara.type != SceneCharacterType.BAG)
                {
                    chara.loadAvatarPart(this.blankAvatarParamData);
                }
            }
            return;
        }
		/**
		 * 设置阴影 
		 * @param apd
		 * 
		 */
        public function setShadowAvatarParamData(apd:AvatarParamData) : void
        {
            var chara:SceneCharacter = null;
            apd.id_noCheckValid = AvatarPartID.SHADOW;
            apd.type = AvatarPartType.MAGIC_RING;
            apd.repeat = AvatarPartType.getDefaultRepeat(AvatarPartType.MAGIC_RING);
            apd.depth = -int.MAX_VALUE;
            apd.useType = 0;
            apd.clearSameType = false;
            this.shadowAvatarParamData = apd;
            for each (chara in this.sceneCharacters)
            {
                
                if (chara.type != SceneCharacterType.BAG && chara.type != SceneCharacterType.TRANSPORT)
                {
                    chara.loadAvatarPart(this.shadowAvatarParamData);
                }
            }
            return;
        }
		/**
		 * 设置实时阴影 
		 * @param apd
		 * 
		 */
		public function setShadowVisible(value:Boolean=false) : void
		{
			var chara:SceneCharacter = null;
			for each (chara in this.sceneCharacters)
			{
				
				if (chara.type != SceneCharacterType.BAG && chara.type != SceneCharacterType.TRANSPORT)
				{
					chara.enabledShadow = value;
				}
			}
			return;
		}
		/**
		 * 设置选择状态
		 * @param apd
		 * 
		 */
        public function setSelectedAvatarParamData(apd:AvatarParamData) : void
        {
            apd.id_noCheckValid = AvatarPartID.SELECTED;
            apd.type = AvatarPartType.MAGIC_RING;
            apd.repeat = AvatarPartType.getDefaultRepeat(AvatarPartType.MAGIC_RING);
            apd.depth = -int.MAX_VALUE + 1;
            apd.useType = 0;
            apd.clearSameType = false;
            var chara:SceneCharacter = this._selectedCharacter;
            this.setSelectedCharacter(null);
            this._selectedAvatarParamData = apd;
            this.setSelectedCharacter(chara);
            return;
        }
		/**
		 * 设置目标点，鼠标点击位置 
		 * @param apd
		 * 
		 */
        public function setMouseCharAvatarParamData(apd:AvatarParamData) : void
        {
            apd.type = AvatarPartType.BODY;
            apd.repeat = AvatarPartType.getDefaultRepeat(AvatarPartType.BODY);
            this._mouseChar.removeAllAvatarParts(false);
            this._mouseChar.loadAvatarPart(apd);
            return;
        }
		/**
		 * 创建场景角色 
		 * @param $sceneCharacterType 1:Player
		 * @param param2 参数1
		 * @param param3 参数2
		 * @param param4 参数2
		 * @return 
		 * 
		 */
        public function createSceneCharacter($sceneCharacterType:int = 1, param2:int = 0, param3:int = 0, param4:int = 0) : SceneCharacter
        {
            var sc:SceneCharacter = SceneCharacter.createSceneCharacter($sceneCharacterType, this, param2, param3, param4);
            this.addCharacter(sc);
            if (sc.type != SceneCharacterType.DUMMY && sc.type != SceneCharacterType.BAG)
            {
                if (this.blankAvatarParamData != null)
                {
                    sc.loadAvatarPart(this.blankAvatarParamData);
                }
                if (sc.type != SceneCharacterType.TRANSPORT && this.shadowAvatarParamData != null)
                {
                    sc.loadAvatarPart(this.shadowAvatarParamData);
                }
            }
            return sc;
        }

        public function addCharacter(sc:SceneCharacter) : void
        {
            if (sc == null)
            {
                return;
            }
            if (sc.type != SceneCharacterType.DUMMY)
            {
                if (this.sceneCharacters.indexOf(sc) != -1)
                {
                    return;
                }
                this.sceneCharacters.push(sc);
                this.renderCharacters.push(sc);
                Logger.info("###场景角色数量：" + this.sceneCharacters.length + " 虚拟体数量：" + this._sceneDummies.length);
            }
            else
            {
                if (this._sceneDummies.indexOf(sc) != -1)
                {
                    return;
                }
                this._sceneDummies.push(sc);
                this.renderCharacters.push(sc);
				Logger.info("###场景角色数量：" + this.sceneCharacters.length + " 虚拟体数量：" + this._sceneDummies.length);
            }
            sc.visible = this.isAlwaysShowChar(sc) || this.getCharVisible(sc.type);
            sc.updateNow = true;
            return;
        }

        public function removeCharacter(sc:SceneCharacter, recycle:Boolean = true) : void
        {
            var index:int = 0;
            if (sc == null)
            {
                return;
            }
            if (sc.type != SceneCharacterType.DUMMY)
            {
                index = this.sceneCharacters.indexOf(sc);
                if (index != -1)
                {
                    this.sceneCharacters.splice(index, 1);
                    this.renderCharacters.splice(this.renderCharacters.indexOf(sc), 1);
                    TweenLite.killTweensOf(sc);
                    if (this._mouseOnCharacter == sc)
                    {
                        this.setMouseOnCharacter(null);
                    }
                    if (this._selectedCharacter == sc)
                    {
                        this.setSelectedCharacter(null);
                    }
                    this.removeAlwaysShowChar(sc);
                    if (recycle)
                    {
                        SceneCharacter.recycleSceneCharacter(sc);
                    }
                    else
                    {
                        sc.clearMe();
                    }
                }
                Logger.info("###场景角色数量：" + this.sceneCharacters.length + " 虚拟体数量：" + this._sceneDummies.length);
            }
            else
            {
                index = this._sceneDummies.indexOf(sc);
                if (index != -1)
                {
                    this._sceneDummies.splice(index, 1);
                    this.renderCharacters.splice(this.renderCharacters.indexOf(sc), 1);
                    TweenLite.killTweensOf(sc);
                    if (recycle)
                    {
                        SceneCharacter.recycleSceneCharacter(sc);
                    }
                    else
                    {
                        sc.clearMe();
                    }
                }
                Logger.info("###场景角色数量：" + this.sceneCharacters.length + " 虚拟体数量：" + this._sceneDummies.length);
            }
            return;
        }

        public function removeCharacterByIDAndType($id:int, $type:int = 1, $recycle:Boolean = true) : void
        {
            var sc:SceneCharacter = this.getCharByID($id, $type);
            if (this.getCharByID($id, $type) != null)
            {
                this.removeCharacter(sc, $recycle);
            }
            return;
        }

        public function getCharByID($id:int, $type:int = 1) : SceneCharacter
        {
            var sc:SceneCharacter = null;
            for each (sc in this.sceneCharacters)
            {
                if (sc.id == $id && sc.type == $type)
                {
                    return sc;
                }
            }
            return null;
        }

        public function getCharsByType($type:int = 1) : Array
        {
            var sc:SceneCharacter = null;
            var temp:Array = [];
            for each (sc in this.sceneCharacters)
            {
                if (sc.type == $type)
                {
                    temp.push(sc);
                }
            }
            return temp;
        }

        private function dispose() : void
        {
            var sc:SceneCharacter = null;
            SceneCache.mapImgCache.dispose();
            SceneCache.currentMapZones = {};
            SceneCache.mapTiles = {};
            SceneCache.mapSolids = {};
            SceneCache.mapZones = {};
            SceneCache.removeWaitingAvatar(null, null, null, [this.mainChar, this._mouseChar]);
            this.mapConfig = null;
            this.sceneSmallMapLayer.dispose();
            this.sceneMapLayer.dispose();
            this.sceneAvatarLayer.dispose();
            this.sceneHeadLayer.dispose();
			this.sceneShadowLayer.dispose();
            var index:int = 0;
            while (this.renderCharacters.length > index)
            {
                
                sc = this.renderCharacters[index];
                if (sc != this.mainChar && sc != this._mouseChar)
                {
                    this.removeCharacter(sc);
                    continue;
                }
                index++;
            }
            this.hideMouseChar();
            this.setMouseOnCharacter(null);
            this.setSelectedCharacter(null);
            this.renderCharacters = [];
            this.sceneCharacters = [];
            this._sceneDummies = [];
            this._mouseOnCharacter = null;
            this._selectedCharacter = null;
            this.sceneCamera.lookAt(null);
            if (this.mainChar)
            {
                this.mainChar.stopMove();
                this.addCharacter(this.mainChar);
                if (this.mainChar.showContainer)
                {
                    this.sceneHeadLayer.addChild(this.mainChar.showContainer);
                }
            }
            this.addCharacter(this._mouseChar);
            return;
        }

        public function sceneDispatchEvent(event:Event) : void
        {
            if (this.mapConfig != null)
            {
                this.sceneInteractiveLayer.dispatchEvent(event);
            }
            return;
        }

        public function enableInteractiveHandle() : void
        {
            this.sceneInteractiveLayer.enableInteractiveHandle();
            return;
        }

        public function disableInteractiveHandle() : void
        {
            this.sceneInteractiveLayer.disableInteractiveHandle();
            return;
        }

        public function showMouseChar(tileX:Number, tileY:Number) : void
        {
            this._mouseChar.tile_x = tileX;
            this._mouseChar.tile_y = tileY;
            this._mouseChar.visible = true;
            return;
        }

        public function hideMouseChar() : void
        {
            this._mouseChar.visible = false;
            return;
        }

        public function setMouseOnCharacter(sc:SceneCharacter) : void
        {
            if (this._mouseOnCharacter == sc)
            {
                return;
            }
            if (this._mouseOnCharacter != null && this._mouseOnCharacter.usable)
            {
                this._mouseOnCharacter.isMouseOn = false;
            }
            this._mouseOnCharacter = sc;
            if (this._mouseOnCharacter != null && this._mouseOnCharacter.usable)
            {
                this._mouseOnCharacter.isMouseOn = true;
            }
            else
            {
                this._mouseOnCharacter = null;
            }
            return;
        }

        public function getMouseOnCharacter() : SceneCharacter
        {
            return this._mouseOnCharacter;
        }

        public function setSelectedCharacter(sc:SceneCharacter) : void
        {
            if (this._selectedCharacter == sc)
            {
                return;
            }
            if (this._selectedCharacter != null && this._selectedCharacter.usable)
            {
                this._selectedCharacter.removeAvatarPartByID(AvatarPartID.SELECTED);
                this._selectedCharacter.isSelected = false;
            }
            this._selectedCharacter = sc;
            if (this._selectedCharacter != null && this._selectedCharacter.usable)
            {
                if (this._selectedAvatarParamData != null)
                {
                    this._selectedCharacter.loadAvatarPart(this._selectedAvatarParamData);
                }
                this._selectedCharacter.isSelected = true;
            }
            else
            {
                this._selectedCharacter = null;
            }
            return;
        }

        public function getSelectedCharacter() : SceneCharacter
        {
            return this._selectedCharacter;
        }

        public function getSceneObjectsUnderPoint($point:Point) : Array
        {
            var sc:SceneCharacter = null;
            var tempPoint:Point = null;
            var numChild:int = 0;
            var index:int = 0;
            var showCon:ShowContainer = null;
            var color:uint = 0;
            var mapTile:Array = [null, [], []];
            var tileX:int = floor($point.x / TILE_WIDTH);
            var tileY:int = floor($point.y / TILE_HEGHT);
            mapTile[0] = SceneCache.mapTiles[tileX + "_" + tileY];
            if (mapTile[0] == null)
            {
                return mapTile;
            }
            if (!this._charAvatarVisible)
            {
                tempPoint = this.localToGlobal($point);
                numChild = this.sceneHeadLayer.numChildren;
                index = numChild - 1;
                while (index >= 0)
                {
                    
                    showCon = this.sceneHeadLayer.getChildAt(index) as ShowContainer;
                    if (showCon != null && showCon.headFace != null && showCon.visible && showCon.headFace.visible)
                    {
                        if (showCon.headFace.hitTestPoint(tempPoint.x, tempPoint.y, true))
                        {
                            sc = showCon.owner as SceneCharacter;
                            if (sc != null)
                            {
                                if (sc == this.mainChar)
                                {
                                }
                                else
                                {
                                    mapTile[1].push(sc);
                                }
                            }
                        }
                    }
                    index = index - 1;
                }
            }
            var $x:int = floor($point.x / MAX_AVATARBD_WIDTH);
            var $y:int = floor($point.y / MAX_AVATARBD_HEIGHT);
            var bmd:BitmapData = this.sceneAvatarLayer.getAvatarBD($x, $y);
            if (this.sceneAvatarLayer.getAvatarBD($x, $y) != null)
            {
                color = bmd.getPixel32($point.x - $x * MAX_AVATARBD_WIDTH, $point.y - $y * MAX_AVATARBD_HEIGHT);
                if (color != 0)
                {
                    for each (sc in this.sceneCharacters)
                    {
                        
                        if (sc == this.mainChar)
                        {
                            continue;
                        }
                        if (mapTile[1].indexOf(sc) != -1)
                        {
                            continue;
                        }
                        if (sc.mouseRect != null && sc.mouseRect.containsPoint($point))
                        {
                            mapTile[2].push(sc);
                        }
                    }
                }
            }
            if (mapTile[2].length > 0)
            {
                mapTile[2].sortOn("pixel_y", Array.DESCENDING | Array.NUMERIC);
            }
            return mapTile;
        }

        public function updateCameraNow() : void
        {
            this.sceneCamera.run(false);
            return;
        }


		public function get gridVisible():Boolean
		{
			return _gridVisible;
		}

		public function set gridVisible(value:Boolean):void
		{
			_gridVisible = value;
			mapGrid.visible = _gridVisible ;
		}
		
		private function drawGrid():void{
			mapGrid.graphics.clear();
			DrawUtil.drawGrid(mapGrid,mapConfig.mapGridX,mapConfig.mapGridY,SceneConfig.TILE_WIDTH,SceneConfig.TILE_HEIGHT,new Point(),new StyleData(2,0) );
		}

    }
}
