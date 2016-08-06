package
{
	import feathers.controls.StackScreenNavigator;
	import feathers.controls.StackScreenNavigatorItem;
	import feathers.motion.Fade;
	
	import screens.AllNamesScreen;
	import screens.DiscoverScreen;
	import screens.FavoritesScreen;
	import screens.HomeScreen;
	import screens.NameDetailsScreen;
	import screens.Top100Screen;
	
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class Main extends Sprite
	{
		private var myNavigator:StackScreenNavigator;

		private static const HOME_SCREEN:String = "homeScreen";
		private static const ALL_NAMES_SCREEN:String = "allNamesScreen";
		private static const TOP_100_SCREEN:String = "goTop100Screen";
		private static const DISCOVER_SCREEN:String = "discoverScreen";
		private static const FAVORITES_SCREEN:String = "favoritesScreen";
		private static const NAME_DETAILS_SCREEN:String = "nameDetailsScreen";
		
		public function Main()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		protected function addedToStageHandler(event:Event):void
		{			
			this.removeEventListener(starling.events.Event.ADDED_TO_STAGE, addedToStageHandler);
				
			new CustomTheme();
			
			var NAVIGATOR_DATA:NavigatorData = new NavigatorData();
			
			myNavigator = new StackScreenNavigator();
			myNavigator.pushTransition = Fade.createFadeOutTransition();
			myNavigator.popTransition = Fade.createFadeOutTransition();
			addChild(myNavigator);
			
			var homeScreenItem:StackScreenNavigatorItem = new StackScreenNavigatorItem(HomeScreen);
			homeScreenItem.setScreenIDForPushEvent(HomeScreen.GO_ALL_NAMES, ALL_NAMES_SCREEN);
			homeScreenItem.setScreenIDForPushEvent(HomeScreen.GO_TOP_100, TOP_100_SCREEN);
			homeScreenItem.setScreenIDForPushEvent(HomeScreen.GO_DISCOVER, DISCOVER_SCREEN)
			homeScreenItem.setScreenIDForPushEvent(HomeScreen.GO_FAVORITES, FAVORITES_SCREEN);;
			myNavigator.addScreen(HOME_SCREEN, homeScreenItem);
			
			var allnamesScreenItem:StackScreenNavigatorItem = new StackScreenNavigatorItem(AllNamesScreen);
			allnamesScreenItem.properties.data = NAVIGATOR_DATA;
			allnamesScreenItem.addPopEvent(Event.COMPLETE);
			allnamesScreenItem.setScreenIDForPushEvent(AllNamesScreen.GO_NAME_DETAILS, NAME_DETAILS_SCREEN);
			myNavigator.addScreen(ALL_NAMES_SCREEN, allnamesScreenItem);
			
			var top100ScreenItem:StackScreenNavigatorItem = new StackScreenNavigatorItem(Top100Screen);
			top100ScreenItem.properties.data = NAVIGATOR_DATA;
			top100ScreenItem.addPopEvent(Event.COMPLETE);
			top100ScreenItem.setScreenIDForPushEvent(Top100Screen.GO_NAME_DETAILS, NAME_DETAILS_SCREEN);		
			myNavigator.addScreen(TOP_100_SCREEN, top100ScreenItem);
			
			var discoverScreenItem:StackScreenNavigatorItem = new StackScreenNavigatorItem(DiscoverScreen);
			discoverScreenItem.properties.data = NAVIGATOR_DATA;
			discoverScreenItem.addPopEvent(Event.COMPLETE);
			discoverScreenItem.setScreenIDForPushEvent(DiscoverScreen.GO_NAME_DETAILS, NAME_DETAILS_SCREEN);
			myNavigator.addScreen(DISCOVER_SCREEN, discoverScreenItem);
			
			var favoritesScreenItem:StackScreenNavigatorItem = new StackScreenNavigatorItem(FavoritesScreen);
			favoritesScreenItem.properties.data = NAVIGATOR_DATA;
			favoritesScreenItem.addPopEvent(Event.COMPLETE);
			favoritesScreenItem.setScreenIDForPushEvent(FavoritesScreen.GO_NAME_DETAILS, NAME_DETAILS_SCREEN);
			myNavigator.addScreen(FAVORITES_SCREEN, favoritesScreenItem);
			
			var nameDetailsScreenItem:StackScreenNavigatorItem = new StackScreenNavigatorItem(NameDetailsScreen);
			nameDetailsScreenItem.properties.data = NAVIGATOR_DATA;
			nameDetailsScreenItem.addPopEvent(Event.COMPLETE);
			myNavigator.addScreen(NAME_DETAILS_SCREEN, nameDetailsScreenItem);
			
			myNavigator.rootScreenID = HOME_SCREEN;

		}
		
		
	}
}