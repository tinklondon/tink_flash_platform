package ws.tink.mx.flash

{

	

	import flash.geom.ColorTransform;

	import mx.flash.UIMovieClip;

	

	public class UITintedMovieClip extends UIMovieClip

	{

		

		public function UITintedMovieClip()

		{

			super();

		}

			

		override public function initialize():void

    	{

			super.initialize();

			

			try

			{

				var color:Number = systemManager[ "application" ].getStyle( "skinTint" );

				if( !isNaN( color ) )

				{

					transform.colorTransform = new ColorTransform( 1, 1, 1, 1, ( color >> 16 ) & 0xFF, ( color >> 8 ) & 0xFF, color & 0xFF, 0 );

				}

			}

			catch( e:Error )

			{

			}

		}

		

	}

}