package com.thinkido.framework.engine.vo
{
	import com.thinkido.framework.engine.graphics.tagger.HeadFace;
	import flash.display.Sprite;

    public class ShowContainer extends Sprite
    {
        private var _headFace:HeadFace;
        private var _showHeadFaceContainer:Boolean = true;
        private var _attackFaceContainer:Sprite;
        private var _showAttackFaceContainer:Boolean = true;
        private var _customFaceContainer:Sprite;
        private var _showCustomFaceContainer:Boolean = true;
        private var _owner:BaseElement;

        public function ShowContainer(value1:BaseElement)
        {
            this._owner = value1;
            return;
        }

        public function get headFace() : HeadFace
        {
            return this._headFace;
        }

        public function set headFace(value1:HeadFace) : void
        {
            if (this._headFace != value1)
            {
                if (this._headFace != null && this._headFace.parent != null)
                {
                    this._headFace.parent.removeChild(this._headFace);
                }
                this._headFace = value1;
            }
            if (this._showHeadFaceContainer)
            {
                this.showHeadFaceContainer();
            }
            return;
        }

        public function showHeadFaceContainer() : void
        {
            this._showHeadFaceContainer = true;
            if (this._headFace != null && this._headFace.parent != this)
            {
                this.addChild(this._headFace);
            }
            return;
        }

        public function hideHeadFaceContainer() : void
        {
            this._showHeadFaceContainer = false;
            if (this._headFace != null && this._headFace.parent != null)
            {
                this._headFace.parent.removeChild(this._headFace);
            }
            return;
        }

        public function get attackFaceContainer() : Sprite
        {
            if (this._attackFaceContainer == null)
            {
                this._attackFaceContainer = new Sprite();
                if (this._showAttackFaceContainer)
                {
                    this.showAttackFaceContainer();
                }
            }
            return this._attackFaceContainer;
        }

        public function showAttackFaceContainer() : void
        {
            this._showAttackFaceContainer = true;
            if (this._attackFaceContainer != null && this._attackFaceContainer.parent != this)
            {
                this.addChild(this._attackFaceContainer);
            }
            return;
        }

        public function hideAttackFaceContainer() : void
        {
            this._showAttackFaceContainer = false;
            if (this._attackFaceContainer != null && this._attackFaceContainer.parent != null)
            {
                this._attackFaceContainer.parent.removeChild(this._attackFaceContainer);
            }
            return;
        }

        public function get customFaceContainer() : Sprite
        {
            if (this._customFaceContainer == null)
            {
                this._customFaceContainer = new Sprite();
                if (this._showCustomFaceContainer)
                {
                    this.showCustomFaceContainer();
                }
            }
            return this._customFaceContainer;
        }

        public function showCustomFaceContainer() : void
        {
            this._showCustomFaceContainer = true;
            if (this._customFaceContainer != null && this._customFaceContainer.parent != this)
            {
                this.addChild(this._customFaceContainer);
            }
            return;
        }

        public function hideCustomFaceContainer() : void
        {
            this._showCustomFaceContainer = false;
            if (this._customFaceContainer != null && this._customFaceContainer.parent != null)
            {
                this._customFaceContainer.parent.removeChild(this._customFaceContainer);
            }
            return;
        }

        public function get owner() : BaseElement
        {
            return this._owner;
        }

    }
}
