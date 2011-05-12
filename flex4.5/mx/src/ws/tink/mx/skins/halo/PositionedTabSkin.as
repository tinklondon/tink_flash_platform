////////////////////////////////////////////////////////////////////////////////
//
//	Copyright (c) 2007 Tink Ltd | http://www.tink.ws
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

package ws.tink.mx.skins.halo
{
	
	import flash.display.DisplayObjectContainer;
	import flash.display.GradientType;
	import flash.geom.Rectangle;
	
	import mx.core.EdgeMetrics;
	import mx.core.IFlexModuleFactory;
	import mx.core.UIComponent;
	import mx.skins.Border;
	import mx.skins.halo.HaloColors;
	import mx.styles.IStyleClient;
	import mx.styles.StyleManager;
	import mx.utils.ColorUtil;
	
	import ws.tink.mx.containers.PositionedTabNavigator;
	
	/**
	 *  The skin for all the states of a PositionedTab in a PositionedTabNavigator or PositionedTabBar.
	 */
	public class PositionedTabSkin extends Border
	{


		//--------------------------------------------------------------------------
		//
		//  Class variables
		//
		//--------------------------------------------------------------------------
	
		/**
		 *  @private
		 */
		private static var cache:Object = {};
	
		//--------------------------------------------------------------------------
		//
		//  Class methods
		//
		//--------------------------------------------------------------------------
	
		/**
		 *  @private
		 *  Several colors used for drawing are calculated from the base colors
		 *  of the component (themeColor, borderColor and fillColors).
		 *  Since these calculations can be a bit expensive,
		 *  we calculate once per color set and cache the results.
		 */
		private static function calcDerivedStyles(themeColor:uint,
												  borderColor:uint,
												  falseFillColor0:uint,
												  falseFillColor1:uint,
												  fillColor0:uint,
												  fillColor1:uint):Object
		{
			var key:String = HaloColors.getCacheKey(themeColor, borderColor,
													falseFillColor0,
													falseFillColor1,
													fillColor0, fillColor1);
			
			if (!cache[key])
			{
				var o:Object = cache[key] = {};
	
				// Cross-component styles.
				HaloColors.addHaloColors(o, themeColor, fillColor0, fillColor1);
				
				// Tab-specific styles.
				o.borderColorDrk1 =
					ColorUtil.adjustBrightness2(borderColor, 10);
				o.falseFillColorBright1 =
					ColorUtil.adjustBrightness(falseFillColor0, 15);
				o.falseFillColorBright2 =
					ColorUtil.adjustBrightness(falseFillColor1, 15);
			}
			
			return cache[key];
		}
	
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
	
		/**
		 *  Constructor.
		 */
		public function PositionedTabSkin()
		{
			super();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridden properties
		//
		//--------------------------------------------------------------------------
	
		//----------------------------------
		//  borderMetrics
		//----------------------------------
	
		/**
		 *  @private
		 *  Storage for the borderMetrics property.
		 */
		private var _borderMetrics:EdgeMetrics = new EdgeMetrics(1, 1, 1, 1);
	
		/**
		 *  @private
		 */
		override public function get borderMetrics():EdgeMetrics
		{
			return _borderMetrics;
		}
	
		//----------------------------------
		//  measuredWidth
		//----------------------------------
		
		/**
		 *  @private
		 */
		override public function get measuredWidth():Number
		{
			return UIComponent.DEFAULT_MEASURED_MIN_WIDTH;
		}
		
		//----------------------------------
		//  measuredHeight
		//----------------------------------
	
		/**
		 *  @private
		 */
		override public function get measuredHeight():Number
		{
			return UIComponent.DEFAULT_MEASURED_MIN_HEIGHT;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
	
		/**
		 *  @private
		 */
		override protected function updateDisplayList(w:Number, h:Number):void
		{
			super.updateDisplayList(w, h);
	
			// User-defined styles.
			var backgroundAlpha:Number = getStyle("backgroundAlpha");		
			var backgroundColor:Number = getStyle("backgroundColor");
			var borderColor:uint = getStyle("borderColor");
			var cornerRadius:Number = getStyle("cornerRadius");
			var fillAlphas:Array = getStyle("fillAlphas");
			var fillColors:Array = getStyle("fillColors");
			if( parent )
			{
				const m:IFlexModuleFactory = UIComponent( parent ).moduleFactory;
				if( m ) StyleManager.getStyleManager( m ).getColorNames(fillColors);
			}
			var highlightAlphas:Array = getStyle("highlightAlphas");		
			var themeColor:uint = getStyle("themeColor");
			
			// Placehold styles stub.
			var falseFillColors:Array = []; /* of Number*/ // added style prop
			falseFillColors[0] = ColorUtil.adjustBrightness2(fillColors[0], -5);
			falseFillColors[1] = ColorUtil.adjustBrightness2(fillColors[1], -5);
			
			// Derivative styles.
			var derStyles:Object = calcDerivedStyles(themeColor, borderColor,
													 falseFillColors[0],
													 falseFillColors[1],
													 fillColors[0], fillColors[1]);
			
			var parentedByTabNavigator:Boolean = parent != null &&
													parent.parent != null &&
													parent.parent.parent != null &&
													parent.parent.parent is PositionedTabNavigator;
			
			var tabOffset:Number = 1;
			
			
			var drawBottomLine:Boolean =
				parentedByTabNavigator &&
				IStyleClient(parent.parent.parent).getStyle("borderStyle") != "none" &&
				tabOffset >= 0;
			
			var cornerRadius2:Number = Math.max(cornerRadius - 2, 0);
			var cr:Object;
			var cr2:Object;
			var bottomLine:Rectangle;
			var outerEdge:Rectangle;
			
			var position:String = getStyle( "position" );
			
			switch( position )
			{
				case "top" :
				{
					if( parentedByTabNavigator ) tabOffset = PositionedTabNavigator( parent.parent.parent ).borderMetrics.top;
					cr = { tl: cornerRadius, tr: cornerRadius, bl: 0, br: 0 };
					cr2 = { tl: cornerRadius2, tr: cornerRadius2, bl: 0, br: 0 };
					outerEdge = new Rectangle( 0, 0, w, h - 1 );	
					bottomLine = new Rectangle( 1, h - tabOffset, w - 2, tabOffset );
					break;
				}
				case "bottom" :
				{
					if( parentedByTabNavigator ) tabOffset = PositionedTabNavigator( parent.parent.parent ).borderMetrics.bottom;
					cr = { tl: 0, tr: 0, bl: cornerRadius, br: cornerRadius };
					cr2 = { tl: 0, tr: 0, bl: cornerRadius2, br: cornerRadius2 };
					outerEdge = new Rectangle( 0, 1, w, h - 1 );	
					bottomLine = new Rectangle( 1, 0, w - 2, tabOffset );
					break;
				}
				case "left" :
				{
					if( parentedByTabNavigator ) tabOffset = PositionedTabNavigator( parent.parent.parent ).borderMetrics.left;
					cr = { tl: cornerRadius, tr: 0, bl: cornerRadius, br: 0 };
					cr2 = { tl: cornerRadius2, tr: 0, bl: cornerRadius2, br: 0 };
					outerEdge = new Rectangle( 0, 0, w - 1, h );	
					bottomLine = new Rectangle( w - tabOffset, 1, tabOffset, h - 2 );
					break;
				}
				case "right" :
				{
					if( parentedByTabNavigator ) tabOffset = PositionedTabNavigator( parent.parent.parent ).borderMetrics.right;
					cr = { tl: 0, tr: cornerRadius, bl: 0, br: cornerRadius };
					cr2 = { tl: 0, tr: cornerRadius2, bl: 0, br: cornerRadius2 };
					outerEdge = new Rectangle( 1, 0, w - 1, h );	
					bottomLine = new Rectangle( 0, 1, tabOffset, h - 2 );
					break;
				}
			}
			graphics.clear();
			
			switch (name)
			{
				case "upSkin":
				{
	   				var upFillColors:Array = [ falseFillColors[0], falseFillColors[1] ];
					var upFillAlphas:Array = [ fillAlphas[0], fillAlphas[1] ];
					
					// outer edge
					drawRoundRect( outerEdge.x, outerEdge.y, outerEdge.width, outerEdge.height, cr, [ derStyles.borderColorDrk1, borderColor], 1, verticalGradientMatrix(0, 0, w, h), GradientType.LINEAR, null, { x: 1, y: 1, w: w - 2, h: h - 2, r: cr2 }); 
	
					// tab fill
					drawRoundRect( 1, 1, w - 2, h - 2, cr2, upFillColors, upFillAlphas, verticalGradientMatrix(0, 2, w - 2, h - 6));
				
					// tab highlight
					drawRoundRect( 1, 1, w - 2, (h - 2) / 2, cr2, [ 0xFFFFFF, 0xFFFFFF ], highlightAlphas, verticalGradientMatrix(1, 1, w - 2, (h - 2) / 2));
	
					// tab bottom line
					if (drawBottomLine) drawRoundRect( bottomLine.x, bottomLine.y, bottomLine.width, bottomLine.height, 0, borderColor, fillAlphas[1]);
					
					// tab shadow	
					drawRoundRect( 0, h - 2, w, 1, 0, 0x000000, 0.09);
					
					// tab shadow
					drawRoundRect( 0, h - 3, w, 1, 0, 0x000000, 0.03);
					
					break;
				}
	
				case "overSkin":
				{
					var overFillColors:Array;
					if (fillColors.length > 2)
						overFillColors = [ fillColors[2], fillColors[3] ];
					else
						overFillColors = [ fillColors[0], fillColors[1] ];
	
					var overFillAlphas:Array;
					if (fillAlphas.length > 2)
						overFillAlphas = [ fillAlphas[2], fillAlphas[3] ];
	  				else
						overFillAlphas = [ fillAlphas[0], fillAlphas[1] ];
					
					// outer edge
					drawRoundRect( outerEdge.x, outerEdge.y, outerEdge.width, outerEdge.height, cr, [ themeColor, derStyles.themeColDrk2 ], 1, verticalGradientMatrix(0, 0, w, h - 6), GradientType.LINEAR, null, { x: 1, y: 1, w: w - 2, h: h - 2, r: cr2 });
					
					// tab fill
					drawRoundRect( 1, 1, w - 2, h - 2, cr2, [ derStyles.falseFillColorBright1, derStyles.falseFillColorBright2 ], overFillAlphas, verticalGradientMatrix(2, 2, w - 2, h - 2));
				
					// tab highlight
					drawRoundRect( 1, 1, w - 2, (h - 2) / 2, cr2, [ 0xFFFFFF, 0xFFFFFF ], highlightAlphas, verticalGradientMatrix(1, 1, w - 2, (h - 2) / 2));
	
					// tab bottom line
					if( drawBottomLine ) drawRoundRect( bottomLine.x, bottomLine.y, bottomLine.width, bottomLine.height, 0, borderColor, fillAlphas[1]);
					
					// tab shadow	
					drawRoundRect( 0, h - 2, w, 1, 0, 0x000000, 0.09);
					
					// tab shadow
					drawRoundRect( 0, h - 3, w, 1, 0, 0x000000, 0.03);
					
					break;
				}
	
				case "disabledSkin":
				{
	   				var disFillColors:Array = [ fillColors[0], fillColors[1] ];
	
	   				var disFillAlphas:Array =
						[ Math.max( 0, fillAlphas[0] - 0.15),
						  Math.max( 0, fillAlphas[1] - 0.15) ];
				
					// outer edge
					drawRoundRect( outerEdge.x, outerEdge.y, outerEdge.width, outerEdge.height, cr, [ derStyles.borderColorDrk1, borderColor], 0.5, verticalGradientMatrix(0, 0, w, h - 6));
					
					// tab fill
					drawRoundRect( 1, 1, w - 2, h - 2, cr2, disFillColors, disFillAlphas, verticalGradientMatrix(0, 2, w - 2, h - 2));
					
					// tab bottom line
					if (drawBottomLine) drawRoundRect( bottomLine.x, bottomLine.y, bottomLine.width, bottomLine.height, 0, borderColor, fillAlphas[1]);
					
					// tab shadow	
					drawRoundRect( 0, h - 2, w, 1, 0, 0x000000, 0.09);
					
					// tab shadow
					drawRoundRect( 0, h - 3, w, 1, 0, 0x000000, 0.03);
					
					break;
				}
				
				case "downSkin":
				case "selectedUpSkin":
				case "selectedDownSkin":
				case "selectedOverSkin":
				case "selectedDisabledSkin":
				{
					if (isNaN(backgroundColor))
					{
						// Walk the parent chain until we find a background color
						var p:DisplayObjectContainer = parent;
						
						while (p)
						{
							if (p is IStyleClient)
								backgroundColor = IStyleClient(p).getStyle("backgroundColor");
							
							if (!isNaN(backgroundColor))
								break;
								
							p = p.parent;
						}
						
						// Still no backgroundColor? Use white.
						if (isNaN(backgroundColor))
							backgroundColor = 0xFFFFFF;
					}
					
					// outer edge
					drawRoundRect( outerEdge.x, outerEdge.y, outerEdge.width, outerEdge.height, cr, [ derStyles.borderColorDrk1, borderColor], 1, verticalGradientMatrix(0, 0, w, h - 2), GradientType.LINEAR, null, { x: 1, y: 1, w: w - 2, h: h - 2, r: cr2 });
				
					// tab fill color
					drawRoundRect( 1, 1, w - 2, h - 2, cr2, backgroundColor, backgroundAlpha);
					
					// tab bottom line
					if (drawBottomLine) drawRoundRect( bottomLine.x, bottomLine.y, bottomLine.width, bottomLine.height, 0, backgroundColor, backgroundAlpha);
					
					break;
				}
			}
		}
		
	}

}
