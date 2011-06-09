/* 
 * EZFLAR v. 0.1 (beta)
 * http://www.ezflar.com
 * Copyright 2009, tcha-tcho
 * --------------------------------------------------------------------------------
 * EZFLAR is based in the Example developed by Eric Socolofsky in FLARManager.
 * This sofware attempt to wrap 3 great codes to provide a quick way to work:
 * FLARManager(c), developed by Eric Socolofsky
 * FLARToolkit(c), developed by Saqoosha as part of the Libspark project.
 * PaperVision3D(c), developed by PV3D team
 *
 * Bla bla bla bla this is under GPL... bla bla
 *
 *	http://www.tcha-tcho.com
 *  hey! fork this at http://www.github.com/
 * 
 */
package com.tchatcho {
	import com.transmote.flar.FLARCameraSource;
	import com.transmote.flar.FLARLoaderSource;
	import com.transmote.flar.FLARManager;
	import com.transmote.flar.FLARMarkerEvent;
	import com.transmote.flar.FLARPattern;
	import com.transmote.flar.IFLARSource;
	import com.transmote.utils.time.FramerateDisplay;

	import flash.display.Sprite;
	import flash.events.Event;

	import com.tchatcho.Base_model;
	import flash.media.Camera;
	import flash.events.*;
    	import com.tchatcho.NoCamera;

	//to handle objects from outside
	import com.transmote.flar.FLARMarker;
	import org.papervision3d.objects.DisplayObject3D;
	
	//TODO: Loading all code, loading each model working

	[SWF(width="640", height="480", frameRate="30", backgroundColor="#FFFFFF")]
	public class EZflar extends Sprite 
	{
		//defaults paths to assets inside resources folder
		
		/*private*/ protected static const PATH_TO_MODELS:String = "models/";
		/*private*/ protected static const CAMERA_PARAMS_PATH:String = "flar/FLARparams.dat";
		/*private*/ protected static const PATTERN_PATH:String = "flar/patterns/";
		// private static const PATTERN_RESOLUTION:uint = 16;

		/*private*/ protected var patterns:Array;
		/*private*/ protected var flarManager:FLARManager;
		/*private*/ protected var flarLoader:FLARLoaderSource;
		/*private*/ protected var base_model:Base_model;
		/*private*/ protected var _camSource:FLARCameraSource;
		/*private*/ protected var _objects:Array;
		
		private var _width:int;
		private var _height:int;
		private var _frameRate:Number;
		private var _downSampleRatio:Number;
		private var _isMirrored:Boolean = false;
		private var _noCamMessage:String = "Sorry ;( ... we need a cam";
		private var _noCamColorTxt:uint = 0x00FF00;
		private var _noCamColorBackground:uint = 0xCCFFCC;
		private var _nocam:NoCamera;
		
		/*private*/protected var _pathToResources:String = new String();
		
		protected var _patternResolution:uint 		= 16;
		protected var _patternThreshold:uint		= 80;
		protected var _patternToBorderRatio:Number 	= 50;
		protected var _unscaledMarkerWidth:Number 	= 80;
		protected var _minConfidence:Number 		= 0.5;
		protected var _markerUpdateThreshold:Number	= 20;

		/*private*/ protected var _funcStarted:Function;
		/*private*/ protected var _funcAdded:Function;
		/*private*/ protected var _funcUpdated:Function;
		/*private*/ protected var _funcRemoved:Function;


		public function EZflar  ( objects:Array
					, width:int = 640
					, height:int = 480
					, frameRate:Number = 30
					, downSampleRatio:Number = 0.5
					, res:uint = 16
					, thresh:uint = 20
					, mirror:Boolean = true
					, patternToBorderRatio:Number = 50
					, unscaledMarkerWidth:Number = 80
					, minConfidence:Number = 0.5
					, markerUpdateThreshold:Number = 20
					)
		{
			_width 			= width;
			_height 		= height;
			_frameRate 		= frameRate;
			_downSampleRatio	= downSampleRatio;
			_objects 		= objects;
			_patternResolution 	= res;
			_patternThreshold 	= thresh;
			_isMirrored		= mirror;
			_patternToBorderRatio	= patternToBorderRatio;
			_unscaledMarkerWidth	= unscaledMarkerWidth;
			_markerUpdateThreshold	= markerUpdateThreshold;
			_minConfidence		= minConfidence;
		}

		public function initializer(theStage:*, newPath:String = "./resources/"):void
		{
			this._pathToResources = newPath;
			this.init();
			theStage.addChild(this);
		};

		/*private*/ protected function init () :void 
		{
			trace("[EZflar::init] EZFLAR 0.1(beta) is running!  :)\n keep calm and look busy!\n");
			if( !isCameraAvailable() ) 
			{
				trace("[EZflar::init] no camera available");
								
				_nocam = new NoCamera(
					_width,_height, _noCamMessage, _noCamColorTxt, _noCamColorBackground );				
				this.addChild(_nocam);
			} 
			else 
			{
				trace("[EZflar::init] camera available");
				
				_camSource = new FLARCameraSource(_width, _height, _frameRate, _downSampleRatio)
				
				// build list of FLARPatterns for FLARToolkit to detect
				this.patterns = new Array();
				for (var i:int = 0; i < _objects.length; i++) 
				{
					if(_objects[i][0][2] == undefined)
					{
						_objects[i][0][2] = null
					}
					if(_objects[i][1] == undefined)
					{
						_objects[i][1] = null
					}
					var str:String = _objects[i][0][0] as String;
					trace("EZflar::init() pattern[" + str + "]");

					this.patterns.push(
    						  new FLARPattern(
							  _pathToResources + PATTERN_PATH + _objects[i][0][0]
							, _patternResolution
							, _patternToBorderRatio
							, _unscaledMarkerWidth
							, _minConfidence 
							)
						);
				}
				
				// use Camera (default)
				this.flarManager = createFlarManager(_pathToResources + CAMERA_PARAMS_PATH, patterns, _camSource);
				this.flarManager.markerUpdateThreshold = _markerUpdateThreshold;
				this.addChild(FLARCameraSource(this.flarManager.flarSource));

				// begin listening for FLARMarkerEvents
				this.flarManager.addEventListener(FLARMarkerEvent.MARKER_ADDED, this.onMarkerAdded);
				this.flarManager.addEventListener(FLARMarkerEvent.MARKER_UPDATED, this.onMarkerUpdated);
				this.flarManager.addEventListener(FLARMarkerEvent.MARKER_REMOVED, this.onMarkerRemoved);
				this.flarManager.addEventListener(Event.INIT, this.onFlarManagerInited);		
			}
			if(this._isMirrored == false)
			{
				trace("[EZflar::init] mirror");
				this.mirror();
			}
		}

		/**
			returns a FlarManagerObject. This method can be overridden in a subclass in order to create a custom FlarManager
		*/
		protected function createFlarManager(cameraParamsPath:String, patterns:Array, source:IFLARSource=null):FLARManager
		{
			trace("EZflar::createFlarManager cameraParamsPath[" + cameraParamsPath + "]");
			return new FLARManager(cameraParamsPath, patterns, source);
		}

		public function customizeNoCam(message:String, colorTxt:uint, colorBackground:uint):void
		{
			_noCamMessage 	= message;
			_noCamColorTxt 	= colorTxt;
			_noCamColorBackground = colorBackground;
			
			if( !isCameraAvailable() )
			{
				trace("[EZflar::customizeNoCam] no camera available");
				if( this.contains(_nocam) )
				{
					trace("[EZflar::customizeNoCam] remove nocam child");
					this.removeChild(_nocam);
				}
				_nocam = new NoCamera(_width,_height, _noCamMessage, _noCamColorTxt, _noCamColorBackground);
				trace("[EZflar::customizeNoCam] add nocam child");				
				this.addChild(_nocam);
			}			
		}
		public function mirror():void
		{
			if(this._isMirrored == false){
				this.scaleX = -1;
				this.x = _width;
				this._isMirrored = true;
			} else {
				this.scaleX = 1;
				this.x = 0;
				this._isMirrored = false;
			}
		};
		public function moveTo(x:Number = 640, y:Number = -1):void{
			this.x = x;
			this.y = y;
		}
		
		public function viewFrameRate():void{
			//build a frame display to watch performance
			var framerateDisplay:FramerateDisplay = new FramerateDisplay();
			this.stage.addChild(framerateDisplay);
		}
		/*private*/ protected function onFlarManagerInited (evt:Event) :void {
			this.base_model = new Base_model(_objects,
				this.patterns.length,
				this.flarManager.cameraParams,
				_width,
				_height,
				_pathToResources,
				PATH_TO_MODELS);
			this.addChild(this.base_model);
			if (_funcStarted != null){
				_funcStarted();
			}
		}

		/*private*/ protected function onMarkerAdded (evt:FLARMarkerEvent) :void {
			this.base_model.addMarker(evt.marker);
			if (_funcAdded != null){
				_funcAdded(evt);
			}
		}

		/*private*/ protected function onMarkerUpdated (evt:FLARMarkerEvent) :void {
			if (_funcUpdated != null){
				_funcUpdated(evt);
			}
		}

		/*private*/ protected function onMarkerRemoved (evt:FLARMarkerEvent) :void {
			this.base_model.removeMarker(evt.marker);
			if (_funcRemoved != null){
				_funcRemoved(evt);
			}
		}

		public function onStarted(func:Function):void{
			_funcStarted = func;
		}

		public function onAdded(func:Function):void{
			_funcAdded = func;
		}

		public function onUpdated(func:Function):void{
			_funcUpdated = func;
		}
		public function onRemoved(func:Function):void{
			_funcRemoved = func;
		}
		public function addModelTo(set1:Array, set2:Array = null):void
		{
			this.base_model.addModelToStage(set1, set2);
		}
		public function getObject(onMarker:int,thisName:String = "universe"):*{
			var arrToReturn:Array = new Array();
			arrToReturn = this.base_model.getObjectByName(onMarker,thisName);
			if(arrToReturn.length == 1){
				return arrToReturn[0];
			}else{
				return arrToReturn;
			};
		}

		public function viewWidth():int
		{
			return _width;
		}

		public function viewHeight():int
		{
			return _height;
		}

		public function get patternResolution():uint
		{
			return _patternResolution;
		}

		public function get patternThreshold():uint
		{
			return _patternThreshold;
		}

		public function set patternThreshold(value:uint):void
		{
			_patternThreshold = value;
		}

		public function set patternResolution(value:uint):void
		{
			_patternResolution = value;
		} 

		public function get availableCameras():Array
		{
			return Camera.names;
		}

		protected function isCameraAvailable():Boolean
		{
			return (Camera.names.length > 0)
		}
	}
}
