package com.quilombo
{
	import com.quilombo.IAction;

	public class StringActionPair
	{
		public var _string:String;
		public var _actions:Vector.<IAction>;

		public function StringActionPair( string:String, actions:Vector.<IAction> ):void
		{
			_string = string;
			_actions = actions;
		}
	}
}
