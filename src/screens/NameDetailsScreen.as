package screens
{
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	import flash.events.Event;
	import flash.events.SQLEvent;
	import flash.globalization.NumberFormatter;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import feathers.controls.Button;
	import feathers.controls.ImageLoader;
	import feathers.controls.Label;
	import feathers.controls.LayoutGroup;
	import feathers.controls.List;
	import feathers.controls.PanelScreen;
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.events.FeathersEventType;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	import feathers.layout.VerticalLayout;
	
	import starling.display.DisplayObject;
	import starling.events.Event;
	import starling.textures.Texture;
	
	public class NameDetailsScreen extends PanelScreen
	{
		private var currentState:String;
		private var numberFormatter:NumberFormatter
		private var nameTxt:Label;
		private var countTxt:Label;
		private var summaryTxt:Label;
		private var yearsList:List;
		
		private var numberedIcon:ImageLoader;
		private var infoIcon:ImageLoader;
		
		private var optionsButton:Button;
		
		private var loadingGroup:LayoutGroup;
		
		private var myStatement:SQLStatement;
		
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
			this.title = "Name Details";
			this.layout = new AnchorLayout();
			this.backButtonHandler = goBack;
			
			var backButton:Button = new Button();
			backButton.addEventListener(starling.events.Event.TRIGGERED, goBack);
			backButton.styleNameList.add("back-button");
			this.headerProperties.leftItems = new <DisplayObject>[backButton];
			
			infoIcon = new ImageLoader();
			infoIcon.source = "assets/icons/info.png";
			infoIcon.width = infoIcon.height = 25;
			
			numberedIcon = new ImageLoader();
			numberedIcon.source = "assets/icons/list_numbered.png";
			numberedIcon.width = numberedIcon.height = 25;
			
			optionsButton = new Button();
			optionsButton.addEventListener(starling.events.Event.TRIGGERED, function():void
			{
			
				if(currentState == "summary"){
					showList();
				} else if(currentState == "list") {
					showSummary();
				} else {
					
				}
			
			});
			optionsButton.styleNameList.add("header-button");
			optionsButton.defaultIcon = numberedIcon;
			
			this.headerProperties.rightItems = new <DisplayObject>[optionsButton];
			
			numberFormatter = new NumberFormatter("en_US");
			
			this.addEventListener(FeathersEventType.TRANSITION_IN_COMPLETE, transitionComplete);
		}
		
		private function transitionComplete(event:starling.events.Event):void
		{
			this.removeEventListener(FeathersEventType.TRANSITION_IN_COMPLETE, transitionComplete);
			
			currentState = "summary";
			
			nameTxt = new Label();
			nameTxt.layoutData = new AnchorLayoutData(0, 10, NaN, 10, NaN, NaN);
			nameTxt.styleNameList.add("big-label");
			nameTxt.text = _data.currentName.name;
			this.addChild(nameTxt);
			
			countTxt = new Label();
			countTxt.layoutData = new AnchorLayoutData(80, 10, NaN, 10, NaN, NaN);
			this.addChild(countTxt);
			
			getNameCount(_data.currentName.name);			
			getNameInfo(_data.currentName.name);
		}
		
		private function getNameInfo(name:String):void
		{
			var request:URLRequest = new URLRequest("https://en.wikipedia.org/w/api.php?format=json&action=query&redirects=1&prop=extracts&exintro=&titles="+name+"_(name)");
			
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(flash.events.Event.COMPLETE, function():void
			{
				var rawData:Object = JSON.parse(loader.data);
				
				for each(var item:Object in rawData.query.pages)
				{					
					if(item.extract == undefined){
						//Sometimes the _(given_name) prefix doesn't exist, so we try without it
						getNameInfoAlt(name);
					} else {
						summaryTxt = new Label();
						summaryTxt.text = item.extract;
						summaryTxt.layoutData = new AnchorLayoutData(120, 10, NaN, 10, NaN, NaN);
						summaryTxt.styleNameList.add("summary-style");
						summaryTxt.paddingBottom = 10;
						summaryTxt.textRendererProperties.wordWrap = true;
						addChild(summaryTxt);
					}
				}			
			});
			loader.load(request);
		}
		
		private function getNameInfoAlt(name:String):void
		{
			var request:URLRequest = new URLRequest("https://en.wikipedia.org/w/api.php?format=json&action=query&redirects=1&prop=extracts&exintro=&titles="+name+"_(given_name)");
			
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(flash.events.Event.COMPLETE, function():void
			{
				var rawData:Object = JSON.parse(loader.data);
				
				for each(var item:Object in rawData.query.pages)
				{					
					if(item.extract == undefined){
						//If name summary is not available we inform the user
						summaryTxt = new Label();
						summaryTxt.text = "No summary available.";
						summaryTxt.layoutData = new AnchorLayoutData(120, 10, NaN, 10, NaN, NaN);
						addChild(summaryTxt);
					} else {
						summaryTxt = new Label();
						summaryTxt.text = item.extract;
						summaryTxt.layoutData = new AnchorLayoutData(120, 10, NaN, 10, NaN, NaN);
						summaryTxt.styleNameList.add("summary-style");
						summaryTxt.paddingBottom = 10;
						summaryTxt.textRendererProperties.wordWrap = true;
						addChild(summaryTxt);
					}				
				}			
			});
			loader.load(request);
		}
		
		private function showList():void
		{
			currentState = "list";
			
			optionsButton.defaultIcon = infoIcon;
			
			nameTxt.visible = false;			
			countTxt.visible = false;			
			summaryTxt.visible = false;
			
			if(yearsList){
				 yearsList.visible = true;
			} else {
				loadingGroup = new LayoutGroup();
				loadingGroup.layout = new VerticalLayout();
				loadingGroup.layoutData = new AnchorLayoutData(NaN, NaN, NaN, NaN, 0, 0);
				this.addChild(loadingGroup);
				
				var clockIcon:ImageLoader = new ImageLoader();
				clockIcon.source = Texture.fromEmbeddedAsset(CustomTheme.clockAsset);
				clockIcon.width = clockIcon.height = 50;
				loadingGroup.addChild(clockIcon);			
				
				var loadingLabel:Label = new Label();
				loadingLabel.text = "Loading...";
				loadingGroup.addChild(loadingLabel);
				
				myStatement = new SQLStatement();
				myStatement.sqlConnection = NamesApp.conn;
				myStatement.addEventListener(SQLEvent.RESULT, yearsDataLoaded);
				
				var myQuery:String = "SELECT * FROM names WHERE name='"+_data.currentName.name+"' COLLATE NOCASE GROUP BY year ORDER BY year DESC";
				
				myStatement.text = myQuery;
				myStatement.execute();		
			}			
		}
		
		private function yearsDataLoaded(event:SQLEvent):void
		{
			myStatement.removeEventListener(SQLEvent.RESULT, yearsDataLoaded);
			
			//Since our data is now loaded we don't require the loading group anymore
			this.removeChild(loadingGroup, true);
			
			var result:SQLResult = myStatement.getResult();
			
			yearsList = new List();
			yearsList.layoutData = new AnchorLayoutData(0, 0, 0, 0, NaN, NaN);
			yearsList.itemRendererFactory = function():DefaultListItemRenderer
			{
				var renderer:DefaultListItemRenderer = new DefaultListItemRenderer();
				renderer.isQuickHitAreaEnabled = true;
				renderer.labelFunction = function(item:Object):String
				{
					return numberFormatter.formatInt(item.quantity) + " records in " + item.year;
				}
				
				return renderer;
			};
			this.addChild(yearsList);
			
			yearsList.dataProvider = new ListCollection(result.data);
			result = null;
		}
		
		private function showSummary():void
		{
			currentState = "summary";
			
			optionsButton.defaultIcon = numberedIcon;
			
			yearsList.visible = false;				
			
			nameTxt.visible = true;
			countTxt.visible = true;
			summaryTxt.visible = true;
		}
		
		private function getNameCount(name:String):void
		{
			myStatement = new SQLStatement();
			myStatement.sqlConnection = NamesApp.conn;
			myStatement.addEventListener(SQLEvent.RESULT, function():void
			{
			;	var result:SQLResult = myStatement.getResult();
				countTxt.text = numberFormatter.formatInt(result.data[0].count) + " records.";
			});
						
			var myQuery:String = "SELECT * FROM first_names WHERE name='"+name+"'";
			
			myStatement.text = myQuery;
			myStatement.execute();	
		}
		
		private function goBack():void
		{
			if(yearsList)
			{
				yearsList.dataProvider = null;				
			}
			
			this.dispatchEventWith(starling.events.Event.COMPLETE);
		}
	}
}