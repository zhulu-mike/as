package com.thinkido.framework.engine.tools
{
    
    import br.com.stimuli.loading.BulkLoader;
    import br.com.stimuli.loading.BulkProgressEvent;
    
    import com.thinkido.framework.manager.loader.LoaderManager;
    import com.thinkido.framework.utils.SystemUtil;
    
	/**
	 *  场景加载器,加载地图tile，
	 * @author Administrator
	 * 
	 */
    public class SceneLoader extends Object
    {
		
		public static var smallMapImgLoader:BulkLoader = LoaderManager.creatNewLoader("smallMapImgLoader",smallMapCom);
		public static var avatarXmlLoader:BulkLoader = LoaderManager.creatNewLoader("avatarXmlLoader", avatarXmlCom);
		public static var mapImgLoader:BulkLoader = LoaderManager.creatNewLoader("mapImgLoader", mapImgCom);
		
        public function SceneLoader()
        {
            return;
        }
		private static function smallMapCom(evt:BulkProgressEvent):void
		{
			SystemUtil.gc();
		}
		private static function mapImgCom(evt:BulkProgressEvent):void
		{
			SystemUtil.gc();
		}
		
		private static function avatarXmlCom(evt:BulkProgressEvent):void
		{
			SystemUtil.gc();
		}
		
    }
}
