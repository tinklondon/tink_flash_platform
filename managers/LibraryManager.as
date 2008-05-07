/*
Copyright (c) 2008 Tink Ltd - http://www.tink.ws

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
documentation files (the "Software"), to deal in the Software without restriction, including without limitation 
the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and
to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions
of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO 
THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, 
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/

package ws.tink.managers
{
	import ws.tink.core.Library;
	import ws.tink.errors.LibraryManagerError;
	
	public class LibraryManager
	{
		
		
		private static var _instance			: LibraryManager;
		private static var _allowConstructor	: Boolean;
		
		private var _libraries					: Array;

		
		public function LibraryManager()
		{
			super();
			
			if( !_allowConstructor ) throw new LibraryManagerError( LibraryManagerError.FORCE_SINGLETON );
			
			initialize();
		}
		
		public static function get libraryManager():LibraryManager
        { 
            if( !_instance )
            {
                _allowConstructor = true;
                _instance = new LibraryManager();
                _allowConstructor = false;
            }
           
            return _instance;
        }
		
        public function contains( name:String ):Boolean
		{
			return ( getLibraryIndex( name ) != -1 );
		}
		
		public function getLibrary( name:String ):Library
		{
			var libraryIndex:int = getLibraryIndex( name );
			
			return ( libraryIndex == -1 ) ? null : Library( _libraries[ libraryIndex ] );
		}
		
		public function createLibrary( name:String ):Library
		{
			if( getLibraryIndex( name ) == -1 )
			{
				var library:Library = new Library( name );			
				_libraries.push( library );
				return library;
			}

			throw new LibraryManagerError( LibraryManagerError.DUPLICATE_LIBRARY_NAME );
		}

		public function addLibrary( library:Library, name:String ):void
		{
			if( getLibraryIndex( name ) == -1 )
			{		
				_libraries.push( library );
			}

			throw new LibraryManagerError( LibraryManagerError.DUPLICATE_LIBRARY_NAME );
		}
		
		public function removeLibrary( name:String, destroy:Boolean = false ):void
		{
			var index:int = getLibraryIndex( name );
			if( index != -1 )
			{
				var library:Library = Library( _libraries.splice( index, 1 )[ 0 ] );
				if( destroy ) library.destroy();
			}
			
			throw new LibraryManagerError( LibraryManagerError.LIBRARY_NOT_FOUND );
		}
		
		private function initialize():void
		{
			_libraries = new Array();
		}
		
		private function getLibraryIndex( name:String ):int
		{
			var numLibraries:int = _libraries.length;
			for( var i:int = 0; i < numLibraries; i++ )
			{
				if( name == Library( _libraries[ i ] ).name ) return i;
			}
			
			return -1;
		}
	}
}