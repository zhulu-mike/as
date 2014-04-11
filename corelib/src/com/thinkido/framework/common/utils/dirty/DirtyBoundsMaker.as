package com.thinkido.framework.common.utils.dirty
{
    import com.thinkido.framework.common.linkedlist.*;
    import com.thinkido.framework.common.pool.Pool;
    import com.thinkido.framework.common.vo.*;
    import com.thinkido.framework.manager.PoolManager;

	/**
	 * 以链表的方式添加bounds，便于渲染快速存取 
	 * @author thinkido
	 * 
	 */
    public class DirtyBoundsMaker extends Object
    {
        private var first:LNode;
        private var last:LNode;
        private var beginLN:LNode;
		private var nodePool:Pool = PoolManager.creatPool("nodePool",3000);

        public function DirtyBoundsMaker()
        {
            return;
        }

        public function clear() : void
        {
			var temp:LNode = last?last.pre:null ;
			var temp1:LNode ;
			while(temp){
				if(temp.data != null){
					Bounds.deleteBounds(Bounds(temp.data));
				}
				temp1 = temp.pre ;
				nodePool.disposeObj(temp);
				temp = temp1 ;
			}
            this.first = null;
            this.last = null;
            this.beginLN = null;
            return;
        }

        public function addBounds(bound:Bounds, useBegin:Boolean = false) : void
        {
			var lBound:Bounds = null;
			var _interBounds:Bounds = null;
			var _unionBounds:Bounds = null;
			var lNode:LNode = this.first || (useBegin ? (this.beginLN) : (this.first));
			if (lNode != null)
			{
				while (lNode != null)
				{
					
					lBound = lNode.data as Bounds;
					if (lBound.bottom <= bound.top)
					{
						lNode = lNode.next;
						continue;
					}
					if (lBound.top >= bound.bottom)
					{
						//                        this.add(new LNode(bound), lNode.pre);
						this.add( nodePool.createObj(LNode,bound) as LNode, lNode.pre);
						return;
					}
					_interBounds = lBound.intersection(bound);
					if (_interBounds)
					{
						if (_interBounds.equals(bound))
						{
							Bounds.deleteBounds(bound);
						}
						else if (_interBounds.equals(lBound))
						{
							this.remove(lNode);
							if (this.beginLN != null)
							{
								this.addBounds(bound);
							}
							else
							{
								this.add(new LNode(bound), this.last);
							}
						}
						else
						{
							_unionBounds = lBound.union(bound);
							this.remove(lNode);
							this.beginLN = this.first;
//							Bounds.deleteBounds(bound);
							if (this.beginLN != null)
							{
								this.addBounds(_unionBounds);
							}
							else
							{
								this.add(new LNode(_unionBounds), this.last);
							}
						}
//						Bounds.deleteBounds(_interBounds);
						return;
					}
					lNode = lNode.next;
					continue;
				}
				if (lNode == null)
				{
					this.add(new LNode(bound), this.last);
				}
			}
			else
			{
				this.add(new LNode(bound), null);
			}
			return;
        }

        private function cutTwoIntersectedBounds($b1:Bounds, $b2:Bounds) : Array
        {
            var _left:Number = NaN;
            var _riht:Number = NaN;
            var _top:Number = NaN;
            var _buttom:Number = NaN;
            var _loc_10:Number = NaN;
            var _loc_11:Number = NaN;
            var _loc_3:Array = [];
            var _arr1:Array = [$b1.top, $b1.bottom, $b2.top, $b2.bottom].sort(Array.NUMERIC);
            var _arr2:Array = [$b1.left, $b1.right, $b2.left, $b2.right].sort(Array.NUMERIC);
            var _topB:Bounds = $b1.top <= $b2.top ? ($b1) : ($b2);
            _left = Bounds($b1.top <= $b2.top ? ($b1) : ($b2)).left;
            _riht = _topB.right;
            _top = _arr2[0];
            _buttom = _arr2[3];
            _topB = $b1.bottom >= $b2.bottom ? ($b1) : ($b2);
            _loc_10 = _topB.left;
            _loc_11 = _topB.right;
            return [new Bounds(_left, _riht, _arr1[0], _arr1[1]), new Bounds(_top, _buttom, _arr1[1], _arr1[2]), new Bounds(_loc_10, _loc_11, _arr1[2], _arr1[3])];
        }

        public function getBoundsArr() : Array
        {
            var tempArr:Array = [];
            var lNode:LNode = this.first;
            while (lNode != null)
            {
                tempArr.push(lNode.data);
                lNode = lNode.next;
            }
            return tempArr;
        }

        private function add($newBounds:LNode, $preBounds:LNode = null) : void
        {
            if ($preBounds == null)
            {
                this.first = $newBounds;
                this.first.pre = null;
                this.first.next = null;
                this.last = $newBounds;
                this.last.pre = null;
                this.last.next = null;
            }
            else if ($preBounds == this.last)
            {
                this.last.next = $newBounds;
                $newBounds.pre = this.last;
                this.last = $newBounds;
            }
            else
            {
                $newBounds.pre = $preBounds;
                $newBounds.next = $preBounds.next;
                $newBounds.pre.next = $newBounds;
                $newBounds.next.pre = $newBounds;
            }
            return;
        }

        private function remove(lNode:LNode) : void
        {
            if (lNode == this.first)
            {
                if (lNode == this.last)
                {
                    this.first = null;
                    this.last = null;
                }
                else
                {
                    this.first = lNode.next;
                    this.first.pre = null;
                }
            }
            else if (lNode == this.last)
            {
                this.last = this.last.pre;
                this.last.next = null;
            }
            else
            {
                lNode.pre.next = lNode.next;
                lNode.next.pre = lNode.pre;
            }
            this.beginLN = lNode.next;
            return;
        }

    }
}
