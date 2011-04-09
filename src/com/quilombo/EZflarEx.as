package com.quilombo
{
	import flash.events.Event;
	import flash.media.Camera;

	import com.tchatcho.constructors.URLconstructor;
	import com.tchatcho.Base_model;
	import com.tchatcho.EZflar;

	import com.quilombo.ConfigHolder;
	import com.quilombo.BaseModelEx;
	import com.quilombo.constructors.LoadingEzflarEx;
	
	import com.quilombo.constructors.ConstructorEventDispatcher;
	import com.quilombo.constructors.PatternNameEvent;

	public class EZflarEx extends EZflar
	{
		protected var _dispatcher:ConstructorEventDispatcher = new ConstructorEventDispatcher();

		protected var _funcMarkerClicked:Function;
		protected var _funcMarkerMouseOver:Function;
		protected var _funcMarkerMouseOut:Function;
	
		public function EZflarEx ( configuration:ConfigHolder )
		{
			super	( configuration.objects
				, configuration.width
				, configuration.height
				, configuration.frameRate
				, configuration.downsampleRatio
				, configuration.patternResolution
				, configuration.patternThreshold
				, configuration.mirror
				, configuration.patternToBorderRatio
				, configuration.unscaledMarkerWidth
				, configuration.patternMinConfidence
				, configuration.markerUpdateThreshold
				);
		}

		protected function markerClicked (event:PatternNameEvent) :void 
		{
			if (_funcMarkerClicked != null)
			{
				_funcMarkerClicked(event);
			}
		}
		
		protected function markerMouseOver (event:PatternNameEvent) :void 
		{
			if (_funcMarkerMouseOver != null)
			{
				_funcMarkerMouseOver(event);
			}
		}

		protected function markerMouseOut (event:PatternNameEvent) :void 
		{
			if (_funcMarkerMouseOut != null)
			{
				_funcMarkerMouseOut(event);
			}
		}

		public function onMarkerClicked(func:Function):void
		{
			_funcMarkerClicked = func;
		}

		public function onMarkerMouseOver(func:Function):void
		{
			_funcMarkerMouseOver = func;
		}

		public function onMarkerMouseOut(func:Function):void
		{
			_funcMarkerMouseOut = func;
		}

		private function onFlarManagerInitiated (evt:Event) :void 
		{
			// register three event handlers that gets invoked on mouse interaction with a detected marker
			_dispatcher.addEventListener( ConstructorEventDispatcher.CLICK, markerClicked);
			_dispatcher.addEventListener( ConstructorEventDispatcher.MOUSE_OVER, markerMouseOver);
			_dispatcher.addEventListener( ConstructorEventDispatcher.MOUSE_OUT, markerMouseOut);

			super.base_model = new BaseModelEx(	super._objects,
								super.patterns.length,
								super.flarManager.cameraParams,
								viewWidth(),
								viewHeight(),
								super._pathToResources,
								PATH_TO_MODELS,
								_dispatcher,
								new LoadingEzflarEx());
			super.addChild(super.base_model);
			
			if (super._funcStarted != null){
				super._funcStarted();
			}
		}

		protected override function init () :void 
		{	
			// call base class first
			super.init();

			// only remove listeners if camera is availble. otherwise, the event listeners are
			// not registered. 
			if( isCameraAvailable() )
			{
				// set the pattern brightness threshold
				super.flarManager.threshold = super._patternThreshold;
			
				// remove the init event listener registered by the base class and register the one of this class 
				// which uses the extended version of the Base_model > BaseModelEx
				flarManager.removeEventListener(Event.INIT, super.onFlarManagerInited);				
				flarManager.addEventListener(Event.INIT, this.onFlarManagerInitiated);
			}
		}
	}
} 
