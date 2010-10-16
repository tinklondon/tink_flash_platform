package ws.tink.mx.charts.chartClasses
{
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getQualifiedClassName;
	
	import mx.charts.AreaChart;
	import mx.charts.ChartItem;
	import mx.charts.chartClasses.ChartBase;
	import mx.charts.chartClasses.Series;
	import mx.charts.events.ChartItemEvent;
	import mx.charts.series.items.AreaSeriesItem;
	import mx.charts.series.items.BarSeriesItem;
	import mx.charts.series.items.BubbleSeriesItem;
	import mx.charts.series.items.ColumnSeriesItem;
	import mx.charts.series.items.LineSeriesItem;
	import mx.charts.series.items.LineSeriesSegment;
	import mx.charts.series.items.PieSeriesItem;
	import mx.charts.series.items.PlotSeriesItem;
	import mx.core.UIComponent;

	public class ChartToolTipSync
	{
		
		private var _charts				: Array = new Array();
		private var _ignoreEvents		: Boolean;
		
		public function ChartToolTipSync()
		{
		}
		
		public function set charts( charts:Array ):void
		{
			removeAllCharts();
			const numItems:int = charts.length;
			for( var i:int = 0; i < numItems; i++ )
			{
				addChart( ChartBase( charts[ i ] ) );
			}
		}
		
		public function removeAllCharts():void
		{
			const numItems:int = _charts.length;
			for( var i:int = 0; i < numItems; i++ )
			{
				_removeChartAt( 0 );
			}
		}
		
		public function addChart( chart:ChartBase ):void
		{
			const index:int = getChartIndex( chart );
			if( index == -1 )
			{
				_charts.push( chart );
				addListeners( chart );
			}
		}
		
		public function removeChart( chart:ChartBase ):void
		{
			const index:int = getChartIndex( chart );
			if( index != -1 )
			{
				_removeChartAt( index );
			}
		}
		
		public function removeChartAt( index:int ):void
		{
			if( index < 0 || index >= _charts.length ) return;
			
			_removeChartAt( index );
		}
		
		private function _removeChartAt( index:int ):void
		{
			var chart:ChartBase = ChartBase( _charts.splice( index, 1 )[ 0 ] );
			removeListeners( chart );
		}
		
		private function getChartIndex( chart:ChartBase ):int
		{
			const numItems:int = _charts.length;
			for( var i:int = 0; i < numItems; i++ )
			{
				if( ChartBase( _charts[ i ] ) == chart ) return i;
			}
			
			return -1;
		}
		
		private function addListeners( chart:ChartBase ):void
		{
			chart.addEventListener( ChartItemEvent.ITEM_ROLL_OVER, onChartItemRollOver, false, 0, true );
			chart.addEventListener( ChartItemEvent.ITEM_ROLL_OUT, onChartItemRollOut, false, 0, true );
		}
		
		private function removeListeners( chart:ChartBase ):void
		{
			chart.removeEventListener( ChartItemEvent.ITEM_ROLL_OVER, onChartItemRollOver, false );
			chart.removeEventListener( ChartItemEvent.ITEM_ROLL_OUT, onChartItemRollOut, false );
		}
		
		private function onChartItemRollOver( event:ChartItemEvent ):void
		{
			if( _ignoreEvents ) return;
			
			_ignoreEvents = true;
			
			var target:ChartBase = ChartBase( event.currentTarget );
			var targetIndex:int = event.hitData.chartItem.index;
				
			var chart:ChartBase;
			
			var chartItem:ChartItem;
			var numSeries:int;
			var s:int;
			var mouseEvent:MouseEvent;
			
			var point:Point;
			
			const numItems:int = _charts.length;
			for( var i:int = 0; i < numItems; i++ )
			{
				chart = ChartBase( _charts[ i ] );
				
				if( chart != target )
				{
					numSeries = chart.series.length;
					for( s = 0; s < numSeries; s++ )
					{
						chartItem = getChartItem( Series( chart.series[ s ] ).items, targetIndex );//ChartItem( items[ targetIndex ] );
						
						if( !chartItem ) continue;

						switch( getQualifiedClassName( chartItem ) )
						{
							
							case getQualifiedClassName( AreaSeriesItem ) :
							{
								point = getAreaSeriesItemPoint( AreaSeriesItem( chartItem ), chart );
								break;
							}
							case getQualifiedClassName( BarSeriesItem ) :
							{
								point = getBarSeriesItemPoint( BarSeriesItem( chartItem ), chart );
								break;
							}
							case getQualifiedClassName( BubbleSeriesItem ) :
							{
								point = getBubbleSeriesItemPoint( BubbleSeriesItem( chartItem ), chart );
								break;
							}
							case getQualifiedClassName( ColumnSeriesItem ) :
							{
								point = getColumnSeriesItemPoint( ColumnSeriesItem( chartItem ), chart );
								break;
							}
							case getQualifiedClassName( LineSeriesItem ) :
							{
								point = getLineSeriesItemPoint( LineSeriesItem( chartItem ), chart );
								break;
							}
							case getQualifiedClassName( PieSeriesItem ) :
							{
								point = getPieSeriesItemPoint( PieSeriesItem( chartItem ) );
								break;
							}
							case getQualifiedClassName( PlotSeriesItem ) :
							{
								point = getPlotSeriesItemPoint( PlotSeriesItem( chartItem ), chart );
								break;
							}
							default :
							{
								throw new Error( "Unsupported ChartItem: " + getQualifiedClassName( chartItem ) );
							}
						}
						
						if( point )
						{
							mouseEvent = new MouseEvent( MouseEvent.MOUSE_MOVE );
							mouseEvent.localX = point.x;
							mouseEvent.localY = point.y - 1;
							chart.dispatchEvent( mouseEvent );
						}
					}
				}
			}
			
			_ignoreEvents = false;
		}
		
		private function onChartItemRollOut( event:ChartItemEvent ):void
		{
			if( _ignoreEvents ) return;
			
			_ignoreEvents = true;
			
			var target:ChartBase = ChartBase( event.currentTarget );
			
			var mouseEvent:MouseEvent = new MouseEvent( MouseEvent.MOUSE_MOVE );
			mouseEvent.localX = -100;
			mouseEvent.localY = -100;
			
			var chart:ChartBase;
			
			const numItems:int = _charts.length;
			for( var i:int = 0; i < numItems; i++ )
			{
				chart = ChartBase( _charts[ i ] );
				if( chart != target ) chart.dispatchEvent( mouseEvent );
			}
			
			_ignoreEvents = false;
		}
		
		private function getAreaSeriesItemPoint( item:AreaSeriesItem, chart:ChartBase ):Point
		{
			var point:Point = new Point();
			point = chart.globalToLocal( item.element.localToGlobal( point ) );
			point.x += item.x;
			point.y += item.y;
			
			var bounds:Rectangle = item.element.getBounds( chart );
			if( point.x + 1 >= bounds.x + bounds.width ) point.x--;
			if( point.y + 1 >= bounds.y + bounds.height ) point.y--;
			return point;
		}
		
		private function getBarSeriesItemPoint( item:BarSeriesItem, chart:ChartBase ):Point
		{
			var point:Point = new Point();
			point = chart.globalToLocal( item.element.localToGlobal( point ) );
			point.x += item.x;
			point.y += item.y;
			
			var bounds:Rectangle = item.element.getBounds( chart );
			if( point.x + 1 >= bounds.x + bounds.width ) point.x--;
			if( point.y + 1 >= bounds.y + bounds.height ) point.y--;
			return point;
		}
		
		private function getBubbleSeriesItemPoint( item:BubbleSeriesItem, chart:ChartBase ):Point
		{
			var point:Point = new Point();
			point = chart.globalToLocal( item.element.localToGlobal( point ) );
			point.x += item.x;
			point.y += item.y;
			
			var bounds:Rectangle = item.element.getBounds( chart );
			if( point.x + 1 >= bounds.x + bounds.width ) point.x--;
			if( point.y + 1 >= bounds.y + bounds.height ) point.y--;
			return point;
		}
		
		private function getColumnSeriesItemPoint( item:ColumnSeriesItem, chart:ChartBase ):Point
		{
			var point:Point = new Point();
			point = chart.globalToLocal( item.element.localToGlobal( point ) );
			point.x += item.x;
			point.y += item.y;
			
			var bounds:Rectangle = item.element.getBounds( chart );
			if( point.x + 1 >= bounds.x + bounds.width ) point.x--;
			if( point.y + 1 >= bounds.y + bounds.height ) point.y--;
			return point;
		}
		
		private function getLineSeriesItemPoint( item:LineSeriesItem, chart:ChartBase ):Point
		{
			var point:Point = new Point();
			point = chart.globalToLocal( item.element.localToGlobal( point ) );
			point.x += item.x;
			point.y += item.y;
			
			var bounds:Rectangle = item.element.getBounds( chart );
			if( point.x + 1 >= bounds.x + bounds.width ) point.x--;
			if( point.y + 1 >= bounds.y + bounds.height ) point.y--;
			return point;
		}
		
		private function getPieSeriesItemPoint( item:PieSeriesItem):Point
		{
			var radius:Number = item.innerRadius + ( ( item.outerRadius - item.innerRadius ) / 2 );
			var angle:Number = -( item.startAngle + ( item.angle / 2 ) );
			return new Point( item.origin.x + Math.cos( angle ) * radius, item.origin.y + Math.sin( angle ) * radius );
		}
		
		private function getPlotSeriesItemPoint( item:PlotSeriesItem, chart:ChartBase ):Point
		{
			var point:Point = new Point();
			point = chart.globalToLocal( item.element.localToGlobal( point ) );
			point.x += item.x;
			point.y += item.y;
			
			var bounds:Rectangle = item.element.getBounds( chart );
			if( point.x + 1 >= bounds.x + bounds.width ) point.x--;
			if( point.y + 1 >= bounds.y + bounds.height ) point.y--;
			return point;
		}
		
		private function getChartItem( items:Array, index:int ):ChartItem
		{
			var chartItem:ChartItem = ChartItem( items[ index ] );
			
			if( chartItem ) if( chartItem.index == index ) return chartItem;
//			
			const numItems:int = items.length;
			for( var i:int = 0; i < numItems; i++ )
			{
				chartItem = ChartItem( items[ i ] );
				if( chartItem ) if( chartItem.index == index ) return chartItem;
			}
			
			return null;
		}
		

	}
}