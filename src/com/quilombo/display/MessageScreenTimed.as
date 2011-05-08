package com.quilombo.display
{
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import com.quilombo.display.MessageScreen;

	public class MessageScreenTimed extends MessageScreen 
	{
		protected var _timer:Timer;
		
		public function MessageScreenTimed(width:int, height:int, colorTxt:uint, colorBackground:uint, displayTime:uint = 5000)
		{
			super(width, height, colorTxt, colorBackground);
			_timer = new Timer(displayTime, 1);
			_timer.addEventListener(TimerEvent.TIMER, hideAfterTimerStop);
		}

		override public function show(msg:String):void
		{
			trace("MessageScreenTimed::show() message [" + msg + "]");
			super.show(msg);
			_timer.start();
		}

		protected function hideAfterTimerStop(event:TimerEvent):void
		{
			trace("MessageScreenTimed::hideAfterTimerStop() begin");
			super.hide();	
			trace("MessageScreenTimed::hideAfterTimerStop() end");
		}

		public function set displayTime (time:uint):void	
		{
			trace("MessageScreenTimed::displayTime() time [" + time + "]");
			_timer.delay = time;
		}

		public function get displayTime ():uint
		{
			return _timer.delay;
		}
	}
}
