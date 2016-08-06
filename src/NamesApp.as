package
{
	
	import flash.data.SQLConnection;
	import flash.data.SQLMode;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.display3D.Context3DRenderMode;
	import flash.events.Event;
	import flash.events.SQLEvent;
	import flash.filesystem.File;
	
	import feathers.utils.ScreenDensityScaleFactorManager;
	
	import starling.core.Starling;
	
	[SWF(width="320",height="480",frameRate="60",backgroundColor="#443941")]
	public class NamesApp extends Sprite
	{
		public static var conn:SQLConnection;
		private var myStarling:Starling;
		private var myScaler:ScreenDensityScaleFactorManager;
		
		public function NamesApp()
		{			
			if(this.stage)
			{
				this.stage.scaleMode = StageScaleMode.NO_SCALE;
				this.stage.align = StageAlign.TOP_LEFT;
			}
			this.mouseEnabled = this.mouseChildren = false;
		
			
			
			var db:File = File.applicationDirectory.resolvePath("assets/names.sqlite");
			conn = new SQLConnection();
			conn.addEventListener(SQLEvent.OPEN, openDatabaseHandler);
			
			//Since this database is big and queries can take several seconds we use async instead of regular synchronous
			conn.openAsync(db, SQLMode.READ);
			
			this.loaderInfo.addEventListener(Event.COMPLETE, loaderInfo_completeHandler);
		}
		
		private function openDatabaseHandler(event:SQLEvent):void
		{
			conn.removeEventListener(SQLEvent.OPEN, openDatabaseHandler);
		}		
		
		private function loaderInfo_completeHandler(event:Event):void
		{
			Starling.multitouchEnabled = true;
			
			this.myStarling = new Starling(Main, this.stage, null, null, Context3DRenderMode.AUTO, "auto");
			this.myScaler = new ScreenDensityScaleFactorManager(this.myStarling);
			this.myStarling.enableErrorChecking = false;
			this.myStarling.skipUnchangedFrames = true;
			//this.myStarling.showStats = true;
			
			this.myStarling.start();			
			
			this.stage.addEventListener(Event.DEACTIVATE, stage_deactivateHandler, false, 0, true);
		}
		
		private function stage_deactivateHandler(event:Event):void
		{
			this.myStarling.stop();
			this.stage.addEventListener(Event.ACTIVATE, stage_activateHandler, false, 0, true);
		}
		
		private function stage_activateHandler(event:Event):void
		{
			this.stage.removeEventListener(Event.ACTIVATE, stage_activateHandler);
			this.myStarling.start();
		}
		
	}
}