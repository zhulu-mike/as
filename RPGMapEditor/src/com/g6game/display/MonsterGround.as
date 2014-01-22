package com.g6game.display
{
	import com.g6game.factory.MonsterFactory;
	import com.g6game.managers.EditorManager;
	
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	
	import utils.GridUtils;
	
	import vo.BornPointVO;
	
	/**
	 * 出生点层
	 */
	public class MonsterGround extends BaseGround
	{
		
		private var monsters:Vector.<BornPointVO> = new Vector.<BornPointVO>();
		
		private var filter:Array = [new GlowFilter(0x00ff00,1,3,3,10,1)];
		
		private var filterSprite:BornSprite;
		
		private var currentIndex:int;

		public  var lastMonsterVO:BornPointVO;
		
		public function MonsterGround()
		{
			this.addEventListener(MouseEvent.CLICK, onClick);
			if (stage)
				register(null);
			else
				this.addEventListener(Event.ADDED_TO_STAGE, register);
		}
		
		public function get monsterArr():Vector.<BornPointVO>
		{
			return monsters;
		}
		
		private function register(e:Event):void
		{
//			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		}
		
		public function init():void
		{
			filterSprite = null;
			deleteAllBorns();
			monsters.splice(0, monsters.length);
		}
		
		public function addNPC(m:int, n:int, nid:String="", nname:String="", dir:int=1) : BornPointVO
		{
			var xpos:Number = GridUtils.getXPos(m,n);
			var ypos:Number = GridUtils.getYPos(m,n);
			var _loc_3:BornPointVO = new BornPointVO();
			_loc_3.p.x = m;
			_loc_3.p.y = n;
			_loc_3.mid = nid;
			_loc_3.mname = nname;
			_loc_3.dir = dir;
			_loc_3.monster = MonsterFactory.getInstance().getMonsterSysbol(2);
			_loc_3.monster.voo = _loc_3;
			_loc_3.monster.x = xpos;
			_loc_3.monster.y = ypos;
			_loc_3.type = 2;
			this.monsters.push(_loc_3);
			addChild(_loc_3.monster);
			return _loc_3;
		}// end function
		
		/**增加怪物出生点*/
		public function addMonster(m:int, n:int, nid:String="", nname:String="", dir:int=1, group:int=0):BornPointVO
		{
			var xpos:Number = GridUtils.getXPos(m,n);
			var ypos:Number = GridUtils.getYPos(m,n);
			var voo:BornPointVO = new BornPointVO();
			voo.p.x = m;
			voo.p.y = n;
			voo.mid = nid;
			voo.mname = nname;
			voo.dir = dir;
			voo.monster = MonsterFactory.getInstance().getMonsterSysbol(1);
			voo.monster.voo = voo;
			voo.type = 1;
			voo.monster.x = xpos;
			voo.monster.y = ypos;
			voo.group = group;
			monsters.push(voo);
			addChild(voo.monster);
			if (nid != "")
				voo.monster.update(1);
			return voo;
		}
		/**增加采集出生点*/
		public function addCollect(m:int, n:int, nid:String="", nname:String="", model:String="", goods:String="", dir:int=1, group:int=0):BornPointVO
		{
			var xpos:Number = GridUtils.getXPos(m,n);
			var ypos:Number = GridUtils.getYPos(m,n);
			var voo:BornPointVO = new BornPointVO();
			voo.p.x = m;
			voo.p.y = n;
			voo.mid = nid;
			voo.mname = nname;
			voo.dir = dir;
			voo.monster = MonsterFactory.getInstance().getMonsterSysbol(3);
			voo.monster.voo = voo;
			voo.type = 3;
			voo.monster.x = xpos;
			voo.monster.y = ypos;
			voo.model = model;
			voo.goods = goods;
			monsters.push(voo);
			addChild(voo.monster);
			if (nid != "")
				voo.monster.update(3);
			return voo;
		}
		
		
		private function onClick(e:MouseEvent):void
		{
			if (e.target is BornSprite)
			{
				if (filterSprite)
					filterSprite.filters = [];
				if (filterSprite == e.target)
				{
					filterSprite = null;
					if (e.target.voo.type == 1)
					{
						EditorManager.getInstance().hideMonsterPanel();
					}
					else if (e.target.voo.type == 2)
					{
						EditorManager.getInstance().hideNpcPanel();
					}
					else
					{
						EditorManager.getInstance().hideNpcPanel();
					}
				}
				else
				{
					e.target.filters = filter;
					filterSprite = e.target as BornSprite;
					if (this.filterSprite.voo.type == 1)
					{
						EditorManager.getInstance().showSelectMonster(filterSprite.voo.mid, this.filterSprite.voo.mname,this.filterSprite.voo.dir, this.filterSprite.voo.group);
					}
					else if (this.filterSprite.voo.type == 2)
					{
						EditorManager.getInstance().showSelectNPC((e.target as BornSprite).voo.mid, (e.target as BornSprite).voo.mname, (e.target as BornSprite).voo.dir);
					}
					else
					{
						EditorManager.getInstance().showSelectCollect((e.target as BornSprite).voo.mid, (e.target as BornSprite).voo.mname);
					}
				}
			}
		}
		
		/**当前选中的出生点*/
		public function get selectSprite():BornSprite
		{
			if (this.filterSprite && this.filterSprite.voo.type == 1)
			{
				return this.filterSprite;
			}
			return null;
		}
		/**删除出生点*/
		private function onKeyUp(e:KeyboardEvent):void
		{
			if (e.keyCode == Keyboard.DELETE)
			{
//				if (filterSprite)
//				{
//					filterSprite.filters = [];
//					if (this.filterSprite.voo.type == 1)
//					{
//						EditorManager.getInstance().showSelectMonster(0,"",0);
//					}
//					else
//					{
//						EditorManager.getInstance().showSelectNPC(0,"",0);
//					}
//					this.removeChild(filterSprite);
//					var index:int = monsters.indexOf(filterSprite.voo);
//					if (index >= 0)
//					{
//						monsters.splice(index, 1);
//					}
//					MonsterFactory.getInstance().recycleShape(filterSprite);
//					EditorManager.getInstance().showSelectMonster("");
//					filterSprite = null;
//				}
			}
		}
		
		/**
		 * 搜索该位置是否有NPC点或者怪物出生点
		 * @param m:int the point row index 
		 * @param n:int the point col index
		 */
		public function hasPoint(m:int,n:int):Boolean
		{
			var len:int = monsters.length;
			if (len <= 0)
				return false;
			var i:int=0;
			var p:Point;
			for (i;i<len;i++)
			{
				p = monsters[i].p;
				if (m==p.x&&n==p.y){
					currentIndex = i;
					return true;
				}
			}
			return false;
		}
		
		/**
		 * 删除所有的NPC和怪物点 
		 */
		public function deleteAllBorns():void
		{
			currentIndex = 0;
			var len:int = monsters.length;
			while (len > 0)
			{
				destroyCircle();
				len = monsters.length;
			}
		}
		
		/**
		 * 清除传送点 
		 * 
		 */
		public function destroyCircle():void
		{
			var voo:BornPointVO = monsters[currentIndex];
			voo.p = null;
			if (voo.monster == filterSprite){
				filterSprite = null;
//				EditorManager.getInstance().hideSelectTrans();
			}
			this.removeChild(voo.monster);
			MonsterFactory.getInstance().recycleShape(voo.monster);
			voo.monster = null;
			monsters.splice(currentIndex,1);
		}
		
		/***/
		public function setNpcProperty(id:String, name:String, dir:int):void
		{
			if (filterSprite == null || filterSprite.voo.type != 2)
				return;
			filterSprite.voo.mid = id;
			filterSprite.voo.mname = name;
			filterSprite.voo.dir = dir;
		}
		
		/***/
		public function setMonsterProperty(id:String, name:String, dir:int, group:int=0):void
		{
			if (filterSprite == null || filterSprite.voo.type != 1)
				return;
			filterSprite.voo.mid = id;
			filterSprite.voo.mname = name;
			filterSprite.voo.dir = dir;
			filterSprite.update(1);
			filterSprite.voo.group = group;
			lastMonsterVO = filterSprite.voo;
		}
		/***/
		public function setCollectProperty(id:String, name:String, model:String, good:String):void
		{
			if (filterSprite == null || filterSprite.voo.type != 3)
				return;
			filterSprite.voo.mid = id;
			filterSprite.voo.mname = name;
			filterSprite.voo.goods = good;
			filterSprite.voo.model = model;
			filterSprite.update(3);
		}
	}
}