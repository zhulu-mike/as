package com.thinkido.framework.engine.move
{
	import com.thinkido.framework.common.events.EventDispatchCenter;
	import com.thinkido.framework.engine.SceneCharacter;
	import com.thinkido.framework.engine.events.SceneEvent;
	import com.thinkido.framework.engine.events.SceneEventAction_walk;
	
	import flash.geom.Point;

    public class PathCutter extends Object
    {
        public var sceneCharacter:SceneCharacter;
        private var $sourcePath:Array;
        private var movePaths:Array;
        private var currentMovetag:int = 0;

        public function PathCutter(sc:SceneCharacter)
        {
            this.sceneCharacter = sc;
            return;
        }

        public function clear() : void
        {
            this.$sourcePath = null;
            this.movePaths = null;
            this.currentMovetag = 0;
            return;
        }

        public function walkNext($tileX:int, $tileY:int) : void
        {
            if (this.movePaths == null || this.movePaths.length == 0)
            {
                return;
            }
            var currentArr:Array = this.movePaths[this.currentMovetag];
            if (currentArr[(currentArr.length - 1)][0] == $tileX && currentArr[(currentArr.length - 1)][1] == $tileY)
            {
				currentMovetag += 1;
                currentArr = this.movePaths[this.currentMovetag];
                if (currentArr == null || currentArr.length == 1)
                {
                    return;
                }
                this.sendPathMsg(currentArr);
            }
            else if ($tileX == -1 && $tileY == -1)
            {
                if (currentArr.length == 1)
                {
                    this.sendPathMsg(currentArr);
                }
                else
                {
                    this.sendPathMsg(currentArr);
                }
            }
            return;
        }
		/**
		 * 
		 * @param value （主角寻路后）移动路径
		 * 五步一发消息修改
		 */
        public function cutMovePath(value:Array) : void
        {
            var index:int = 0;
            if (value.length < 1)
            {
                return;
            }
            this.movePaths = [];
            this.currentMovetag = 0;
            this.$sourcePath = value;
            var len:int = this.$sourcePath.length;
            var _sendPathNum:int = 5;
			/** 每一段要发送致服务器端的数据 , 5步一发数据如下：0 1 2 3 4 5| 5 6 7 8 9 10|  10 11 12 13 14 15|15 16 17 */
            var _partPath:Array = []; 
            var _temp:Array = [];
            index = 0;
			while (index < len)
            {
                _partPath[_partPath.length] = [this.$sourcePath[index][0], this.$sourcePath[index][1]];
                if (index != 0 && index % _sendPathNum == 0 || index == (len - 1) )   //第五步或者最后剩下的一步
                {
                    if (this.movePaths.length != 0)
                    {
                        _partPath.splice(0, 0, [_temp[0], _temp[1]]);
                    }
                    _temp = [this.$sourcePath[index][0], this.$sourcePath[index][1]];
                    this.movePaths[this.movePaths.length] = _partPath;
                    _partPath = [];
                }
                index++;
            }
            return;
        }
		/**
		 * 每 5 title 一组 发一次数据  
		 * @param pathArr
		 * 包括起始点、终点 6格title
		 * 现在在walkNext 中修改为 每格发一次数据
		 */
        public function sendPathMsg(pathArr:Array) : void
        {
            if (pathArr.length < 2)
            {
                return;
            }
//            var by:ByteArray = PathConverter.convertToVector(pathArr);
            var se:SceneEvent = new SceneEvent(SceneEvent.WALK, SceneEventAction_walk.SEND_PATH, [this.sceneCharacter, pathArr]);
            EventDispatchCenter.getInstance().dispatchEvent(se);
            return;
        }
		/**
		 * 将数组路径转换为方向路径 
		 * @param pathArr
		 * @return 
		 * 
		 */
        private function convertPath(pathArr:Array) : Array
        {
            var index:int = 0;
            var temp:Array = [];
            temp[temp.length] = [pathArr[0][0], pathArr[0][1]];
            var len:int = pathArr.length;
            index = 0;
            while (index < len)
            {
                temp[temp.length] = this.getVectorBy2Point(new Point(pathArr[index][0], pathArr[index][0]), new Point(pathArr[(index + 1)][0], pathArr[(index + 1)][0]));
                index++;
            }
            return temp;
        }

		/**
		 * 根据2点获取前端方向 ，-1 为错误，
		 * @param curP
		 * @param nextP
		 * @return 
		 * 方向从时钟12点方向开始：5 6 7 0 1 2 3 4
		 */		
        private function getVectorBy2Point(curP:Point, nextP:Point) : int
        {
            var tempX:int = nextP.x - curP.x;
            var tempY:int = nextP.y - curP.y;
            if (tempX == 0 && tempY == 1)
            {
                return 0;
            }
            if (tempX == -1 && tempY == 1)
            {
                return 1;
            }
            if (tempX == -1 && tempY == 0)
            {
                return 2;
            }
            if (tempX == -1 && tempY == -1)
            {
                return 3;
            }
            if (tempX == 0 && tempY == -1)
            {
                return 4;
            }
            if (tempX == 1 && tempY == -1)
            {
                return 5;
            }
            if (tempX == 1 && tempY == 0)
            {
                return 6;
            }
            if (tempX == 1 && tempY == 1)
            {
                return 7;
            }
            return -1;
        }

    }
}
