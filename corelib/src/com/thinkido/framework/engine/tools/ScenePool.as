package com.thinkido.framework.engine.tools
{
    import com.thinkido.framework.common.pool.*;
    import com.thinkido.framework.manager.PoolManager;

    public class ScenePool extends Object
    {
        public static var sceneCharacterPool:Pool = PoolManager.creatPool("sceneCharacterPool", 100);
        public static var avatarPool:Pool = PoolManager.creatPool("avatarPool", 100);
		public static var shadowPool:Pool = PoolManager.creatPool("shadowPool", 100);
        public static var avatarPartPool:Pool = PoolManager.creatPool("avatarPartPool", 200);
        public static var attackFacePool:Pool = PoolManager.creatPool("attackFacePool", 200);
        public static var headFacePool:Pool = PoolManager.creatPool("headFacePool", 200);
        public static var mapTilePool:Pool = PoolManager.creatPool("mapTilePool");

        public function ScenePool()
        {
            return;
        }

    }
}
