package ws.tink.flex.skins
{

	import mx.core.EdgeMetrics;
	import mx.core.IBorder;
	
	/**
	 *  The Border class is an abstract base class for various classes that
	 *  draw borders, either rectangular or non-rectangular, around UIComponents.
	 *  This class does not do any actual drawing itself.
	 *
	 *  <p>If you create a new non-rectangular border class, you should extend
	 *  this class.
	 *  If you create a new rectangular border class, you should extend the
	 *  abstract subclass RectangularBorder.</p>
	 *
	 *  @tiptext
	 *  @helpid 3321
	 */
	public class SpriteBorder extends SpriteProgrammaticSkin implements IBorder
	{
	
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
	
		/**
		 *  Constructor.
		 */
		public function SpriteBorder()
		{
			super();
		}
	
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
	
		//----------------------------------
		//  borderMetrics
		//----------------------------------
	
		/**
		 *  The thickness of the border edges.
		 *
		 *  @return EdgeMetrics with left, top, right, bottom thickness in pixels
		 */
		public function get borderMetrics():EdgeMetrics
		{
			return EdgeMetrics.EMPTY;
		}
	}

}
