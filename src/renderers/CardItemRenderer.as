package renderers
{	
	import flash.globalization.NumberFormatter;
	
	import feathers.controls.Button;
	import feathers.controls.ImageLoader;
	import feathers.controls.Label;
	import feathers.controls.LayoutGroup;
	import feathers.controls.ScrollContainer;
	import feathers.controls.Scroller;
	import feathers.controls.renderers.LayoutGroupListItemRenderer;
	import feathers.events.FeathersEventType;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	import feathers.layout.HorizontalLayout;
	
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Quad;
	import starling.events.Event;
	import starling.events.ResizeEvent;
	
	public class CardItemRenderer extends LayoutGroupListItemRenderer
	{	
		protected static var FIXED_HEIGHT:Number;
		protected var numberFormatter:NumberFormatter;
		
		protected var _scrollerContainer:ScrollContainer;
		protected var _leftContent:LayoutGroup;
		protected var _middleContent:LayoutGroup;
		protected var _rightContent:LayoutGroup;
		
		protected var _label1:Label;
		protected var _label2:Label;
		protected var _heartButton:Button;		
		
		public function CardItemRenderer()
		{			
			super();			
		}
		
		override protected function initialize():void
		{	
			FIXED_HEIGHT = stage.stageHeight-50;
			numberFormatter = new NumberFormatter("en-US");
			
			var transparentSkin:Quad = new Quad(3, 3, 0xFFFFFF);
			transparentSkin.alpha = 0;
			
			var blackSkin:Quad = new Quad(3, 3, 0x000000);
			blackSkin.alpha = 0.50;
			
			this._scrollerContainer = new ScrollContainer();
			this._scrollerContainer.scrollBarDisplayMode = Scroller.SCROLL_BAR_DISPLAY_MODE_NONE;
			this._scrollerContainer.layout = new HorizontalLayout();
			this._scrollerContainer.hasElasticEdges = false;
			this._scrollerContainer.decelerationRate = 0.3;
			this.addChild(_scrollerContainer);
			
			this._leftContent = new LayoutGroup();
			this._leftContent.height = FIXED_HEIGHT;
			this._leftContent.layout = new AnchorLayout();
			this._leftContent.backgroundSkin = transparentSkin;
			this._scrollerContainer.addChild(this._leftContent);
			
			this._middleContent = new LayoutGroup();
			this._middleContent.height = FIXED_HEIGHT;
			this._middleContent.layout = new AnchorLayout();
			this._middleContent.backgroundSkin = blackSkin;
			this._scrollerContainer.addChild(this._middleContent);
			
			this._rightContent = new LayoutGroup();
			this._rightContent.height = FIXED_HEIGHT;
			this._rightContent.layout = new AnchorLayout();
			this._rightContent.backgroundSkin = transparentSkin
			this._scrollerContainer.addChild(this._rightContent);
			
			this._label1 = new Label();
			this._label1.styleNameList.add("big-label");
			this._label1.layoutData = new AnchorLayoutData(NaN, NaN, NaN, NaN, 0, -50);
			this._middleContent.addChild(this._label1);
			
			this._label2 = new Label();
			this._label2.styleNameList.add("medium-label");
			this._label2.layoutData = new AnchorLayoutData(NaN, NaN, NaN, NaN, 0, 0);
			this._middleContent.addChild(this._label2);
			
			var heartIcon:ImageLoader = new ImageLoader();
			heartIcon.source = "assets/icons/heart.png";
			heartIcon.width = heartIcon.height = 40;
			
			this._heartButton = new Button();
			this._heartButton.addEventListener(Event.TRIGGERED, function():void
			{
				var bubblingEvent:Event = new Event("name-favorited", true, _data);
				dispatchEvent(bubblingEvent);
				
				disposeRenderer();
			});				
			this._heartButton.defaultIcon = heartIcon;
			this._heartButton.layoutData = new AnchorLayoutData(NaN, NaN, NaN, NaN, 0, 50);
			this._middleContent.addChild(this._heartButton);
		}
		
		override protected function commitData():void
		{
			if(this._data && this._owner)
			{
				this.alpha = 1.0;
				this.scaleY = 1;				
				
				this._scrollerContainer.scrollToPosition(0, this.owner.width, 0);
				this._scrollerContainer.snapToPages = true;
				
				this._label1.text = this._data.name;
				this._label2.text = String(numberFormatter.formatInt(this._data.count)) + " records";
				
				this._scrollerContainer.addEventListener(FeathersEventType.BEGIN_INTERACTION, startDrag);
				this._scrollerContainer.addEventListener(FeathersEventType.END_INTERACTION, stopDrag);
				
				stage.addEventListener(ResizeEvent.RESIZE, reSize);
			} else {
				this._label1.text = "";
				this._label2.text = "";
			}
		}
		
		override protected function postLayout():void
		{			
			this._scrollerContainer.width = this.owner.width;
			this._scrollerContainer.pageWidth = this.owner.width;
			
			this._leftContent.width = this.owner.width;
			this._middleContent.width = this.owner.width;
			this._rightContent.width = this.owner.width;
			
			this._scrollerContainer.scrollToPageIndex(1, 0, 0);
			this._scrollerContainer.snapToPages = true;
		}
		
		protected function reSize(event:ResizeEvent):void
		{
			this._scrollerContainer.removeEventListener(Event.SCROLL, scrollingHandler);
						
			var newHeight:Number = (event.height/Starling.contentScaleFactor)-50;
			
			this.height = newHeight;
			this._scrollerContainer.height = newHeight	
			this._leftContent.height = newHeight
			this._middleContent.height = newHeight
			this._rightContent.height = newHeight

			var newWidth:Number = event.width/Starling.contentScaleFactor;
				
			this.width = newWidth;
			this._scrollerContainer.width = newWidth;
			this._scrollerContainer.pageWidth = newWidth;
			
			this._leftContent.width = newWidth;
			this._middleContent.width = newWidth;
			this._rightContent.width = newWidth;
			
			this._scrollerContainer.scrollToPosition(0, newWidth, 0);
			this._scrollerContainer.snapToPages = true;
		}
		
		protected function startDrag(event:Event):void
		{
			this._scrollerContainer.addEventListener(Event.SCROLL, scrollingHandler);
			this.owner.selectedIndex = owner.dataProvider.getItemIndex(data);
		}		
		
		protected function stopDrag(event:Event):void
		{
			if(this.owner.selectedIndex == owner.dataProvider.getItemIndex(data)){
				if(this._scrollerContainer.horizontalScrollPosition <= 40)
				{
					event.stopImmediatePropagation();
					this._scrollerContainer.removeEventListener(Event.SCROLL, scrollingHandler);
					
					var bubblingEvent:Event = new Event("name-liked", true, _data);
					dispatchEvent(bubblingEvent);
					
					disposeRenderer();
				}
				
				if (this._scrollerContainer.horizontalScrollPosition >= this._scrollerContainer.maxHorizontalScrollPosition-40) {
					event.stopImmediatePropagation();
					this._scrollerContainer.removeEventListener(Event.SCROLL, scrollingHandler);
					disposeRenderer();
				}	
			}			
		}
		
		protected function scrollingHandler(event:Event):void
		{			
			if(this.owner.selectedIndex == owner.dataProvider.getItemIndex(data)){
				if(this._scrollerContainer.horizontalScrollPosition <= 40)
				{
					event.stopImmediatePropagation();
					this._scrollerContainer.removeEventListener(Event.SCROLL, scrollingHandler);
					
					var bubblingEvent:Event = new Event("name-liked", true, _data);
					dispatchEvent(bubblingEvent);
					
					disposeRenderer();
				}
				
				if (this._scrollerContainer.horizontalScrollPosition >= this._scrollerContainer.maxHorizontalScrollPosition-40) {
					event.stopImmediatePropagation();
					this._scrollerContainer.removeEventListener(Event.SCROLL, scrollingHandler);
					disposeRenderer();
				}	
			}
		}
		
		protected function disposeRenderer():void
		{
			this._scrollerContainer.snapToPages = false;
			
			var tween:Tween = new Tween(this, 0.3);
			tween.animate("scaleY", 0);
			tween.fadeTo(0);
			tween.onComplete = function():void
			{					
				Starling.juggler.remove(tween);
				_scrollerContainer.horizontalScrollPosition = 0;
				_label1.text = "";
				_label2.text = "";

				if(_owner.dataProvider.length <= 1)
				{
					var bubblingEvent:Event = new Event("review-finished", true);
					dispatchEvent(bubblingEvent);
					bubblingEvent.stopImmediatePropagation();
				} else {
					_owner.dataProvider.removeItemAt(_owner.dataProvider.getItemIndex(data));					
				}
			};
			Starling.juggler.add(tween);	
		}
		
	}
}