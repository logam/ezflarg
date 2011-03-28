package com.quilombo
{	
	/**
		just a class that holds some configuration values and provides the
		corresponding getter and setter methods.
	*/
	public class ConfigHolder
	{
		protected var _objects:Array 		= new Array;
		protected var _width:int 		= 0;
		protected var _height:int 		= 0;
		protected var _frameRate:Number 	= 0;
		protected var _downsampleRatio:Number 	= 0;
		protected var _patternResolution:uint 	= 0;
		protected var _patternThreshold:uint 	= 0;
		protected var _mirror:Boolean 		= false;

		public function get objects		():Array { return _objects; } 
		public function get width		():int { return _width; }
		public function get height		():int { return _height; }
		public function get frameRate		():Number { return _frameRate; }
		public function get downsampleRatio	():Number { return _downsampleRatio; }
		public function get patternResolution	():uint { return _patternResolution; }
		public function get patternThreshold	():uint { return _patternThreshold; }
		public function get mirror		():Boolean { return _mirror; }

		public function set objects		( value:Array ):void 	{ _objects = value; } 
		public function set width		( value:int ):void 	{ _width  = value; }
		public function set height		( value:int ):void 	{ _height  = value; }
		public function set frameRate		( value:Number ):void 	{ _frameRate  = value; }
		public function set downsampleRatio	( value:Number ):void 	{ _downsampleRatio  = value; }
		public function set patternResolution	( value:uint ):void 	{ _patternResolution  = value; }
		public function set patternThreshold	( value:uint ):void 	{ _patternThreshold  = value; }
		public function set mirror		( value:Boolean ):void 	{ _mirror  = value; }
	}
}
