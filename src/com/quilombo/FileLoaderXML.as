package com.quilombo
{
	import com.quilombo.ConfigLoaderBase;
	import com.quilombo.ConfigHolder;
	import com.quilombo.IConfigLoader;

	public class FileLoaderXML 	extends ConfigLoaderBase
					implements IConfigLoader
	{
		/**
			returns a reference to a new and filled Array of xml file strings
		*/
		public function load(value:Object):Object
		{
			super.loadXML(value);
			var files:Array = new Array;
			
			trace("FileLoaderXML::load " + _xml);

			files.push(_xml.config.text());
			files.push(_xml.objects.text());
			files.push(_xml.mode.text());

			return files;
		}
	} 
}
