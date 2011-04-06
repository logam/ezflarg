package com.quilombo
{
	import com.quilombo.ConfigLoaderBase;
	import com.quilombo.ConfigHolder;
	import com.quilombo.IConfigLoader;

	public class ConfigLoaderXML 	extends ConfigLoaderBase
					implements IConfigLoader
	{
		/**
			returns a reference to a new and filled ConfigHolder object
		*/
		public function load(value:Object):Object
		{
			super.loadXML(value);
			var configuration:ConfigHolder = new ConfigHolder();
			
			configuration.width			= _xml.width.text();
			configuration.height			= _xml.height.text();
			configuration.patternResolution		= _xml.patternresolution.text();
			configuration.patternThreshold		= _xml.patternthreshold.text();
			configuration.frameRate			= _xml.framerate.text();
			configuration.downsampleRatio		= _xml.downsampleratio.text();
			configuration.mirror			= _xml.mirror.text();
			configuration.patternToBorderRatio	= _xml.patternborderratio.text();
			configuration.patternMinConfidence	= _xml.patternminconfidence.text();
			configuration.unscaledMarkerWidth	= _xml.unscaledmarkerwidth.text();
			
			return configuration;
		}
	} 
}
