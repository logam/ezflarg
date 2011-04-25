package com.quilombo
{
	import com.quilombo.ConfigLoaderBase;
	import com.quilombo.ConfigHolder;
	import com.quilombo.IConfigLoader;

	public class FileLoaderXML 	extends ConfigLoaderBase
					implements IConfigLoader
	{
		protected var _configFile:String;
		protected var _objectsFile:String;
		protected var _modeFile:String;

		/**
			@return a reference to a new and filled Array of xml file strings
				the array has a size of three elements. the elements are ordered in the following sequence
				array[0] configuration file name 
				array[1] objects file name
				array[2] mode file name
			@return in case some of the file names have not been defined in the xml file, default names are used
		*/
		public function load(value:Object):Object
		{
			super.loadXML(value);
			setDefaults();

			var files:Array = new Array;
			trace("FileLoaderXML::load() " + _xml);

			var fileList:XMLList = super._xml.children();
			for each (var file:XML in fileList )
			{
				if(file.name() == "config")
				{
					trace("FileLoaderXML::load() found file [config]" + "[" + file.text() + "]");
					_configFile = file.text();
				}
				if(file.name() == "objects")
				{
					trace("FileLoaderXML::load() found file [objects]" + "[" + file.text() + "]");
					_objectsFile = file.text();
				}
				if(file.name() == "mode")
				{
					trace("FileLoaderXML::load() found file [mode]" + "[" + file.text() + "]");
					_modeFile = file.text();
				}
			}
			
			files.push(_configFile);
			files.push(_objectsFile);
			files.push(_modeFile);

			return files;
		}
		
		/**
			sets default file names for the case that no names are defined in the corresponding xml file.
			if u want to overwrite the file names, just inherit from this class and overwrite this method. 

			the default file names are as follows
			config file : config.xml
			objects file: objects.xml
			modes file  : mode.xml
		*/
		public function setDefaults():void
		{
			_configFile = "config.xml";
			_objectsFile = "objects.xml";
			_modeFile = "mode.xml";
		}
	} 
}
