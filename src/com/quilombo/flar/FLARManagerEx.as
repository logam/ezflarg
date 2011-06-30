package com.quilombo.flar
{
	import flash.events.Event;
	
	import com.transmote.flar.FLARManager;
	import com.transmote.flar.IFLARSource;

	public class FLARManagerEx extends FLARManager
	{
		protected var _frameCount:uint = 0;
		protected var _skipFrames:uint = 0;

		public function FLARManagerEx(cameraParamsPath:String, patterns:Array/*:Vector.<FLARPattern>*/, source:IFLARSource=null)
		{
			trace("FLARManagerEx() cameraParamsPath[" + cameraParamsPath + "]");
			super( cameraParamsPath, patterns, source );
		}
	
		/**
			this function calls the super class function onEnterFrame 
			but it limits the calls to a fraction set by skipFrame

			this feature can be used in order to reduce cpu load, especially
			on mobile devices where marker detection on every frame reduces
			application speed drastically. 
		*/

		protected override function onEnterFrame (evt:Event) :void 
		{
			// trace("FLARManagerEx::onEnterFrame framecount [" + _frameCount + "] skipframes [" + _skipFrames + "]");
			if (!this.updateSource()) 
			{ 
				return; 
			}

			if( _frameCount == _skipFrames )
			{	
				_frameCount = 0;
				this.detectMarkers();			
			}
			else
			{
				_frameCount++;
			}
		}
	
		/**
			if this function is not called or called with 0, no frames are skipped and marker detection
			is performed at every frame

			otherwise, the given number determines how many frames are skipped, where then no marker detection
			is performed. 

			if 4 frames are requested to be skipped, marker detection just occurs every 5th frame. the follwing
			4 frames are skipped again, thus no detection takes place, and so on 
		*/
		public function set skipFrames( numFrames:uint):void
		{
			_skipFrames = numFrames;
		}

		public function get skipFrames():uint
		{
			return _skipFrames;
		}
	}
}
