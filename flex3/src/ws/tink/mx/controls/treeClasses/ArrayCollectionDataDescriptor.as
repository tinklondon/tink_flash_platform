package ws.tink.mx.controls.treeClasses
{

	import mx.collections.ArrayCollection;
	import mx.collections.ICollectionView;
	import mx.controls.treeClasses.DefaultDataDescriptor;
	
	public class ArrayCollectionDataDescriptor extends DefaultDataDescriptor
	{
		
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
    	
		override public function getChildren( node:Object, model:Object = null ):ICollectionView
	    {
	        return node as ArrayCollection;
	    }

	}
}