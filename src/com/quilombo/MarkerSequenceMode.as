package com.quilombo
{
	import com.transmote.flar.FLARMarkerEvent;

	import com.quilombo.IMode;
	import com.quilombo.MarkerModeBase;

	public class MarkerSequenceMode extends MarkerModeBase implements IMode  
	{
		protected var _messageAlreadyDetected:String;
		protected var _messagePreviouslyDetected:String;
		protected var _messageNotNextInSequence:String;

		protected var _funcMarkerAlreadyDetected:Function;
		protected var _funcMarkerPreviouslyDetected:Function;
		protected var _funcMarkerNotNextInSequence:Function;
		protected var _funcMarkerDetected:Function;

		protected var _currentMarkerIndex:int = -1;
		protected var _markerSequence:Array;
		/**

		*/
		public function MarkerSequenceMode():void
		{
			super();	// call baseclass constructor
		}

		public function get numItems():int
		{
			return _markerSequence.length;
		}
		
		/**	start a new marker sequence and delete the old one. the new sequence determines
			in which order the markers must be detected
		*/
		public function newSequence():void
		{
			_markerSequence = new Array();
			_currentMarkerIndex = -1;
		}

		/**	add a new marker to the sequence
		*/
		public function nextInSequence(patternName:String):void
		{
			if(_markerSequence!=null)
			{	
				if( _markerSequence.indexOf(patternName) == -1 )
				{	
					_markerSequence.push(patternName);
					trace("MarkerSequenceMode::nextInSequence(): added pattern [" + patternName + "]");
				}
				else
				{
					trace("MarkerSequenceMode::nextInSequence(): pattern was already added [" + patternName + "] and cannot be added again. check your sequence definition.");
				}
			}
		}
		
		/**	can be called when a marker was detected. pass the marker label as argument.
			the function will detected if the detected marker is the next one in the marker
			sequence. 

			In case it is the next one: 
				the callback function set in onDetection gets invoked (if available) 
				with a DetectMarkerEvent that corresponds to the marker label

			In case it is the current one again:
				the callback function set in onMarkerAlreadyDetected gets invoked (if available) 
				with an error message	

			In case it is one of the previously detected without the current one:
				the callback function set in onMarkerPreviouslyDetected gets invoked (if available) 
				with an error message

			In case it is one of the future markers but not the next one in the sequence:
				the callback function set in onNotNextInSequence gets invoked (if available) 
				with an error message.
		*/
		public function detected ( markerName:String, event:FLARMarkerEvent ):FLARMarkerEvent
		{
			// find current marker in sequence
			var newMarkerIndex:int = _markerSequence.indexOf(markerName);

			// is this the first marker to detect or the next in the sequence?
			if( newMarkerIndex == _currentMarkerIndex+1 )
			{
				event = callMarkerDetected(markerName, event);	
				_currentMarkerIndex = newMarkerIndex;
			}
			else
			{
				// is the same marker detected?
				if( newMarkerIndex == _currentMarkerIndex )
				{
					event = callMarkerAlreadyDetected(markerName, event, _messageAlreadyDetected);	
				}
			
				// is a future marker detected (but not the next one)?
				if( newMarkerIndex > _currentMarkerIndex+1)
				{
					event = callMarkerNotNextInSequence(markerName, event, _messageNotNextInSequence);	
				}
			
				// is a previous marker detected?
				if( newMarkerIndex < _currentMarkerIndex )
				{
					event = callMarkerPreviouslyDetected(markerName, event, _messagePreviouslyDetected);	
				}
			}

			return event;
		}

		protected function callMarkerNotNextInSequence(markerName:String, event:FLARMarkerEvent, message:String ):FLARMarkerEvent
		{
			// is the detected marker one of the future markers
			if(_funcMarkerNotNextInSequence != null )
			{			
				event = _funcMarkerNotNextInSequence(markerName, event, message);
			}
			return event;
		}

		protected function callMarkerAlreadyDetected(markerName:String, event:FLARMarkerEvent, message:String ):FLARMarkerEvent
		{
			// is the detected marker the currently detected marker again
			if( _funcMarkerAlreadyDetected != null )
			{			
				event = _funcMarkerAlreadyDetected(markerName, event, message);
			}
			return event;
		}

		protected function callMarkerPreviouslyDetected(markerName:String, event:FLARMarkerEvent, message:String ):FLARMarkerEvent
		{
			// is the detected marker one of the previously detected markers
			if(_funcMarkerPreviouslyDetected != null )
			{			
				event = _funcMarkerPreviouslyDetected(markerName, event, message);
			}
			return event;
		}

		protected function callMarkerDetected(markerName:String, event:FLARMarkerEvent ):FLARMarkerEvent
		{
			// is the detected marker the next one in the sequence
			if( _funcMarkerDetected != null )
			{			
				event = _funcMarkerDetected(markerName, event);
			}
			return event;
		}

		/**
			callback for the case the last detected marker gets detected again

			function signature must be
			function(markerName:String, event:FLARMarkerEvent, message:String):FLARMarkerEvent
		*/
		public function onMarkerAlreadyDetected( callback:Function ):void
		{
			_funcMarkerAlreadyDetected = callback;
		}

		/**
			callback for the case on of the previously detected markers 
			(except the last one) gets detected again

			function signature must be
			function(markerName:String, event:FLARMarkerEvent, message:String):FLARMarkerEvent
		*/
		public function onMarkerPreviouslyDetected( callback:Function ):void
		{
			_funcMarkerPreviouslyDetected = callback;
		}

		/**
			callback for the case one of the future markers (except the next one)
			gets detected

			function signature must be
			function(markerName:String, event:FLARMarkerEvent, message:String):FLARMarkerEvent
		*/
		public function onNotNextInSequence( callback:Function ):void
		{
			_funcMarkerNotNextInSequence = callback;
		}

		/**	callback for the case the right marker, the next one in the sequence, 
			gets detected.

			function signature must be
			function(markerName:String, event:FLARMarkerEvent):FLARMarkerEvent
		*/
		public function onDetection ( callback:Function ):void
		{
			_funcMarkerDetected = callback;
		}

		/**	the message send to the onNotNextInSequence callback function
		*/
		public function messageNotNextInSequence ( message:String ):void
		{
			_messageNotNextInSequence = message;
		}		
		
		/**	the message send to the onMarkerPreviouslyDetected callback function
		*/
		public function messagePreviouslyDetected ( message:String ):void
		{
			_messagePreviouslyDetected = message;
		}

		/**	the message send to the onMarkerAlreadyDetected callback function
		*/		
		public function messageAlreadyDetected ( message:String ):void
		{
			_messageAlreadyDetected = message;
		}	
	}
}
