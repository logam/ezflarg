package com.quilombo
{
	import flash.events.Event;
	import flash.media.Camera;

	import com.tchatcho.Base_model;
	import com.tchatcho.EZflar;

	import com.quilombo.ConfigHolder;

	public class EZflarEx extends EZflar
	{
/*
		public function EZflarEx ( 	objects:Array,
					   	width:int = 640,
					   	height:int = 480,
						frameRate:Number = 30,
						downSampleRatio:Number = 0.5,
						res:uint = 16,
						thresh:uint = 20,
						mirror:Boolean = true
					  )
		{
			super(objects, width, height, frameRate, downSampleRatio, res, thresh, mirror);
		}
*/
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
				);
		}

		private function onFlarManagerInitiated (evt:Event) :void 
		{
			super.base_model = new Base_model(	super._objects,
								super.patterns.length,
								super.flarManager.cameraParams,
								viewWidth(),
								viewHeight(),
								super._pathToResources,
								PATH_TO_MODELS);
			super.addChild(super.base_model);
			
			if (super._funcStarted != null){
				super._funcStarted();
			}
		}

		protected override function init () :void 
		{	
			// call base class first
			super.init();

			// set the pattern brightness threshold
			super.flarManager.threshold = super._patternThreshold;
			
			// remove the init event listener registered by the base class and register the one of this class 
			// which uses the extended version of the Base_model > BaseModelEx
			if(Camera.names.length > 0) 
			{
				flarManager.removeEventListener(Event.INIT, super.onFlarManagerInited);				
				flarManager.addEventListener(Event.INIT, this.onFlarManagerInitiated);
			}
			
		}
	}
} 
