package com.thinkido.framework.utils
{
	/**
	 * 数组工具，包括一些常用的方法
	 * @author thinkido
	 * 
	 */
    public class ArrayUtil extends Object
    {
		/**
		 * 加
		 */		
		public static const MergeType_Plus:int = 1;
		/**
		 * 减
		 */		
		public static const MergeType_Sub:int = 2;
		/**
		 * 替换（覆盖）相同数据 
		 */		
		public static const MergeType_Replace:int = 3;
		
		public function ArrayUtil()
		{
			return;
		}
		/**
		 * 删除数组中的元素 ，修改原数组
		 * @param srcArr 数组
		 * @param delItem 需要被删除的元素
		 * @return 删除结果，true 成功。
		 * 
		 */		
		public static function removeItem(srcArr:Array, delItem:Object) : Boolean
		{
			var len:int = srcArr.length;
			var index:int = 0;
			while (index < len)
			{
				if (srcArr[index] == delItem)
				{
					srcArr.splice(index, 1);
					return true;
				}
				index++;
			}
			return false;
		}
		/**
		 * 合并2个数组，返回一个新数组
		 * @param $firstArr 第一个数组
		 * @param $secondArr 第二个数字
		 * @param $firstProp 第一个属性，值为 Number 类型
		 * @param $secondProp 第二个属性，值为 Number 类型
		 * @param $mergeType 合并类型
		 * @return 合并后数组
		 * 
		 */		
		public static function merge($firstArr:Array, $secondArr:Array, $firstProp:String, $secondProp:String, $mergeType:int = 0) : Array
		{
			var _tempArr:Array = null;
			var _item1:Object = null;
			var item:Object = null;
			var _index2:int = 0;
			var _loc_13:int = 0;
			if (!$firstArr || $firstArr.length == 0)
			{
				_tempArr = $secondArr;
				for each (item in _tempArr)
				{
					switch($mergeType)
					{
						case MergeType_Sub:
						{
							item[$secondProp] = -item[$secondProp];
							break;
						}
						default:
						{
							break;
						}
					}
				}
				return _tempArr;
			}
			if (!$secondArr || $secondArr.length == 0)
			{
				_tempArr = $firstArr;
				return _tempArr;
			}
			if (!$firstProp)
			{
				_tempArr = $firstArr.concat($secondArr);
				return _tempArr;
			}
			var _loc_9:Array = [];
			var _tempItemArr:Array = [];
			if (!_tempArr)
			{
				_tempArr = [];
			}
			var _index:int = 0;
			while (_index < $firstArr.length)
			{
				_item1 = $firstArr[_index];
				if (_item1.hasOwnProperty($firstProp))
				{
					_index2 = 0;
					while (_index2 < $secondArr.length)
					{
						item = $secondArr[_index2];
						if (_tempItemArr.indexOf(_index2) == -1 && _loc_9.indexOf(_index2) == -1)
						{
							_tempItemArr.push(_index2);
						}
						if (item.hasOwnProperty($firstProp))
						{
							if (_item1[$firstProp] == item[$firstProp])
							{
								if (_loc_9.indexOf(_index2) == -1)
								{
									_loc_9.push(_index2);
								}
								if (_tempItemArr.indexOf(_index2) != -1)
								{
									_tempItemArr.splice(_tempItemArr.indexOf(_index2), 1);
								}
								switch($mergeType)
								{
									case MergeType_Plus:
									{
										_item1[$secondProp] = _item1[$secondProp] + item[$secondProp];
										break;
									}
									case MergeType_Sub:
									{
										_item1[$secondProp] = _item1[$secondProp] - item[$secondProp];
										break;
									}
									case MergeType_Replace:
									{
										_item1[$secondProp] = item[$secondProp];
										break;
									}
									default:
									{
										break;
									}
								}
							}
						}
						_index2++;
					}
					_tempArr.push(_item1);
				}
				_index++;
			}
			if (_tempItemArr.length > 0)
			{
				for each (_loc_13 in _tempItemArr)
				{
					
					item = $secondArr[_loc_13];
					if ($mergeType == MergeType_Sub)
					{
						item[$secondProp] = -item[$secondProp];
					}
					_tempArr.push(item);
				}
			}
			return _tempArr;
		}

    }
}
