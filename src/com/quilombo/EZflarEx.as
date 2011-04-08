package com.quilombo
{
	import flash.events.Event;
	import flash.media.Camera;

	import com.tchatcho.Base_model;
	import com.tchatcho.EZflar;

	import com.quilombo.ConfigHolder;
	import com.quilombo.BaseModelEx;
	import com.quilombo.constructors.LoadingEzflarEx;

	public class EZflarEx extends EZflar
	{
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

		private function onFlarManagerInitiated (evt:Event) :void 
		{
			super.base_model = new BaseModelEx(	super._objects,
								super.patterns.length,
								super.flarManager.cameraParams,
								viewWidth(),
								viewHeight(),
								super._pathToResources,
								PATH_TO_MODELS,
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
