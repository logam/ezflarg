package com.quilombo
{	
	import mx.utils.ObjectUtil;

	public class ObjectHolder
	{
		protected var _objects:Array = new Array;

		public function set objects(objects:Array):void { _objects = objects; }
		public function get objects():Array { return _objects; }

		public function clone():ObjectHolder
		{
			var clone:ObjectHolder = new ObjectHolder;
			clone.objects = this.objects.slice();				
			return clone;
		}

		public function toString():String
		{
			return "ObjectHolder::toString()";
		}
	}
}
