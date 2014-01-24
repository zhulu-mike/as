package com.thinkido.framework.engine.utils
{
	import com.thinkido.framework.engine.config.MapConfig;
	import com.thinkido.framework.engine.utils.astars.AStarGrid;
	import com.thinkido.framework.engine.utils.astars.AStarNode;
	import com.thinkido.framework.engine.utils.astars.BinaryHeap;
	
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	
	import org.osflash.thunderbolt.Logger;

	/**
	 * a* 寻路 
	 * @author Administrator
	 * 
	 */
    public class Astar extends Object
    {
        private static var ro:Object = {r1:[-1, -1], r2:[0, -1], r3:[1, -1], r4:[1, 0], r5:[1, 1], r6:[0, 1], r7:[-1, 1], r8:[-1, 0]};

		public static var starGrid:AStarGrid = new AStarGrid();
		private static var _endNode:AStarNode;
		private static var _startNode:AStarNode;
		private static var _straightCost:Number = 1.0;
		private static var _diagCost:Number = Math.SQRT2;
		private static var nowversion:int = 1;
		private static var _open:BinaryHeap = new BinaryHeap(justMin);
		
		public static function init():void
		{
			nowversion = 1;
			_endNode = null;
			_startNode = null;
			_open.dispose();
		}
		
        public function Astar() : void
        {
            return;
        }
		
		
		
		
		
		private static function justMin(x:Object, y:Object):Boolean {
			return x.f < y.f;
		}
		
		
		private static function euclidian2(node:AStarNode):Number {
			var dx:Number = node.x - _endNode.x;
			var dy:Number = node.y - _endNode.y;
			return dx * dx + dy * dy;
		}
		
		/**
		 * 寻路 
		 * @param $mapSolid
		 * @param $sx
		 * @param $sy
		 * @param $ex
		 * @param $ey
		 * @param param6
		 * @return 
		 * 
		 */
		public static function search($mapSolid:ByteArray, $sx:int, $sy:int, $ex:int, $ey:int, mapconfig:MapConfig, param6:int = -1) : Array
		{
			var delObj:Object = null;
			var node:Object = null;
			var _loc_17:int = 0;
			var _loc_18:int = 0;
			var _loc_19:int = 0;
			var _loc_20:int = 0;
			var _loc_21:Object = null;
			var _loc_22:int = 0;
			if ($mapSolid)
				$mapSolid.position = 0;
			if (!$mapSolid || $mapSolid.bytesAvailable <= 0)
			{
				Logger.warn("$mapSolid为空");
				return null;
			}
			if ($sx == $ex && $sy == $ey)
			{
				Logger.warn("目标点与起始点相同");
				return null;
			}
			var index:int = 0;
			$mapSolid.position = $sx * mapconfig.mapGridY + $sy;
			var value:int = $mapSolid.readByte();
			if (value != 0)
			{
				Logger.warn("起始点是阻挡点"+value+$sx+"."+$sy);
				return null;
			}
			$mapSolid.position = $ex * mapconfig.mapGridY + $ey;
			value = $mapSolid.readByte();
			if (value != 0)
			{
				Logger.warn("目标点是阻挡点"+value+$sx+"."+$sy);
				return null;
			}
			_open.dispose();
			_startNode = starGrid.getNode($sx, $sy);
			_endNode = starGrid.getNode($ex, $ey);
			nowversion++;
			_startNode.g = 0;
			return searchPath();
		}
		public static function searchPath():Array {
			var time:int = getTimer();
			var node:AStarNode = _startNode;
			node.version = nowversion;
			while (node != _endNode){
				if (node.walkable && node.links == null)
				{
					Astar.starGrid.initNodeLink(node, 0);
				}
				var len:int = node.links.length;
				for (var i:int = 0; i < len; i++){
					var test:AStarNode = node.links[i].node;
					var cost:Number = node.links[i].cost;
					var g:Number = node.g + cost;
					var h:Number = euclidian2(test);
					var f:Number = g + h;
					if (test.version == nowversion){
						if (test.f > f){
							test.f = f;
							test.g = g;
							test.h = h;
							test.parent = node;
						}
					} else {
						test.f = f;
						test.g = g;
						test.h = h;
						test.parent = node;
						_open.ins(test);
						test.version = nowversion;
					}
					
				}
				if (_open.a.length == 1){
					return null;
				}
				node = _open.pop() as AStarNode;
			}
			Logger.warn("寻路花费："+(getTimer()-time));
			return buildPath();
			
		}
		
		/** 弗洛伊德路径平滑处理 */
		public static function floyd(path:Array):Array 
		{
			if (path == null)
				return null;
			var _floydPath:Array = path.concat([]);
			var len:int = _floydPath.length;
			if (len > 2)
			{
				var vector:AStarNode = new AStarNode(0, 0);
				var tempVector:AStarNode = new AStarNode(0, 0);
				//遍历路径数组中全部路径节点，合并在同一直线上的路径节点
				//假设有1,2,3,三点，若2与1的横、纵坐标差值分别与3与2的横、纵坐标差值相等则
				//判断此三点共线，此时可以删除中间点2
				floydVector(vector, _floydPath[len - 1], _floydPath[len - 2]);
				for (var i:int = _floydPath.length - 3; i >= 0; i--)
				{
					floydVector(tempVector, _floydPath[i + 1], _floydPath[i]);
					if (vector.x == tempVector.x && vector.y == tempVector.y)
					{
						_floydPath.splice(i + 1, 1);
					}
					else
					{
						vector.x = tempVector.x;
						vector.y = tempVector.y;
					}
				}
			}
			//合并共线节点后进行第二步，消除拐点操作。算法流程如下：
			//如果一个路径由1-10十个节点组成，那么由节点10从1开始检查
			//节点间是否存在障碍物，若它们之间不存在障碍物，则直接合并
			//此两路径节点间所有节点。
			len = _floydPath.length;
			for (i = len - 1; i >= 0; i--)
			{
				for (var j:int = 0; j <= i - 2; j++)
				{
					if ( starGrid.hasBarrier(_floydPath[i].x, _floydPath[i].y, _floydPath[j].x, _floydPath[j].y) == false )
					{
						for (var k:int = i - 1; k > j; k--)
						{
							_floydPath.splice(k, 1);
						}
						i = j;
						len = _floydPath.length;
						break;
					}
				}
			}
			len = _floydPath.length;
			i = 0;
			var ret:Array = [];
			for (;i<len;i++)
			{
				ret.push([_floydPath[i].x, _floydPath[i].y]);
			}
			return ret;
			
		}
		
		private static function floydVector(target:AStarNode, n1:AStarNode, n2:AStarNode):void {
			target.x = n1.x - n2.x;
			target.y = n1.y - n2.y;
		}
		
		
		
		private static function buildPath():Array {
			var _path:Array = [];
			var node:AStarNode = _endNode;
//			Logger.warn("路径"+node.x+","+node.y+"-"+node.walkable);
			_path.push([node.x, node.y]);
			while (node != _startNode){
				node = node.parent;
				_path.push([node.x, node.y]);
//				Logger.warn("路径"+node.x+","+node.y+"-"+node.walkable);
			}
			return _path;
		}
     /*   public static function search($mapSolid:Object, $sx:int, $sy:int, $ex:int, $ey:int, param6:int = -1) : Array
        {
			var time:int = getTimer();
            var delObj:Object = null;
            var node:Object = null;
            var _loc_17:int = 0;
            var _loc_18:int = 0;
            var _loc_19:int = 0;
            var _loc_20:int = 0;
            var _loc_21:Object = null;
            var _loc_22:int = 0;
            if (!$mapSolid)
            {
                return null;
            }
            if ($sx == $ex && $sy == $ey)
            {
                return null;
            }
            if ($mapSolid[$sx + "_" + $sy] != 0)
            {
                return null;
            }
            if ($mapSolid[$ex + "_" + $ey] != 0)
            {
                return null;
            }
            var resultArr:Array = new Array();
            var startArr:Array = new Array();
            var delObjs:Array = new Array();
            var startPoint:Object = new Object();
			startPoint.x = $sx;
            startPoint.y = $sy;
            startPoint.g = 0;
            var dx:int = $sx - $ex < 0 ? (($sx - $ex) * -1) : ($sx - $ex);
            var dy:int = $sy - $ey < 0 ? (($sy - $ey) * -1) : ($sy - $ey);
            startPoint.h = (dx + dy) * 10;
            startPoint.f = startPoint.g + startPoint.h;
            startPoint.parentPoint = 0;
            var startInt:int = 0;
            updatePoint(startArr, startPoint, startInt++);
            startArr[startPoint.x + "_" + startPoint.y] = startPoint;
            var index:int = 0;
            while (true)
            {
                index++;
                if (param6 > 0)
                {
                    if (index > param6)
                    {
                        return null;
                    }
                }
                if (startArr.length == 0)
                {
                    return null;
                }
                delObj = delPoint(startArr, startInt--);
                delObjs.push(delObj);
                delObjs[delObj.x + "_" + delObj.y] = delObj;
                if (delObj.x == $ex && delObj.y == $ey)
                {
                    node = delObj;
					Logger.warn("路径"+node.x+","+node.y);
                    resultArr.push([node.x, node.y]);
                    while (true)
                    {
                        
                        if (node.parentPoint == 0)
                        {
							Logger.warn("寻路花费："+(getTimer()-time));
                            return resultArr;
                        }
                        node = node.parentPoint;
                        resultArr.push([node.x, node.y]);
						Logger.warn("路径"+node.x+","+node.y);
                    }
                }
                _loc_17 = 1;
                while (_loc_17 <= 8)
                {
                    _loc_18 = delObj.x + ro["r" + _loc_17][0];
                    _loc_19 = delObj.y + ro["r" + _loc_17][1];
                    if ($mapSolid[_loc_18 + "_" + _loc_19] != 0 || delObjs[_loc_18 + "_" + _loc_19] != undefined)
                    {
                    }
                    else
                    {
                        _loc_20 = _loc_17 % 2;
                        if (_loc_20 == 1 && ($mapSolid[delObj.x + "_" + _loc_19] != 0 || $mapSolid[_loc_18 + "_" + delObj.y] != 0))
                        {
                        }
                        else
                        {
                            _loc_21 = startArr[_loc_18 + "_" + _loc_19];
                            _loc_22 = delObj.g + (_loc_20 == 0 ? (10) : (14));
                            if (_loc_21 != null)
                            {
                                if (_loc_22 < _loc_21.g)
                                {
                                    _loc_21.g = _loc_22;
                                    _loc_21.f = _loc_21.g + _loc_21.h;
                                    _loc_21.parentPoint = delObj;
                                    updatePoint(startArr, _loc_21, startArr.indexOf(_loc_21));
                                }
                            }
                            else
                            {
                                _loc_21 = new Object();
                                _loc_21.x = _loc_18;
                                _loc_21.y = _loc_19;
                                _loc_21.g = _loc_22;
                                dx = _loc_18 - $ex < 0 ? ((_loc_18 - $ex) * -1) : (_loc_18 - $ex);
                                dy = _loc_19 - $ey < 0 ? ((_loc_19 - $ey) * -1) : (_loc_19 - $ey);
                                _loc_21.h = (dx + dy) * 10;
                                _loc_21.f = _loc_21.g + _loc_21.h;
                                _loc_21.parentPoint = delObj;
                                updatePoint(startArr, _loc_21, startInt++);
                                startArr[_loc_21.x + "_" + _loc_21.y] = _loc_21;
                            }
                        }
                    }
                    _loc_17++;
                }
            }
			
            return null;
        }*/

        private static function updatePoint($startArr:Array, $startPoint:Object, $startInt:int) : void
        {
            var lastPoint:Object = null;
            var halfPoint:Object = null;
            $startArr[$startInt] = $startPoint;
			var len:int = $startInt + 1 ;
            var half:int = len / 2;
            while (half > 0)
            {
                
                lastPoint = $startArr[(len - 1)];
                halfPoint = $startArr[(half - 1)];
//               临时  注释 修复
				if (lastPoint.f < halfPoint.f)
                {
                    $startArr[(len - 1)] = halfPoint;
                    $startArr[(half - 1)] = lastPoint;
                    len = half;
                    half = len / 2;
                    continue;
                }
                break;
            }
            return;
        }

        private static function delPoint($points:Array, $index:int) : Object
        {
            var _loc_6:int = 0;
            var _loc_7:int = 0;
            var currPoint:Object = null;
            var tempPoint:Object = null;
            var _loc_10:Object = null;
            var _loc_3:* = $points[0];
            var lastIndex:int = $index - 1;
            $points[0] = $points[lastIndex];
            $points.pop();
            var _index:int = 0;
            while ((_index + 1) * 2 < lastIndex)
            {
                
                currPoint = $points[_index];
                _loc_6 = (_index + 1) * 2;
                _loc_7 = _loc_6 + 1;
                tempPoint = $points[(_loc_6 - 1)];
                _loc_10 = _loc_7 != lastIndex ? ($points[(_loc_7 - 1)]) : (null);
                if (_loc_10 != null)
                {
                    if (currPoint.f < tempPoint.f && currPoint.f < _loc_10.f)
                    {
                        break;
                    }
                    if (tempPoint.f <= _loc_10.f)
                    {
                        if (currPoint.f > tempPoint.f)
                        {
                            $points[_index] = tempPoint;
                            $points[(_loc_6 - 1)] = currPoint;
                            _index = _loc_6 - 1;
                        }
                        else
                        {
                            $points[_index] = _loc_10;
                            $points[(_loc_7 - 1)] = currPoint;
                            _index = _loc_7 - 1;
                        }
                    }
                    else if (currPoint.f > _loc_10.f)
                    {
                        $points[_index] = _loc_10;
                        $points[(_loc_7 - 1)] = currPoint;
                        _index = _loc_7 - 1;
                    }
                    else
                    {
                        $points[_index] = tempPoint;
                        $points[(_loc_6 - 1)] = currPoint;
                        _index = _loc_6 - 1;
                    }
                    continue;
                }
                if (currPoint.f > tempPoint.f)
                {
                    $points[_index] = tempPoint;
                    $points[(_loc_6 - 1)] = currPoint;
                    _index = _loc_6 - 1;
                    continue;
                }
                break;
            }
            return _loc_3;
        }

    }
}
