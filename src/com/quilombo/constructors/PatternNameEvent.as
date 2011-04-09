package com.quilombo.constructors
{
	import flash.events.EventDispatcher;
	import flash.events.Event;

	import com.quilombo.constructors.PatternNameEvent;

	public class PatternNameEvent extends Event 
	{
   		private var _patternName:String;
		private var _patternId:int;
   
		public function PatternNameEvent(type:String, name:String, id:int, bubbles:Boolean = false, cancelable:Boolean = false):void
		{
			super(type, bubbles, cancelable);
			_patternName = name;
			_patternId = id;
		}

		public function get patternName():String
		{
			return _patternName;
		}

		public function get patternId():int
		{
			return _patternId;
		}

  		public override function clone():Event 
		{
        		return new PatternNameEvent(type, patternName, patternId, bubbles, cancelable);
		}
     	}
}
