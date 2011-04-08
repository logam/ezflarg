package com.quilombo.display
{
	import flash.display.Sprite;
	import flash.display.SimpleButton;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.MouseEvent;


	public class GenericButton extends Sprite
	{
		public function GenericButton   ( width:uint
						, height:uint
						, colorBackground:Number = 0x222222
						, colorBorder:Number = 0x888888
						, cornerRadius:uint = 10 
						, borderSize:uint = 5)
		{
			var shape:Shape = new Shape();
			shape.graphics.beginFill(colorBackground);
			shape.graphics.lineStyle(borderSize,colorBorder);
			shape.graphics.drawRoundRect(0, 0, width, height, cornerRadius);
			shape.graphics.endFill();

			this.addChild(shape);			
		}
	}
}
