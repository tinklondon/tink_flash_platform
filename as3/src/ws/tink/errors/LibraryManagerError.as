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

package ws.tink.errors
{
	
	public class LibraryManagerError extends Error
	{
		
		public static const FORCE_SINGLETON			: uint = 3001;
		public static const DUPLICATE_LIBRARY_NAME	: uint = 3002;
		public static const LIBRARY_NOT_FOUND		: uint = 1000;
		
		private const BASE_ERROR_CODE				:	uint = 3000;	
		private const ERROR_MSG						: Array = new Array( "LibraryManager is to be used as a Singleton and should only be accessed through LibraryManager.libraryManager.", 
																		 "There is already a library with this name. Libraries stored in the LibraryManager must be unique names.",
														 				 "The supplied library name could not be found in the LibraryManager." );
		
		public function LibraryManagerError( errCode:uint )
		{
			super( "Error #" + errCode +": " + ERROR_MSG[ errCode - BASE_ERROR_CODE ], errCode );
			
			name = "LibraryManagerError";
		}
		
	}
}