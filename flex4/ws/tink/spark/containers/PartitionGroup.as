package ws.tink.spark.containers
{
	import spark.components.Group;
	
	import ws.tink.spark.controls.partitionSupportClasses.IPartitionable;
	
	public class PartitionGroup extends Group implements IPartitionable
	{
		public function PartitionGroup()
		{
			super();
		}
		
		private var _partitions	: Vector.<int>;
		public function get partitions():Vector.<int>
		{
			return _partitions;
		}
		
		public function set partitions(value:Vector.<int>):void
		{
			if( _partitions == value ) return;
			
			trace( value );
			_partitions = value;
			invalidateDisplayList();
		}
	}
}