package ws.tink.spark.controls.partitionSupportClasses
{
	public interface IPartitionable
	{
		function get partitions():Vector.<int>
		function set partitions( value:Vector.<int> ):void
	}
}