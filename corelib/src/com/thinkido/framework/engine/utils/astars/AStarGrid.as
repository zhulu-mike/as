package com.thinkido.framework.engine.utils.astars
{
	import com.thinkido.framework.utils.MathUtil;
	
	import flash.geom.Point;

	public class AStarGrid
	{
		private var _startNode:AStarNode;
		private var _endNode:AStarNode;
		private var _nodes:Object = {};
		private var _numCols:int;
		private var _numRows:int;
		
		private var type:int;
		
		private var _straightCost:Number = 1.0;
		private var _diagCost:Number = Math.SQRT2;
		
		public function AStarGrid(numCols:int=0, numRows:int=0){
			init(numCols, numRows);
		}
		
		public function init(numCols:int, numRows:int):void
		{
			dispose();
			_numCols = numCols;
			_numRows = numRows;
			_nodes = {};
//			for (var i:int = 0; i < _numCols; i++){
//				_nodes[i] = [];
//				for (var j:int = 0; j < _numRows; j++){
//					_nodes[i][j] = new AStarNode(i, j);
//				}
//			}
		}
		
		/**
		 *
		 * @param    type    0八方向 1四方向 2跳棋
		 */
		public function calculateLinks(type:int = 0):void {
//			this.type = type;
//			for (var i:int = 0; i < _numCols; i++){
//				for (var j:int = 0; j < _numRows; j++){
//					if (_nodes[i][j].walkable)
//						initNodeLink(_nodes[i][j], type);
//				}
//			}
		}
		
		public function getType():int {
			return type;
		}
		
		/**
		 *
		 * @param    node
		 * @param    type    0八方向 1四方向 2跳棋
		 */
		public function initNodeLink(node:AStarNode, type:int):void {
			var startX:int = Math.max(0, node.x - 1);
			var endX:int = Math.min(numCols - 1, node.x + 1);
			var startY:int = Math.max(0, node.y - 1);
			var endY:int = Math.min(numRows - 1, node.y + 1);
			node.links = [];
			for (var i:int = startX; i <= endX; i++){
				for (var j:int = startY; j <= endY; j++){
					var test:AStarNode = getNode(i, j);
					if (test == null || test == node || !test.walkable){
						continue;
					}
					if (type != 2 && i != node.x && j != node.y){
						var test2:AStarNode = getNode(node.x, j);
						if (test2 == null || !test2.walkable){
							continue;
						}
						test2 = getNode(i, node.y);
						if (test2 == null || !test2.walkable){
							continue;
						}
					}
					var cost:Number = _straightCost;
					if (!((node.x == test.x) || (node.y == test.y))){
						if (type == 1){
							continue;
						}
						if (type == 2 && (node.x - test.x) * (node.y - test.y) == 1){
							continue;
						}
						if (type == 2){
							cost = _straightCost;
						} else {
							cost = _diagCost;
						}
					}
					node.links.push(new AStarLink(test, cost));
				}
			}
		}
		
		public function getNode(x:int, y:int):AStarNode {
			if (_nodes[x+"_"+y] == undefined)
				return null;
			return _nodes[x+"_"+y];
		}
		
		public function setEndNode(x:int, y:int):void {
			_endNode = _nodes[x+"_"+y];
		}
		
		public function setStartNode(x:int, y:int):void {
			_startNode = _nodes[x+"_"+y];
		}
		
		public function setWalkable(x:int, y:int, value:Boolean):void {
			if (_nodes[x+"_"+y] == undefined)
				_nodes[x+"_"+y] = new AStarNode(x,y);
			_nodes[x+"_"+y].walkable = value;
		}
		
		public function get endNode():AStarNode {
			return _endNode;
		}
		
		public function get numCols():int {
			return _numCols;
		}
		
		public function get numRows():int {
			return _numRows;
		}
		
		public function get startNode():AStarNode {
			return _startNode;
		}
		
		public function dispose():void
		{
			_startNode = null;
			_endNode = null;
			var len:int = _nodes.length, i:int = 0, j:int = 0, len2:int = 0;
			var temp:AStarNode
			for each (temp in _nodes)
			{
				temp.dispose();
			}
			_nodes = null;
			_numCols = 0;
			_numRows = 0;
		}
		
		/**
		 * 判断两节点之间是否存在障碍物 
		 * 
		 */                
		public function hasBarrier( startX:int, startY:int, endX:int, endY:int ):Boolean
		{
			//如果起点终点是同一个点那傻子都知道它们间是没有障碍物的
			if( startX == endX && startY == endY )return false;		
			if( getNode(endX, endY).walkable == false )return true;
			
			//两节点中心位置
			var point1:Point = new Point( startX + 0.5, startY + 0.5 );
			var point2:Point = new Point( endX + 0.5, endY + 0.5 );
			
			var distX:Number = Math.abs(endX - startX);
			var distY:Number = Math.abs(endY - startY);									
			
			/**遍历方向，为true则为横向遍历，否则为纵向遍历*/
			var loopDirection:Boolean = distX > distY ? true : false;
			
			/**起始点与终点的连线方程*/
			var lineFuction:Function;
			
			/** 循环递增量 */
			var i:Number;
			
			/** 循环起始值 */
			var loopStart:Number;
			
			/** 循环终结值 */
			var loopEnd:Number;
			
			/** 起终点连线所经过的节点 */
			var nodesPassed:Array = [];
			var elem:AStarNode;
			
			//为了运算方便，以下运算全部假设格子尺寸为1，格子坐标就等于它们的行、列号
			if( loopDirection )
			{				
				lineFuction = MathUtil.getLineFunc(point1, point2, 0);
				
				loopStart = Math.min( startX, endX );
				loopEnd = Math.max( startX, endX );
				
				//开始横向遍历起点与终点间的节点看是否存在障碍(不可移动点) 
				for( i=loopStart; i<=loopEnd; i++ )
				{
					//由于线段方程是根据终起点中心点连线算出的，所以对于起始点来说需要根据其中心点
					//位置来算，而对于其他点则根据左上角来算
					if( i==loopStart )i += .5;
					//根据x得到直线上的y值
					var yPos:Number = lineFuction(i);
					
					
					nodesPassed = getNodesUnderPoint( i, yPos );
					for each( elem in nodesPassed )
					{
						if( elem.walkable == false )return true;
					}
					
					
					if( i == loopStart + .5 )i -= .5;
				}
			}
			else
			{
				lineFuction = MathUtil.getLineFunc(point1, point2, 1);
				
				loopStart = Math.min( startY, endY );
				loopEnd = Math.max( startY, endY );
				
				//开始纵向遍历起点与终点间的节点看是否存在障碍(不可移动点)
				for( i=loopStart; i<=loopEnd; i++ )
				{
					if( i==loopStart )i += .5;
					//根据y得到直线上的x值
					var xPos:Number = lineFuction(i);
					
					nodesPassed = getNodesUnderPoint( xPos, i );
					for each( elem in nodesPassed )
					{
						if( elem.walkable == false )return true;
					}
					
					if( i == loopStart + .5 )i -= .5;
				}
			}
			
			
			return false;			
		}
		
		/**
		 * 得到一个点下的所有节点 
		 * @param xPos		点的横向位置
		 * @param yPos		点的纵向位置
		 * @param grid		所在网格
		 * @param exception	例外格，若其值不为空，则在得到一个点下的所有节点后会排除这些例外格
		 * @return 			共享此点的所有节点
		 * 
		 */		
		public function getNodesUnderPoint( xPos:Number, yPos:Number, exception:Array=null ):Array
		{
			var result:Array = [];
			var xIsInt:Boolean = xPos % 1 == 0;
			var yIsInt:Boolean = yPos % 1 == 0;
			
			//点由四节点共享情况
			if( xIsInt && yIsInt )
			{
				result[0] = getNode( xPos - 1, yPos - 1);
				result[1] = getNode( xPos, yPos - 1);
				result[2] = getNode( xPos - 1, yPos);
				result[3] = getNode( xPos, yPos);
			}
				//点由2节点共享情况
				//点落在两节点左右临边上
			else if( xIsInt && !yIsInt )
			{
				result[0] = getNode( xPos - 1, int(yPos) );
				result[1] = getNode( xPos, int(yPos) );
			}
				//点落在两节点上下临边上
			else if( !xIsInt && yIsInt )
			{
				result[0] = getNode( int(xPos), yPos - 1 );
				result[1] = getNode( int(xPos), yPos );
			}
				//点由一节点独享情况
			else
			{
				result[0] = getNode( int(xPos), int(yPos) );
			}
			
			//在返回结果前检查结果中是否包含例外点，若包含则排除掉
			if( exception && exception.length > 0 )
			{
				for( var i:int=0; i<result.length; i++ )
				{
					if( exception.indexOf(result[i]) != -1 )
					{
						result.splice(i, 1);
						i--;
					}
				}
			}
			
			return result;
		}
		
	}
}