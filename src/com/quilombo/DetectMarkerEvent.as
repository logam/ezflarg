package com.quilombo
{
	import flash.events.Event;

	public class DetectMarkerEvent extends Event
	{
		protected var _markerLabel:String;
		protected var _action:String;
		
		public function DetectMarkerEvent( type:String, markerLabel:String, action:String, bubbles:Boolean = false, cancelable:Boolean = false )
		{
			super(type, bubbles, cancelable);
			_markerLabel = markerLabel;
			_action = action;
		}

		public function addTextAction( type:String, content:String ):void
		{}

		public function addMediaAction( content:String ):void
		{}

		public override function clone():Event
		{
			return new DetectMarkerEvent(type, _markerLabel, _action, bubbles, cancelable);
		}

		public function set markerLabel( value:String ):void
		{
			_markerLabel = value;
		}

		public function set action ( value:String ):void
		{
			_action = value;
		}

		public function get markerLabel():String
		{
			return _markerLabel;
		}

		public function get action():String
		{
			return _action;
		}
	}
}
