package com.thinkido.framework.engine.utils.astars
{
	import flash.utils.getTimer;

	/**
	 * 二叉堆
	 * 某个元素的左节点和右节点分别为数组的第n*2和n*2+1
	 * 父节点是n/2取整
	 * @author Administrator
	 * 
	 */	
	public class BinaryHeap
	{
			public var a:Array = [];
			public var justMinFun:Function = function(x:Object, y:Object):Boolean {
				return x < y;
			};
			
			/**
			 * 
			 * @param justMinFun 排序的方法
			 * 
			 */			
			public function BinaryHeap(justMinFun:Function = null){
				a.push(-1);
				if (justMinFun != null)
					this.justMinFun = justMinFun;
			}
			
			/**
			 * 插入
			 * 首先把要添加的元素加到数组的末尾，然后和它的父节点（位置为当前位置除以2取整，比如第4个元素的父节点位置是2，第7个元素的父节点位置是3）比较，如果新元素比父节点元素小则交换这两个元素，然后再和新位置的父节点比较，直到它的父节点不再比它大，或者已经到达顶端，及第1的位置。 
			 * @param value
			 * 
			 */			
			public function ins(value:Object):void {
				var p:int = a.length;
				var ctime:int = getTimer();
				a[p] = value;
				var pp:int = p >> 1;
				while (p > 1 && justMinFun(a[p], a[pp])){
					var temp:Object = a[p];
					a[p] = a[pp];
					a[pp] = temp;
					p = pp;
					pp = p >> 1;
				}
			}
			
			/**
			 * 从二叉堆中删除一个元素
			 * 删除元素的过程类似，只不过添加元素是“向上冒”，而删除元素是“向下沉”：删除位置1的元素，把最后一个元素移到最前面，然后和它的两个子节点比较，如果较小的子节点比它小就将它们交换，直到两个子节点都比它大
			 * @return 
			 * 
			 */			
			public function pop():Object {
				var ctime:int = getTimer();
				var min:Object = a[1];
				a[1] = a[a.length - 1];
				a.pop();
				var p:int = 1;
				var l:int = a.length;
				var sp1:int = p << 1;
				var sp2:int = sp1 + 1;
				while (sp1 < l){
					if (sp2 < l){
						var minp:int = justMinFun(a[sp2], a[sp1]) ? sp2 : sp1;
					} else {
						minp = sp1;
					}
					if (justMinFun(a[minp], a[p])){
						var temp:Object = a[p];
						a[p] = a[minp];
						a[minp] = temp;
						p = minp;
						sp1 = p << 1;
						sp2 = sp1 + 1;
					} else {
						break;
					}
				}
				return min;
			}
			
			public function dispose():void
			{
				a.length = 0;
				a.push(-1);
			}
	}
}