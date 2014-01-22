package com.thinkido.framework.manager
{
    import com.greensock.TweenMax;
    import com.thinkido.framework.common.drag.DragType;
    import com.thinkido.framework.common.drag.vo.DragData;
    import com.thinkido.framework.common.handler.helper.HandlerHelper;
    import com.thinkido.framework.common.utils.Fun;
    
    import flash.display.DisplayObject;
    import flash.display.InteractiveObject;
    import flash.display.Stage;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.geom.Point;
    
    import org.osflash.thunderbolt.Logger;
    
	/**
	 * 拖动管理器 
	 * @author thinkido
	 */
    public class DragManager extends Object
    {
        private static var _dragArr:Array = [];
        private static var TEvent:Class = MouseEvent;
        private static var _stage:Stage;

        public function DragManager()
        {
            throw new Event("静态类");
        }

        public static function addDrag($dragData:DragData) : void
        {
            var dragData:DragData = null;
            var point:Point = null;
            if (!$dragData)
            {
                return;
            }
            if (!$dragData.isValid())
            {
                return;
            }
            if ($dragData.touchRect)
            {
                point = $dragData.dobj.globalToLocal($dragData.dobj.parent.localToGlobal($dragData.guiderStartPoint));
                if (!$dragData.touchRect.containsPoint(point))
                {
                    return;
                }
            }
            for each (dragData in _dragArr)
            {
                
                if (dragData.equal($dragData))
                {
                    return;
                }
                if (dragData.guiderID == $dragData.guiderID)
                {
                    removeDrag(dragData);
                    break;
                }
            }
            if ($dragData.face != $dragData.dobj)
            {
                $dragData.dobj.parent.addChild($dragData.face);
                if ($dragData.type == DragType.DROP)
                {
                    $dragData.dobj.visible = false;
                }
            }
            $dragData.dobj.mouseEnabled = false;
            _dragArr[_dragArr.length] = $dragData;
            Logger.info("DragManager::addDrag()::_dragArr.length:" + _dragArr.length);
            if (_dragArr.length == 1)
            {
                _stage = $dragData.stage;
                EventManager.addEvent(Event.ENTER_FRAME, update, _stage);
                EventManager.addEvent(TEvent.MOUSE_UP, mouseUpHandle, _stage, false, 0, true);
            }
            return;
        }

        public static function removeDragByGuiderID($guideId:int) : DragData
        {
            var dragData:DragData = null;
            for each (dragData in _dragArr)
            {
                
                if (dragData.guiderID == $guideId)
                {
                    removeDrag(dragData);
                    return dragData;
                }
            }
            return null;
        }

        public static function removeDrag($dragData:DragData) : void
        {
            if (!$dragData)
            {
                return;
            }
            if ($dragData.type == DragType.DROP)
            {
                doTween($dragData);
            }
            $dragData.face.alpha = $dragData.dobjStartAlpha;
            var temp:int = _dragArr.indexOf($dragData);
            if (temp != -1)
            {
                _dragArr.splice(temp, 1);
                Logger.info("DragManager::removeDrag()::_dragArr.length:" + _dragArr.length);
            }
            return;
        }

        public static function removeAllDrags() : void
        {
            var dragData:DragData = null;
            for each (dragData in _dragArr)
            {
                
                if (dragData.type == DragType.DROP)
                {
                    doTween(dragData);
                }
                dragData.face.alpha = dragData.dobjStartAlpha;
            }
            _dragArr = [];
            Logger.info("DragManager::removeAllDrags()::_dragArr.length:0");
            return;
        }

        private static function update(event:Event) : void
        {
            var point:Point = null;
            var dragData:DragData = null;
            for each (dragData in _dragArr)
            {
                
                if (Fun.isParentChild(dragData.stage, dragData.dobj))
                {
                    if (dragData.guiderID == -1)
                    {
                        point = dragData.dobj.parent.globalToLocal(new Point(dragData.stage.mouseX, dragData.stage.mouseY));
                    }
                    if (point)
                    {
                        if (Point.distance(point, dragData.guiderStartPoint) > dragData.criticalDis)
                        {
                            dragData.canMove = true;
                        }
                        if (dragData.canMove)
                        {
                            setPos(dragData.face, point, dragData);
                            dragData.face.alpha = dragData.alpha;
                        }
                    }
                    continue;
                }
                removeDrag(dragData);
            }
            if (_dragArr.length == 0)
            {
                EventManager.removeEvent(Event.ENTER_FRAME, update, _stage);
                EventManager.removeEvent(TEvent.MOUSE_UP, mouseUpHandle, _stage, false);
            }
            return;
        }

        private static function setPos(target:DisplayObject, $point:Point, $dragData:DragData) : void
        {
            var _x:Number = NaN;
            var _y:Number = NaN;
            if (!target || !$dragData)
            {
                return;
            }
            _x = $dragData.dobjStartPoint.x + ($point.x - $dragData.guiderStartPoint.x);
            _y = $dragData.dobjStartPoint.y + ($point.y - $dragData.guiderStartPoint.y);
            if ($dragData.xyRect)
            {
                if (_x < $dragData.xyRect.x)
                {
                    _x = $dragData.xyRect.x;
                }
                if (_x > $dragData.xyRect.x + $dragData.xyRect.width)
                {
                    _x = $dragData.xyRect.x + $dragData.xyRect.width;
                }
                if (_y < $dragData.xyRect.y)
                {
                    _y = $dragData.xyRect.y;
                }
                if (_y > $dragData.xyRect.y + $dragData.xyRect.height)
                {
                    _y = $dragData.xyRect.y + $dragData.xyRect.height;
                }
            }
            target.x = _x;
            target.y = _y;
            return;
        }

        private static function mouseUpHandle(value:* = null) : void
        {
            var dropToTarget:InteractiveObject;
            var arr:Array;
            var iObj:InteractiveObject;
            var item:DisplayObject;
            var e:* = value;
            var eID:* = e is MouseEvent ? (-1) : (e.ID);
            var dragData:* = removeDragByGuiderID(eID);
            if (!dragData)
            {
                return;
            }
            var stageXY:Point = new Point(e.stageX, e.stageY);
            if (dragData.type == DragType.DRAG)
            {
                if (dragData.face != dragData.dobj && dragData.face.parent)
                {
                    dragData.face.parent.removeChild(dragData.face);
                }
                if (dragData.canMove)
                {
                    setPos(dragData.dobj, dragData.dobj.parent.globalToLocal(stageXY), dragData);
                }
                dragData.dobj.mouseEnabled = true;
            }
            else if (dragData.type == DragType.DROP)
            {
                arr = dragData.stage.getObjectsUnderPoint(stageXY);
                var _loc_3:int = 0;
                var _loc_4:* = arr;
                while (_loc_4 in _loc_3)
                {
                    
                    item = _loc_4[_loc_3];
                    iObj = item as InteractiveObject;
                    if (iObj && iObj.mouseEnabled)
                    {
                        dropToTarget = iObj;
                        break;
                    }
                }
                if (dropToTarget && dropToTarget.hasOwnProperty("dropIn"))
                {
                    try
                    {
                        (dropToTarget as Object).dropIn(dragData.data);
                        TweenMax.killTweensOf(dragData.face, true);
                    }
                    catch (e:Error)
                    {
                    }
                }
            }
            if (dragData.onComplete != null)
            {
                HandlerHelper.execute(dragData.onComplete, dragData.onCompleteParameters);
            }
            return;
        }

        private static function doTween($dragData:DragData, $duration:Number = 0.2) : void
        {
            var dragData:DragData = $dragData;
            var duration:int = $duration;
            if (!dragData)
            {
                return;
            }
            if (!dragData.isValid())
            {
                return;
            }
            if (dragData.type != DragType.DROP)
            {
                return;
            }
            try
            {
                TweenMax.to(dragData.face, duration, {x:dragData.dobjStartPoint.x, y:dragData.dobjStartPoint.y, onComplete:tweenComplete, onCompleteParams:[dragData]});
            }
            catch (e:Error)
            {
                dragData.face.x = dragData.dobjStartPoint.x;
                dragData.face.y = dragData.dobjStartPoint.y;
                tweenComplete(dragData);
            }
            return;
        }

        private static function tweenComplete($dragData:DragData) : void
        {
            if (!$dragData)
            {
                return;
            }
            if (!$dragData.isValid())
            {
                return;
            }
            if ($dragData.type != DragType.DROP)
            {
                return;
            }
            if ($dragData.face != $dragData.dobj && $dragData.face.parent)
            {
                $dragData.face.parent.removeChild($dragData.face);
            }
            $dragData.dobj.x = $dragData.dobjStartPoint.x;
            $dragData.dobj.y = $dragData.dobjStartPoint.y;
            $dragData.dobj.alpha = $dragData.dobjStartAlpha;
            $dragData.dobj.mouseEnabled = true;
            $dragData.dobj.visible = true;
            return;
        }

    }
}
