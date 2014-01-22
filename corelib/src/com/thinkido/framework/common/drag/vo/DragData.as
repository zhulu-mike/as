package com.thinkido.framework.common.drag.vo
{
	import com.thinkido.framework.common.drag.DragShowMode;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * 拖动数据 
	 * @author thinkido
	 * 
	 */
    public class DragData extends Object
    {
        private var _canMove:Boolean;
        private var _dobj:InteractiveObject;
        private var _type:int;
        private var _showMode:int;
        private var _guiderID:Number;
        private var _criticalDis:Number;
        private var _xyRect:Rectangle;
        private var _touchRect:Rectangle;
        private var $alpha:Number;
        private var _data:Object;
        private var _stage:Stage;
        private var _face:DisplayObject;
        private var _guiderStartPoint:Point;
        private var _dobjStartPoint:Point;
        private var _dobjStartAlpha:Number;
        private var _onComplete:Function;
        private var _onCompletevalueeters:Array;

        public function DragData(value1:InteractiveObject, $type:int = 1, $showMode:int = 1, $guiderID:int = -1, $criticalDis:Number = 2, $xyRect:Rectangle = null, $touchRect:Rectangle = null, value8:Number = 1, $onCompleteFun:Function = null, $onCompletevalueeters:Array = null, $data:Object = null)
        {
            var _loc_12:Sprite = null;
            var _loc_13:Rectangle = null;
            var _loc_14:BitmapData = null;
            var _loc_15:Bitmap = null;
            var _loc_16:Shape = null;
            this._canMove = false;
            this._dobj = value1;
            this._type = $type;
            this._showMode = $showMode;
            this._guiderID = $guiderID;
            this._criticalDis = $criticalDis;
            this._xyRect = $xyRect;
            this._touchRect = $touchRect;
            this.$alpha = value8;
            this._onComplete = $onCompleteFun;
            this._onCompletevalueeters = $onCompletevalueeters;
            this._data = $data;
            if (this._dobj)
            {
                this._stage = value1.stage;
                this._dobjStartPoint = new Point(this._dobj.x, this._dobj.y);
                this._dobjStartAlpha = this._dobj.alpha;
                if (this._dobj.parent)
                {
                    switch(this._showMode)
                    {
                        case DragShowMode.SELF:
                        {
                            this._face = this._dobj;
                            break;
                        }
                        case DragShowMode.BITMAP:
                        {
                            _loc_14 = new BitmapData(this._dobj.width, this._dobj.height, true, 0);
                            _loc_14.draw(this._dobj, null, null, null, null, true);
                            _loc_15 = new Bitmap(_loc_14, "auto", true);
                            _loc_12 = new Sprite();
                            _loc_12.addChild(_loc_15);
                            _loc_12.mouseEnabled = false;
                            _loc_13 = this.dobj.getBounds(this.dobj.parent);
                            _loc_15.x = _loc_13.x - this._dobjStartPoint.x;
                            _loc_15.y = _loc_13.y - this._dobjStartPoint.y;
                            _loc_12.x = this._dobjStartPoint.x;
                            _loc_12.y = this._dobjStartPoint.y;
                            this._face = _loc_12;
                            break;
                        }
                        case DragShowMode.FRAME:
                        {
                        }
                        default:
                        {
                            _loc_12 = new Sprite();
                            _loc_16 = new Shape();
                            _loc_16.graphics.clear();
                            _loc_16.graphics.lineStyle(1, 0, 1);
                            _loc_16.graphics.beginFill(0, 0);
                            _loc_16.graphics.drawRect(0, 0, this._dobj.width, this._dobj.height);
                            _loc_16.graphics.endFill();
                            _loc_12.addChild(_loc_16);
                            _loc_12.mouseEnabled = false;
                            _loc_13 = this.dobj.getBounds(this.dobj.parent);
                            _loc_16.x = _loc_13.x - this._dobjStartPoint.x;
                            _loc_16.y = _loc_13.y - this._dobjStartPoint.y;
                            _loc_12.x = this._dobjStartPoint.x;
                            _loc_12.y = this._dobjStartPoint.y;
                            this._face = _loc_12;
                            break;
                            break;
                        }
                    }
                }
                if (this._stage)
                {
                    this._guiderStartPoint = this._dobj.parent.globalToLocal(new Point(this._stage.mouseX, this._stage.mouseY));
                }
            }
            return;
        }

        public function isValid() : Boolean
        {
            return this.dobj != null && this.dobj.parent != null && !isNaN(this._type) && !isNaN(this._showMode) && !isNaN(this._guiderID) && this._guiderStartPoint != null && !isNaN(this._criticalDis) && this._dobjStartPoint != null && !isNaN(this._dobjStartAlpha) && !isNaN(this.$alpha) && this._stage != null;
        }

        public function equal(value1:DragData) : Boolean
        {
            return this.guiderID == value1.guiderID && this.dobj == value1.dobj;
        }

        public function get type() : int
        {
            return this._type;
        }

        public function get dobj() : InteractiveObject
        {
            return this._dobj;
        }

        public function get guiderID() : int
        {
            return this._guiderID;
        }

        public function get guiderStartPoint() : Point
        {
            return this._guiderStartPoint;
        }

        public function get dobjStartPoint() : Point
        {
            return this._dobjStartPoint;
        }

        public function get dobjStartAlpha() : Number
        {
            return this._dobjStartAlpha;
        }

        public function get criticalDis() : Number
        {
            return this._criticalDis;
        }

        public function get xyRect() : Rectangle
        {
            return this._xyRect;
        }

        public function get touchRect() : Rectangle
        {
            return this._touchRect;
        }

        public function get alpha() : Number
        {
            return this.$alpha;
        }

        public function get onComplete() : Function
        {
            return this._onComplete;
        }

        public function get onCompletevalueeters() : Array
        {
            return this._onCompletevalueeters;
        }

        public function get data() : Object
        {
            return this._data;
        }

        public function get face() : DisplayObject
        {
            return this._face;
        }

        public function get canMove() : Boolean
        {
            return this._canMove;
        }

        public function get stage() : Stage
        {
            return this._stage;
        }

        public function set canMove(value1:Boolean) : void
        {
            this._canMove = value1;
            return;
        }

    }
}
