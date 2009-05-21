package ws.tink.flex.controls.treeClasses
{
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	import mx.collections.ICollectionView;
	import mx.controls.treeClasses.DefaultDataDescriptor;
	import mx.controls.treeClasses.HierarchicalCollectionView;
	import mx.core.mx_internal;
	
	use namespace mx_internal;
	public class ArrayCollectionDataDescriptor extends DefaultDataDescriptor
	{
		
		private var ChildCollectionCache:Dictionary = new Dictionary(true);
		
		public function ArrayCollectionDataDescriptor()
		{
			super();
		}
		
		override public function isBranch( node:Object, model:Object = null):Boolean
    	{
    		return ( node is ArrayCollection ) ? node.length > 0 : false;
    	}
    	
		override public function hasChildren( node:Object, model:Object = null):Boolean
    	{
    		return ( node is ArrayCollection ) ? node.length > 0 : false;
    	}
    	
		override public function getChildren( node:Object, model:Object = null):ICollectionView
	    {
	        return node as ArrayCollection;
	    }

	}
}