package screens
{
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	import flash.events.SQLEvent;
	import flash.globalization.NumberFormatter;
	
	import feathers.controls.Alert;
	import feathers.controls.Button;
	import feathers.controls.List;
	import feathers.controls.PanelScreen;
	import feathers.controls.TextInput;
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.events.FeathersEventType;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	
	import renderers.LongPressRenderer;
	
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.events.Event;
	
	public class AllNamesScreen extends PanelScreen
	{
		public static const GO_NAME_DETAILS:String = "goNameDetails";
		
		private var namesArray:Array;
		private var tempArray:Array;
		private var myStatement:SQLStatement;
		private var numberFormatter:NumberFormatter;
		
		private var alert:Alert;
		private var namesInput:TextInput
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
			this.title = "Search All Names";
			this.layout = new AnchorLayout();
			this.backButtonHandler = goBack;
			
			var backButton:Button = new Button();
			backButton.addEventListener(starling.events.Event.TRIGGERED, goBack);
			backButton.styleNameList.add("back-button");
			this.headerProperties.leftItems = new <DisplayObject>[backButton];
			
			namesInput = new TextInput();
			namesInput.layoutData = new AnchorLayoutData(0, 10, NaN, 10, NaN, NaN);
			namesInput.height = 50;
			namesInput.prompt = "Start typing a name";
			this.addChild(namesInput);
			
			namesList = new List();
			namesList.alpha = 0;
			namesList.layoutData = new AnchorLayoutData(60, 0, 0, 0, NaN, NaN);
			namesList.itemRendererFactory = function():DefaultListItemRenderer
			{
				var renderer:LongPressRenderer = new LongPressRenderer()
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
			
			if(_data.savedNames){
				namesArray = _data.namesArray;
				namesList.dataProvider = _data.savedNames;
				namesList.scrollToDisplayIndex(_data.selectedIndex);
				namesList.selectedIndex = _data.selectedIndex;
				namesInput.text = _data.nameInputText;				
				
				namesList.addEventListener(Event.CHANGE, changeHandler);
				namesInput.addEventListener(Event.CHANGE, inputHandler);
				
				var fadeInList:Tween = new Tween(namesList, 0.3);
				fadeInList.fadeTo(1);
				fadeInList.onComplete = function():void
				{
					Starling.juggler.remove(fadeInList);
				};
				Starling.juggler.add(fadeInList);
			} else {
				namesList.addEventListener(Event.CHANGE, changeHandler);
				namesInput.addEventListener(Event.CHANGE, inputHandler);
				
				loadNamesList();
			}
		}
		
		private function loadNamesList():void
		{			
			myStatement = new SQLStatement();
			myStatement.sqlConnection = NamesApp.conn;
			myStatement.addEventListener(SQLEvent.RESULT, namesLoaded);
			
			var myQuery:String = "SELECT * FROM first_names";
			
			myStatement.text = myQuery;
			myStatement.execute();
		}
				
		private function namesLoaded(event:SQLEvent):void
		{
			myStatement.removeEventListener(SQLEvent.RESULT, namesLoaded);
			
			var result:SQLResult = myStatement.getResult();
			
			if(result.data != null)
			{
				namesList.dataProvider = new ListCollection(namesArray = result.data);
				result = null;
				
				var fadeInList:Tween = new Tween(namesList, 0.3);
				fadeInList.fadeTo(1);
				fadeInList.onComplete = function():void
				{
					Starling.juggler.remove(fadeInList);
				};
				Starling.juggler.add(fadeInList);
			}			
		}
		
		private function changeHandler(event:Event):void
		{
			_data.currentName = namesList.selectedItem;
			_data.selectedIndex = namesList.selectedIndex;
			_data.namesArray = namesArray;
			_data.savedNames = namesList.dataProvider;
			_data.nameInputText = namesInput.text;
			
			this.dispatchEventWith(GO_NAME_DETAILS);
		}
		
		private function longPressHandler(event:Event):void
		{
			var myObject:Object = event.target; //Everything is an object if you believe hard enough.
			
			alert = Alert.show("Do you want to add "+myObject.data.name+" to your favorites?", "Add Name", new ListCollection(
				[
					{ label: "Cancel"},
					{ label: "OK"}
				]) );
			
			alert.addEventListener(Event.CLOSE, function(event:Event, data:Object):void
			{
				if(data.label == "OK"){
					FavoritesManager.addToFavorites(myObject.data)	
				}				
			});
		}
				
		private function inputHandler(event:Event):void
		{
			namesList.removeEventListener(Event.CHANGE, changeHandler);
			namesList.dataProvider = new ListCollection(tempArray = namesArray.filter(filterStates));
			namesList.addEventListener(Event.CHANGE, changeHandler);
		}
		
		private function filterStates(item:Object, index:int, arr:Array):Boolean {
			return item.name.match(new RegExp(namesInput.text, "i"));
		}
		
		private function goBack():void
		{
			namesList.removeEventListener(Event.CHANGE, changeHandler);
			
			if(alert){
				alert.removeFromParent(true);
			}
			
			_data.currentName = null
			_data.selectedIndex = null;
			_data.namesArray = null;
			_data.savedNames = null;
			_data.nameInputText = null;
			
			namesList.dataProvider = null;
			namesArray = null;
			tempArray = null;
			
			this.dispatchEventWith(Event.COMPLETE);
		}
	}
}