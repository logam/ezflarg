package com.quilombo
{	
	/**
	*/
	public class IconHolder
	{
		protected var _objects:Vector.<String> = new Vector.<String>;

		public function set objects(objects:Vector.<String>):void { _objects = objects; }
		public function get objects():Vector.<String> { return _objects; }

		public function clone():IconHolder
		{
			var clone:IconHolder = new IconHolder;
			clone.objects = this.objects.slice();				
			return clone;
		}

		public function toString():String
		{
			return "IconHolder::toString(): objects\n" + objects.toString();
		}
	}
}
