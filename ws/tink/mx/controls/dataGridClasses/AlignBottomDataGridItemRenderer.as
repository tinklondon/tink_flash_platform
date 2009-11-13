package ws.tink.mx.controls.dataGridClasses
{
	import mx.controls.dataGridClasses.DataGridItemRenderer;

	public class AlignBottomDataGridItemRenderer extends DataGridItemRenderer
	{
		public function AlignBottomDataGridItemRenderer()
		{
			super();
		}
		
		override public function setActualSize( w:Number, h:Number ):void
		{
			super.setActualSize( w, h );
			
			if( listData )
    		{
	    		var lineHeight:int = int( textHeight / numLines );
	    		var numPossibleLines:int = int( h / lineHeight );
	    		if( numLines < numPossibleLines )
	    		{
	    			var pad:String = "";
	    			for( var i:int = numLines; i < numPossibleLines; i++ )
	    			{
	    				pad += "\n";
	    			}
	    			text = pad + listData.label;
	    		}
	    	}
		}
		
	}
}