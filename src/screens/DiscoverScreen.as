package screens
{	
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	import flash.events.SQLEvent;
	import flash.globalization.NumberFormatter;
	
	import feathers.controls.Button;
	import feathers.controls.ImageLoader;
	import feathers.controls.Label;
	import feathers.controls.LayoutGroup;
	import feathers.controls.List;
	import feathers.controls.PanelScreen;
	import feathers.controls.Scroller;
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.VerticalLayout;
	
	import renderers.CardItemRenderer;
	
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.events.Event;
	import starling.textures.Texture;
	
	public class DiscoverScreen extends PanelScreen
	{		
		public static const GO_NAME_DETAILS:String = "goNameDetails";
		
		private var numberFormatter:NumberFormatter;
		private var myStatement:SQLStatement;
		private var myQuery:String;
		private var gender:String;
		private var nameLength:String;
		private var nameRarity:String;
		
		private var startGroup:LayoutGroup;
		private var genderGroup:LayoutGroup;	
		private var lengthGroup:LayoutGroup;
		private var rarityGroup:LayoutGroup;
		private var loadingGroup:LayoutGroup;
		
		private var likedNames:Array;
		private var namesList:List;
		private var likedNamesList:List;
		
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
			this.title = "Name Discovery";
			this.layout = new AnchorLayout();
			this.backButtonHandler = goBack;
			
			var backButton:Button = new Button();
			backButton.addEventListener(starling.events.Event.TRIGGERED, goBack);
			backButton.styleNameList.add("back-button");
			this.headerProperties.leftItems = new <DisplayObject>[backButton];
									
			numberFormatter = new NumberFormatter("en-US");
			
			//We check if there are saved results and display them if so; otherwise start a name discovery
			
			if(_data.savedResults){
				
				//We create a list and restore it to where we left it. You can see the origin of these values at the bottom of this document.
				
				likedNamesList = new List();
				likedNamesList.layoutData = new AnchorLayoutData(0, 0, 0, 0, NaN, NaN);
				likedNamesList.dataProvider = _data.savedResults;
				likedNamesList.selectedIndex = _data.selectedIndex;
				likedNamesList.scrollToDisplayIndex(_data.selectedIndex);
				likedNamesList.itemRendererFactory = function():DefaultListItemRenderer
				{
					var renderer:DefaultListItemRenderer = new DefaultListItemRenderer();
					renderer.isQuickHitAreaEnabled = true;
					renderer.labelFunction = function(item:Object):String
					{
						return item.name + "\n" + numberFormatter.formatInt(item.count) + " records";
					};
					
					return renderer;
				};
				this.addChild(likedNamesList);
				likedNamesList.addEventListener(Event.CHANGE, changeHandler);				

			} else {
				startDiscover();
			}
		}
		
		/*
			The following blocks create the user interface, animations and disposes them in the same order
		*/
		
		private function startDiscover():void
		{
			var layoutForstartGroup:VerticalLayout = new VerticalLayout();
			layoutForstartGroup.gap = 10;
			
			startGroup = new LayoutGroup();
			startGroup.layout = layoutForstartGroup;
			startGroup.layoutData = new AnchorLayoutData(NaN, NaN, NaN, NaN, 0, 0);
			startGroup.alpha = 0;
			this.addChild(startGroup);
			
			var startLabel:Label = new Label();
			startLabel.styleNameList.add("medium-label");
			startLabel.maxWidth = 200;
			startLabel.textRendererProperties.wordWrap = true;
			startLabel.text = "Let's discover great names!";
			startGroup.addChild(startLabel);
			
			var startButton:Button = new Button();
			startButton.addEventListener(Event.TRIGGERED, step1);
			startButton.styleNameList.add("light-button");
			startButton.width = 200;
			startButton.height = 50;
			startButton.label = "Start";
			startGroup.addChild(startButton);
			
			var startGroupFadeIn:Tween = new Tween(startGroup, 0.3);
			startGroupFadeIn.fadeTo(1);
			Starling.juggler.add(startGroupFadeIn);
		}
		
		private function step1():void
		{
			var startGroupFadeOut:Tween = new Tween(startGroup, 0.3);
			startGroupFadeOut.fadeTo(0);
			startGroupFadeOut.onComplete = function():void
			{
				removeChild(startGroup, true);
				title = "Select a Gender";
			};
			Starling.juggler.add(startGroupFadeOut);
						
			var layoutForGenderGroup:HorizontalLayout = new HorizontalLayout();;
			layoutForGenderGroup.gap = 70;
			
			genderGroup = new LayoutGroup();
			genderGroup.alpha = 0;
			genderGroup.layoutData = new AnchorLayoutData(NaN, NaN, NaN, NaN, 0, 0);
			genderGroup.layout = layoutForGenderGroup;
			this.addChild(genderGroup);
			
			var maleIcon:ImageLoader = new ImageLoader();
			maleIcon.source = "assets/icons/male.png";
			maleIcon.width = maleIcon.height = 60;
			
			var maleButton:Button = new Button();
			maleButton.addEventListener(Event.TRIGGERED, function():void
			{
				gender = "M";
				step2();
			});
			maleButton.label = "Male";
			maleButton.styleNameList.add("home-button");
			maleButton.defaultIcon = maleIcon;
			genderGroup.addChild(maleButton);
			
			var femaleIcon:ImageLoader = new ImageLoader();
			femaleIcon.source = "assets/icons/female.png";
			femaleIcon.width = femaleIcon.height = 60;
			
			var femaleButton:Button = new Button();
			femaleButton.addEventListener(Event.TRIGGERED, function():void
			{
				gender = "F";
				step2();
			});
			femaleButton.label = "Female";
			femaleButton.styleNameList.add("home-button");
			femaleButton.defaultIcon = femaleIcon;
			genderGroup.addChild(femaleButton);
			
			var genderGroupFadeIn:Tween = new Tween(genderGroup, 0.3);
			genderGroupFadeIn.fadeTo(1);
			Starling.juggler.add(genderGroupFadeIn);
		}
		
		private function step2():void
		{
			var genderGroupFadeOut:Tween = new Tween(genderGroup, 0.3);
			genderGroupFadeOut.fadeTo(0);
			genderGroupFadeOut.onComplete = function():void
			{
				removeChild(genderGroup, true);
				title = "Select Name Length";
			};
			Starling.juggler.add(genderGroupFadeOut);
					
			var layoutForLengthGroup:VerticalLayout = new VerticalLayout();;;
			layoutForLengthGroup.gap = 50;
			
			lengthGroup = new LayoutGroup();
			lengthGroup.alpha = 0;
			lengthGroup.layoutData = new AnchorLayoutData(NaN, NaN, NaN, NaN, 0, 0);
			lengthGroup.layout = layoutForLengthGroup;
			this.addChild(lengthGroup);
			
			var shortButton:Button = new Button();
			shortButton.addEventListener(Event.TRIGGERED, function():void
			{
				nameLength = "short";
				step3();
			});
			shortButton.styleNameList.add("light-button");
			shortButton.width = 200;
			shortButton.height = 50;
			shortButton.label = "Short Name";
			lengthGroup.addChild(shortButton);
			
			var longButton:Button = new Button();
			longButton.addEventListener(Event.TRIGGERED, function():void
			{
				nameLength = "long";
				step3();
			});
			longButton.styleNameList.add("light-button");
			longButton.width = 200;
			longButton.height = 50;
			longButton.label = "Long Name";
			lengthGroup.addChild(longButton);
			
			var lengthGroupFadeIn:Tween = new Tween(lengthGroup, 0.3);
			lengthGroupFadeIn.fadeTo(1);
			Starling.juggler.add(lengthGroupFadeIn);
		}
		
		private function step3():void
		{
			var lengthGroupFadeOut:Tween = new Tween(lengthGroup, 0.3);
			lengthGroupFadeOut.fadeTo(0);
			lengthGroupFadeOut.onComplete = function():void
			{
				removeChild(lengthGroup, true);
				title = "Name Rarity";
			};
			Starling.juggler.add(lengthGroupFadeOut);
			
			var layoutForRarityGroup:VerticalLayout = new VerticalLayout();;;
			layoutForRarityGroup.gap = 50;
			
			rarityGroup = new LayoutGroup();
			rarityGroup.alpha = 0;
			rarityGroup.layoutData = new AnchorLayoutData(NaN, NaN, NaN, NaN, 0, 0);
			rarityGroup.layout = layoutForRarityGroup;
			this.addChild(rarityGroup);
			
			var commonButton:Button = new Button();
			commonButton.addEventListener(Event.TRIGGERED, function():void
			{
				nameRarity = "common";
				step4();
			});
			commonButton.styleNameList.add("light-button");
			commonButton.width = 200;
			commonButton.height = 50;
			commonButton.label = "Common Name";
			rarityGroup.addChild(commonButton);
			
			var unCommonButton:Button = new Button();
			unCommonButton.addEventListener(Event.TRIGGERED, function():void
			{
				nameRarity = "uncommon";
				step4();
			});
			unCommonButton.styleNameList.add("light-button");
			unCommonButton.width = 200;
			unCommonButton.height = 50;
			unCommonButton.label = "Uncommon Name";
			rarityGroup.addChild(unCommonButton);
			
			var rarityGroupFadeIn:Tween = new Tween(rarityGroup, 0.3);
			rarityGroupFadeIn.fadeTo(1);
			Starling.juggler.add(rarityGroupFadeIn);
		}
			
		private function step4():void
		{
			var rarityGroupFadeOut:Tween = new Tween(rarityGroup, 0.3);
			rarityGroupFadeOut.fadeTo(0);
			rarityGroupFadeOut.onComplete = function():void
			{
				removeChild(lengthGroup, true);
				title = "Review Names";
				loadNames();						
			};
			Starling.juggler.add(rarityGroupFadeOut);
		}
		
		/*
			Once we get the user search preferences we prepare the query. This query searches over 1.8 M records so it takes a while.
			A clock image appears to let the user the app is working.
		*/
		
		private function loadNames():void
		{
			loadingGroup = new LayoutGroup();
			loadingGroup.alpha = 0;
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
			myStatement.addEventListener(SQLEvent.RESULT, namesLoaded);
						
			if(nameLength == "short" && nameRarity == "common"){
				myQuery = "SELECT name, sum(quantity) as count FROM names WHERE gender='"+gender+"' AND LENGTH(name)<6 GROUP BY name HAVING count>1000 ORDER BY RANDOM() LIMIT 10";	
			} 
			else if(nameLength == "short" && nameRarity == "uncommon"){
				myQuery = "SELECT name, sum(quantity) as count FROM names WHERE gender='"+gender+"' AND LENGTH(name)<6 GROUP BY name HAVING count<=1000 ORDER BY RANDOM() LIMIT 10";	
			}
			else if(nameLength == "long" && nameRarity == "common"){
				myQuery = "SELECT name, sum(quantity) as count FROM names WHERE gender='"+gender+"' AND LENGTH(name)>6 GROUP BY name HAVING count>=1001 ORDER BY RANDOM() LIMIT 10";	
			}
			else if(nameLength == "long" && nameRarity == "uncommon"){
				myQuery = "SELECT name, sum(quantity) as count FROM names WHERE gender='"+gender+"' AND LENGTH(name)>6 GROUP BY name HAVING count<=1000 ORDER BY RANDOM() LIMIT 10";	
			}
			else {
				//Do nothing
			}			
			
			myStatement.text = myQuery;
			
			var loadingGroupFadeIn:Tween = new Tween(loadingGroup, 0.3);
			loadingGroupFadeIn.fadeTo(1);
			loadingGroupFadeIn.onComplete = function():void
			{
				myStatement.execute();
			}
			Starling.juggler.add(loadingGroupFadeIn);			
		}
		
		private function namesLoaded(event:SQLEvent):void
		{
			myStatement.removeEventListener(SQLEvent.RESULT, namesLoaded);
			
			var loadingGroupFadeOut:Tween = new Tween(loadingGroup, 0.3);
			loadingGroupFadeOut.fadeTo(0);
			loadingGroupFadeOut.onComplete = function():void
			{
				removeChild(loadingGroup, true);
									
			};
			Starling.juggler.add(loadingGroupFadeOut);
						
			var result:SQLResult = myStatement.getResult();
			
			if(result.data != null)
			{
				var layoutForList:VerticalLayout = new VerticalLayout();
				layoutForList.hasVariableItemDimensions = true;
				
				//This is where the fun begins, you might want to theck the ItemRenderer code as well.
				
				namesList = new List();
				namesList.addEventListener("name-liked", addLiked);
				namesList.addEventListener("name-favorited", addFavorited);
				namesList.addEventListener("review-finished", reviewFinished);
				namesList.alpha = 0;
				namesList.verticalScrollPolicy = Scroller.SCROLL_POLICY_OFF;
				namesList.itemRendererType = CardItemRenderer;
				namesList.layout = layoutForList;
				namesList.typicalItem = {name:"Name", count:12345};
				namesList.layoutData = new AnchorLayoutData(0, 0, 0, 0, NaN, NaN);
				
				this.addChild(namesList);
				
				namesList.dataProvider = new ListCollection(result.data as Array);
				result = null;
				likedNames = new Array();
				
				var namesListFadeIn:Tween = new Tween(namesList, 0.3);
				namesListFadeIn.fadeTo(1);
				Starling.juggler.add(namesListFadeIn);
			}			
		}
		
		/*
			If you swipe right it gets added to the Liked list.
		*/
		
		private function addLiked(event:Event):void
		{
			likedNames.push(event.data);
		}
		
		/*
			If you press the heart buttton it also gets added to the Liked list.
			It will also add it to a persistent file for future review.
		*/
		
		private function addFavorited(event:Event):void
		{
			likedNames.push(event.data);
			FavoritesManager.addToFavorites(event.data);
		}
				
		/*
			Review game has finished, time to clean up and show results.
		*/
		
		private function reviewFinished():void
		{
			namesList.removeEventListener("name-liked", addLiked);
			namesList.removeEventListener("name-favorited", addFavorited);
			namesList.removeEventListener("review-finished", reviewFinished);
			namesList.dataProvider = null;
			this.removeChild(namesList, true);
			
			likedNamesList = new List();
			likedNamesList.addEventListener(Event.CHANGE, changeHandler);
			likedNamesList.alpha = 0;
			likedNamesList.layoutData = new AnchorLayoutData(0, 0, 0, 0, NaN, NaN);
			likedNamesList.dataProvider = new ListCollection(likedNames);
			likedNamesList.itemRendererFactory = function():DefaultListItemRenderer
			{
				var renderer:DefaultListItemRenderer = new DefaultListItemRenderer();
				renderer.isQuickHitAreaEnabled = true;
				renderer.labelFunction = function(item:Object):String
				{
					return item.name + "\n" + numberFormatter.formatInt(item.count) + " records";
				};
				
				return renderer;
			};
			this.addChild(likedNamesList);
			
			var likedNamesListFadeIn:Tween = new Tween(likedNamesList, 0.3);
			likedNamesListFadeIn.fadeTo(1);
			Starling.juggler.add(likedNamesListFadeIn);
			
		}
		
		/*
			Saving the selected item and index so when we go back from NameDetails the app will remember where we left.
		*/
		
		private function changeHandler(event:Event):void
		{
			_data.currentName = likedNamesList.selectedItem;
			_data.selectedIndex = likedNamesList.selectedIndex;
			_data.savedResults = likedNamesList.dataProvider;
			dispatchEventWith(GO_NAME_DETAILS);
		}
		
		/*
			Standard clean up when going back to the main menu.
		*/
		
		private function goBack():void
		{
			_data.savedResults = null;
			_data.selectedIndex = null;
			_data.currentName = null;
			
			this.dispatchEventWith(Event.COMPLETE);
		}
		
	}
}