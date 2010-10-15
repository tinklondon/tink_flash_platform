package ws.tink.mx.controls.alertTabBarClasses
{
	import mx.core.mx_internal;
	import mx.styles.CSSStyleDeclaration;
	import mx.styles.StyleManager;
	import mx.controls.ButtonPhase;
	//import mx.controls.ButtonPhase;
	
	import ws.tink.mx.controls.positionedTabBarClasses.PositionedTab;
	import ws.tink.mx.skins.halo.AlertTabSkin;
	
	use namespace mx_internal;

	[Style(name="alerted", type="Boolean", enumeration="true,false", inherit="no")]
	
	public class AlertTab extends PositionedTab
	{
		
		
		private static var defaultStylesSet				: Boolean = setDefaultStyles();
		
		private var _color								: Number;
		private var _textRollOverColor					: Number;
		
		
		override public function styleChanged( styleProp:String ):void
		{
			super.styleChanged( styleProp );
			
			if( !styleProp || styleProp == "alerted" )
			{
				var alerted:Boolean = getStyle( "alerted" );
			
				if( selected && alerted ) setStyle( "alerted", false );
			}
		}
		
		override public function set selected(value:Boolean):void
	    {
	        super.selected = value;
	        
	        if( value ) setStyle( "alerted", false );
	    }
    
		override mx_internal function viewSkinForPhase( tempSkinName:String, stateName:String ):void
    	{
    		super.mx_internal::viewSkinForPhase( tempSkinName, stateName );
    		
			var labelColor:Number;
	
	        if( enabled )
	        {
	        	var alerted:Boolean = getStyle( "alerted" );
	        	
	            if( phase == ButtonPhase.OVER )
	            {
	                labelColor = ( alerted ) ? textField.getStyle( "alertedTextRollOverColor" ) : textField.getStyle( "textRollOverColor" );
	            }
	            else if( phase == ButtonPhase.DOWN )
	            {
	                labelColor = textField.getStyle( "textSelectedColor" );
	            }
	            else
	            {
	                labelColor = ( alerted ) ? textField.getStyle( "alertedColor" ) : textField.getStyle( "color" );
	            }
	
	            textField.setColor(labelColor);
	        }
	    }
	    
		
		/**
	     *  @private
	     */
		private static function setDefaultStyles():Boolean
		{
			var style:CSSStyleDeclaration = StyleManager.getStyleDeclaration( "AlertTab" );
			
		    if( !style )
		    {
		        style = new CSSStyleDeclaration();
		        StyleManager.setStyleDeclaration( "AlertTab", style, true );
		    }
		    
		    if( style.defaultFactory == null )
	        {
	        	style.defaultFactory = function():void
	            {
	            	this.alerted = false;
	            	this.alertedTextRollOverColor = 0xFFFFFF;
	            	this.alertedColor = 0xFFFFFF;
	            	this.alertedFillColors = [ 0xFF0000, 0xFF0000 ];
	            	this.alertedBorderColor = 0xFF0000;
	            	this.skin = AlertTabSkin;	
	            };
	        }

		    return true;
		}
		
	}
}