package com.quilombo.constructors
{

	import flash.events.EventDispatcher;
	import flash.events.Event;

	import com.quilombo.constructors.PatternNameEvent;

	public class ConstructorEventDispatcher extends EventDispatcher 
	{
    		public static var CLICK:String = "constructorclicked";
		public static var MOUSE_OVER:String = "constructorover";
		public static var MOUSE_OUT:String = "constructorout";

    		public function onClick(patternName:String, patternId:int):void 
		{
        		dispatchEvent(new PatternNameEvent(ConstructorEventDispatcher.CLICK, patternName, patternId));
    		}

		public function onMouseOver(patternName:String, patternId:int):void 
		{
        		dispatchEvent(new PatternNameEvent(ConstructorEventDispatcher.MOUSE_OVER, patternName, patternId));
    		}

		public function onMouseOut(patternName:String, patternId:int):void 
		{
        		dispatchEvent(new PatternNameEvent(ConstructorEventDispatcher.MOUSE_OUT, patternName, patternId));
    		}
	}
}

