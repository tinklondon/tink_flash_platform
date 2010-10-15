package ws.tink.spark.core
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.events.StatusEvent;
	import flash.events.TimerEvent;
	import flash.net.LocalConnection;
	import flash.ui.ContextMenuItem;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	
	import flashx.textLayout.conversion.ConversionType;
	import flashx.textLayout.conversion.ITextExporter;
	import flashx.textLayout.conversion.TextConverter;
	import flashx.textLayout.elements.TextFlow;
	
	import mx.core.IMXMLObject;
	import mx.core.ISelectableList;
	import mx.events.FlexEvent;
	
	import slides.Slide;
	
	import spark.components.Application;
	import spark.components.DataGroup;
	import spark.events.IndexChangeEvent;
	
	import ws.tink.spark.layouts.StackLayout;
	import ws.tink.spark.layouts.supportClasses.NavigatorLayoutBase;

	public class PresentationConnectionManager extends EventDispatcher
	{
		
		private var sender:LocalConnection;
		private var reciever:LocalConnection;
		private var success:Boolean;
		private var _timer:Timer;
		private var _notesTextFlow	: TextFlow;
		
		private var _slides		: ISelectableList;
		
//		private var _application	: SlideView;
		
		public function PresentationConnectionManager()
		{
			
		}
		
//		private var _document:Object;
//		public function initialized(document:Object, id:String):void
//		{
////			_application = SlideView( document );
//			_document = document;
//			_document.addEventListener( FlexEvent.CREATION_COMPLETE, onCreationComplete, false, 0, true );
//			
//		}
		
//		private function onCreationComplete( event:Event ):void
//		{
//			if( _document.viewSourceURL ) ContextMenuItem( _document.contextMenu.customItems[ 0 ] ).caption = "View Presentation Source";
//			
//			_document.addEventListener( Event.ADDED_TO_STAGE, onAddedToStage, false, 0, true );
//			
//			if( !reciever ) createLC();
//		}
//		
//		private function onAddedToStage( event:Event ):void
//		{
//			_document.stage.addEventListener( KeyboardEvent.KEY_DOWN, onKeyDown, false, 0, true );
//		}
		
		private function onKeyDown( event:KeyboardEvent ):void
		{
			switch( event.keyCode )
			{
				case 83 :
				{
					if( _document.navigatorControl ) _document.navigatorControl.visible = !_document.navigatorControl.visible;
//					_application.scroller.setStyle( "horizontalScrollPolicy", ( _application.scroller.getStyle( "horizontalScrollPolicy" ) == "off" ) ? "auto" : "off" );
					break;
				}
				case 78 :
				{
					if( _document.notes ) _document.notes.visible = !_document.notes.visible;
					break;
				}
				case 37 :
				{
					if( _slides.selectedIndex > 0 ) _slides.selectedIndex--;
					break;
				}
				case 39 :
				{
					if( _slides.selectedIndex < _slides.length - 1 ) _slides.selectedIndex++;
					break;
				}
			}
		}

		[Bindable( event="change" )]
		public function get notesTextFlow():TextFlow
		{
			return _notesTextFlow;
		}
		
		public function set slides( value:ISelectableList ):void
		{
			if( _slides == value ) return;
			
			_slides = value;
			_slides.addEventListener( IndexChangeEvent.CHANGE, onSlidesChange, false, 0, true );
		}
		
		public function recieveSlideNum( value:Number ):void
		{
			//				text.text = value;
			_slides.selectedIndex = value;
		}
		
		public function testConnection( value:String ):void
		{
			
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
		
		private function onStatus(event:StatusEvent):void
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
		
		
		
		private function sendNotes():void
		{
			if( !_notesTextFlow ) _notesTextFlow = new TextFlow();
//			textFlow.whiteSpaceCollapse = getStyle("whiteSpaceCollapse");
			_notesTextFlow.mxmlChildren = Slide( _slides.getItemAt( _slides.selectedIndex ) ).notes as Array;
			
			_notesTextFlow.whiteSpaceCollapse = undefined;
			
			dispatchEvent( new Event( "change" ) );
			
			var textExporter:ITextExporter = TextConverter.getExporter( TextConverter.TEXT_LAYOUT_FORMAT );
			var exported:Object = textExporter.export( _notesTextFlow, ConversionType.STRING_TYPE );
			
			var byteArray:ByteArray = new ByteArray();
			byteArray.writeObject( exported );
			
			if( _document.notes ) _document.notes.textFlow = notesTextFlow;
			
			if( sender ) sender.send( "slidesToPresenter", "recieveNotes", byteArray, _slides.selectedIndex );
		}
		
		private function sendScrollSettings():void
		{
			var string:String = "";
			var numItems:int = _slides.length;
			for( var i:int = 0; i < numItems; i++ )
			{
				if( i > 0 ) string += "::";
				string += Slide( _slides.getItemAt( i ) ).label;
				
			}
			sender.send( "slidesToPresenter", "recieveScrollSettings", string );
		}
		
		protected function onSlidesChange(event:Event):void
		{
			sendNotes();
		}
	}
}