package utils
{
	import vo.CellVO;

	public class GridUtils
	{
		public function GridUtils()
		{
		}
		
		/**
		 * 计算并返回格子的像素坐标
		 * @param n:int 格子的纵坐标
		 */
		public static function getXPos(m:int, n:int):Number
		{
			var xPos:Number = CellVO.CELL_WIDTH*m;
			return xPos;
		}
		
		/**
		 * 计算并返回格子的像素坐标
		 * @param m:int 格子的横坐标
		 */
		public static function getYPos(m:int, n:int):Number
		{
			var yPos:Number = CellVO.CELL_HEIGHT*n;
			return yPos;
		}
		
		public static function getMpos(xpos:Number,ypos:Number):int
		{
			var m:int = int(xpos/CellVO.CELL_WIDTH);
			return m;
		}
		
		public static function getNpos(xpos:Number,ypos:Number):int
		{
			var n:int = int(ypos/CellVO.CELL_HEIGHT);
			return n;
		}
		
		
	}
}