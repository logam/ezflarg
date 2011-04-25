package com.quilombo
{
	public class ActionDispatcher
	{
		public static var OnClicked:String = "OnClicked";

		public function ActionDispatcher():void
		{}

		public function execute( objectName:String, type:String ):void
		{}

		public function addAction():void
		{}

		public function reset():void
		{}

		public function asString():String
		{
			var result:String = "empty yet"
			return result;
		}
	}
}
