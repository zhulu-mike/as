package com.thinkido.framework.engine.vo.avatar
{
	import com.thinkido.framework.common.handler.HandlerThread;
	import com.thinkido.framework.engine.SceneCharacter;
	import com.thinkido.framework.engine.config.GlobalConfig;
	import com.thinkido.framework.engine.graphics.avatar.AvatarPart;
	import com.thinkido.framework.engine.staticdata.AvatarPartID;
	import com.thinkido.framework.engine.staticdata.AvatarPartType;
	import com.thinkido.framework.engine.vo.avatar.DynamicPosition.IDynamicPosition;
	
	import flash.utils.Dictionary;
	
	public class AvatarParamData extends Object
	{
		private var _id:String;
		public var sourcePath:String;
		public var type:String;
		public var repeat:int = 0;
		public var depth:int = 0;
		public var useType:int = 0;
		public var useSpecilizeXY:Boolean = true;
		public var offsetX:int = 0;
		public var offsetY:int = 0;
		public var offsetOnMountX:int = 0;
		public var offsetOnMountY:int = 0;
		public var offsetDandaoStartX:int = 0;
		public var offsetDandaoStartY:int = 0;
		public var dynamicPosition:IDynamicPosition = null;
		public var sleepTime:int = 0;
		public var playCompleteAutoRecycle:Boolean = false;
		public var status:String = "stand";
		public var angle:int = -1;
		public var rotation:int = -1;
		public var clearSameType:Boolean = false;
		public var playCallBack:AvatarPlayCallBack = null;
		public var isBitmap:Boolean = false;
		
		public var useDelay:Boolean = false ;   //添加字段，直接控制使用技能延迟 ，和 useType 字段有部分功能一样
		public var beforeDelay:int = 0 ;
		public var startDelay:int = 0 ;
		public var updateDelay:int = 0 ;
		public var completeDelay:int = 0 ;
		public var addDelay:int = 0 ;
		public var removeDelay:int = 0 ;
		public var hasExecutedCallback:Boolean = false ;
		
		public var statusList:Array;
		public var logicAngleList:Array;
		private var _playCallBackDict:Dictionary;
		private var _baseClassName:String;
		
		/**
		 *  
		 * @param $sourcePath
		 * @param $type
		 * 
		 *  var apd:AvatarParamData ;
		 apd = new AvatarParamData(ResPathManager.getAvatarPath_Effect(ResPathManager.AVATAR_EFFECT , ResPathManager.BATTLE_FIRE));
		 new AvatarParamData(ResPathManager.getAvatarPath_Others(ResPathManager.AVATAR_CLOTHES , 155))
		 apd.clearSameType = true ;
		 apd.type = AvatarPartType.MAGIC_RING ;
		 sc.loadAvatarPart( apd );
		 */
		public function AvatarParamData($sourcePath:String = "", $type:String = "body")
		{
			_playCallBackDict = new Dictionary() ;
			this.sourcePath = $sourcePath;
			if (this.sourcePath != null && this.sourcePath != "")
			{
				//格式为xxxxxxx/mid1/stand.swf
				var prev:String = this.sourcePath.substring(0,sourcePath.lastIndexOf("/"));
				_baseClassName = prev.substring(prev.lastIndexOf("/") + 1,prev.length) + ".";
			}
			this.type = $type;
			this.repeat = AvatarPartType.getDefaultRepeat(this.type);
			return;
		}
		public function getFullSourcePath($status:String) : String
		{
			if (this.sourcePath == null || this.sourcePath == "")
			{
				return null;
			}
			var _str:String = this.isBitmap ? (this.sourcePath) : (this.sourcePath.replace("#", $status));
			if (GlobalConfig.version != null)
			{
				_str = GlobalConfig.version(_str);
			}
			return _str;
		}
		
		public function hasStatus($status:String) : Boolean
		{
			if (this.statusList == null)
			{
				return true;
			}
			return this.statusList.indexOf($status) != -1;
		}
		
		public function get id() : String
		{
			return this._id;
		}
		
		public function set id($id:String) : void
		{
			if (!AvatarPartID.isValidID($id))
			{
				throw new Error("换装ID非法（原因：该ID为引擎换装ID关键字）");
			}
			this._id = $id;
			return;
		}
		
		public function set id_noCheckValid($id:String) : void
		{
			this._id = $id;
			return;
		}
		
		public function hasLogicAngle($angle:int) : Boolean
		{
			if (this.logicAngleList == null)
			{
				return true;
			}
			return this.logicAngleList.indexOf($angle) != -1;
		}
		
		
		
		/**
		 * 扩展回调方法， 
		 * @param BeforeFun
		 * @param startFun
		 * @param updateFun
		 * @param completeFun
		 * @param addFun
		 * @param removeFun
		 * @param isClearOld 如果为真，则 方法覆盖老数据， false: 责 新旧数据添加到一起 并执行
		 * 
		 */
		public function extendCallBack( $status:String, BeforeFun:Function = null, startFun:Function = null, updateFun:Function = null, completeFun:Function = null, addFun:Function = null, removeFun:Function = null, isClearOld:Boolean = false) : void
		{
			if (!this.hasStatus($status))
			{
				return;
			}
			var apc:AvatarPlayCallBack = this._playCallBackDict[$status];
			if (this._playCallBackDict[$status] == null)
			{
				apc = new AvatarPlayCallBack();
				this._playCallBackDict[$status] = apc;
			}
			apc.extendCallBack(BeforeFun, startFun, updateFun, completeFun, addFun, removeFun, isClearOld);
			return;
			
			var onPlayBeforeStart_old:Function;
			var onPlayStart_old:Function;
			var onPlayUpdate_old:Function;
			var onPlayComplete_old:Function;
			var onAdd_old:Function;
			var onRemove_old:Function;
			var $new_onPlayBeforeStart:Function = BeforeFun;
			var $new_onPlayStart:Function = startFun;
			var $new_onPlayUpdate:Function = updateFun;
			var $new_onPlayComplete:Function = completeFun;
			var $new_onAdd:Function = addFun;
			var $new_onRemove:Function = removeFun;
			var $clearOld:Boolean = isClearOld;
			this.playCallBack = this.playCallBack || new AvatarPlayCallBack();
			if ($clearOld)
			{
				this.playCallBack.onBeforeStart = $new_onPlayBeforeStart;
				this.playCallBack.onStart = $new_onPlayStart;
				this.playCallBack.onUpdate = $new_onPlayUpdate;
				this.playCallBack.onComplete = $new_onPlayComplete;
				this.playCallBack.onAdd = $new_onAdd;
				this.playCallBack.onRemove = $new_onRemove;
			}
			else
			{
				if ($new_onPlayBeforeStart != null)
				{
					if (this.playCallBack.onBeforeStart == null)
					{
						this.playCallBack.onBeforeStart = $new_onPlayBeforeStart;
					}
					else
					{
						onPlayBeforeStart_old = this.playCallBack.onBeforeStart;
						this.playCallBack.onBeforeStart = function (param1:SceneCharacter = null, param2:AvatarPart = null) : void
						{
							onPlayBeforeStart_old(param1, param2);
							$new_onPlayBeforeStart(param1, param2);
							return;
						};
					}
				}
				if ($new_onPlayStart != null)
				{
					if (this.playCallBack.onStart == null)
					{
						this.playCallBack.onStart = $new_onPlayStart;
					}
					else
					{
						onPlayStart_old = this.playCallBack.onStart;
						this.playCallBack.onStart = function (param1:SceneCharacter = null, param2:AvatarPart = null) : void
						{
							onPlayStart_old(param1, param2);
							$new_onPlayStart(param1, param2);
							return;
						};
					}
				}
				if ($new_onPlayUpdate != null)
				{
					if (this.playCallBack.onUpdate == null)
					{
						this.playCallBack.onUpdate = $new_onPlayUpdate;
					}
					else
					{
						onPlayUpdate_old = this.playCallBack.onUpdate;
						this.playCallBack.onUpdate = function (param1:SceneCharacter = null, param2:AvatarPart = null) : void
						{
							onPlayUpdate_old(param1, param2);
							$new_onPlayUpdate(param1, param2);
							return;
						};
					}
				}
				if ($new_onPlayComplete != null)
				{
					if (this.playCallBack.onComplete == null)
					{
						this.playCallBack.onComplete = $new_onPlayComplete;
					}
					else
					{
						onPlayComplete_old = this.playCallBack.onComplete;
						this.playCallBack.onComplete = function (param1:SceneCharacter = null, param2:AvatarPart = null) : void
						{
							onPlayComplete_old(param1, param2);
							$new_onPlayComplete(param1, param2);
							return;
						} ;
					}
				}
				if ($new_onAdd != null)
				{
					if (this.playCallBack.onAdd == null)
					{
						this.playCallBack.onAdd = $new_onAdd;
					}
					else
					{
						onAdd_old = this.playCallBack.onAdd;
						this.playCallBack.onAdd = function (param1:SceneCharacter = null, param2:AvatarPart = null) : void
						{
							onAdd_old(param1, param2);
							$new_onAdd(param1, param2);
							return;
						} ;
					}
				}
				if ($new_onRemove != null)
				{
					if (this.playCallBack.onRemove == null)
					{
						this.playCallBack.onRemove = $new_onRemove;
					}
					else
					{
						onRemove_old = this.playCallBack.onRemove;
						this.playCallBack.onRemove = function (param1:SceneCharacter = null, param2:AvatarPart = null) : void
						{
							onRemove_old(param1, param2);
							$new_onRemove(param1, param2);
							return;
						};
					}
				}
			}
			return;
		}
		
		
		/**
		 * 
		 * @param sc 回调方法参数数组0
		 * @param ap 回调方法参数数组1
		 * @param useBefore 在播放前执行回调方法
		 * @param useStart 在开始播放时执行回调方法
		 * @param useUpdate 更新时执行
		 * @param useComplete 播放结束时调用
		 * @param useAdd 添加时调用
		 * @param useRemove 移除时调用
		 * @param beforeDelay 调用延迟
		 * @param startDelay
		 * @param updateDelay
		 * @param completeDelay
		 * @param addDelay
		 * @param removeDelay
		 * 
		 */
		public function getPlayCallBack(status:String) : AvatarPlayCallBack
		{
			return this._playCallBackDict[status];
		}// end function
		/**
		 *  
		 * @param status 状态
		 * @param apcb 赋值的
		 * @return 返回被赋值前的apcb
		 * 
		 */		
		public function setPlayCallBack(status:String, apcb:AvatarPlayCallBack) : AvatarPlayCallBack
		{
			var _loc_3:AvatarPlayCallBack = this._playCallBackDict[status];
			this._playCallBackDict[status] = apcb;
			return _loc_3;
		}
		
		public function clearCallBack($status:String = null) : void
		{
			var _loc_2:AvatarPlayCallBack = null;
			var _loc_3:String = null;
			if ($status == null)
			{
				for (_loc_3 in this._playCallBackDict)
				{
					
					_loc_2 = this._playCallBackDict[_loc_3];
					_loc_2.clearCallBack();
					delete this._playCallBackDict[_loc_3];
				}
			}
			else
			{
				_loc_2 = this._playCallBackDict[$status];
				if (_loc_2 != null)
				{
					_loc_2.clearCallBack();
					delete this._playCallBackDict[$status];
				}
			}
			return;
		}
		
		public function executeCallBack(sc:SceneCharacter = null, ap:AvatarPart = null, status:String = "", useBefore:Boolean = true, useStart:Boolean = true, useUpdate:Boolean = true, useComplete:Boolean = true, useAdd:Boolean = true, useRemove:Boolean = true, $beforeDelay:int = 0, $startDelay:int = 0, $updateDelay:int = 0, $completeDelay:int = 0, $addDelay:int = 0, $removeDelay:int = 0) : void
		{
			if (!this.hasStatus(status))
			{
				return;
			}
			var _apcb:AvatarPlayCallBack = this._playCallBackDict[status];
			if (this._playCallBackDict[status] == null)
			{
				return;
			}
			_apcb.executeCallBack(sc, ap,useBefore, useStart, useUpdate, useComplete, useAdd, useRemove,$beforeDelay, $startDelay, $updateDelay, $completeDelay, $addDelay,$removeDelay);
			return;
			
			
			beforeDelay = $beforeDelay||beforeDelay ;
			startDelay = $startDelay||startDelay ;
			updateDelay = $updateDelay||updateDelay ;
			completeDelay = $completeDelay||completeDelay ;
			addDelay = $addDelay||addDelay ;
			removeDelay = $removeDelay||removeDelay ;
			if (this.playCallBack == null || hasExecutedCallback )
			{
				return;
			}
			hasExecutedCallback = true ;
			var ht:HandlerThread = new HandlerThread();
			if (useBefore && this.playCallBack.onBeforeStart != null)
			{
				ht.push(this.playCallBack.onBeforeStart, [sc, ap], beforeDelay);
			}
			if (useStart && this.playCallBack.onStart != null)
			{
				ht.push(this.playCallBack.onStart, [sc, ap], startDelay);
			}
			if (useUpdate && this.playCallBack.onUpdate != null)
			{
				ht.push(this.playCallBack.onUpdate, [sc, ap], updateDelay);
			}
			if (useComplete && this.playCallBack.onComplete != null)
			{
				ht.push(this.playCallBack.onComplete, [sc, ap], completeDelay);
			}
			if (useAdd && this.playCallBack.onAdd != null)
			{
				ht.push(this.playCallBack.onAdd, [sc, ap], addDelay);
			}
			if (useRemove && this.playCallBack.onRemove != null)
			{
				ht.push(this.playCallBack.onRemove, [sc, ap], removeDelay);
			}
			return;
		}
		/**
		 * 复制自己 
		 * @return 
		 * 
		 */
		public function clone() : AvatarParamData
		{
			var temp:AvatarParamData = new AvatarParamData(this.sourcePath, this.type);
			var _status:String = null;
			var _apcb:AvatarPlayCallBack = null;
			temp.id_noCheckValid = this.id;
			temp.repeat = this.repeat;
			temp.depth = this.depth;
			temp.useType = this.useType;
			temp.offsetX = this.offsetX;
			temp.offsetY = this.offsetY;
			temp.offsetOnMountX = this.offsetOnMountX;
			temp.offsetOnMountY = this.offsetOnMountY;
			temp.offsetDandaoStartX = this.offsetDandaoStartX;
			temp.offsetDandaoStartY = this.offsetDandaoStartY;
			
			for (_status in this._playCallBackDict)
			{
				_apcb = this._playCallBackDict[_status];
				temp.setPlayCallBack(_status, _apcb.clone());
			}
			
			
			if (this.statusList != null)
			{
				temp.statusList = this.statusList.concat();
			}
			if (this.dynamicPosition != null)
			{
				temp.dynamicPosition = this.dynamicPosition.clone();
			}
			temp.sleepTime = this.sleepTime;
			temp.useSpecilizeXY = this.useSpecilizeXY;
			temp.status = this.status;
			temp.angle = this.angle;
			temp.rotation = this.rotation;
			temp.clearSameType = this.clearSameType;
			temp.useDelay = this.useDelay ;
			temp.beforeDelay = this.beforeDelay ;
			temp.startDelay = this.startDelay ;
			temp.updateDelay = this.updateDelay ;
			temp.completeDelay = this.completeDelay ;
			temp.addDelay = this.addDelay ;
			temp.removeDelay = this.removeDelay;
			temp.hasExecutedCallback = this.hasExecutedCallback ;
			if (this.playCallBack != null)
			{
				temp.playCallBack = this.playCallBack.clone();
			}
			return temp;
		}
		/**
		 * 是否一样
		 * @param apd 对比的AvatarParamData
		 * @return 
		 * 
		 */
		public function equals(apd:AvatarParamData) : Boolean
		{
			return apd.hasExecutedCallback = this.hasExecutedCallback && this.sourcePath == apd.sourcePath && this.type == apd.type && this.id == apd.id && this.repeat == apd.repeat && this.depth == apd.depth && this.useType == apd.useType && this.offsetX == apd.offsetX && this.offsetY == apd.offsetY && this.offsetOnMountX == apd.offsetOnMountX && this.offsetOnMountY == apd.offsetOnMountY && this.offsetDandaoStartX == apd.offsetDandaoStartX && this.offsetDandaoStartY == apd.offsetDandaoStartY && (this.dynamicPosition == null && apd.dynamicPosition == null || this.dynamicPosition.equals(apd.dynamicPosition)) && this.sleepTime == apd.sleepTime && this.useSpecilizeXY == apd.useSpecilizeXY && this.status == apd.status && this.angle == apd.angle && this.rotation == apd.rotation && this.clearSameType == apd.clearSameType && useDelay == apd.useDelay;
		}

		public function get baseClassName():String
		{
			return _baseClassName;
		}

		
	}
}