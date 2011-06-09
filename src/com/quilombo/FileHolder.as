package com.quilombo
{	
	import mx.utils.ObjectUtil;

	/**
		just a class that holds some configuration values and provides the
		corresponding getter and setter methods.
	*/
	public class FileHolder
	{
		protected var _configFile:String = "";
		protected var _objectsFile:String = "";
		protected var _modeFile:String = "";
		protected var _actionFile:String = "";
		protected var _resourcePath:String = "";

		public function get configFile			():String { return _resourcePath + _configFile; } 
		public function get objectsFile			():String { return _resourcePath + _objectsFile; }
		public function get modeFile			():String { return _resourcePath + _modeFile; }
		public function get actionFile			():String { return _resourcePath + _actionFile; }
		public function get resourcePath		():String { return _resourcePath; }

		public function set configFile			(value:String):void { _configFile = value; } 
		public function set objectsFile			(value:String):void { _objectsFile = value; }
		public function set modeFile			(value:String):void { _modeFile = value; }
		public function set actionFile			(value:String):void { _actionFile = value; }
		public function set resourcePath		(value:String):void { _resourcePath = value; }

		public function clone():FileHolder
		{
			var clone:FileHolder = new FileHolder();
			clone.configFile = _configFile;
			clone.objectsFile = _objectsFile;
			clone.modeFile = _modeFile;
			clone.actionFile = _actionFile;
			clone.resourcePath = _resourcePath;
			
			return clone;
		}

		public function toString():String
		{
			return "FileHolder::asString():\n"
				+ "configFile [" + _configFile + "]\n"
				+ "objectsFile [" + _objectsFile + "]\n"
				+ "modeFile [" + _modeFile + "]\n"
				+ "actionFile [" + _actionFile + "]\n"
				+ "resourcePath [" + _resourcePath + "]";
		}
	}
}
