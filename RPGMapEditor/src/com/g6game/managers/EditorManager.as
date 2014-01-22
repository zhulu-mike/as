package com.g6game.managers
{
	import com.g6game.display.MonsterGround;
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import mx.controls.Alert;
	
	import utils.GridUtils;
	
	import vo.BornPointVO;
	import vo.TransPointVO;
	
	public class EditorManager extends EventDispatcher
	{
		public var app:RPGMapEditor;
		
		public function EditorManager(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		private static var instance:EditorManager;
		
		public static function getInstance():EditorManager
		{
			if (!instance)
				instance = new EditorManager();
			return instance;
		}
		
		/***/
		public function drawPoint(m:int, n:int):void
		{
			if (m>=0&&m<=EditorConfig.getInstance().mapVO.rows-1 && n>=0&&n<=EditorConfig.getInstance().mapVO.cols-1)
			{
				if (app.hinder.searchPoint(m,n))
				{
					app.hinder.destroyCircle();
				}
				switch (app.currState)
				{
					case 1:
						app.hinder.drawRedCircle(m,n);
						break;
					case 2:
						app.hinder.drawGreenCircle(m,n);
						break;
				}
			}
		}
		
		public function onClickLayer(evt:MouseEvent):void
		{
			var m:int = GridUtils.getMpos(evt.localX, evt.localY);
			var n:int = GridUtils.getNpos(evt.localX, evt.localY);
			
			if (m>=0&&m<=EditorConfig.getInstance().mapVO.rows-1 && n>=0&&n<=EditorConfig.getInstance().mapVO.cols-1)
			{
				switch (app.currState)
				{
					case 0:
						break;
					case 1:
						if (!app.hinder.searchPoint(m,n))
						{
							app.hinder.drawRedCircle(m,n);
						}
						else
						{
//							app.hinder.destroyCircle();
						}
						break;
					case 2:
						if (!app.hinder.searchPoint(m,n))
						{
							app.hinder.drawGreenCircle(m,n);
						}
						else
						{
//							app.hinder.destroyCircle();
						}
						break;
					case 3:
						if (!app.transport.searchTransPoint(m,n))
						{
							app.transport.drawTranspoint(m,n);
						}
						else
						{
							app.transport.destroyCircle();
						}
						break;
					case 4:
						if (!app.hinder.searchPoint(m,n))
						{
//							app.hinder.drawRedCircle(m,n);
						}
						else
						{
							app.hinder.destroyCircle();
						}
						break;
					case 5://加NPC
						if (!app.monsterUI.hasPoint(m,n))
						{
							app.monsterUI.addNPC(m,n);
						}
						else
						{
							app.monsterUI.destroyCircle();
						}
						break;
					case 6://加怪物
						if (!app.monsterUI.hasPoint(m,n))
						{
							var bvo:BornPointVO = app.monsterUI.lastMonsterVO;
							if (bvo==null)
								app.monsterUI.addMonster(m,n);
							else
								app.monsterUI.addMonster(m,n,bvo.mid,bvo.mname,bvo.dir,bvo.group);
						}
						else
						{
							app.monsterUI.destroyCircle();
						}
						break;
					case 7://加采集
						if (!app.monsterUI.hasPoint(m,n))
						{
							app.monsterUI.addCollect(m,n);
						}
						else
						{
							app.monsterUI.destroyCircle();
						}
						break;
				}
			}
		}
	
		/**
		 * 删除图层
		 */
		public function deleteLayer(data:Object):void
		{
			app.deleteLayer(data);
		}
		
		/**
		 * 新建图层
		 */
		public function createLayer():void
		{
			app.showCreateLayerPanel();
		}
		
		/**创建图层*/
		public function addLayer(name:String):void
		{
			app.addLayer(name);
		}
		
		/**添加出生点*/
		public function addMonster(src:XML):void
		{
			app.addMonster(src);
		}
		
		public function showSelectNPC(id:String,name:String,dir:int) : void
		{
			this.app.showSelectNPC(id, name, dir);
			return;
		}// end function

		
		public function showSelectMonster(id:String,name:String,dir:int,group:int=0):void
		{
			app.showSelectMonster(id, name, dir, group);
		}
		public function showSelectCollect(id:String,name:String):void
		{
			app.showSelectCollect(id, name);
		}
		
		/**
		 * 
		 * @param id ID
		 * @param name 名称
		 * @param dir 方向
		 * @param group 组队号
		 * 
		 */		
		public function setMonsterProperty(id:String, name:String, dir:int, group:int):void
		{
			app.monsterUI.setMonsterProperty(id,name,dir,group);
			Alert.show("设置成功");
			
		}
		public function setCollectProperty(id:String, name:String, model:String, good:String):void
		{
			app.monsterUI.setCollectProperty(id,name,model, good);
			Alert.show("设置成功");
			
		}
		
		/**设置NPC点*/
		public function addNpcProperty(data:XML):void
		{
			app.setNpcProperty(data.@nid, data.@nname);
		}
		/***/
		public function setNpcProperty(id:String, name:String, dir:int):void
		{
			app.monsterUI.setNpcProperty(id,name,dir);
			Alert.show("设置成功");
		}
		
		public function hideSelectTrans():void
		{
			app.hideSelectTrans();
		}
		
		/***/
		public function hideMonsterPanel():void
		{
			app.hideMonsterPanel();
		}
		
		/***/
		public function hideCollectPanel():void
		{
			app.hideCollectPanel();
		}
		
		/***/
		public function hideNpcPanel():void
		{
			app.hideNPCPanel();
		}
		
		public function showSelectTrans(voo:TransPointVO):void
		{
			app.showSelectTrans(voo);
		}
		
		public function changeProperty(id:int, target:String, p:Point=null):void
		{
			app.changeTransProperty(id, target, p);
		}
		
		/**删除传送点*/
		public function deteleteTranspoint(p:Point):void
		{
			if (app.transport.searchTransPoint(p.x, p.y))
			{
				app.transport.destroyCircle();
			}
		}
	}
}