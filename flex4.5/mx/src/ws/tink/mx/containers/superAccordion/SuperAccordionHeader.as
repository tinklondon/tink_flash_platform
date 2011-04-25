////////////////////////////////////////////////////////////////////////////////
//
//	Copyright (c) 2008 Tink Ltd | http://www.tink.ws
//	
//	Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
//	documentation files (the "Software"), to deal in the Software without restriction, including without limitation 
//	the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and
//	to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//	
//	The above copyright notice and this permission notice shall be included in all copies or substantial portions
//	of the Software.
//	
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO 
//	THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, 
//	TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//	SOFTWARE.
//
////////////////////////////////////////////////////////////////////////////////

package ws.tink.mx.containers.superAccordion
{

	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.containers.ViewStack;
	import mx.controls.Button;
	import mx.controls.ButtonBar;
	import mx.core.Container;
	import mx.core.IDataRenderer;
	import mx.core.mx_internal;
	import mx.events.ChildExistenceChangedEvent;
	
	import ws.tink.mx.containers.SuperAccordion;
	
	use namespace mx_internal;
	
	[AccessibilityClass(implementation="mx.accessibility.AccordionHeaderAccImpl")]
	
	/**
	 *  The AccordionHeader class defines the appearance of the navigation buttons
	 *  of an Accordion.
	 *  You use the <code>getHeaderAt()</code> method of the Accordion class to get a reference
	 *  to an individual AccordionHeader object.
	 *
	 *  @see mx.containers.Accordion
	 */
	public class SuperAccordionHeader extends ButtonBar implements IDataRenderer
	{
		private var _data					: Container;
		private var _selected				: Boolean = false;
		private var _selectedIndex			: int = 0;
		private var _prevDisplayIndex		: int;
		
		public function SuperAccordionHeader()
		{
			super();
			
			addEventListener( MouseEvent.MOUSE_OVER, onMouseOver );
			addEventListener( MouseEvent.MOUSE_OUT, onMouseOut );
		}

    	
		public function get selected():Boolean
		{
			return _selected;
		}
		public function set selected( value:Boolean ):void
		{
			if( value != _selected )
			{
				_selected = value;

				if( _selectedIndex < numChildren )
	    		{
	    			var button:Button = Button( getChildAt( _selectedIndex ) );
	    			button.selected = selected;
	    		}
	  		}
		}
		
		override public function get data():Object
		{
			return _data;
		}
		override public function set data( value:Object ):void
		{
			if( value != _data )
			{
				// Remove old listeners.
				if( _data is ViewStack )
				{
					_data.removeEventListener( ChildExistenceChangedEvent.CHILD_ADD, onViewStackChildAdd );
					_data.removeEventListener( ChildExistenceChangedEvent.CHILD_REMOVE, onViewStackChildRemove );
					_data.removeEventListener( Event.CHANGE, onViewStackChange );
					_data.removeEventListener( "labelChanged", onViewStackLabelChanged );
				}
				
				_data = Container( value );
				if( _data is ViewStack )
				{
					_data.addEventListener( ChildExistenceChangedEvent.CHILD_ADD, onViewStackChildAdd, false, 0, true );
					_data.addEventListener( ChildExistenceChangedEvent.CHILD_REMOVE, onViewStackChildRemove, false, 0, true );
					_data.addEventListener( Event.CHANGE, onViewStackChange, false, 0, true );
					_data.addEventListener( "labelChanged", onViewStackLabelChanged, false, 0, true );
				}
			}
			
			_data = Container( value );
			createButtons();
		}
		

    	override public function initialize():void
    	{
    		super.initialize();
    		
    		addEventListener( ChildExistenceChangedEvent.CHILD_ADD, onChildAdd, false, 0, true );
    	}
		override protected function clickHandler( event:MouseEvent ):void
    	{
    		super.clickHandler( event );
 
    		if( _data is ViewStack )
			{
				var button:Button = Button( event.currentTarget );
        		var index:int = getChildIndex( button );
				
				if( _selectedIndex != index )
				{
					Button( getChildAt( _selectedIndex ) ).selected = false;
							
					_selectedIndex = index;
					
					ViewStack( _data ).selectedIndex = _selectedIndex;
					
					if( !_selected )
					{
						dispatchEvent( new MouseEvent( MouseEvent.CLICK, false ) );
					}
					else
					{
						button.selected = true;
					}
				}
				else
				{
					dispatchEvent( new MouseEvent( MouseEvent.CLICK, false ) );
				}
			}
			else
			{
				dispatchEvent( new MouseEvent( MouseEvent.CLICK, false ) );
			}
    	}
    	
		private function createButtons():void
		{
			if( _data is ViewStack && _data.label.length == 0 )
			{
				/*var labels:Array = new Array();
				for( var i:int = 0; i < _data.numChildren; i++ )
				{
					labels.push( Container( _data.getChildAt( i ) ).label );
				}*/
				dataProvider = _data;
			}
			else
			{
				dataProvider = [ _data.label ];
			}
		}
		
		private function onViewStackLabelChanged( event:Event ):void
		{
			createButtons();
		}
		
		private function onViewStackChildAdd( event:ChildExistenceChangedEvent ):void
		{
			createButtons();
		}
		
		private function onViewStackChildRemove( event:ChildExistenceChangedEvent ):void
		{
			createButtons();
		}
		
		
		private function onViewStackChange( event:Event ):void
		{
			if( _data.label.length == 0 )
			{
				var newIndex:int = ViewStack( _data ).selectedIndex;
				
				if( _selectedIndex != newIndex && _selected )
				{
					if( _selected )
					{
						Button( getChildAt( _selectedIndex ) ).selected = false;
						Button( getChildAt( newIndex ) ).selected = true;
					}
					_selectedIndex = newIndex;
				}
			}
		}
		
		private function onChildAdd( event:ChildExistenceChangedEvent ):void
		{
			if( _selected )
			{
				Button( getChildAt( _selectedIndex ) ).selected = true;
			}
		}
		
		
		/**
		 *  @private
		 */
		private function onMouseOver( event:MouseEvent ):void
		{
			// The halo design specifies that accordion headers overlap
			// by a pixel when layed out. In order for the border to be
			// completely drawn on rollover, we need to set our index
			// here to bring this header to the front.
			var superAccordion:SuperAccordion = SuperAccordion( parent );
			_prevDisplayIndex = superAccordion.rawChildren.getChildIndex( this );
			if( superAccordion.enabled ) superAccordion.rawChildren.setChildIndex( this, superAccordion.rawChildren.numChildren - 1 );
		}
		
		private function onMouseOut( event:MouseEvent ):void
		{
			// The halo design specifies that accordion headers overlap
			// by a pixel when layed out. In order for the border to be
			// completely drawn on rollover, we need to set our index
			// here to bring this header to the front.
			var superAccordion:SuperAccordion = SuperAccordion( parent );
			if( superAccordion.enabled ) superAccordion.rawChildren.setChildIndex( this, _prevDisplayIndex );
		}
		
	}

}
