package lm.mui.manager
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Quint;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import lm.mui.events.DragEvent;

    public class DragManager extends Object
    {
        public var currentDragItem:IDragDrop;
        public var currentDrogItem:IDragDrop;
        private var dragLayer:DisplayObjectContainer;
        private var tempDragItem:DisplayObject;
        private var thumItem:Sprite;
        private var oldMoveOverItem:IDragDrop;
        private var tempCurrentDragItem:IDragDrop;
        private var currentDragSource:Object;
        private var dragBitMapData:BitmapData;
        private static var _instance:DragManager;
		private var _stage:Stage;

        public function DragManager(param1:DisplayObjectContainer)
        {
            if (_instance != null)
            {
                throw new Error(" DragManager 单例 ");
            }
            this.dragLayer = param1;
            _instance = this;
            return;
        }

        public function startDragItem(param1:IDragDrop, param2:BitmapData = null) : void
        {
            var rect:Rectangle = null;
            var posX:Number = NaN;
            var posY:Number = NaN;
            if (!param1.isDragAble)
            {
                return;
            }
            this.dragBitMapData = param2;
            this.currentDragSource = param1.dragSource;
            var displayObj:DisplayObject = param1 as DisplayObject;
            if (instance.tempCurrentDragItem == null)
            {
				rect = displayObj.getBounds((param1 as DisplayObject).parent);
				posX = displayObj.parent.mouseX;
				posY = displayObj.parent.mouseY;
                if (posX > rect.left && posX < rect.right && posY > rect.top && posY < rect.bottom)
                {
                    this.doDragItem(displayObj);
                }
            }
            return;
        }

        private function doDragItem(param1:DisplayObject) : void
        {
            this.clearThum();
            this.tempDragItem = param1;  //拖动源对象
            this.currentDragItem = param1 as IDragDrop;  //拖动源对象
            param1.addEventListener(MouseEvent.MOUSE_MOVE, this.onDragItemMove);
            param1.addEventListener(MouseEvent.MOUSE_UP, this.onStopDrag);
            return;
        }

        private function onStopDrag(event:MouseEvent) : void
        {
            this.tempDragItem.removeEventListener(MouseEvent.MOUSE_UP, this.onStopDrag);
            this.tempDragItem.removeEventListener(MouseEvent.MOUSE_MOVE, this.onDragItemMove);
            return;
        }

        private function onDragItemMove(event:Event) : void
        {
            var bmd:BitmapData;
            var bitmap:Bitmap;
            var rect:Rectangle;
            this.tempDragItem.removeEventListener(MouseEvent.MOUSE_UP, this.onStopDrag);
            this.tempDragItem.removeEventListener(MouseEvent.MOUSE_MOVE, this.onDragItemMove);
            if (this.thumItem == null)
            {
                this.tempDragItem.dispatchEvent(new DragEvent(DragEvent.Event_Start_Drag, this.currentDragItem, this.currentDrogItem, this.currentDragSource, true));
                this.thumItem = new Sprite();
                if (this.dragBitMapData)
                {
					bmd = this.dragBitMapData;
                }
                else
                {
                    if (this.tempDragItem.width > 0 && this.tempDragItem.height > 0)
                    {
						rect = this.tempDragItem.getRect(this.dragLayer);
						bmd = new BitmapData(rect.width, rect.height, true, 0);
                    }
                    else
                    {
						bmd = new BitmapData(1, 1, true, 0);
                    }
					bmd.draw(this.tempDragItem);
                }
				bitmap = new Bitmap(bmd);
                this.thumItem.addChild(bitmap);
                this.dragLayer.addChild(this.thumItem);
                this.thumItem.x = this.dragLayer.mouseX - this.tempDragItem.mouseX;
                this.thumItem.y = this.dragLayer.mouseY - this.tempDragItem.mouseY;
                this.thumItem.mouseEnabled = false;
                this.thumItem.mouseChildren = false;
                this.thumItem.startDrag();
                this.currentDragItem = this.tempDragItem as IDragDrop;
                this.tempCurrentDragItem = this.currentDragItem;
                this.thumItem.stage.addEventListener(MouseEvent.MOUSE_MOVE, this.onDragItemMove);
                this.thumItem.stage.addEventListener(MouseEvent.MOUSE_UP, this.onDragItemDrop);
            }
            var displayObj:DisplayObject = this.getMainContainer(this.thumItem.dropTarget);
            if (displayObj != this.oldMoveOverItem)
            {
                this.tempCurrentDragItem.dispatchEvent(new DragEvent(DragEvent.Event_Move_Over, this.currentDragItem, this.currentDrogItem, this.currentDragSource, true));
                if (this.oldMoveOverItem)
                {
                    this.oldMoveOverItem.dispatchEvent(new DragEvent(DragEvent.Event_Be_Drag_out, this.currentDragItem, this.currentDrogItem, this.currentDragSource, true));
                }
                if (displayObj)
                {
                    this.currentDrogItem = displayObj as IDragDrop;
					displayObj.dispatchEvent(new DragEvent(DragEvent.Event_Be_Drag_over, this.currentDragItem, this.currentDrogItem, this.currentDragSource, true));
                    this.oldMoveOverItem = this.currentDrogItem;
                }
            }
            return;
        }

        private function onDragItemDrop(event:MouseEvent) : void
        {
            var displayObj:DisplayObject = null;
            var dragDrop:IDragDrop = null;
            if (this.tempDragItem.hasEventListener(MouseEvent.MOUSE_MOVE))
            {
                this.tempDragItem.removeEventListener(MouseEvent.MOUSE_MOVE, this.onDragItemMove);
            }
            if (this.thumItem && this.thumItem.stage.hasEventListener(MouseEvent.MOUSE_MOVE))
            {
                this.thumItem.stage.removeEventListener(MouseEvent.MOUSE_MOVE, this.onDragItemMove);
            }
            if (this.tempCurrentDragItem != null)
            {
				displayObj = this.thumItem.dropTarget;
				dragDrop = this.getMainContainer(displayObj) as IDragDrop;
                if (dragDrop is IDragDrop)
                {
                    if (this.canPutIn(this.currentDragItem, dragDrop))
                    {
                        this.currentDrogItem = dragDrop;
                        this.currentDragItem.dispatchEvent(new DragEvent(DragEvent.Event_Move_To, this.currentDragItem, this.currentDrogItem, this.currentDragSource, true));
						dragDrop.dispatchEvent(new DragEvent(DragEvent.Event_Move_In, this.currentDragItem, this.currentDrogItem, this.currentDragSource, true));
                        this.thumItem.stopDrag();
                        this.clearThum();
                        this.tempCurrentDragItem = null;
                    }
                    else
                    {
                        this.thumItem.stopDrag();
                        this.moveBack();
                    }
                }
                else
                {
                    this.currentDrogItem = null;
                    if (!this.tempCurrentDragItem.isThrowAble)
                    {
                        this.thumItem.stopDrag();
                        this.moveBack();
                        this.tempCurrentDragItem = null;
                    }
                    else
                    {
                        this.thumItem.stopDrag();
                        this.clearThum();
                        this.tempCurrentDragItem.dispatchEvent(new DragEvent(DragEvent.Event_Throw_goods, this.currentDragItem, this.currentDrogItem, this.currentDragSource, true));
                        this.tempCurrentDragItem = null;
                    }
                }
            }
            else
            {
                this.clearThum();
                return;
            }
            return;
        }

        private function moveBack() : void
        {
            var rect:Rectangle = null;
            if (this.currentDragItem)
            {
				rect = (this.currentDragItem as DisplayObject).getBounds(this.dragLayer);
                TweenMax.to(this.thumItem, 0.2, {x:rect.left, y:rect.top, onComplete:this.moveBackEnd, ease:Quint.easeOut});
            }
            else
            {
                this.moveBackEnd();
            }
            return;
        }

        private function moveBackEnd() : void
        {
            this.tempCurrentDragItem = null;
            this.clearThum();
            return;
        }

        private function clearThum() : void
        {
            if (this.thumItem)
            {
                if (this.thumItem.hasEventListener(MouseEvent.MOUSE_MOVE))
                {
                    this.thumItem.removeEventListener(MouseEvent.MOUSE_MOVE, this.onDragItemMove);
                }
                if (this.thumItem.hasEventListener(MouseEvent.MOUSE_UP))
                {
                    this.thumItem.removeEventListener(MouseEvent.MOUSE_UP, this.onDragItemDrop);
                }
                if (this.dragLayer.contains(this.thumItem))
                {
                    this.dragLayer.removeChild(this.thumItem);
                }
                this.thumItem = null;
            }
            return;
        }

        private function canPutIn(param1:IDragDrop, param2:IDragDrop) : Boolean
        {
            return param2.canDrop(param1, param2);
        }

        private function getMainContainer(param1:DisplayObject) : DisplayObject
        {
            if (!param1)
            {
                return null;
            }
            if (param1 is IDragDrop && (param1 as IDragDrop).isDropAble)
            {
                return param1;
            }
            if (param1.parent is IDragDrop && (param1.parent as IDragDrop).isDropAble)
            {
                return param1.parent;
            }
            if (param1.parent == _stage)
            {
                return null;
            }
            return this.getMainContainer(param1.parent);
        }

        public static function get instance() : DragManager
        {
            if (!_instance)
            {
                throw new Error("DragManager 尚未初始化");
            }
            return _instance;
        }

        public static function init(param1:DisplayObjectContainer) : void
        {
            if (_instance == null)
            {
                _instance = new DragManager(param1);
            }
            return;
        }

    }
}
