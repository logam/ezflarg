package com.quilombo.display
{
	import flash.display.Sprite;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.events.Event;

	import com.quilombo.display.ILayout;

	public class StartScreen extends Sprite
	{
		protected var _width:uint = 0;
		protected var _height:uint = 0;
		protected var _posX:uint = 0;
		protected var _posY:uint = 0;
		protected var _colorBackground:Number = 0;
		
		protected var _layout:ILayout = null;
		protected var _background:DisplayObject = null;

		public function StartScreen()
		{}

		public function init(width:uint, height:uint, posX:uint, posY:uint, backColor:Number=0xFFFFFF, layout:ILayout=null):Boolean
		{
			var result:Boolean = true;

			_width 		= width;
			_height 	= height;
			_posX		= posX;
			_posY		= posY;
			_colorBackground= backColor;
			_layout 	= layout;
			
			// construct the background
			_background 	= constructBackground();
			this.addChild(_background);
			
			if( _layout != null)
			{
				this.addChild(_layout.getLayout());
			}
			return result;
		}

		protected function constructBackground():DisplayObject
		{
			var background:Shape = new Shape();
			
			background.graphics.beginFill(_colorBackground);
			background.graphics.drawRect(0, 0, _width, _height);
			background.graphics.endFill();
			
			background.x = _posX;
			background.y = _posY;

			return background;
		}
	}
}
