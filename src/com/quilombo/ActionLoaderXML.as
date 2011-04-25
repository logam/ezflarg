package com.quilombo
{
	import com.quilombo.ConfigLoaderBase;
	import com.quilombo.IConfigLoader;
	import com.quilombo.ActionDispatcher;
	
	public class ActionLoaderXML 	extends ConfigLoaderBase
					implements IConfigLoader
	{
		/**
		*/
		public function load(value:Object):Object
		{
			var dispatcher:ActionDispatcher = new ActionDispatcher();

			return dispatcher;
		}

		/**
		*/
		public function setDefaults():void
		{}
	}
}
