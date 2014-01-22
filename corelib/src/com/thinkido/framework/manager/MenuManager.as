package com.thinkido.framework.manager
{
	import com.thinkido.framework.core.Singleton;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.ContextMenuEvent;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	/**
	 * flashplayer 本身的右键工具 
	 * @author thinkido
	 * 
	 */	
    public class MenuManager extends Singleton
    {
        private var _contextMenu:ContextMenu;
        private var _container:DisplayObjectContainer;
        private static var _instacne:MenuManager;

        public function MenuManager()
        {
            this._contextMenu = new ContextMenu();
            this._contextMenu.hideBuiltInItems();
            return;
        }
		/**
		 * 初始化 
		 * @param $container
		 * 
		 */
        public function initMenu($container:DisplayObjectContainer) : void
        {
            this._container = $container;
            if (this._container)
            {
                this._container.contextMenu = this._contextMenu;
            }
            return;
        }
		/**
		 * 使用fp 右键菜单 
		 * @param menuLabel
		 * @param callback
		 */
        public function addItem(menuLabel:String, callback:Function = null) : void
        {
            var item:ContextMenuItem;
            var isCallback:Boolean = callback is Function;
            if (isCallback)
            {
                item = new ContextMenuItem(menuLabel, false);
            }
            else
            {
                item = new ContextMenuItem(menuLabel, false, false);
            }
            this._contextMenu.customItems.push(item);
            if (isCallback)
            {
                var menuItemSelectHandler:Function = function (event:ContextMenuEvent) : void
	            {
	                callback();
	                return;
	            };
                item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, menuItemSelectHandler);
            }
            return;
        }

        public static function get instance() : MenuManager
        {
            if (_instacne == null)
            {
                _instacne = new MenuManager;
            }
            return _instacne;
        }

    }
}
