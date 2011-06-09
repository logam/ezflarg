package com.quilombo
{	
	import flash.geom.Point;
	import mx.utils.ObjectUtil;

	public class IconAttributesHolder
	{
		protected var _pos:Point = new Point;
		protected var _numIconsPerLine:uint = 0;
		protected var _iconWidth:uint = 0;
		protected var _iconHeight:uint = 0;
		protected var _opacityLevel:Number = 1.0;
		protected var _visible:Boolean = true;

		public function set pos ( pos:Point):void 		{ _pos = pos; }
		public function set numIconsPerLine ( num:uint):void 	{ _numIconsPerLine = num; }
		public function set iconWidth ( iconWidth:uint):void 	{ _iconWidth = iconWidth; }
		public function set iconHeight ( iconHeight:uint ):void { _iconHeight = iconHeight; }
		public function set opacity ( opacity:Number ):void 	{ _opacityLevel = opacity; }
		public function set visibility ( visible:Boolean):void 	{ _visible = visible; }
		
		public function get pos ():Point 			{ return _pos; }
		public function get numIconsPerLine ():uint 		{ return _numIconsPerLine; }
		public function get iconWidth ():uint 			{ return _iconHeight; }
		public function get iconHeight ():uint 			{ return _iconWidth; }
		public function get opacity ():Number 			{ return _opacityLevel; }
		public function get visibility ():Boolean 		{ return _visible; }
		
		public function clone():IconAttributesHolder
		{
			var clone:IconAttributesHolder = new IconAttributesHolder;

			clone.pos		= this.pos.clone();
			clone.numIconsPerLine	= this.numIconsPerLine; 
			clone.iconWidth		= this.iconWidth;
			clone.iconHeight	= this.iconHeight;
			clone.opacity		= this.opacity;
			clone.visibility	= this.visibility;
			
			return clone;
		}

		public function toString():String
		{
			return 	"IconAttributesHolder::toString()\n" + 
				"position [" + this.pos + "]\n" +
				"icons per line [" + this.numIconsPerLine + "]\n" + 
				"icon width [" + this.iconWidth + "]\n" +
				"icon height [" + this.iconHeight + "]\n" +
				"icon opacity [" + this.opacity + "]\n" +
				"icons visible [" + this.visibility + "]";
		}
	}
}
