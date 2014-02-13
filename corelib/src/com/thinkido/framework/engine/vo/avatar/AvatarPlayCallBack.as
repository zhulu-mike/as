package com.thinkido.framework.engine.vo.avatar
{
	import com.thinkido.framework.common.handler.HandlerThread;
	import com.thinkido.framework.engine.SceneCharacter;
	import com.thinkido.framework.engine.graphics.avatar.AvatarPart;

	/**
	 * AvatarParamData 回调方法 
	 * @author thinkido
	 * 
	 */
    public class AvatarPlayCallBack extends Object
    {
		public var _onBeforeStartList:Vector.<Function>;
		public var _onStartList:Vector.<Function>;
		public var _onUpdateList:Vector.<Function>;
		public var _onCompleteList:Vector.<Function>;
		public var _onAddList:Vector.<Function>;
		public var _onRemoveList:Vector.<Function>;

		
        public function AvatarPlayCallBack()
        {
			this._onBeforeStartList = new Vector.<Function>;
			this._onStartList = new Vector.<Function>;
			this._onUpdateList = new Vector.<Function>;
			this._onCompleteList = new Vector.<Function>;
			this._onAddList = new Vector.<Function>;
			this._onRemoveList = new Vector.<Function>;
        }

		public function onBeforeStart(param1:SceneCharacter = null, param2:AvatarPart = null) : void
		{
			var _loc_4:Function = null;
			if (_onBeforeStartList == null || _onBeforeStartList.length == 0)
			{
				return;
			}
			var _loc_3:* = _onBeforeStartList.concat();
			for each (_loc_4 in _loc_3)
			{
				_loc_4(param1, param2);
			}
			return;
		}
		
		public function onStart(param1:SceneCharacter = null, param2:AvatarPart = null) : void
		{
			var _loc_4:Function = null;
			if (_onStartList == null || _onStartList.length == 0)
			{
				return;
			}
			var _loc_3:* = _onStartList.concat();
			for each (_loc_4 in _loc_3)
			{
				
				_loc_4(param1, param2);
			}
			return;
		}
		
		public function onUpdate(param1:SceneCharacter = null, param2:AvatarPart = null) : void
		{
			var _loc_4:Function = null;
			if (_onUpdateList == null || _onUpdateList.length == 0)
			{
				return;
			}
			var _loc_3:* = _onUpdateList.concat();
			for each (_loc_4 in _loc_3)
			{
				
				_loc_4(param1, param2);
			}
			return;
		}
		
		public function onComplete(param1:SceneCharacter = null, param2:AvatarPart = null) : void
		{
			var _loc_4:Function = null;
			if (_onCompleteList == null || _onCompleteList.length == 0)
			{
				return;
			}
			var _loc_3:* = _onCompleteList.concat();
			for each (_loc_4 in _loc_3)
			{
				
				_loc_4(param1, param2);
			}
			return;
		}
		
		public function onAdd(param1:SceneCharacter = null, param2:AvatarPart = null) : void
		{
			var _loc_4:Function = null;
			if (_onAddList == null || _onAddList.length == 0)
			{
				return;
			}
			var _loc_3:* = _onAddList.concat();
			for each (_loc_4 in _loc_3)
			{
				
				_loc_4(param1, param2);
			}
			return;
		}
		
		public function onRemove(param1:SceneCharacter = null, param2:AvatarPart = null) : void
		{
			var _loc_4:Function = null;
			if (_onRemoveList == null || _onRemoveList.length == 0)
			{
				return;
			}
			var _loc_3:* = _onRemoveList.concat();
			for each (_loc_4 in _loc_3)
			{
				
				_loc_4(param1, param2);
			}
			return;
		}
		
		public function extendCallBack(param1:Function = null, param2:Function = null, param3:Function = null, param4:Function = null, param5:Function = null, param6:Function = null, param7:Boolean = false) : void
		{
			var _loc_8:int = 0;
			if (param7)
			{
				clearCallBack();
				if (param1 != null)
				{
					_onBeforeStartList.push(param1);
				}
				if (param2 != null)
				{
					_onStartList.push(param2);
				}
				if (param3 != null)
				{
					_onUpdateList.push(param3);
				}
				if (param4 != null)
				{
					_onCompleteList.push(param4);
				}
				if (param5 != null)
				{
					_onAddList.push(param5);
				}
				if (param6 != null)
				{
					_onRemoveList.push(param6);
				}
			}
			else
			{
				if (param1 != null)
				{
					_loc_8 = _onBeforeStartList.indexOf(param1);
					if (_loc_8 == -1)
					{
						_onBeforeStartList.push(param1);
					}
				}
				if (param2 != null)
				{
					_loc_8 = _onStartList.indexOf(param2);
					if (_loc_8 == -1)
					{
						_onStartList.push(param2);
					}
				}
				if (param3 != null)
				{
					_loc_8 = _onUpdateList.indexOf(param3);
					if (_loc_8 == -1)
					{
						_onUpdateList.push(param3);
					}
				}
				if (param4 != null)
				{
					_loc_8 = _onCompleteList.indexOf(param4);
					if (_loc_8 == -1)
					{
						_onCompleteList.push(param4);
					}
				}
				if (param5 != null)
				{
					_loc_8 = _onAddList.indexOf(param5);
					if (_loc_8 == -1)
					{
						_onAddList.push(param5);
					}
				}
				if (param6 != null)
				{
					_loc_8 = _onRemoveList.indexOf(param6);
					if (_loc_8 == -1)
					{
						_onRemoveList.push(param6);
					}
				}
			}
			return;
		}
		
		public function removeCallBack(param1:Function = null, param2:Function = null, param3:Function = null, param4:Function = null, param5:Function = null, param6:Function = null) : void
		{
			var _loc_7:int = 0;
			if (param1 != null)
			{
				_loc_7 = _onBeforeStartList.indexOf(param1);
				if (_loc_7 != -1)
				{
					_onBeforeStartList.splice(_loc_7, 1);
				}
			}
			if (param2 != null)
			{
				_loc_7 = _onStartList.indexOf(param2);
				if (_loc_7 != -1)
				{
					_onStartList.splice(_loc_7, 1);
				}
			}
			if (param3 != null)
			{
				_loc_7 = _onUpdateList.indexOf(param3);
				if (_loc_7 != -1)
				{
					_onUpdateList.splice(_loc_7, 1);
				}
			}
			if (param4 != null)
			{
				_loc_7 = _onCompleteList.indexOf(param4);
				if (_loc_7 != -1)
				{
					_onCompleteList.splice(_loc_7, 1);
				}
			}
			if (param5 != null)
			{
				_loc_7 = _onAddList.indexOf(param5);
				if (_loc_7 != -1)
				{
					_onAddList.splice(_loc_7, 1);
				}
			}
			if (param6 != null)
			{
				_loc_7 = _onRemoveList.indexOf(param6);
				if (_loc_7 != -1)
				{
					_onRemoveList.splice(_loc_7, 1);
				}
			}
			return;
		}
		
		public function clearCallBack(param1:Boolean = true, param2:Boolean = true, param3:Boolean = true, param4:Boolean = true, param5:Boolean = true, param6:Boolean = true) : void
		{
			if (param1)
			{
				_onBeforeStartList.length = 0;
			}
			if (param2)
			{
				_onStartList.length = 0;
			}
			if (param3)
			{
				_onUpdateList.length = 0;
			}
			if (param4)
			{
				_onCompleteList.length = 0;
			}
			if (param5)
			{
				_onAddList.length = 0;
			}
			if (param6)
			{
				_onRemoveList.length = 0;
			}
			return;
		}
		
		public function executeCallBack(param1:SceneCharacter = null, param2:AvatarPart = null, param3:Boolean = true, param4:Boolean = true, param5:Boolean = true, param6:Boolean = true, param7:Boolean = true, param8:Boolean = true, param9:int = 0, param10:int = 0, param11:int = 0, param12:int = 0, param13:int = 0, param14:int = 0) : void
		{
			var _loc_15:HandlerThread = new HandlerThread();
			if (param3 && onBeforeStart != null)
			{
				_loc_15.push(onBeforeStart, [param1, param2], param9);
			}
			if (param4 && onStart != null)
			{
				_loc_15.push(onStart, [param1, param2], param10);
			}
			if (param5 && onUpdate != null)
			{
				_loc_15.push(onUpdate, [param1, param2], param11);
			}
			if (param6 && onComplete != null)
			{
				_loc_15.push(onComplete, [param1, param2], param12);
			}
			if (param7 && onAdd != null)
			{
				_loc_15.push(onAdd, [param1, param2], param13);
			}
			if (param8 && onRemove != null)
			{
				_loc_15.push(onRemove, [param1, param2], param14);
			}
			return;
		}
		
		public function clone() : AvatarPlayCallBack
		{
			var temp:AvatarPlayCallBack = new AvatarPlayCallBack();
			temp._onBeforeStartList = _onBeforeStartList.concat();
			temp._onStartList = _onStartList.concat();
			temp._onUpdateList = _onUpdateList.concat();
			temp._onCompleteList = _onCompleteList.concat();
			temp._onAddList = _onAddList.concat();
			temp._onRemoveList = _onRemoveList.concat();
			return temp;
		}

    }
}
