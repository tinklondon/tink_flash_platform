package ws.tink.spark.slides
{
	import flash.events.ContextMenuEvent;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	import flash.utils.getQualifiedClassName;
	
	import mx.core.ILayoutElement;
	import mx.core.IVisualElement;
	import mx.core.UIComponent;
	import mx.core.mx_internal;
	
	import spark.components.Group;
	import spark.components.Label;
	import spark.components.supportClasses.GroupBase;
	import spark.primitives.Rect;
	
	use namespace mx_internal;
	
	public class SlideGroup extends Group
	{
		
		private var _example:ContextMenu;
		
		public function SlideGroup()
		{
			super();
			
			var exampleContextMenu:ContextMenu = new ContextMenu();
			exampleContextMenu.hideBuiltInItems();
			
			var item:ContextMenuItem = new ContextMenuItem( "View Example Source" );
			item.addEventListener( ContextMenuEvent.MENU_ITEM_SELECT, onViewExampleSourceMenuItemSelect );
			exampleContextMenu.customItems.push( item );
			
			contextMenu = exampleContextMenu;
		}
		
		private function onViewExampleSourceMenuItemSelect( event:ContextMenuEvent ):void
		{
			var element:IVisualElement;
			var rectangle:Rectangle
			var numItems:int = numElements;
			for( var i:int = 0; i < numItems; i++ )
			{
				element = getElementAt( i );
				rectangle = new Rectangle( element.x, element.y, element.getLayoutBoundsWidth(), element.getLayoutBoundsHeight() );
				if( rectangle.contains( element.parent.mouseX, element.parent.mouseY ) )
				{
					var name:String = getQualifiedClassName( element );
					if( name.indexOf( "examples::" ) == -1 ) name = getExampleElement( element );
					navigateToURL( new URLRequest( "srcview/source/" + name.split( "::" ).join( "/" ) + ".mxml.html" ), "_blank" );
					break;
				}
			}
		}
		
		private function getExampleElement( element:ILayoutElement ):String
		{
			if( element is GroupBase )
			{
				var name:String;
				var g:GroupBase = GroupBase( element );
				var numItems:int = g.numElements;
				for( var i:int = 0; i < numItems; i++ )
				{
					name = getQualifiedClassName( g.getElementAt( i ) );
					if( name.indexOf( "examples::" ) != -1 ) return name;
				}
			}
			
			return null;
		}
		
		override protected function updateDisplayList( unscaledWidth:Number, unscaledHeight:Number ):void
		{
			super.updateDisplayList( unscaledWidth, unscaledHeight );
			
			graphics.clear();
			graphics.beginFill( getStyle( "backgroundColor" ), 0.3 );
			
			var element:IVisualElement;
			var numItems:int = numElements;
			for( var i:int = 0; i < numItems; i++ )
			{
				element = getElementAt( i );
				graphics.drawRect( element.x, element.y, element.getLayoutBoundsWidth(), element.getLayoutBoundsHeight() );
			}
			
			graphics.endFill();
		}
		
		
	}
}