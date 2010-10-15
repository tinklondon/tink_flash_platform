package ws.tink.spark.core
{
	
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.StatusEvent;
	import flash.events.TimerEvent;
	import flash.net.LocalConnection;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	
	import flashx.textLayout.conversion.ConversionType;
	import flashx.textLayout.conversion.ITextExporter;
	import flashx.textLayout.conversion.TextConverter;
	import flashx.textLayout.elements.TextFlow;
	
	import spark.components.TextArea;
	import spark.components.supportClasses.ButtonBarBase;
	import spark.events.IndexChangeEvent;
	
	import ws.tink.spark.core.NavigatorApplication;
	import ws.tink.spark.slides.ISlide;
	
	
	public class Presentation extends NavigatorApplication
	{
		
		[SkinPart(required="false")]
		public var navigatorControl	: ButtonBarBase;
		
		[SkinPart(required="false")]
		public var notes	: TextArea;
		
		private var _stage	: Stage;
		
		private var sender:LocalConnection;
		private var reciever:LocalConnection;
		
		private var success:Boolean;
		private var _timer:Timer;
		
		
		public function Presentation()
		{
			addEventListener( Event.ADDED_TO_STAGE, onAddedToStage, false, 0, true );
		}
		
		public function recieveSlideNum( value:Number ):void
		{
			selectedIndex = value;
		}
		
		private var _notesTextFlow	: TextFlow;
		private function sendNotes():void
		{
			if( !_notesTextFlow ) _notesTextFlow = new TextFlow();
			//			textFlow.whiteSpaceCollapse = getStyle("whiteSpaceCollapse");
			_notesTextFlow.mxmlChildren = ISlide( getItemAt( selectedIndex ) ).notes as Array;
			
			_notesTextFlow.whiteSpaceCollapse = undefined;
			
			dispatchEvent( new Event( "change" ) );
			
			var textExporter:ITextExporter = TextConverter.getExporter( TextConverter.TEXT_LAYOUT_FORMAT );
			var exported:Object = textExporter.export( _notesTextFlow, ConversionType.STRING_TYPE );
			
			var byteArray:ByteArray = new ByteArray();
			byteArray.writeObject( exported );
			
			if( notes ) notes.textFlow = _notesTextFlow;
			
			if( sender ) sender.send( "slidesToPresenter", "recieveNotes", byteArray, selectedIndex );
		}
		
		private function sendScrollSettings():void
		{
			var string:String = "";
			var numItems:int = length;
			for( var i:int = 0; i < numItems; i++ )
			{
				if( i > 0 ) string += "::";
				string += ISlide( getItemAt( i ) ).label;
				
			}
			sender.send( "slidesToPresenter", "recieveScrollSettings", string );
		}
		
		
		
		private function onAddedToStage( event:Event ):void
		{
			removeEventListener( Event.ADDED_TO_STAGE, onAddedToStage, false );
			addEventListener( Event.REMOVED_FROM_STAGE, onRemovedFromStage, false, 0, true );
			
			_stage = stage;
			_stage.addEventListener( KeyboardEvent.KEY_DOWN, onKeyDown, false, 0, true );
		}
		
		private function onRemovedFromStage( event:Event ):void
		{
			_stage.removeEventListener( KeyboardEvent.KEY_DOWN, onKeyDown, false );
			_stage = null;
			
			removeEventListener( Event.ADDED_TO_STAGE, onAddedToStage, false );
			addEventListener( Event.ADDED_TO_STAGE, onAddedToStage, false, 0, true );
		}
		
		private var _nextKey:uint = 39;
		public function get nextKey():uint
		{
			return _nextKey;
		}
		public function set nextKey( value:uint ):void
		{
			_nextKey = value;
		}
		
		private var _previousKey:uint = 37;
		public function get previousKey():uint
		{
			return _previousKey;
		}
		public function set previousKey( value:uint ):void
		{
			_previousKey = value;
		}
		
		private var _toggleNotesKey:uint = 78;
		public function get toggleNotesKey():uint
		{
			return _toggleNotesKey;
		}
		public function set toggleNotesKey( value:uint ):void
		{
			_toggleNotesKey = value;
		}
		
		private var _toggleButtonBarKey:uint = 83;
		public function get toggleButtonBarKey():uint
		{
			return _toggleButtonBarKey;
		}
		public function set toggleButtonBarKey( value:uint ):void
		{
			_toggleButtonBarKey = value;
		}
		
		private function onKeyDown( event:KeyboardEvent ):void
		{
			switch( event.keyCode )
			{
				case _toggleButtonBarKey :
				{
					if( navigatorControl ) navigatorControl.visible = !navigatorControl.visible;
					break;
				}
				case _toggleNotesKey :
				{
					if( notes ) notes.visible = !notes.visible;
					break;
				}
				case _previousKey :
				{
					if( contentGroup.selectedIndex > 0 ) contentGroup.selectedIndex--;
					break;
				}
				case _nextKey :
				{
					if( contentGroup.selectedIndex < contentGroup.length - 1 ) contentGroup.selectedIndex++;
					break;
				}
			}
		}
		
		private function onContentGroupChange( event:IndexChangeEvent ):void
		{
			sendNotes();
		}
		
		private function createLC():void
		{
			reciever = new LocalConnection();
			reciever.client = this;
			try
			{
				reciever.connect( "presenterToSlides" );
			}
			catch (error:ArgumentError)
			{
				trace("Can't connect...the connection name is already being used by another SWF");
			}
			
			sender = new LocalConnection();
			sender.addEventListener( StatusEvent.STATUS, onStatus );
			
			_timer = new Timer( 500 );
			_timer.addEventListener( TimerEvent.TIMER, onTimerTick, false, 0, true );
			_timer.start();
		}
		
		private function onTimerTick( event:TimerEvent ):void
		{
			sender.send( "slidesToPresenter", "testConnection", "testConnection dddd" );
		}
		
		private function onStatus( event:StatusEvent ):void
		{
			switch (event.level)
			{
				case "status":
				{
					if( !success )
					{
						_timer.stop();
						success = true;
						sendNotes();
						sendScrollSettings();
					}
					break;
				}
			}
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			
			if( !reciever ) createLC();
		}
		
		override protected function partAdded( partName:String, instance:Object ):void
		{
			super.partAdded( partName, instance );
			
			if( instance == contentGroup )
			{
				contentGroup.addEventListener( IndexChangeEvent.CHANGE, onContentGroupChange, false, 0, true );
			}
		}
		
		override protected function partRemoved( partName:String, instance:Object ):void
		{
			super.partRemoved( partName, instance );
			
			if( instance == contentGroup )
			{
				contentGroup.removeEventListener( IndexChangeEvent.CHANGE, onContentGroupChange, false );
			}
		}
	}
	
}