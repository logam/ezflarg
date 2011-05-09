package com.quilombo
{
	import com.quilombo.ConfigLoaderBase;
	import com.quilombo.ConfigHolder;
	import com.quilombo.IConfigLoader;

	public class ConfigLoaderXML 	extends ConfigLoaderBase
					implements IConfigLoader
	{
		protected var _configuration:ConfigHolder = new ConfigHolder();

		/**
			returns a reference to a new and filled ConfigHolder object
		*/
		public function load(value:Object):Object
		{
			super.loadXML(value);
			setDefaults();
			var configuration:ConfigHolder = _configuration.clone();

			var childList:XMLList = super._xml.children();
			for each (var val:XML in childList)
			{
				trace("ConfigLoaderXML::load() found [" + val.name() + "]");
				if ( val.name() == "width")
				{
					trace("ConfigLoaderXML::load() found width [" + val.text() + "]");
					configuration.width = val.text();
					continue;
				}

				if ( val.name() == "height")
				{
					trace("ConfigLoaderXML::load() found height [" + val.text() + "]");
					configuration.height = val.text();
					continue;
				}

				if ( val.name() == "patternresolution")
				{
					trace("ConfigLoaderXML::load() found patternresolution [" + val.text() + "]");
					configuration.patternResolution = val.text();
					continue;
				}

				if ( val.name() == "patternthreshold")
				{
					trace("ConfigLoaderXML::load() found patternthreshold [" + val.text() + "]");
					configuration.patternThreshold = val.text();
					continue;
				}

				if ( val.name() == "framerate")
				{
					trace("ConfigLoaderXML::load() found framerate [" + val.text() + "]");
					configuration.frameRate = val.text();
					continue;
				}
				
				if ( val.name() == "downsampleratio")
				{
					trace("ConfigLoaderXML::load() found downsampleratio [" + val.text() + "]");
					configuration.downsampleRatio = val.text();
					continue;
				}

				if ( val.name() == "mirror")
				{
					trace("ConfigLoaderXML::load() found mirror [" + val.text() + "]");
					configuration.mirror = val.text();
					continue;
				}

				if ( val.name() == "patternborderratio")
				{
					trace("ConfigLoaderXML::load() found patternToBorderRatio [" + val.text() + "]");
					configuration.patternToBorderRatio = val.text();
					continue;
				}

				if ( val.name() == "patternminconfidence")
				{
					trace("ConfigLoaderXML::load() found patternminconfidence [" + val.text() + "]");
					configuration.patternMinConfidence = val.text();
					continue;
				}

				if ( val.name() == "unscaledmarkerwidth")
				{
					trace("ConfigLoaderXML::load() found unscaledmarkerwidth [" + val.text() + "]");
					configuration.unscaledMarkerWidth = val.text();
					continue;
				}

				if ( val.name() == "markerUpdateThreshold")
				{
					trace("ConfigLoaderXML::load() found markerUpdateThreshold [" + val.text() + "]");
					configuration.markerUpdateThreshold = val.text();
					continue;
				}
/*
				if ( val.name() == "contentPath")
				{
					trace("ConfigLoaderXML::load() found contentPath [" + val.text() + "]");
					configuration.contentPath = val.text();
					continue;
				}
*/
				
				if ( val.name() == "mousehandling")
				{
					trace("ConfigLoaderXML::load() found mouseHandling [" + val.text() + "]");
					configuration.mouseHandling = val.text();
					continue;
				}				
			}

			return configuration;
		}

		/**
			sets default values for the case not all configuration values are specified in the config file
			the value are set to

			symbols			= create a new and empty Array
			width			= 640
			height			= 480
			patternResolution	= 16
			patternThreshold	= 80
			frameRate		= 30
			downsampleRatio		= 0.66
			mirror			= false
			patternToBorderRatio	= 50
			patternMinConfidence	= 0.5
			unscaledMarkerWidth	= 80
			markerUpdateThreshold	= 20
			contentPath		= ""
			mouseHandling		= true
		*/
		public function setDefaults():void
		{
			_configuration.objects			= new Array;
			_configuration.width			= 640;
			_configuration.height			= 480;
			_configuration.patternResolution	= 16;
			_configuration.patternThreshold		= 80;
			_configuration.frameRate		= 30;
			_configuration.downsampleRatio		= 0.66;
			_configuration.mirror			= false;
			_configuration.patternToBorderRatio	= 50;
			_configuration.patternMinConfidence	= 0.5;
			_configuration.unscaledMarkerWidth	= 80;
			_configuration.markerUpdateThreshold	= 20;
			// _configuration.contentPath		= "";
			_configuration.mouseHandling		= true;
		}
	} 
}
