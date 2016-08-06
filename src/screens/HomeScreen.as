package screens
{
	
	import flash.system.System;
	
	import feathers.controls.Button;
	import feathers.controls.ImageLoader;
	import feathers.controls.Label;
	import feathers.controls.LayoutGroup;
	import feathers.controls.Screen;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	import feathers.layout.HorizontalLayout;
	
	import starling.events.Event;
	
	public class HomeScreen extends Screen
	{	
		
		public static const GO_ALL_NAMES:String = "goAllNames";
		public static const GO_TOP_100:String = "goTop100";
		public static const GO_DISCOVER:String = "goDiscover";
		public static const GO_FAVORITES:String = "goFavorites";
		
		override protected function initialize():void
		{
			
			this.layout = new AnchorLayout();
			
			var label1:Label = new Label();
			label1.styleNameList.add("big-label");
			label1.layoutData = new AnchorLayoutData(NaN, NaN, NaN, NaN, 0, -50);
			label1.text = "Names DB";
			this.addChild(label1);
			
			var layoutForMainGroup:HorizontalLayout = new HorizontalLayout();
			layoutForMainGroup.gap = 20;
			
			var mainGroup:LayoutGroup = new LayoutGroup();
			mainGroup.layout = layoutForMainGroup;
			mainGroup.layoutData = new AnchorLayoutData(NaN, NaN, NaN, NaN, 0, 50);
			this.addChild(mainGroup);
			
			var searchIcon:ImageLoader = new ImageLoader();
			searchIcon.source = "assets/icons/search.png";
			searchIcon.width = searchIcon.height = 35;
			
			var searchAllButton:Button = new Button();
			searchAllButton.addEventListener(Event.TRIGGERED, function():void
			{
				dispatchEventWith(GO_ALL_NAMES);
			});
			searchAllButton.styleNameList.add("home-button");
			searchAllButton.label = "Search";
			searchAllButton.defaultIcon = searchIcon;
			mainGroup.addChild(searchAllButton);
			
			var top100Icon:ImageLoader = new ImageLoader();
			top100Icon.source = "assets/icons/star.png";
			top100Icon.width = top100Icon.height = 35;
			
			var top100Button:Button = new Button();
			top100Button.addEventListener(Event.TRIGGERED, function():void
			{
				dispatchEventWith(GO_TOP_100);
			});
			top100Button.styleNameList.add("home-button");
			top100Button.defaultIcon = top100Icon;
			top100Button.label = "Top 100";
			mainGroup.addChild(top100Button);
			
			var discoverIcon:ImageLoader = new ImageLoader();
			discoverIcon.source = "assets/icons/face.png";
			discoverIcon.width = discoverIcon.height = 35;
			
			var discoverButton:Button = new Button();
			discoverButton.addEventListener(Event.TRIGGERED, function():void
			{
				dispatchEventWith(GO_DISCOVER);
			});
			discoverButton.styleNameList.add("home-button");
			discoverButton.label = "Discover";
			discoverButton.defaultIcon = discoverIcon;
			mainGroup.addChild(discoverButton);
			
			var heartIcon:ImageLoader = new ImageLoader();
			heartIcon.source = "assets/icons/heart.png";
			heartIcon.width = heartIcon.height = 35;
			
			var heartButton:Button = new Button();
			heartButton.addEventListener(Event.TRIGGERED, function():void
			{
				dispatchEventWith(GO_FAVORITES);
			});
			heartButton.styleNameList.add("home-button");
			heartButton.label = "Favorites";
			heartButton.defaultIcon = heartIcon;
			mainGroup.addChild(heartButton);
			
			System.gc();
		}
		
	}
}