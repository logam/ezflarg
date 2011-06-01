package com.quilombo
{	
	import mx.utils.ObjectUtil;
	import flash.filesystem.File;

	/**
		just a class that holds some configuration values and provides the
		corresponding getter and setter methods.
	*/
	public class FileHolder
	{
		protected var _configFile:File = new File();
		protected var _objectsFile:File = new File();
		protected var _modeFile:File = new File();
		protected var _actionFile:File = new File();
		protected var _resourcePath:File = new File();

		public function get configFile			():String { return _resourcePath.resolvePath( _configFile.nativePath ).nativePath; } 
		public function get objectsFile			():String { return _resourcePath.resolvePath( _objectsFile.nativePath ).nativePath; }
		public function get modeFile			():String { return _resourcePath.resolvePath( _modeFile.nativePath ).nativePath; }
		public function get actionFile			():String { return _resourcePath.resolvePath( _actionFile.nativePath ).nativePath; }
		public function get resourcePath		():String { return _resourcePath.nativePath; }

		public function set configFile			(value:String):void { _configFile = new File(value); } 
		public function set objectsFile			(value:String):void { _objectsFile = new File(value); }
		public function set modeFile			(value:String):void { _modeFile = new File(value); }
		public function set actionFile			(value:String):void { _actionFile = new File(value); }
		public function set resourcePath		(value:String):void { _resourcePath = new File(value); }

		public function clone():FileHolder
		{
			var clone:FileHolder = new FileHolder();
			clone.configFile = _configFile.nativePath;
			clone.objectsFile = _objectsFile.nativePath;
			clone.modeFile = _modeFile.nativePath;
			clone.actionFile = _actionFile.nativePath;
			clone.resourcePath = _resourcePath.nativePath;
			
			return clone;
		}

		public function toString():String
		{
			return "FileHolder::asString():\n"
				+ "configFile [" + _configFile.nativePath + "]\n"
				+ "objectsFile [" + _objectsFile.nativePath + "]\n"
				+ "modeFile [" + _modeFile.nativePath + "]\n"
				+ "actionFile [" + _actionFile.nativePath + "]\n"
				+ "resourcePath [" + _resourcePath.nativePath + "]";
		}
	}
}
