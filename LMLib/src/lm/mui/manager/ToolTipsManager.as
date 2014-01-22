package lm.mui.manager
{
	import flash.accessibility.AccessibilityProperties;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;

    public class ToolTipsManager extends Sprite
    {
        private var area:DisplayObject;
        private var toolTipContent:IToolTip;
        private var toolTipLayer:DisplayObjectContainer;
        private var delayTimer:Timer;
        private static var toolClassMap:Object = {};
        private static var classId:int = 0;
        private static var _instance:ToolTipsManager = null;
        private static var _defaultRenderClass:Class;

        public function ToolTipsManager(param1:DisplayObjectContainer)
        {
            visible = false;
            mouseChildren = false;
            mouseEnabled = false;
            this.toolTipLayer = param1;
            param1.addChild(this);
            return;
        }

        public function targetMouseHandler(event:MouseEvent) : void
        {
            var displayObj:DisplayObject = null;
            switch(event.type)
            {
                case MouseEvent.MOUSE_OUT:
                case MouseEvent.MOUSE_DOWN:
                case MouseEvent.MOUSE_UP:
                {
                    _instance.hide();
                    break;
                }
                case MouseEvent.MOUSE_MOVE:
                {
                    _instance.move(new Point(event.stageX, event.stageY));
                    break;
                }
                case MouseEvent.MOUSE_OVER:
                {
					displayObj = event.currentTarget as DisplayObject;
                    if (_instance.area != displayObj)
                    {
                        _instance.hide();
                    }
                    if (displayObj.alpha == 1)
                    {
                        _instance.area = event.currentTarget as DisplayObject;
                        this.startDelayCount();
                    }
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }

        public function show(param1:DisplayObject) : void
        {
            var classMapData:Object = null;
            var tempTipData:Object = null;
            var container:DisplayObjectContainer = null;
            this.area.addEventListener(MouseEvent.MOUSE_MOVE, this.targetMouseHandler);
            if (param1.accessibilityProperties)
            {
                this.clearConetnt();
				classMapData = toolClassMap[param1.accessibilityProperties.description];
                if (classMapData.areaItem is IToolTipItem)
                {
                    tempTipData = (classMapData.areaItem as IToolTipItem).toolTipData;
                }
                else
                {
                    tempTipData = classMapData.toolTipData;
                }
                if (classMapData != null)
                {
                    this.toolTipContent = ToolTipPool.getObject(classMapData.toolTipClass as Class);
                    (this.toolTipContent as DisplayObject).visible = true;
                    this.toolTipContent.data = tempTipData;
					container = this.toolTipContent as DisplayObjectContainer;
					container.mouseChildren = false;
					container.mouseEnabled = false;
                    addChild(container);
                }
            }
            return;
        }

        public function hide() : void
        {
            this.clearDelayCount();
            this.clearConetnt();
            if (this.area)
            {
                this.area.removeEventListener(MouseEvent.MOUSE_DOWN, this.targetMouseHandler);
                this.area.removeEventListener(MouseEvent.MOUSE_OUT, this.targetMouseHandler);
                this.area.removeEventListener(MouseEvent.MOUSE_MOVE, this.targetMouseHandler);
                this.area = null;
            }
            visible = false;
            return;
        }

        private function clearConetnt() : void
        {
            var displayObj:DisplayObject = null;
            if (this.toolTipContent)
            {
                ToolTipPool.disposeObject(this.toolTipContent);
				displayObj = this.toolTipContent as DisplayObject;
				displayObj.visible = false;
                if (displayObj.hasOwnProperty("dispose"))
                {
//                    var _loc_2:* = displayObj;
//                    _loc_2._loc_1["dispose"]();
					displayObj['dispose']();
                }
                if (this.contains(displayObj))
                {
                    this.removeChild(displayObj);
                }
                this.toolTipContent = null;
            }
            return;
        }

        public function move(param1:Point) : void
        {
            var point:Point = this.parent.globalToLocal(param1);
            this.x = point.x + 15;
            if (this.x > this.toolTipLayer.stage.stageWidth - this.width - 6)
            {
                this.x = point.x - this.width - 6;
            }
            this.y = point.y + 6;
            var _loc_4:* = this.toolTipContent as DisplayObject;
            if (this.toolTipContent as DisplayObject)
            {
                if (_loc_4.height > this.toolTipLayer.stage.stageHeight)
                {
                    this.y = 0;
                }
                else if (this.y + _loc_4.height > this.toolTipLayer.stage.stageHeight)
                {
                    this.y = this.toolTipLayer.stage.stageHeight - _loc_4.height - 20;
                }
            }
            if (!visible)
            {
                visible = true;
            }
            return;
        }

        private function startDelayCount() : void
        {
            if (!this.delayTimer)
            {
                this.delayTimer = new Timer(500, 1);
                this.delayTimer.addEventListener(TimerEvent.TIMER_COMPLETE, this.showAfterDelay);
            }
            this.delayTimer.reset();
            this.delayTimer.start();
            this.area.addEventListener(MouseEvent.MOUSE_DOWN, this.targetMouseHandler);
            this.area.addEventListener(MouseEvent.MOUSE_OUT, this.targetMouseHandler);
            this.area.addEventListener(MouseEvent.MOUSE_UP, this.targetMouseHandler);
            return;
        }

        private function clearDelayCount() : void
        {
            if (this.delayTimer)
            {
                this.delayTimer.stop();
            }
            return;
        }

        private function showAfterDelay(event:TimerEvent) : void
        {
            var point:Point = null;
            if (this.area)
            {
                this.show(this.area);
				point = new Point(this.area.mouseX, this.area.mouseY);
				point = this.area.localToGlobal(point);
                this.move(point);
            }
            return;
        }

        override public function get width() : Number
        {
            if (this.toolTipContent && this.toolTipContent is DisplayObject)
            {
                return (this.toolTipContent as DisplayObject).width;
            }
            return super.width;
        }

        public static function get defaultRenderClass() : Class
        {
            return _defaultRenderClass;
        }

        public static function set defaultRenderClass(param1:Class) : void
        {
            _defaultRenderClass = param1;
            return;
        }

        public static function init(param1:DisplayObjectContainer) : void
        {
            if (_instance == null)
            {
                _instance = new ToolTipsManager(param1);
            }
            return;
        }
		/**
		 *  
		 * @param $target  需要添加tooltip 的对象
		 * @param $toolTipClass 自定义 tooltip 类，默认tooltip 时 为null 。
		 * @param $toolTipData  tooltip 数据，
		 * 关于tooltip
			1、实现了借口IToolTipItem的类需要设置toolTipData 添加 tip
			使用ToolTipsManager.register无效。至少string 是。 
		 */
        public static function register($target:DisplayObject, $toolTipClass:Class = null, $toolTipData:Object = null) : void
        {
            var desc:String = null;
            if (_instance == null)
            {
                throw new Error("ToolTipsManager 未初始化");
            }
            var properties:AccessibilityProperties = $target["accessibilityProperties"];
            if ($target["accessibilityProperties"] == null)
            {
                $target["accessibilityProperties"] = new AccessibilityProperties();
				properties = $target["accessibilityProperties"];
				classId = classId + 1;
				desc = "Item" + classId;
				properties.description = desc;
            }
            else
            {
				desc = properties.description;
            }
            var dispatcher:EventDispatcher = $target as EventDispatcher;
			dispatcher.addEventListener(MouseEvent.MOUSE_OVER, _instance.targetMouseHandler);
            if ($toolTipClass != null)
            {
                toolClassMap[desc] = {toolTipClass:$toolTipClass, areaItem:$target, toolTipData:$toolTipData};
            }
            else if (_defaultRenderClass != null)
            {
                toolClassMap[desc] = {toolTipClass:_defaultRenderClass, areaItem:$target, toolTipData:$toolTipData};
            }
            else
            {
                throw new Error("ToolTipManger的dfaultRenderClass未定义");
            }
            return;
        }

        public static function unregister(param1:EventDispatcher) : void
        {
            if (_instance != null && param1)
            {
                param1.removeEventListener(MouseEvent.MOUSE_OVER, _instance.targetMouseHandler);
            }
            return;
        }

    }
}
