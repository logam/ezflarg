package com.quilombo.display
{
	import flash.display.MovieClip;
	import com.quilombo.display.GenericMessageScreen;

	public class MessageScreen extends MovieClip 
	{
		protected var _screen:GenericMessageScreen;

		public function MessageScreen(width:int, height:int, colorTxt:uint, colorBackground:uint):void
		{
			_screen = constructMsgScreen(width, height, colorTxt, colorBackground);
		}

		public function hide():void
		{
			trace("MessageScreenTimed::hide()")
			if(_screen != null )
			{
				this.removeChild(_screen);
			}
		}

		public function show(msg:String):void
		{
			trace("MessageScreen::show() message [" + msg + "]")
			if(_screen != null)
			{
				_screen.message = msg;
				this.addChild(_screen);
			}
		}

		protected function constructMsgScreen(width:int, height:int, colorTxt:uint, colorBackground:uint):GenericMessageScreen
		{
			return new GenericMessageScreen(width, height, colorTxt, colorBackground);	
		}	
	}

}
