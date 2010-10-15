/*
Copyright (c) 2010 Tink Ltd - http://www.tink.ws

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

package ws.tink.spark.controls.supportClasses
{
	import spark.effects.animation.Animation;
	import spark.effects.animation.IAnimationTarget;
	
	public class AnimationTarget implements IAnimationTarget
	{
		public var updateFunction:Function;
		public var startFunction:Function;
		public var stopFunction:Function;
		public var endFunction:Function;
		public var repeatFunction:Function;
		
		public function AnimationTarget(updateFunction:Function = null)
		{
			this.updateFunction = updateFunction;
		}
		
		public function animationStart(animation:Animation):void
		{
			if (startFunction != null)
				startFunction(animation);
		}
		
		public function animationEnd(animation:Animation):void
		{
			if (endFunction != null)
				endFunction(animation);
		}
		
		public function animationStop(animation:Animation):void
		{
			if (stopFunction != null)
				stopFunction(animation);
		}
		
		public function animationRepeat(animation:Animation):void
		{
			if (repeatFunction != null)
				repeatFunction(animation);
		}
		
		public function animationUpdate(animation:Animation):void
		{
			if (updateFunction != null)
				updateFunction(animation);
		}
		
	}
}
