package com.quilombo.display
{
	import flash.display.Sprite;
	import flash.display.DisplayObject;

	import com.quilombo.display.ILayout;

	public class StartScreenLayout extends Sprite implements ILayout
	{
		public function StartScreenLayout()
		{}

		public function addElement(posX:uint, posY:uint, element:DisplayObject):void
		{
			element.x = posX;
			element.y = posY;
			this.addChild(element);	
		}

		public function getLayout():DisplayObject
		{
			return this;
		}
	}
}
