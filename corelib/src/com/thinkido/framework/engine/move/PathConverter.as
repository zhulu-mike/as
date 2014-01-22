package com.thinkido.framework.engine.move
{
    import flash.utils.ByteArray;

    public class PathConverter extends Object
    {

        public function PathConverter()
        {
            return;
        }
		/**
		 * 路劲数据加密，转换为传输数据（2进制） 
		 * @param pathArr
		 * @return 
		 * 解密
		 */
        public static function convertToVector(pathArr:Array) : ByteArray
        {
            var dir:int = 0;
            var temp:ByteArray = new ByteArray();
            if (pathArr.length < 2)
            {
                return temp;
            }
            temp.writeShort(pathArr[0][0]);
            temp.writeShort(pathArr[0][1]);
            var tempX:int = pathArr[0][0];
            var tempY:int = pathArr[0][1];
            var len:int = pathArr.length - 1;
            temp.writeByte(len);
            var encodeDir:int = 0;
            var index:int = 0;
            while (index < len)
            {
                dir = getNextDirection(tempX, tempY, pathArr[(index + 1)][0], pathArr[(index + 1)][1]);
                tempX = pathArr[(index + 1)][0];
                tempY = pathArr[(index + 1)][1];
                if (index % 2 == 0)
                {
                    encodeDir = dir << 4;
                }
                else
                {
                    encodeDir = encodeDir | dir;
                    temp.writeByte(encodeDir);
                }
                index++;
            }
            if (len % 2 == 1)
            {
                temp.writeByte(encodeDir);
            }
            temp.position = 0;
            return temp;
        }
		/**
		 * 
		 * @return 
		 * 转换起始点，方向为坐标点数组
		 */		
		public static function convertToArray(curX:int, curY:int,$dirArr:Array):Array{
			var tempDir:int = 0;
			var face:int = 0;
			var tempLen:int = $dirArr.length ;
			var pathArr:Array = new Array();
			pathArr[0] = [curX, curY];
			var pathArrIndex:int = 1;
			var index:int = 0;
			while (index < tempLen)
			{
				face = $dirArr[index];
				pathArr[pathArrIndex] = [getNextDirectionX6(curX, face), getNextDirectionY6(curY, face)];
				curX = pathArr[pathArrIndex][0];
				curY = pathArr[pathArrIndex][1];
				pathArrIndex++;
				index++;
			}
			return pathArr ;
		}
		
		/**
		 * 网络传输2进制转为点数组 
		 * @param param1 
		 * @return 点数组
		 * 解密
		 */		
        public static function convertToPoint(pathBy:ByteArray) : Array
        {
            var tempDir:int = 0;
            var curX:int = pathBy.readShort();
            var curY:int = pathBy.readShort();
            var tempLen:int = pathBy.readByte();
			var index1:int = 0 ;
			var dirArr:Array = [] ;
            while (index1 < tempLen)
			{
				tempDir = pathBy.readByte();
				dirArr.push(tempDir);
				index1++;
			}
			var pathArr:Array = convertPath(curX,curY,dirArr);
            return pathArr;
        }

        private static function convertPath(curX:int, curY:int,$dirArr:Array) : Array{
			var tempDir:int = 0;
			var dir:int = 0;
			var tempLen:int = $dirArr.length ;
			var pathArr:Array = new Array();
			pathArr[0] = [curX, curY];
			var pathArrIndex:int = 1;
			var len:int = tempLen % 2 == 0 ? (tempLen / 2) : (tempLen / 2 + 1);
			var index:int = 0;
			while (index < len)
			{
				tempDir = $dirArr[index];
				dir = (tempDir & 240) >> 4;
				pathArr[pathArrIndex] = [getNextDirectionX(curX, dir), getNextDirectionY(curY, dir)];
				curX = pathArr[pathArrIndex][0];
				curY = pathArr[pathArrIndex][1];
				pathArrIndex++;
				if (pathArrIndex < (tempLen + 1))
				{
					dir = tempDir & 15;
					pathArr[pathArrIndex] = [getNextDirectionX(curX, dir), getNextDirectionY(curY, dir)];
					curX = pathArr[pathArrIndex][0];
					curY = pathArr[pathArrIndex][1];
					pathArrIndex++;
				}
				index++;
			}
			return pathArr ;
		}
//		方向是从零点顺时针方向开始：  1 2 3 4 5 6 7 0 
        private static function getNextDirectionX(curX:int, nextX:int) : int
        {
            if (nextX == 0 || nextX == 6 || nextX == 7)
            {
                return (curX - 1);
            }
            if (nextX == 1 || nextX == 5)
            {
                return curX;
            }
            if (nextX == 2 || nextX == 3 || nextX == 4)
            {
                return (curX + 1);
            }
            return -1;
        }

        private static function getNextDirection(curX:int, curY:int, nextX:int, nextY:int) : int
        {
            if (nextX < curX)
            {
                if (nextY < curY)
                {
                    return 0;
                }
                if (nextY == curY)
                {
                    return 7;
                }
                return 6;
            }
            else
            {
                if (nextX == curX)
                {
                    if (nextY < curY)
                    {
                        return 1;
                    }
                    return 5;
                }
                else
                {
                    if (nextY < curY)
                    {
                        return 2;
                    }
                    if (nextY == curY)
                    {
                        return 3;
                    }
                    return 4;
                }
            }
        }
//		方向是从零点顺时针方向开始：  1 2 3 4 5 6 7 0 
        private static function getNextDirectionY(curY:int, nextY:int) : int
        {
            if (nextY == 0 || nextY == 1 || nextY == 2)
            {
                return (curY - 1);
            }
            if (nextY == 3 || nextY == 7)
            {
                return curY;
            }
            if (nextY == 4 || nextY == 5 || nextY == 6)
            {
                return (curY + 1);
            }
            return -1;
        }
//		方向是从6点顺时针方向开始：0 1 2 3 4 5 6 7 
		private static function getNextDirectionX6(curX:int, dir:int) : int
		{
			if (dir == 1 || dir == 2 || dir == 3)
			{
				return (curX - 1);
			}
			if (dir == 0 || dir == 4)
			{
				return curX;
			}
			if (dir == 5 || dir == 6 || dir == 7)
			{
				return (curX + 1);
			}
			return -1;
		}
//		方向是从6点顺时针方向开始：0 1 2 3 4 5 6 7 
		private static function getNextDirectionY6(curY:int, dir:int) : int
		{
			if (dir == 3 || dir == 4 || dir == 5)
			{
				return (curY - 1);
			}
			if (dir == 2 || dir == 6)
			{
				return curY;
			}
			if (dir == 7 || dir == 0 || dir == 1)
			{
				return (curY + 1);
			}
			return -1;
		}

    }
}
