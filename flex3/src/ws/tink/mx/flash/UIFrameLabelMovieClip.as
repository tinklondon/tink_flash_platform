////////////////////////////////////////////////////////////////////////////////
//
//	Copyright (c) 2009 Tink Ltd | http://www.tink.ws
//	
//	Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
//	documentation files (the "Software"), to deal in the Software without restriction, including without limitation 
//	the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and
//	to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//	
//	The above copyright notice and this permission notice shall be included in all copies or substantial portions
//	of the Software.
//	
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO 
//	THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, 
//	TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//	SOFTWARE.
//
////////////////////////////////////////////////////////////////////////////////

package ws.tink.mx.flash
{
	
	import flash.display.FrameLabel;
	import mx.flash.UIMovieClip;
	
	import ws.tink.events.FrameLabelEvent;

	[Event(name="frameLabel", type="ws.tink.events.FrameLabelEvent")]
	public class UIFrameLabelMovieClip extends UIMovieClip
	{
		public function UIFrameLabelMovieClip()
		{
			super();
			
			addScriptToFrameLabels();
		}
		
		private function addScriptToFrameLabels():void
		{
			var frameLabel:FrameLabel;
			var numFrameLabels:uint = currentLabels.length;
			for( var i:uint = 0; i < numFrameLabels; i++)
			{
			    frameLabel = FrameLabel( currentLabels[ i ] );
			    addFrameScript( frameLabel.frame - 1, dispatchFrameLabelEvent )
			}
		}
		
		private function dispatchFrameLabelEvent():void
		{
			var frameLabel:FrameLabel = getFrameLabelByName( currentLabel );
			if( frameLabel ) dispatchEvent( new FrameLabelEvent( FrameLabelEvent.FRAME_LABEL, frameLabel, false, false ) );
		}
		
		public function getFrameLabelByName( name:String ):FrameLabel
		{
			var frameLabel:FrameLabel;
			var numFrameLabels:uint = currentLabels.length;
			for( var i:uint = 0; i < numFrameLabels; i++)
			{
			    frameLabel = FrameLabel( currentLabels[ i ] );
			    if( frameLabel.name == name ) return frameLabel;
			}
			
			return null;
		}
		
	}
}