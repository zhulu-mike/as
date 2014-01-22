package com.thinkido.framework.engine.vo
{
	import com.thinkido.framework.engine.config.SceneConfig;
	import com.thinkido.framework.utils.SystemUtil;
	
	import flash.display.DisplayObjectContainer;
	/**
	 * 场景物体基本数据 
	 * @author thinkido
	 */
    public class BaseElement extends Object
    {
        public var id:int = 0;
        public var name:String = "";
        public var tile_width:Number = SceneConfig.TILE_WIDTH;
        public var tile_height:Number = SceneConfig.TILE_HEIGHT;
        private var _pixel_x:Number = 0;
        private var _pixel_y:Number = 0;
        private var _tile_x:int = 0;
        private var _tile_y:int = 0;
        public var data:Object;
        public var showContainer:ShowContainer;
        private var _useContainer:Boolean = false;

        public function BaseElement()
        {
            return;
        }

        public function get pixel_x() : Number
        {
            return this._pixel_x;
        }

        public function set pixel_x($x:Number) : void
        {
            this._pixel_x = $x;
            this._tile_x = this._pixel_x / this.tile_width;
            if (this.showContainer != null && this.showContainer.x != this._pixel_x)
            {
                this.showContainer.x = this._pixel_x;
            }
            return;
        }

        public function get pixel_y() : Number
        {
            return this._pixel_y;
        }

        public function set pixel_y($y:Number) : void
        {
            this._pixel_y = $y;
            this._tile_y = this._pixel_y / this.tile_height;
            if (this.showContainer != null && this.showContainer.y != this._pixel_y)
            {
                this.showContainer.y = this._pixel_y;
            }
            return;
        }

        public function get tile_x() : int
        {
            return this._tile_x;
        }

        public function set tile_x(value1:int) : void
        {
            this._tile_x = value1;
            this._pixel_x = this._tile_x * this.tile_width;
            if (this.showContainer != null && this.showContainer.x != this._pixel_x)
            {
                this.showContainer.x = this._pixel_x;
            }
            return;
        }

        public function get tile_y() : int
        {
            return this._tile_y;
        }

        public function set tile_y(value1:int) : void
        {
            this._tile_y = value1;
            this._pixel_y = this._tile_y * this.tile_height;
            if (this.showContainer != null && this.showContainer.y != this._pixel_y)
            {
                this.showContainer.y = this._pixel_y;
            }
            return;
        }

        public function get useContainer() : Boolean
        {
            return this._useContainer;
        }

        public function enableContainer(value1:DisplayObjectContainer = null) : void
        {
            this._useContainer = true;
            if (this.showContainer == null)
            {
                this.showContainer = new ShowContainer(this);
                this.showContainer.x = this._pixel_x;
                this.showContainer.y = this._pixel_y;
            }
            if (value1 != null && this.showContainer.parent != value1)
            {
                value1.addChild(this.showContainer);
            }
            return;
        }

        public function disableContainer() : void
        {
            this._useContainer = false;
            if (this.showContainer != null)
            {
                if (this.showContainer.parent != null)
                {
                    this.showContainer.parent.removeChild(this.showContainer);
                }
				SystemUtil.clearChildren(this.showContainer, true);
                this.showContainer = null;
            }
            return;
        }

    }
}
