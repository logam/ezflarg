package com.quilombo
{
	public class ConfigLoaderBase
	{
		protected var _xml:XML;
		
		protected function loadXML(value:Object):void
		{
			_xml = new XML(value);
			trace(_xml);
		}
	}
}

