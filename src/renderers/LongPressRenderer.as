package renderers
{
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.utils.touch.LongPress;
	
	public class LongPressRenderer extends DefaultListItemRenderer
	{
		private var _longPress:LongPress;
		
		public function LongPressRenderer()
		{
			super();
			this._longPress = new LongPress(this);
		}
	}
}