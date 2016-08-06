package screens
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.globalization.NumberFormatter;
	
	import feathers.controls.Alert;
	import feathers.controls.Button;
	import feathers.controls.List;
	import feathers.controls.PanelScreen;
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.events.FeathersEventType;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	
	import renderers.LongPressRenderer;
	
	import starling.display.DisplayObject;
	import starling.events.Event;
	
	public class FavoritesScreen extends PanelScreen
	{
		public static const GO_NAME_DETAILS:String = "goNameDetails";
		
		private var numberFormatter:NumberFormatter;

		private var alert:Alert;
		private var namesList:List;
		
		protected var _data:NavigatorData;
		
		public function get data():NavigatorData
		{
			return this._data;
		}		
		
		public function set data(value:NavigatorData):void
		{
			this._data = value;	
		}
		
		override protected function initialize():void
		{
			this.title = "Favorites";
			this.layout = new AnchorLayout();
			this.backButtonHandler = goBack;
			
			var backButton:Button = new Button();
			backButton.addEventListener(starling.events.Event.TRIGGERED, goBack);
			backButton.styleNameList.add("back-button");
			this.headerProperties.leftItems = new <DisplayObject>[backButton];
			
			namesList = new List();
			namesList.layoutData = new AnchorLayoutData(0, 0, 0, 0, NaN, NaN);
			namesList.itemRendererFactory = function():DefaultListItemRenderer
			{
				var renderer:LongPressRenderer = new LongPressRenderer();
				renderer.addEventListener(FeathersEventType.LONG_PRESS, longPressHandler);
				renderer.isQuickHitAreaEnabled = true;
				renderer.labelFunction = function(item:Object):String
				{
					return item.name + "\n" + numberFormatter.formatInt(item.count) + " records";
				}
				
				return renderer;
			};
			this.addChild(namesList);
			
			numberFormatter = new NumberFormatter("en_US");
			
			this.addEventListener(FeathersEventType.TRANSITION_IN_COMPLETE, transitionComplete);
		}
		
		private function transitionComplete(event:Event):void
		{
			this.removeEventListener(FeathersEventType.TRANSITION_IN_COMPLETE, transitionComplete);
		
			if(_data.savedResults){
				namesList.dataProvider = _data.savedResults;
				namesList.selectedIndex = _data.selectedIndex;
				namesList.scrollToDisplayIndex(_data.selectedIndex);
				namesList.addEventListener(Event.CHANGE, changeHandler);				
			} else {
				loadFavorites();			
			}			
		}
		
		private function loadFavorites():void
		{
			var file:File = File.applicationStorageDirectory.resolvePath("favorites.data");
			
			if(file.exists)
			{
				var fileStream:FileStream = new FileStream();
				fileStream.open(file, FileMode.READ);
				
				if(fileStream.bytesAvailable == 0){					
					fileStream.close();				
				} else {
					var favoritesArray:Array = fileStream.readObject();
					
					namesList.dataProvider = new ListCollection(favoritesArray);
					namesList.addEventListener(Event.CHANGE, changeHandler);
					fileStream.close();					
				}								
			}
		}

		private function changeHandler(event:Event):void
		{
			_data.currentName = namesList.selectedItem;
			_data.selectedIndex = namesList.selectedIndex;
			_data.savedResults = namesList.dataProvider;
			dispatchEventWith(GO_NAME_DETAILS);
		}
		
		private function longPressHandler(event:Event):void
		{
			var myObject:Object = event.target; //Everything is an object if you believe hard enough.
			
			trace(myObject.index);
			alert = Alert.show("Do you want to delete "+myObject.data.name+" from your favorites?", "Delete Name", new ListCollection(
				[
					{ label: "Cancel"},
					{ label: "OK"}
				]) );
			
			alert.addEventListener(Event.CLOSE, function(event:Event, data:Object):void
			{
				if(data.label == "OK"){
					deleteName(myObject);
				}				
			});
		}
		
		private function deleteName(item:Object):void
		{
			namesList.removeEventListener(Event.CHANGE, changeHandler);
			FavoritesManager.deleteFromFavorites(item);			
			loadFavorites();
		}
		
		private function goBack():void
		{
			if(alert){
				alert.removeFromParent(true);
			}
			
			_data.savedResults = null;
			_data.selectedIndex = null;
			_data.currentName = null;
			
			this.dispatchEventWith(Event.COMPLETE);
		}
	}
}