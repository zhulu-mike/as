package com.thinkido.framework.common.utils.boxing
{
	import com.thinkido.framework.common.vo.Rect;
	import com.thinkido.framework.manager.TimerManager;
	
	import flash.utils.getTimer;

    public class BoxingHelper extends Object
    {

        public function BoxingHelper()
        {
            return;
        }

        public function boxing(value1:Array, value2:int = 0, value3:Function = null, value4:Function = null) : void
        {
            var boxList:Array;
            var saveBoxList:Array;
            var freeBoxList:Array;
            var boxW:int;
            var box:Rect;
            var time:int;
            var htBox:Function;
            var $rectList:* = value1;
            var $boxType:* = value2;
            var $onUpdate:* = value3;
            var $onComplete:* = value4;
            htBox = function () : void
            {
                if (boxList.length == 0)
                {
                    if ($onComplete is Function)
                    {
                        $onComplete(saveBoxList);
                    }
                    return;
                }
                var _loc_1:* = boxList.pop();
                saveBoxList.push(_loc_1);
                doBoxing(_loc_1);
                if ($onUpdate is Function)
                {
                    $onUpdate(_loc_1);
                }
                TimerManager.addDelayCallBack(1, htBox);
                return;
            }
            ;
            var doBoxing:* = function (value1:Rect) : void
            {
                var inLen:int;
                var inI:int;
                var inFreeBox:Rect;
                var R:Rect;
                var rect1:Rect;
                var rect2:Rect;
                var rect3:Rect;
                var rect4:Rect;
                var $box:* = value1;
                var isTooSmallBox:* = function (value1:Rect) : Boolean
                {
                    var every:Function;
                    var $checkFreeBox:* = value1;
                    every = function (value1:*, value2:int, value3:Array) : Boolean
                    {
                        var _loc_4:* = value1 as Rect;
                        return (value1 as Rect).width > $checkFreeBox.width || _loc_4.height > $checkFreeBox.height;
                    }
                    ;
                    return boxList.every(every);
                }
                ;
                var isNotBeIncludedBox:* = function (value1:Rect) : Boolean
                {
                    var every:Function;
                    var $checkFreeBox:* = value1;
                    every = function (value1:*, value2:int, value3:Array) : Boolean
                    {
                        var _loc_4:* = value1 as Rect;
                        return value1 as Rect == $checkFreeBox || (_loc_4.left > $checkFreeBox.left || _loc_4.right < $checkFreeBox.right || _loc_4.top > $checkFreeBox.top || _loc_4.bottom < $checkFreeBox.bottom);
                    }
                    ;
                    return freeBoxList.every(every);
                }
                ;
                inLen = freeBoxList.length;
                var canIncluded:Boolean;
                inI;
                while (inI < inLen)
                {
                    
                    inFreeBox = freeBoxList[inI];
                    if (inFreeBox.width >= $box.width && inFreeBox.height >= $box.height)
                    {
                        $box.x = inFreeBox.x;
                        $box.y = inFreeBox.y;
                        canIncluded;
                        break;
                    }
                    inI = (inI + 1);
                }
                if (!canIncluded)
                {
                    throw new Error("太小无法容纳");
                }
                var tempFreeBoxList:Array;
                inLen = freeBoxList.length;
                var r:* = $box;
                inI = (inLen - 1);
                while (inI >= 0)
                {
                    
                    R = freeBoxList[inI];
                    if (!R.intersects(r))
                    {
                    }
                    else
                    {
                        freeBoxList.splice(inI, 1);
                        rect1 = new Rect(R.left, R.top, r.left - R.left, R.height);
                        rect2 = new Rect(R.left, R.top, R.width, r.top - R.top);
                        rect3 = new Rect(r.right, R.top, R.right - r.right, R.height);
                        rect4 = new Rect(R.left, r.bottom, R.width, R.bottom - r.bottom);
                        if (!rect1.isEmpty())
                        {
                            freeBoxList.push(rect1);
                        }
                        if (!rect2.isEmpty())
                        {
                            freeBoxList.push(rect2);
                        }
                        if (!rect3.isEmpty())
                        {
                            freeBoxList.push(rect3);
                        }
                        if (!rect4.isEmpty())
                        {
                            freeBoxList.push(rect4);
                        }
                    }
                    inI = (inI - 1);
                }
                inLen = freeBoxList.length;
                inI = (inLen - 1);
                while (inI >= 0)
                {
                    
                    inFreeBox = freeBoxList[inI];
                    if (inFreeBox.isEmpty() || isTooSmallBox(inFreeBox))
                    {
                        freeBoxList.splice(inI, 1);
                    }
                    inI = (inI - 1);
                }
                freeBoxList.sortOn("area", Array.NUMERIC | Array.DESCENDING);
                inLen = freeBoxList.length;
                inI = (inLen - 1);
                while (inI >= 0)
                {
                    
                    inFreeBox = freeBoxList[inI];
                    if (!isNotBeIncludedBox(inFreeBox))
                    {
                        freeBoxList.splice(inI, 1);
                    }
                    inI = (inI - 1);
                }
                freeBoxList.sortOn(["y", "x"], [Array.NUMERIC, Array.NUMERIC]);
                return;
            }
            ;
            boxList = $rectList;
            saveBoxList;
            freeBoxList;
            if ($boxType == 0)
            {
                boxList.sortOn("area", Array.NUMERIC);
            }
            else if ($boxType == 1)
            {
                boxList.sortOn("width", Array.NUMERIC);
            }
            else if ($boxType == 2)
            {
                boxList.sortOn("height", Array.NUMERIC);
            }
            else
            {
                throw new Error("装箱模式错误");
            }
            var boxH:int;
            var totalArea:Number;
            var _loc_6:int = 0;
            var _loc_7:* = boxList;
            while (_loc_7 in _loc_6)
            {
                
                box = _loc_7[_loc_6];
                totalArea = totalArea + box.area;
            }
            boxW = Math.sqrt(totalArea) * 1.25;
            freeBoxList.push(new Rect(0, 0, boxW, boxH));
            time = getTimer();
            htBox();
            return;
        }

    }
}
