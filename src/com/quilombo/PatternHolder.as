package com.quilombo
{	
	import com.quilombo.ObjectHolder;
	import com.quilombo.IconHolder;
	import com.quilombo.IconAttributesHolder;

	/**
		just a class that holds pattern and icons
	*/
	public class PatternHolder
	{
		protected var _symbols:ObjectHolder = new ObjectHolder;
		protected var _icons:IconHolder = new IconHolder;
		protected var _iconAttributes:IconAttributesHolder = new IconAttributesHolder;

		public function set objectHolder( symbols:ObjectHolder ):void
		{
			_symbols = symbols;
		}

		public function set iconHolder ( icons:IconHolder ):void
		{
			_icons = icons;
		}

		public function set iconAttributesHolder ( iconAttributes:IconAttributesHolder ):void
		{
			_iconAttributes = iconAttributes;
		}

		public function get objectHolder():ObjectHolder
		{
			return _symbols;
		}

		public function get iconHolder ():IconHolder
		{
			return _icons;
		}

		public function get iconAttributesHolder ():IconAttributesHolder
		{
			return _iconAttributes;
		}
	
		public function clone():PatternHolder
		{
			var clone:PatternHolder = new PatternHolder;
			
			clone.objectHolder 		= this.objectHolder.clone();
			clone.iconHolder   		= this.iconHolder.clone();
			clone.iconAttributesHolder 	= this.iconAttributesHolder.clone();

			return clone;
		}

		public function toString():String
		{
			return "PatternHolder::toString()\n" 
				+ "objects: " + this.objectHolder.toString() + "\n" 
				+ "icons: " + this.iconHolder.toString() + "\n"
				+ "icon attributes: " + this.iconAttributesHolder.toString();
		}
	}
}
