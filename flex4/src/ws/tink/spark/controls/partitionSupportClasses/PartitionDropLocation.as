package ws.tink.spark.controls.partitionSupportClasses
{
	import spark.layouts.supportClasses.DropLocation;
	
	public class PartitionDropLocation extends DropLocation
	{
		public function PartitionDropLocation()
		{
			super();
		}
		
		public var partitionDropIndex:int = -1;
	}
}