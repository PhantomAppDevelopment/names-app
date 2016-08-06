package
{
	
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.engine.ElementFormat;
	import flash.text.engine.FontDescription;
	import flash.text.engine.FontLookup;
	
	import feathers.controls.Alert;
	import feathers.controls.Button;
	import feathers.controls.ButtonGroup;
	import feathers.controls.Header;
	import feathers.controls.ImageLoader;
	import feathers.controls.Label;
	import feathers.controls.List;
	import feathers.controls.PanelScreen;
	import feathers.controls.Screen;
	import feathers.controls.Scroller;
	import feathers.controls.SpinnerList;
	import feathers.controls.TabBar;
	import feathers.controls.TextInput;
	import feathers.controls.ToggleButton;
	import feathers.controls.renderers.BaseDefaultItemRenderer;
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.controls.text.StageTextTextEditor;
	import feathers.controls.text.TextBlockTextRenderer;
	import feathers.controls.text.TextFieldTextRenderer;
	import feathers.core.FeathersControl;
	import feathers.core.ITextEditor;
	import feathers.core.ITextRenderer;
	import feathers.layout.HorizontalAlign;
	import feathers.themes.StyleNameFunctionTheme;
	
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.textures.Texture;
	import starling.textures.TextureSmoothing;
	
	public class CustomTheme extends StyleNameFunctionTheme
	{
		
		private var railwayFont:FontDescription;
		
		public function CustomTheme()
		{
			super();			
			this.initialize();
		}
		
		private function initialize():void
		{
			Alert.overlayFactory = function():DisplayObject
			{
				var quad:Quad = new Quad(3, 3, 0x000000);
				quad.alpha = 0.50;
				return quad;
			};
			
			railwayFont = new FontDescription("MyFont");
			railwayFont.fontLookup = FontLookup.EMBEDDED_CFF;
						
			this.initializeGlobals();
			this.initializeStyleProviders();	
		}
		
		private function initializeGlobals():void
		{
			FeathersControl.defaultTextRendererFactory = function():ITextRenderer
			{
				return new TextBlockTextRenderer();
			}
			
			FeathersControl.defaultTextEditorFactory = function():ITextEditor
			{
				return new StageTextTextEditor();
			}
		}
		
		private function initializeStyleProviders():void
		{
			this.getStyleProviderForClass(Button).setFunctionForStyleName("alert-button", setAlertButtonStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName("back-button", setBackButtonStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName("header-button", setHeaderButtonStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName("home-button", setHomeButtonStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName("light-button", setLightButtonStyles);
			this.getStyleProviderForClass(Label).setFunctionForStyleName("medium-label", setMediumLabelStyles);
			this.getStyleProviderForClass(Label).setFunctionForStyleName("big-label", setBigLabelStyles);
			this.getStyleProviderForClass(Label).setFunctionForStyleName("summary-style", setSummaryStyles);
			this.getStyleProviderForClass(ToggleButton).setFunctionForStyleName("custom-tab", setTabStyles);
			
			this.getStyleProviderForClass(Alert).defaultStyleFunction = this.setAlertStyles;
			this.getStyleProviderForClass(DefaultListItemRenderer).defaultStyleFunction = this.setDefaultListItemRendererStyles;
			this.getStyleProviderForClass(Header).defaultStyleFunction = this.setHeaderStyles;
			this.getStyleProviderForClass(Label).defaultStyleFunction = this.setLabelStyles;
			this.getStyleProviderForClass(List).defaultStyleFunction = this.setListStyles;
			this.getStyleProviderForClass(PanelScreen).defaultStyleFunction = this.setPanelScreenStyles;
			this.getStyleProviderForClass(Screen).defaultStyleFunction = this.setScreenStyles;
			this.getStyleProviderForClass(SpinnerList).defaultStyleFunction = this.setSpinnerListStyles;
			this.getStyleProviderForClass(TabBar).defaultStyleFunction = this.setTabBarStyles;
			this.getStyleProviderForClass(TextInput).defaultStyleFunction = this.setTextInputStyles;
		}
		
		[Embed(source="assets/fonts/raleway.ttf", fontFamily="MyFont", fontWeight="normal", fontStyle="normal", mimeType="application/x-font", embedAsCFF="true")]
		private static const MY_FONT:Class;
		
		[Embed(source="assets/fonts/raleway.ttf", fontFamily="MyFont2", fontWeight="normal", fontStyle="normal", mimeType="application/x-font", embedAsCFF="false")]
		private static const MY_FONT2:Class;

		//This is usually bad practice, I'm just embedding what's strictly necessary for a fluent UX
		[Embed(source="assets/icons/square.png")] private static const squareAsset:Class;
		[Embed(source="assets/icons/line.png")] private static const lineAsset:Class;
		[Embed(source="assets/icons/clock.png")] public static const clockAsset:Class;

		
		//-------------------------
		// Alert
		//-------------------------
		
		private function setAlertStyles(alert:Alert):void
		{
			var quad:Quad = new Quad(3, 3);
			quad.setVertexColor(0, 0x443941);
			quad.setVertexColor(1, 0x443941);
			quad.setVertexColor(2, 0xAF8B95);
			quad.setVertexColor(3, 0xAF8B95);
			
			alert.backgroundSkin = quad;
			alert.maxWidth = 250;
			alert.minHeight = 50;
			alert.padding = 10;
					
			alert.headerProperties.paddingLeft = 10;
			alert.headerProperties.gap = 10;
			alert.headerProperties.titleAlign = Header.TITLE_ALIGN_PREFER_LEFT;
			
			alert.messageFactory = function():ITextRenderer
			{
				var renderer:TextBlockTextRenderer = new TextBlockTextRenderer();
				renderer.elementFormat = new ElementFormat(railwayFont, 16, 0xFFFFFF);
				renderer.leading = 7;
				renderer.wordWrap = true;
				return renderer;
			};
			
			alert.buttonGroupFactory = function():ButtonGroup
			{
				var group:ButtonGroup = new ButtonGroup();
				group.customButtonStyleName = "alert-button";
				group.direction = ButtonGroup.DIRECTION_HORIZONTAL;
				group.gap = 10;
				group.padding = 10;
				return group;
			}			
		}		
		
		//-------------------------
		// Button
		//-------------------------
				
		private function setAlertButtonStyles(button:Button):void
		{
			
			button.height = 40;
			button.defaultSkin =  new Quad(40, 40, 0x443941);
			button.downSkin = new Quad(40, 40, 0x211B1F);
			button.labelFactory = function():ITextRenderer
			{
				var renderer:TextBlockTextRenderer = new TextBlockTextRenderer();
				renderer.elementFormat = new ElementFormat(railwayFont, 16 , 0xFFFFFF);
				return renderer;
			}
		}
		
		private function setBackButtonStyles(button:Button):void
		{
			var transparentQuad:Quad = new Quad(3, 3, 0xFFFFFF);
			transparentQuad.alpha = 0.20;
			
			var arrowIcon:ImageLoader = new ImageLoader();
			arrowIcon.width = arrowIcon.height = 25;
			arrowIcon.source = "assets/icons/back-arrow.png";
			
			button.width = button.height = 45;
			button.defaultIcon = arrowIcon;
			button.downSkin = transparentQuad;
		}
		
		private function setHeaderButtonStyles(button:Button):void
		{
			var transparentQuad:Quad = new Quad(3, 3, 0xFFFFFF);
			transparentQuad.alpha = 0.20;
			
			button.width = button.height = 45;
			button.downSkin = transparentQuad;
		}
		
		private function setHomeButtonStyles(button:Button):void
		{
			button.gap = 10;
			button.iconPosition = Button.ICON_POSITION_TOP;
			button.labelFactory = function():ITextRenderer
			{								
				var renderer:TextBlockTextRenderer = new TextBlockTextRenderer();
				renderer.elementFormat = new ElementFormat(railwayFont, 14, 0xFFFFFF);
				return renderer;				
			}
		}
		
		private function setLightButtonStyles(button:Button):void
		{
			var background:Image = new Image(Texture.fromEmbeddedAsset(squareAsset));
			background.pixelSnapping = true;
			background.textureSmoothing = TextureSmoothing.TRILINEAR;
			background.scale9Grid = new Rectangle(24, 24, 2, 2);
						
			button.defaultSkin = background;
			
			var downSkin:Quad = new Quad(3, 3, 0xFFFFFF);
			downSkin.alpha = 0.25;
			
			button.downSkin = downSkin;
			
			button.labelFactory = function():ITextRenderer
			{
				var renderer:TextBlockTextRenderer = new TextBlockTextRenderer();
				renderer.elementFormat = new ElementFormat(railwayFont, 16 , 0xFFFFFF);
				return renderer;
			}
		}
		
		//-------------------------
		// Header
		//-------------------------
		
		private function setHeaderStyles(header:Header):void
		{
			var quad:Quad = new Quad(3, 50, 0x443941);
			
			header.backgroundSkin = quad;
			header.titleAlign = Header.TITLE_ALIGN_PREFER_LEFT;
			header.gap = 10;
			
			header.titleFactory = function():ITextRenderer
			{
				var renderer:TextBlockTextRenderer = new TextBlockTextRenderer();
				renderer.elementFormat = new ElementFormat(railwayFont, 16, 0xFFFFFF);
				return renderer;
			}		
		}
		
		//-------------------------
		// Label
		//-------------------------
		
		private function setLabelStyles(label:Label):void
		{
			label.textRendererFactory = function():ITextRenderer
			{				
				var renderer:TextBlockTextRenderer = new TextBlockTextRenderer();
				renderer.elementFormat = new ElementFormat(railwayFont, 16, 0xFFFFFF);
				renderer.wordWrap = true;
				return renderer;
			}		
		}
		
		private function setMediumLabelStyles(label:Label):void
		{			
			label.textRendererFactory = function():ITextRenderer
			{				
				var renderer:TextBlockTextRenderer = new TextBlockTextRenderer();
				renderer.elementFormat = new ElementFormat(railwayFont, 24, 0xFFFFFF);
				return renderer;
			}
		}
		
		private function setBigLabelStyles(label:Label):void
		{
			label.textRendererFactory = function():ITextRenderer
			{				
				var renderer:TextBlockTextRenderer = new TextBlockTextRenderer();
				renderer.elementFormat = new ElementFormat(railwayFont, 48, 0xFFFFFF);
				return renderer;
			}
		}
		
		private function setSummaryStyles(label:Label):void
		{
			label.textRendererFactory = function():ITextRenderer
			{				
				var renderer:TextFieldTextRenderer = new TextFieldTextRenderer();				
				
				var format:TextFormat = new TextFormat("MyFont2", 16, 0xFFFFFF);
				format.leading = 7;
				
				renderer.textFormat = format;
				renderer.embedFonts = true;
				renderer.isHTML = true;
				return renderer;
			}
		}
		
		//-------------------------
		// List
		//-------------------------
		
		private function setListStyles(list:List):void
		{
			list.scrollBarDisplayMode = Scroller.SCROLL_BAR_DISPLAY_MODE_NONE;
			list.hasElasticEdges = false;
		}
		
		private function setDefaultListItemRendererStyles(renderer:DefaultListItemRenderer):void
		{			
			var background:Image = new Image(Texture.fromEmbeddedAsset(lineAsset));
			background.pixelSnapping = true;
			background.textureSmoothing = TextureSmoothing.TRILINEAR;
			background.scale9Grid = new Rectangle(2, 0, 3, 50);
			
			renderer.defaultSkin = background;
					
			var downSkin:Quad = new Quad(3, 3, 0xFFFFFF);
			downSkin.alpha = 0.25;
			
			renderer.downSkin = downSkin;
			renderer.defaultSelectedSkin = downSkin;
			
			renderer.horizontalAlign = Button.HORIZONTAL_ALIGN_LEFT;
			renderer.paddingLeft = 10;
			renderer.paddingRight = 10;
			renderer.paddingTop = 10;
			renderer.paddingBottom = 15;
			renderer.minHeight = 50;
			renderer.gap = 10;
			renderer.accessoryGap = Number.POSITIVE_INFINITY;
			renderer.iconPosition = Button.ICON_POSITION_LEFT;
			renderer.accessoryPosition = BaseDefaultItemRenderer.ACCESSORY_POSITION_RIGHT;
			
			renderer.labelFactory = function():ITextRenderer
			{
				var renderer:TextBlockTextRenderer = new TextBlockTextRenderer();
				renderer.elementFormat = new ElementFormat(railwayFont, 16, 0xFFFFFF);				
				return renderer;								
			};
			
			renderer.iconLabelFactory = function():ITextRenderer
			{
				var renderer:TextBlockTextRenderer = new TextBlockTextRenderer();
				renderer.elementFormat = new ElementFormat(railwayFont, 20, 0xFFFFFF);				
				return renderer;								
			};				
		}		
		
		//-------------------------
		// PanelScreen
		//-------------------------
		
		private function setPanelScreenStyles(screen:PanelScreen):void
		{
			var quad:Quad = new Quad(3, 3);
			quad.setVertexColor(0, 0x443941);
			quad.setVertexColor(1, 0x443941);
			quad.setVertexColor(2, 0xAF8B95);
			quad.setVertexColor(3, 0xAF8B95);
			
			screen.backgroundSkin = quad;
			screen.hasElasticEdges = false;
			screen.scrollBarDisplayMode = Scroller.SCROLL_BAR_DISPLAY_MODE_NONE;
		}
		
		//-------------------------
		// Screen
		//-------------------------
		
		private function setScreenStyles(screen:Screen):void
		{
			var quad:Quad = new Quad(3, 3);
			quad.setVertexColor(0, 0x443941);
			quad.setVertexColor(1, 0x443941);
			quad.setVertexColor(2, 0xAF8B95);
			quad.setVertexColor(3, 0xAF8B95);
			
			screen.backgroundSkin = quad;
		}
		
		//-------------------------
		// SpinnerList
		//-------------------------
		
		private function setSpinnerListStyles(spinnerList:SpinnerList):void
		{
			var overlay:Quad = new Quad(3, 3, 0xCCCCCC);
			overlay.alpha = 0.3;
			
			spinnerList.selectionOverlaySkin = overlay;			
			spinnerList.backgroundSkin = new Quad(3, 3, 0xFFFFFF);
			
		}
		
		//-------------------------
		// TabBar
		//-------------------------
		
		private function setTabBarStyles(tabBar:TabBar):void
		{
			tabBar.customTabStyleName = "custom-tab";
		}
		
		private function setTabStyles(tab:ToggleButton):void
		{
			
			var skin1:Quad = new Quad(3, 50);
			skin1.setVertexColor(0, 0x443941);
			skin1.setVertexColor(1, 0x443941);
			skin1.setVertexColor(2, 0x1B161A);
			skin1.setVertexColor(3, 0x1B161A);
			
			var skin2:Quad = new Quad(3, 50);
			skin2.setVertexColor(0, 0x705D6B);
			skin2.setVertexColor(1, 0x705D6B);
			skin2.setVertexColor(2, 0x443941);
			skin2.setVertexColor(3, 0x443941);
						
			tab.defaultSkin = skin2;
			tab.downSkin = skin1;
			tab.selectedDownSkin = skin1;
			tab.defaultSelectedSkin = skin1;
		}
		
		//-------------------------
		// TextInput
		//-------------------------
		
		private function setTextInputStyles(textInput:TextInput):void
		{			
			var background:Image = new Image(Texture.fromEmbeddedAsset(lineAsset));
			background.pixelSnapping = true;
			background.textureSmoothing = TextureSmoothing.TRILINEAR;
			background.scale9Grid = new Rectangle(2, 0, 3, 50);
			
			textInput.backgroundSkin = background;
						
			textInput.textEditorFactory = function():ITextEditor
			{
				var editor:StageTextTextEditor = new StageTextTextEditor();
				editor.fontSize = 20;
				editor.color = 0xFFFFFF;
				return editor;
			}
			
			textInput.promptFactory	= function():ITextRenderer
			{
				var renderer:TextBlockTextRenderer = new TextBlockTextRenderer();
				renderer.elementFormat = new ElementFormat(railwayFont, 20, 0xCCCCCC);
				return renderer;
			}	
		}
		
	}		
}