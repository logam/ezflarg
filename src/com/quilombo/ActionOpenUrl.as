package com.quilombo
{

	import flash.net.navigateToURL;
    	import flash.net.URLRequest;
	import com.quilombo.IAction;

	public class ActionOpenUrl implements IAction
	{
		protected var _url:String;
		protected var _target:String;

		public function ActionOpenUrl(  url:String, target:String ):void
		{
			_url = url;
			_target = target;
		}

		public function execute():void
		{
			try 
			{
				navigateToURL( new URLRequest(_url), _target );
			} 
			catch (e:Error) 
			{
				trace("ActionOpenUrl::navigateToURL() Error occurred while loading url [" + _url + "]");
			}	
		}
	}
}
