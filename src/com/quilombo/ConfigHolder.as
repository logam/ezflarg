package com.quilombo
{	
	import mx.utils.ObjectUtil;

	/**
		just a class that holds some configuration values and provides the
		corresponding getter and setter methods.
	*/
	public class ConfigHolder
	{
		protected var _objects:Array 			= new Array;
		protected var _width:int 			= 0;	// in pixels
		protected var _height:int 			= 0;	// in pixels
		protected var _frameRate:Number 		= 0;	// in frames per second
		protected var _downsampleRatio:Number 		= 0;	// as percentage: 0-1
		protected var _patternThreshold:uint 		= 0;	// from 0 to 255
		protected var _patternResolution:uint 		= 0;	// in segments: 4, 8, 16, 32, 64
		protected var _mirror:Boolean 			= false;// true or false
		protected var _patternToBorderRatio:Number 	= 0;	// as percentage: 0-1
		protected var _unscaledMarkerWidth:Number 	= 0;	// in pixels
		protected var _patternMinConfidence:Number 	= 0;	// as percentage: 0-1
		protected var _markerUpdateThreshold:Number	= 0;	// in pixels
		protected var _contentPath:String;			// path to the models and content to display

		public function get objects			():Array { return _objects; } 
		public function get width			():int { return _width; }
		public function get height			():int { return _height; }
		public function get frameRate			():Number { return _frameRate; }
		public function get downsampleRatio		():Number { return _downsampleRatio; }
		public function get patternResolution		():uint { return _patternResolution; }
		public function get patternThreshold		():uint { return _patternThreshold; }
		public function get patternToBorderRatio	():Number { return _patternToBorderRatio; }
		public function get patternMinConfidence	():Number { return _patternMinConfidence; }
		public function get unscaledMarkerWidth 	():Number { return _unscaledMarkerWidth; } 		
		public function get mirror			():Boolean { return _mirror; }
		public function get markerUpdateThreshold	():Number { return _markerUpdateThreshold; }
		public function get contentPath			():String { return _contentPath; }

		public function set objects			( value:Array ):void 	{ _objects = value; } 
		public function set width			( value:int ):void 	{ _width  = value; }
		public function set height			( value:int ):void 	{ _height  = value; }
		public function set frameRate			( value:Number ):void 	{ _frameRate  = value; }
		public function set downsampleRatio		( value:Number ):void 	{ _downsampleRatio  = value; }
		public function set patternResolution		( value:uint ):void 	{ _patternResolution  = value; }
		public function set patternThreshold		( value:uint ):void 	{ _patternThreshold  = value; }
		public function set patternToBorderRatio	( value:Number):void	{ _patternToBorderRatio = value; }
		public function set patternMinConfidence	( value:Number):void	{ _patternMinConfidence = value; }
		public function set unscaledMarkerWidth 	( value:Number):void	{ _unscaledMarkerWidth = value; }
		public function set mirror			( value:Boolean ):void 	{ _mirror  = value; }
		public function set markerUpdateThreshold	( value:Number ):void 	{ _markerUpdateThreshold = value; }
		public function set contentPath			( value:String):void	{ _contentPath = value; }

		public function asString():String
		{
			return    "ConfigLoaderXML::trace: \n" 
				+ "screen width [" + width + "]\n"
				+ "screen height [" + height + "]\n"
				+ "frame rate [" + frameRate + "]\n"
				+ "mirror [" + mirror + "]\n"
				+ "downsample ratio [" + downsampleRatio + "]\n"
				+ "unscaled marker width [" + unscaledMarkerWidth + "]\n"
				+ "pattern resolution [" + patternResolution + "]\n"
				+ "pattern threshold [" + patternThreshold + "]\n"
				+ "pattern to border ratio [" + patternToBorderRatio + "]\n"
				+ "pattern min confidence [" + patternMinConfidence + "]\n"
				+ "marker update threshold [" + markerUpdateThreshold + "]"
				+ "content path [" + contentPath + "]";

		}
	}
}
