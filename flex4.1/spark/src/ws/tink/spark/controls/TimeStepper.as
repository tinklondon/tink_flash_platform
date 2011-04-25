package ws.tink.spark.controls
{
	import flash.events.Event;
	
	import spark.components.Label;
	import spark.components.NumericStepper;
	import spark.components.supportClasses.SkinnableComponent;
	
	//--------------------------------------
	//  Styles
	//--------------------------------------
	
	/**
	 *  Name of CSS style declaration that specifies styles for the
	 *  hours NumericStepper skin part.
	 *  
	 *  @default undefined
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Flex 10
	 */
	[Style(name="hoursStyleName", type="String", inherit="no")]
	
	/**
	 *  Name of CSS style declaration that specifies styles for the
	 *  minutes NumericStepper skin part.
	 *  
	 *  @default undefined
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Flex 10
	 */
	[Style(name="minutesStyleName", type="String", inherit="no")]
	
	/**
	 *  Name of CSS style declaration that specifies styles for the
	 *  seconds NumericStepper skin part.
	 *  
	 *  @default undefined
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Flex 10
	 */
	[Style(name="secondsStyleName", type="String", inherit="no")]
	
	/**
	 *  Name of CSS style declaration that specifies styles for the
	 *  milliseconds NumericStepper skin part.
	 *  
	 *  @default undefined
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Flex 10
	 */
	[Style(name="millisecondsStyleName", type="String", inherit="no")]
	
	
	//--------------------------------------
	//  Events
	//--------------------------------------
	
	/**
	 *  Dispatched when the <code>time</code>, <code>hours</code>, <code>minutes</code>,
	 *  <code>seconds</code> or <code>milliseconds</code> properties of the TimeStepper
	 *  control changes as a result of user interaction.
	 *
	 *  @eventType flash.events.Event.CHANGE
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Flex 4
	 */
	[Event(name="change", type="flash.events.Event")]
	
	
	
	/**
	 *  The TimeStepper control...
	 *
	 *  <p>The TimeStepper control has the following default characteristics:</p>
	 *     <table class="innertable">
	 *        <tr>
	 *           <th>Characteristic</th>
	 *           <th>Description</th>
	 *        </tr>
	 *        <tr>
	 *           <td>Default size</td>
	 *           <td>53 pixels wide by 23 pixels high</td>
	 *        </tr>
	 *        <tr>
	 *           <td>Minimum size</td>
	 *           <td>40 pixels wide and 40 pixels high</td>
	 *        </tr>
	 *        <tr>
	 *           <td>Maximum size</td>
	 *           <td>10000 pixels wide and 10000 pixels high</td>
	 *        </tr>
	 *        <tr>
	 *           <td>Default skin classes</td>
	 *           <td>ws.tink.spark.skins.controls.TimeStepperSkin
	 *              <p>spark.skins.spark.NumericStepperSkin</p></td>
	 *        </tr>
	 *     </table>
	 *
	 *  @mxml
	 *
	 *  <p>The <code>&lt;st:TimeStepper&gt;</code> tag inherits all of the tag 
	 *  attributes of its superclass and adds the following tag attributes:</p>
	 *
	 *  <pre>
	 *  &lt;st:TimeStepper
	 *
	 *    <strong>Properties</strong>
	 *    allowValueWrap="true"
	 *    time="0"
	 *    hours="0"
	 *    minutes="0"
	 *    seconds="0"
	 * 	  milliseconds="0"
	 *
	 *    <strong>Styles</strong>
	 *    hoursStyleName="USE_DOMINANT_BASELINE"
	 *    minutesStyleName="0.0"
	 *    secondsStyleName="TB"
	 *    millisecondStyleName="0.5"
	 *  /&gt;
	 *  </pre>
	 *
	 *  @see ws.tink.spark.skins.controls.TimeStepperSkin
	 * 
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Flex 4
	 */
	public class TimeStepper extends SkinnableComponent
	{
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function TimeStepper()
		{
			super();
			
			_date = new Date( 0 );
		}
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 */
		private var _date : Date;
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Skin Parts
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  hoursStepper
		//----------------------------------
		
		[SkinPart(required="false")]
		
		/**
		 *  A skin part that defines the NumericStepper that changes
		 *  and displays the <code>hours</code> property.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public var hoursStepper : NumericStepper;
		
		
		//----------------------------------
		//  minutesStepper
		//----------------------------------
		
		[SkinPart(required="false")]
		
		/**
		 *  A skin part that defines the NumericStepper that changes
		 *  and displays the <code>minutes</code> property.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public var minutesStepper : NumericStepper;
		
		
		//----------------------------------
		//  secondsStepper
		//----------------------------------
		
		[SkinPart(required="false")]
		
		/**
		 *  A skin part that defines the NumericStepper that changes
		 *  and displays the <code>seconds</code> property.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public var secondsStepper : NumericStepper;
		
		
		//----------------------------------
		//  millisecondsStepper
		//----------------------------------
		
		[SkinPart(required="false")]
		
		/**
		 *  A skin part that defines the NumericStepper that changes
		 *  and displays the <code>milliseconds</code> property.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public var millisecondsStepper : NumericStepper;
		
		
		//----------------------------------
		//  meridiemDisplay
		//----------------------------------
		
		[SkinPart(required="false")]
		
		/**
		 *  A skin part that defines the label for the <code>meridiem</code>
		 *  property. 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public var meridiemDisplay : Label;
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  allowValueWrap
		//----------------------------------
		
		/**
		 *  @private
		 *  Internal storage for the allowValueWrap property.
		 */
		private var _allowValueWrap : Boolean = true;
		
		/**
		 *  Comment
		 * 
		 *  @default true
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function get allowValueWrap():Boolean
		{
			return _allowValueWrap;
		}
		/**
		 *  @private
		 */
		public function set allowValueWrap( value:Boolean ):void
		{
			if( _twelveHourClock == value ) return;
			
			_allowValueWrap = value;
			if( hoursStepper ) hoursStepper.allowValueWrap = _allowValueWrap;
			if( minutesStepper ) minutesStepper.allowValueWrap = _allowValueWrap;
			if( secondsStepper ) secondsStepper.allowValueWrap = _allowValueWrap;
			if( millisecondsStepper ) millisecondsStepper.allowValueWrap = _allowValueWrap;
		}
		
		
		//----------------------------------
		//  twelveHourClock
		//----------------------------------
		
		/**
		 *  @private
		 *  Internal storage for the twelveHourClock property.
		 */
		private var _twelveHourClock : Boolean;
		
		/**
		 *  Comment
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function get twelveHourClock():Boolean
		{
			return _twelveHourClock;
		}
		/**
		 *  @private
		 */
		public function set twelveHourClock( value:Boolean ):void
		{
			if( _twelveHourClock == value ) return;
			
			_twelveHourClock = value;
			updateHourStepper();
		}
		
		
		//----------------------------------
		//  meridiem
		//----------------------------------
		
		/**
		 *  Comment
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function get meridiem():String
		{
			if( _date.hours > 12 ) return "PM"; 
			var sub:uint = _date.minutes + _date.seconds + _date.milliseconds;
			return ( _date.hours > 11 && sub > 0 ) ? "PM" : "AM"
		}
		
		
		//----------------------------------
		//  time
		//----------------------------------
		
		/**
		 *  Comment
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function get time():uint
		{
			return _date.time;
		}
		/**
		 *  @private
		 */
		public function set time( value:uint ):void
		{
			if( _date.time == value ) return;
			
			_date.time = value % 24;
			updateHourStepper();
			updateMinuteStepper();
			updateSecondStepper();
			updateMillisecondsStepper();
		}
		
		
		//----------------------------------
		//  hours
		//----------------------------------
		
		/**
		 *  Comment
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function get hours():uint
		{
			return _date.hours;
		}
		/**
		 *  @private
		 */
		public function set hours( value:uint ):void
		{
			if( _date.hours == value ) return;
			
			_date.hours = value % 24;
			updateHourStepper();
			updateMeridiemDisplay();
		}
		
		
		//----------------------------------
		//  minutes
		//----------------------------------
		
		/**
		 *  Comment
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function get minutes():uint
		{
			return _date.minutes;
		}
		/**
		 *  @private
		 */
		public function set minutes( value:uint ):void
		{
			if( _date.minutes == value ) return;
			
			_date.minutes = value % 60;
			updateMinuteStepper();
			updateMeridiemDisplay();
		}
		
		
		//----------------------------------
		//  seconds
		//----------------------------------
		
		/**
		 *  Comment
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function get seconds():uint
		{
			return _date.seconds;
		}
		/**
		 *  @private
		 */
		public function set seconds( value:uint ):void
		{
			if( _date.seconds == value ) return;
			
			_date.seconds = value % 60;
			updateSecondStepper();
			updateMeridiemDisplay();
		}
		
		
		//----------------------------------
		//  milliseconds
		//----------------------------------
		
		/**
		 *  Comment
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function get milliseconds():uint
		{
			return _date.milliseconds;
		}
		/**
		 *  @private
		 */
		public function set milliseconds( value:uint ):void
		{
			if( _date.milliseconds == value ) return;
			
			_date.milliseconds = value % 60;
			updateMillisecondsStepper();
			updateMeridiemDisplay();
		}
		
		
		//---------------------------------
		// hoursStepSize
		//---------------------------------    
		
		private var _hoursStepSize:Number = 1;
		
		[Inspectable(minValue="0.0")]
		
		/**
		 *  The amount that the <code>hours</code> property changes as a result of user interaction
		 *  with the <code>hoursStepper</code> skin part, excluding direct text input.
		 *  It must be a multiple of <code>hoursSnapInterval</code>, unless <code>hoursSnapInterval</code> is 0. 
		 *  If <code>hoursStepSize</code> is not a multiple of <code>hoursSnapInterval</code>,
		 *  it is rounded to the nearest multiple that is greater than or equal to <code>hoursSnapInterval</code>.
		 *
		 *  @default 1
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function get hoursStepSize():Number
		{
			return _hoursStepSize;
		}
		/**
		 *  @private
		 */
		public function set hoursStepSize( value:Number ):void
		{
			if( _hoursStepSize == value ) return;
			
			_hoursStepSize = value < 0 ? 0 : value;
			if( hoursStepper ) hoursStepper.stepSize = _hoursStepSize;       
		}
		
		
		//---------------------------------
		// minutesStepSize
		//---------------------------------    
		
		private var _minutesStepSize:Number = 1;
		
		[Inspectable(minValue="0.0")]
		
		/**
		 *  The amount that the <code>minutes</code> property changes as a result of user interaction
		 *  with the <code>minutesStepper</code> skin part, excluding direct text input.
		 *  It must be a multiple of <code>minutesSnapInterval</code>, unless <code>minutesSnapInterval</code> is 0. 
		 *  If <code>minutesStepSize</code> is not a multiple of <code>minutesSnapInterval</code>,
		 *  it is rounded to the nearest multiple that is greater than or equal to <code>minutesSnapInterval</code>.
		 *
		 *  @default 1
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function get minutesStepSize():Number
		{
			return _minutesStepSize;
		}
		/**
		 *  @private
		 */
		public function set minutesStepSize( value:Number ):void
		{
			if( _minutesStepSize == value ) return;
			
			_minutesStepSize = value < 0 ? 0 : value;
			if( minutesStepper ) minutesStepper.stepSize = _minutesStepSize;       
		}
		
		
		//---------------------------------
		// secondsStepSize
		//---------------------------------    
		
		private var _secondsStepSize:Number = 1;
		
		[Inspectable(minValue="0.0")]
		
		/**
		 *  The amount that the <code>seconds</code> property changes as a result of user interaction
		 *  with the <code>secondsStepper</code> skin part, excluding direct text input.
		 *  It must be a multiple of <code>secondsSnapInterval</code>, unless <code>secondsSnapInterval</code> is 0. 
		 *  If <code>secondsStepSize</code> is not a multiple of <code>secondsSnapInterval</code>,
		 *  it is rounded to the nearest multiple that is greater than or equal to <code>secondsSnapInterval</code>.
		 *
		 *  @default 1
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function get secondsStepSize():Number
		{
			return _secondsStepSize;
		}
		/**
		 *  @private
		 */
		public function set secondsStepSize( value:Number ):void
		{
			if( _secondsStepSize == value ) return;
			
			_secondsStepSize = value < 0 ? 0 : value;
			if( secondsStepper ) secondsStepper.stepSize = _secondsStepSize;       
		}
		
		
		//---------------------------------
		// millisecondsSecondsStepSize
		//---------------------------------    
		
		private var _millisecondsSecondsStepSize:Number = 1;
		
		[Inspectable(minValue="0.0")]
		
		/**
		 *  The amount that the <code>milliseconds</code> property changes as a result of user interaction
		 *  with the <code>millisecondsStepper</code> skin part, excluding direct text input.
		 *  It must be a multiple of <code>milisecondsSnapInterval</code>, unless <code>milisecondsSnapInterval</code> is 0. 
		 *  If <code>millisecondsSecondsStepSize</code> is not a multiple of <code>milisecondsSnapInterval</code>,
		 *  it is rounded to the nearest multiple that is greater than or equal to <code>milisecondsSnapInterval</code>.
		 *
		 *  @default 1
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function get millisecondsSecondsStepSize():Number
		{
			return _millisecondsSecondsStepSize;
		}
		/**
		 *  @private
		 */
		public function set millisecondsSecondsStepSize( value:Number ):void
		{
			if( _millisecondsSecondsStepSize == value ) return;
			
			_millisecondsSecondsStepSize = value < 0 ? 0 : value;
			if( millisecondsStepper ) millisecondsStepper.stepSize = _millisecondsSecondsStepSize;       
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 */
		protected function updateHourStepper():void
		{
			if( !hoursStepper ) return;
			
			hoursStepper.snapInterval = 1;
			
			if( _twelveHourClock )
			{
				hoursStepper.value = _date.hours % 12;
				hoursStepper.maximum = 11;
			}
			else
			{
				hoursStepper.value = _date.hours;
				hoursStepper.maximum = 23;
			}
		}
		
		/**
		 *  @private
		 */
		protected function updateMinuteStepper():void
		{
			if( !minutesStepper ) return;
			
			minutesStepper.snapInterval = 1;
			minutesStepper.value = _date.minutes;
		}
		
		/**
		 *  @private
		 */
		protected function updateSecondStepper():void
		{
			if( !secondsStepper ) return;
			
			secondsStepper.snapInterval = 1;
		}
		
		/**
		 *  @private
		 */
		protected function updateMillisecondsStepper():void
		{
			if( !millisecondsStepper ) return;
			
			millisecondsStepper.snapInterval = 1;
		}
		
		/**
		 *  @private
		 */
		protected function updateMeridiemDisplay():void
		{
			if( !meridiemDisplay ) return;
			
			meridiemDisplay.text = meridiem;
		}
		
		private function twoCharsFormatFunction( value:Number ):String
		{
			if( value < 10 ) return "0" + value.toString();
			return value.toString();
		}
		
		private function fourCharsFormatFunction( value:Number ):String
		{
			var s:String = value.toString();
			var padding:String = "";
			var numPadding:int = 4 - s.length;
			for( var i:int = 0; i < numPadding; i++ )
			{
				padding += "0";
			}
			return padding + s;
		}
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Overridden Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 */
		override public function styleChanged( styleProp:String ):void
		{
			super.styleChanged( styleProp );
			
			var allStyles:Boolean = styleProp == null || styleProp == "styleName";
			
			var style:String;
			
			if( allStyles || styleProp == "hoursStyleName" )
			{
				style = getStyle( "hoursStyleName" );
				if( style && hoursStepper ) hoursStepper.styleName = style;
			}
			
			if( allStyles || styleProp == "minutesStyleName" )
			{
				style = getStyle( "minutesStyleName" );
				if( style && minutesStepper ) minutesStepper.styleName = style;
			}
			
			if( allStyles || styleProp == "secondsStyleName" )
			{
				style = getStyle( "secondsStyleName" );
				if( style && secondsStepper ) secondsStepper.styleName = style;
			}
			
			if( allStyles || styleProp == "millisecondsStyleName" )
			{
				style = getStyle( "millisecondsStyleName" );
				if( style && secondsStepper ) secondsStepper.styleName = style;
			}
		}
		
		/**
		 *  @private
		 */
		override protected function partAdded( partName:String, instance:Object ):void
		{
			super.partAdded( partName, instance );
			
			var style:String;
			
			switch( instance )
			{
				case hoursStepper :
				{
					style = getStyle( "hourssStyleName" );
					if( style ) hoursStepper.styleName = style;
					updateHourStepper();
					hoursStepper.stepSize = 10;
					hoursStepper.valueFormatFunction = twoCharsFormatFunction;
					hoursStepper.allowValueWrap = _allowValueWrap;
					hoursStepper.addEventListener( Event.CHANGE, onHoursStepperChange, false, 0, true );
					break;
				}
				case minutesStepper :
				{
					style = getStyle( "minutesStyleName" );
					if( style ) minutesStepper.styleName = style;
					updateMinuteStepper();
					minutesStepper.maximum = 59;
					minutesStepper.valueFormatFunction = twoCharsFormatFunction;
					minutesStepper.allowValueWrap = _allowValueWrap;
					minutesStepper.addEventListener( Event.CHANGE, onMinutesStepperChange, false, 0, true );
					break;
				}
				case secondsStepper :
				{
					style = getStyle( "secondsStyleName" );
					if( style ) secondsStepper.styleName = style;
					updateSecondStepper();
					secondsStepper.maximum = 59;
					secondsStepper.valueFormatFunction = twoCharsFormatFunction;
					secondsStepper.allowValueWrap = _allowValueWrap;
					secondsStepper.addEventListener( Event.CHANGE, onSecondsStepperChange, false, 0, true );
					break;
				}
				case millisecondsStepper :
				{
					style = getStyle( "millisecondsStyleName" );
					if( style ) millisecondsStepper.styleName = style;
					updateMillisecondsStepper();
					millisecondsStepper.maximum = 999;
					millisecondsStepper.valueFormatFunction = fourCharsFormatFunction;
					millisecondsStepper.allowValueWrap = _allowValueWrap;
					millisecondsStepper.addEventListener( Event.CHANGE, onMillisecondsStepperChange, false, 0, true );
					break;
				}
				case meridiemDisplay :
				{
					updateMeridiemDisplay();
					break;
				}
			}
		}
		
		
		/**
		 *  @private
		 */
		override protected function partRemoved( partName:String, instance:Object ):void
		{
			super.partRemoved( partName, instance );
			
			switch( instance )
			{
				case hoursStepper :
				{
					hoursStepper.removeEventListener( Event.CHANGE, onHoursStepperChange, false );
					break;
				}
				case minutesStepper :
				{
					minutesStepper.removeEventListener( Event.CHANGE, onMinutesStepperChange, false );
					break;
				}
				case secondsStepper :
				{
					secondsStepper.removeEventListener( Event.CHANGE, onSecondsStepperChange, false );
					break;
				}
				case millisecondsStepper :
				{
					millisecondsStepper.removeEventListener( Event.CHANGE, onMillisecondsStepperChange, false );
					break;
				}
			}
		}
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Event Listeners
		//
		//--------------------------------------------------------------------------
			
		/**
		 *  @private
		 */
		private function onHoursStepperChange( event:Event ):void
		{
			_date.hours = hoursStepper.value;
			updateMeridiemDisplay();
			
			dispatchEvent( event );
		}
		
		/**
		 *  @private
		 */
		private function onMinutesStepperChange( event:Event ):void
		{
			if( _date.minutes == 59 && minutesStepper.value == 0 ) hours++;
			if( _date.minutes == 0 && minutesStepper.value == 59 ) hours = hours == 0 ? 23 : hours - 1;
			_date.minutes = minutesStepper.value;
			updateMeridiemDisplay();
			
			dispatchEvent( event );
		}
		
		/**
		 *  @private
		 */
		private function onSecondsStepperChange( event:Event ):void
		{
			if( _date.seconds == 59 && secondsStepper.value == 0 ) minutes++;
			if( _date.seconds == 0 && secondsStepper.value == 59 ) minutes = minutes == 0 ? 59 : minutes - 1;
			_date.seconds = secondsStepper.value;
			updateMeridiemDisplay();
			
			dispatchEvent( event );
		}
		
		/**
		 *  @private
		 */
		private function onMillisecondsStepperChange( event:Event ):void
		{
			if( _date.milliseconds == 999 && secondsStepper.value == 0 ) seconds++;
			if( _date.milliseconds == 0 && secondsStepper.value == 999 ) seconds = seconds == 0 ? 59 : seconds--;
			_date.milliseconds = millisecondsStepper.value;
			updateMeridiemDisplay();
			
			dispatchEvent( event );
		}
	}
}