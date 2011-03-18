/*

Copyright (c) 2010 Tink Ltd - http://www.tink.ws

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
documentation files (the "Software"), to deal in the Software without restriction, including without limitation 
the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and
to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions
of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO 
THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, 
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

*/

package ws.tink.spark.controls
{
	import spark.components.supportClasses.ButtonBarBase;
	import spark.layouts.supportClasses.LayoutBase;
	
	import ws.tink.spark.controls.DataNavigator;
	import ws.tink.spark.layouts.AccordionLayout;
	import ws.tink.spark.layouts.supportClasses.INavigatorLayout;

	public class DataAccordion extends DataNavigator
	{
		
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Constructor. 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function DataAccordion()
		{
			super();
		}
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Skin Parts
		//
		//--------------------------------------------------------------------------
		
		[SkinPart(required="true")]
		
		/**
		 *  An optional skin part that defines the Group where the content 
		 *  children get pushed into and laid out.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public var buttonBar:ButtonBarBase;
		
		[SkinPart(required="true")]
		
		/**
		 *  An optional skin part that defines the Group where the content 
		 *  children get pushed into and laid out.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public var accordionLayout:AccordionLayout;
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  labelField
		//----------------------------------
		
		/**
		 *  @private
		 */
		private var _labelField:String = "label";
		
		/**
		 *  @private
		 */
		private var labelFieldOrFunctionChanged:Boolean; 
		
		/**
		 *  The name of the field in the data provider items to display 
		 *  as the label. 
		 *  The <code>labelFunction</code> property overrides this property.
		 *
		 *  @default "label" 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function get labelField():String
		{
			return _labelField;
		}
		
		/**
		 *  @private
		 */
		public function set labelField( value:String ):void
		{
			if( value == _labelField ) return 
				
				_labelField = value;
			if( buttonBar ) buttonBar.labelField = _labelField;
		}
		
		//----------------------------------
		//  labelFunction
		//----------------------------------
		
		/**
		 *  @private
		 */
		private var _labelFunction:Function; 
		
		/**
		 *  A user-supplied function to run on each item to determine its label.  
		 *  The <code>labelFunction</code> property overrides 
		 *  the <code>labelField</code> property.
		 *
		 *  <p>You can supply a <code>labelFunction</code> that finds the 
		 *  appropriate fields and returns a displayable string. The 
		 *  <code>labelFunction</code> is also good for handling formatting and 
		 *  localization. </p>
		 *
		 *  <p>The label function takes a single argument which is the item in 
		 *  the data provider and returns a String.</p>
		 *  <pre>
		 *  myLabelFunction(item:Object):String</pre>
		 *
		 *  @default null
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function get labelFunction():Function
		{
			return _labelFunction;
		}
		
		/**
		 *  @private
		 */
		public function set labelFunction( value:Function ):void
		{
			if( value == _labelFunction ) return; 
			
			_labelFunction = value;
			if( buttonBar ) buttonBar.labelFunction = _labelFunction;
		}
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Overridden Properties
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  layout
		//----------------------------------    
		
		/**
		 *  @private
		 */
		override public function set layout( value:LayoutBase ):void
		{
			throw( new Error( resourceManager.getString( "components", "layoutReadOnly" ) ) );
		}
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Overridden Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @inheritDoc
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded( partName, instance );
			
			switch( instance )
			{
				case buttonBar :
				{
					buttonBar.labelField = labelField;
					buttonBar.labelFunction = labelFunction;
					buttonBar.dataProvider = this;
					if( accordionLayout ) accordionLayout.buttonBar = buttonBar;
					break;
				}
				case accordionLayout :
				{
					if( buttonBar ) accordionLayout.buttonBar = buttonBar;
					break;
				}
			}
		}
		
		/**
		 *  @inheritDoc
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		override protected function partRemoved( partName:String, instance:Object ):void
		{
			super.partRemoved( partName, instance );
			
			switch( instance )
			{
				case buttonBar :
				{
					if( accordionLayout ) accordionLayout.buttonBar = null;
					break;
				}
			}
		}
	}
}