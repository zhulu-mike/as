package lm.mui.controls
{
	import fl.controls.ComboBox;
	import fl.core.InvalidationType;
	
	import lm.mui.manager.IToolTipItem;
	import lm.mui.manager.ToolTipsManager;
	import lm.mui.skins.SkinManager;

	/**
	 * 
	 * 		this._campCombo = new GComboBox();
            this._campCombo.move(140, 50);
            this._campCombo.width = 100;
            this._campCombo.height = 20;
            this._campCombo.buttonMode = true;
            this._campCombo.styleName = "GComboboxStyle";
            this._campCombo.drawNow();
            this._campCombo.dropdown.setStyle("cellRenderer", MailFriendItemCellRender);
            this._campCombo.dropdown.setStyle("skin", ResouceConst.getScaleBitmap(ImagesConst.WindowCenterB));
            this._campCombo.textField.setStyle("textFormat", new TextFormat("", 12, 11661308, false, false, false, "", "", TextFormatAlign.CENTER));
            this._campDp = new DataProvider();
            this._campDp.addItem({id:0, label:Language.getString(57278)});
            this._campDp.addItem({id:1, label:Language.getString(57279)});
            this._campDp.addItem({id:2, label:Language.getString(57280)});
            this._campDp.addItem({id:3, label:Language.getString(57281)});
            this._campCombo.dataProvider = this._campDp;
            this._campCombo.selectedIndex = 0;
            this._campCombo.addEventListener(Event.CHANGE, this.onCampComboBoxChangeHandler);
            addChild(this._campCombo);
            
	 * 
	 */	
    public class GComboBox extends ComboBox implements IToolTipItem
    {
        public const CLASSNAME:String = "ComboBox";
        private var _toolTipData:Object;
        private var _styleName:String;
        private var _isStyleChange:Boolean = false;

        public function GComboBox()
        {
            this._styleName = this.CLASSNAME;
            return;
        }

        public function get toolTipData():Object
        {
            return this._toolTipData;
        }

        public function set toolTipData(param1:Object) : void
        {
            if (param1 == null || param1 == "")
            {
                ToolTipsManager.unregister(this);
            }
            else
            {
                ToolTipsManager.register(this);
            }
            this._toolTipData = param1;
            return;
        }

        final override protected function configUI() : void
        {
            super.configUI();
            this.createChildren();
            return;
        }

        public function get styleName() : String
        {
            return this._styleName;
        }

        public function set styleName(param1:String) : void
        {
            if (this._styleName != param1)
            {
                this._styleName = param1;
                invalidate(InvalidationType.STYLES);
                this._isStyleChange = true;
            }
            return;
        }

        final override protected function draw() : void
        {
            if (isInvalid(InvalidationType.STYLES))
            {
                if (this._isStyleChange)
                {
                    SkinManager.setComponentStyle(this, this._styleName);
                    this._isStyleChange = false;
                }
                this.updateStyle();
            }
            if (isInvalid(InvalidationType.DATA))
            {
                this.updateDate();
            }
            if (isInvalid(InvalidationType.SIZE))
            {
                this.updateSize();
            }
            if (isInvalid(InvalidationType.SIZE, InvalidationType.SELECTED, InvalidationType.DATA))
            {
                this.updateDisplayList();
            }
            try
            {
                super.draw();
            }
            catch (e:Error)
            {
            }
            return;
        }

        protected function createChildren() : void
        {
            return;
        }

        protected function updateStyle() : void
        {
            return;
        }

        protected function updateSize() : void
        {
            return;
        }

        protected function updateDate() : void
        {
            return;
        }

        protected function updateDisplayList() : void
        {
            return;
        }

        public function set textColor(param1:uint) : void
        {
            this.textField.textField.textColor = param1;
            return;
        }

    }
}
