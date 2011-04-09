package com.quilombo
{
	import flash.events.Event;
	import flash.media.Camera;

	import flash.net.navigateToURL;
    	import flash.net.URLRequest;

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

		protected function loadObjects(event:PatternNameEvent):void
		{
			trace("EZflarEx::loadObjects for pattern [" + event.patternName + "]");

			var url1:String = "http://www.stadt-koeln.de/6/sehenswertes/rathaus/praetorium";
			var url2:String = "http://vimeo.com";
			var url3:String = "http://www.heise.de";
			var url4:String = "http://www.diezeit.de";
			var url5:String = "http://www.gulli.com";
			var url6:String = "http://stackoverflow.com";
			var url7:String = "http://de.wikipedia.org";
			var url8:String = "file:///home/quatsch/sandboy/flex/actionscript/bin/start.html";

			var request:URLRequest;
			
			if( event.patternName == "marker001" )
			{
				request = new URLRequest(url1);
			}
			if( event.patternName == "marker002" )
			{
				request = new URLRequest(url2);
			}
			if( event.patternName == "marker003" )
			{
				request = new URLRequest(url3);
			}
			if( event.patternName == "marker004" )
			{
				request = new URLRequest(url4);
			}
			if( event.patternName == "marker005" )
			{
				request = new URLRequest(url5);
			}
			if( event.patternName == "marker006" )
			{
				request = new URLRequest(url6);
			}
			if( event.patternName == "marker007" )
			{
				request = new URLRequest(url7);
			}
			if( event.patternName == "marker008" )
			{
				request = new URLRequest(url8);
			}

			try 
			{
				navigateToURL(request, '_blank');
			} 
			catch (e:Error) 
			{
				trace("EZflarEx::loadObjects() Error occurred while loading url [" + request + "]");
			}
		}

		private function onFlarManagerInitiated (evt:Event) :void 
		{
			_dispatcher.addEventListener( ConstructorEventDispatcher.CLICK, loadObjects);

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
