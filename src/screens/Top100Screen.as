package screens
{
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	import flash.events.SQLEvent;
	import flash.globalization.NumberFormatter;
	
	import feathers.controls.Alert;
	import feathers.controls.Button;
	import feathers.controls.ImageLoader;
	import feathers.controls.List;
	import feathers.controls.Panel;
	import feathers.controls.PanelScreen;
	import feathers.controls.TabBar;
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.core.PopUpManager;
	import feathers.data.ListCollection;
	import feathers.events.FeathersEventType;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	
	import renderers.LongPressRenderer;
	
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Quad;
	import starling.events.Event;
		
	public class Top100Screen extends PanelScreen
	{
		public static const GO_NAME_DETAILS:String = "goNameDetails";
		
		private var alert:Alert;
		private var myStatement:SQLStatement;
		private var numberFormatter:NumberFormatter;
		private var namesList:List;
		private var optionsPanel:Panel;
		private var tabBar:TabBar;
		
		private var openPopup:Boolean = false;		
		private var gender:String;
		private var year:int;
		
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
			this.layout = new AnchorLayout();
			this.backButtonHandler = goBack;
			
			var backButton:Button = new Button();
			backButton.addEventListener(Event.TRIGGERED, goBack);
			backButton.styleNameList.add("back-button");
			this.headerProperties.leftItems = new <DisplayObject>[backButton];
			
			var menuIcon:ImageLoader = new ImageLoader();
			menuIcon.source = "assets/icons/menu.png";
			menuIcon.width = menuIcon.height = 25;
			
			var menuButton:Button = new Button();
			menuButton.addEventListener(Event.TRIGGERED, openMenu);
			menuButton.styleNameList.add("header-button");
			menuButton.defaultIcon = menuIcon;
			this.headerProperties.rightItems = new <DisplayObject>[menuButton];
			
			namesList = new List();
			namesList.alpha = 0;
			namesList.layoutData = new AnchorLayoutData(0, 0, 50, 0, NaN, NaN);
			namesList.itemRendererFactory = function():DefaultListItemRenderer
			{
				var renderer:LongPressRenderer = new LongPressRenderer()
				renderer.addEventListener(FeathersEventType.LONG_PRESS, longPressHandler);
				renderer.isQuickHitAreaEnabled = true;
				renderer.labelFunction = function(item:Object):String
				{
					return item.name + "\n" + numberFormatter.formatInt(item.count) + " records";
				};
				
				renderer.iconLabelFunction = function(item:Object):String
				{
					return "#" + String(renderer.index+1);
				}					
				
				return renderer;
			};
			this.addChild(namesList);
	
			var maleIcon:ImageLoader = new ImageLoader();
			maleIcon.source = "assets/icons/male.png";
			maleIcon.width = maleIcon.height = 25;
			
			var femaleIcon:ImageLoader = new ImageLoader();
			femaleIcon.source = "assets/icons/female.png";
			femaleIcon.width = femaleIcon.height = 25;
			
			tabBar = new TabBar();
			tabBar.height = 50;
			tabBar.layoutData = new AnchorLayoutData(NaN, 0, 0, 0, NaN, NaN);
			tabBar.dataProvider = new ListCollection(
				[
					{label:"", data:"M", defaultIcon:maleIcon},
					{label:"", data:"F", defaultIcon:femaleIcon}				
				]);
			this.addChild(tabBar);
			
			numberFormatter = new NumberFormatter("en_US");
			
			this.addEventListener(FeathersEventType.TRANSITION_IN_COMPLETE, transitionComplete);
		}
		
		private function transitionComplete(event:Event):void
		{
			this.removeEventListener(FeathersEventType.TRANSITION_IN_COMPLETE, transitionComplete);
									
			if(_data.savedResults){
				namesList.dataProvider = _data.savedResults;
				namesList.scrollToDisplayIndex(_data.selectedIndex);
				namesList.selectedIndex = _data.selectedIndex;
				
				gender = _data.gender;
				year = _data.year;
				
				if(gender == "M"){
					tabBar.selectedIndex = 0;
					title = "Top Male names in " + String(year);
				} else {
					tabBar.selectedIndex = 1;
					title = "Top Female names in " + String(year); 
				}
				
				namesList.addEventListener(Event.CHANGE, changeHandler);
				
				var fadeInList:Tween = new Tween(namesList, 0.3);
				fadeInList.fadeTo(1);
				fadeInList.onComplete = function():void
				{
					Starling.juggler.remove(fadeInList);
				};
				Starling.juggler.add(fadeInList);
			} else {
				_data.optionsSavedIndex = 0;
				gender = "M";
				year = 2015;
				tabBar.selectedIndex = 0;
				
				doSearch();				
			}
			
			tabBar.addEventListener(Event.CHANGE, tabHandler);
		}
		
		private function tabHandler(event:Event):void
		{
			gender = tabBar.selectedItem.data;
			doSearch();
		}
		
		private function changeHandler(event:Event):void
		{
			_data.currentName = namesList.selectedItem;
			_data.selectedIndex = namesList.selectedIndex;
			_data.savedResults = namesList.dataProvider;
			_data.gender = gender;
			_data.year = year;
			dispatchEventWith(GO_NAME_DETAILS);
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
		
		private function doSearch():void
		{
			myStatement = new SQLStatement();
			myStatement.sqlConnection = NamesApp.conn;
			myStatement.addEventListener(SQLEvent.RESULT, namesLoaded);
			
			var myQuery:String = "SELECT name, quantity as count FROM names WHERE year="+year+" AND gender='"+gender+"' LIMIT 100";
			
			myStatement.text = myQuery;
			myStatement.execute();	
		}
		
		private function namesLoaded(event:SQLEvent):void
		{
			myStatement.removeEventListener(SQLEvent.RESULT, namesLoaded);
			
			if(gender == "M"){
				title = "Top Male names in " + String(year);
			} else {
				title = "Top Female names in " + String(year); 
			}
			
			var result:SQLResult = myStatement.getResult();
			
			if(result.data != null)
			{
				namesList.removeEventListener(Event.CHANGE, changeHandler);
				namesList.dataProvider = new ListCollection(result.data);
				result = null;
				namesList.addEventListener(Event.CHANGE, changeHandler);
				
				var fadeInList:Tween = new Tween(namesList, 0.3);
				fadeInList.fadeTo(1);
				fadeInList.onComplete = function():void
				{
					Starling.juggler.remove(fadeInList);
				};
				Starling.juggler.add(fadeInList);
			}			
		}
		
		private function openMenu():void
		{
			openPopup = true;
			
			optionsPanel = new Panel();
			optionsPanel.headerProperties.paddingLeft = 10;
			optionsPanel.title = "Select a Year";
			
			var yearsArray:Array = new Array();
			
			for(var i:uint = 2015; i>=1880; i--){
				yearsArray.push({label:i, data:i});
			}
				
			
			var options:ListCollection = new ListCollection(yearsArray);
			
			var quad:Quad = new Quad(3, 3);
			quad.setVertexColor(0, 0x443941);
			quad.setVertexColor(1, 0x443941);
			quad.setVertexColor(2, 0xAF8B95);
			quad.setVertexColor(3, 0xAF8B95);
			
			var optionsList:List = new List();
			optionsList.backgroundSkin = quad;
			optionsList.width = optionsList.maxWidth = 200;
			optionsList.maxHeight = 200;
			optionsList.dataProvider = options;
			optionsList.hasElasticEdges = false;
			optionsList.itemRendererFactory = function():DefaultListItemRenderer
			{
				var renderer:DefaultListItemRenderer = new DefaultListItemRenderer();
				
				renderer.accessorySourceFunction = function():String
				{
					trace(renderer.index);
					
					if(optionsList.selectedIndex == renderer.index){
						return "assets/icons/radio_checked.png";						
					} else {
						return "assets/icons/radio_unchecked.png";
	
					}					
				}
				
				renderer.accessoryLoaderFactory = function():ImageLoader
				{
					var loader:ImageLoader = new ImageLoader();
					loader.width = loader.height = 20;
					return loader;
				}
					
				return renderer;
				
			};
			optionsPanel.addChild(optionsList);
			
			optionsList.selectedIndex = _data.optionsSavedIndex;
			optionsList.scrollToDisplayIndex(_data.optionsSavedIndex);
			
			optionsList.addEventListener(Event.CHANGE, function():void
			{
				//Order of these instructions DOES matter
				namesList.removeEventListener(Event.CHANGE, changeHandler);
				namesList.selectedIndex = -1;
				year = optionsList.selectedItem.data;
				_data.optionsSavedIndex = optionsList.selectedIndex;
				PopUpManager.removePopUp(optionsPanel, true);
				openPopup = false;
				doSearch();
				namesList.addEventListener(Event.CHANGE, changeHandler);
			});			
			
			PopUpManager.addPopUp(optionsPanel, true, true, function():DisplayObject
			{
				var quad:Quad = new Quad(3, 3, 0x000000);
				quad.alpha = 0.50;
				return quad;				
			});
		}
		
		private function goBack():void
		{
			//This screen is fairly complex, special care is needed to dispose everything correctly.
			
			_data.year = null;
			_data.gender = null;
			_data.savedResults = null;
			_data.optionsSavedIndex = null;
			_data.selectedIndex = null;
			_data.currentName = null;
		
			namesList.removeEventListener(Event.CHANGE, changeHandler);
			namesList.dataProvider = null;
			
			if(alert){
				alert.removeFromParent(true);
			}
			
			if(openPopup){
				PopUpManager.removePopUp(optionsPanel, true);
			}
			
			this.dispatchEventWith(Event.COMPLETE);
		}
	}
}