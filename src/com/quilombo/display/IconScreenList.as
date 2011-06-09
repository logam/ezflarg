package com.quilombo.display
{
	import flash.geom.Point;
	
	import com.quilombo.display.IconScreen;
	

	public class IconScreenList
	{
		protected var _screenList:Vector.<IconScreen> = new Vector.<IconScreen>();
	
		/**
		*/
		public function IconScreenList()
		{}

		/**
		*/
		public function addScreen( screen:IconScreen ):Boolean
		{
			trace("IconScreenList::addScreen()");

			var result:Boolean = false;
			if( screen != null )
			{
				_screenList.push(screen);
				trace("IconScreenList::addScreen() added screen[" + screen.name + "]");
				trace("IconScreenList::addScreen() screen index [" + _screenList.length + "]");
				result = true;
			}
			return result;
		}

		public function removeScreen( screenName:String ):Boolean
		{
			trace("IconScreenList::removeScreen() screen name [" + screenName + "]");
			var result:Boolean = false;
			_screenList = _screenList.filter
			(
				function( item:IconScreen, index:int, vector:Vector.<IconScreen>):Boolean
				{
					result = screenName != item.name;
					return result;
				}
			);

			trace("IconScreenList::removeScreen() num available icons [" + _screenList.length + "]");
			return !result;
		}

		public function removeAllScreens():void
		{
			trace("IconScreenList::removeAllScreen()")
			_screenList = new Vector.<IconScreen>;
		}

		public function show( screenName:String, isOpaque:Boolean=true ):void
		{
			trace("IconScreenList::show() screen [" + screenName + "]");
			var screen:IconScreen = _screenList.filter
			(
				function ( item:IconScreen, index:int, vector:Vector.<IconScreen> ):Boolean
				{
					return screenName == item.name;
				}
			).pop();
			
			if( screen != null)
			{
				trace("IconScreenList::show() found screen [" + screen.name + "]");
				if( isOpaque )
				{
					screen.opaque();	
				}
				else
				{
					screen.transparent();
				}
				screen.show();
			}
			else
			{
				trace("IconScreenList::show() didnt find screen");
			}
		}

		public function hide ( screenName:String ):void
		{
			trace("IconScreenList::hide() screen [" + screenName + "]");
			var screen:IconScreen = _screenList.filter
			(
				function ( item:IconScreen, index:int, vector:Vector.<IconScreen> ):Boolean
				{
					return screenName == item.name;
				}
			).pop();

			if( screen != null )
			{
				trace("IconScreenList::hide() found screen [" + screen.name + "]");
				screen.hide();
			}
			else
			{
				trace("IconScreenList::show() didnt find screen");
			}
		}

		/**
		*/
		public function showAll( isOpaque:Boolean=true):void
		{
			trace("IconScreenList::showAll() num screens[" + _screenList.length + "]");

			_screenList.forEach
			( 		
				function (screen:IconScreen, index:int, vector:Vector.<IconScreen>):void
				{
					if(screen != null)
					{	
						if( isOpaque )
						{
							screen.opaque();	
						}
						else
						{
							screen.transparent();
						}
						screen.show();
					}
				}
			);
		}

		/**
		*/
		public function hideAll():void
		{
			_screenList.forEach
			( 		
				function (screen:IconScreen, index:int, vector:Vector.<IconScreen>):void
				{
					if(screen != null)
					{	
						screen.hide();
					}
				}
			);
		}
		

		/**	this function is supposed to scale the screens to an appropriate size 
			and set their position correspondingly.			   
		*/
		public function placeIcons ( maxScreensPerLine:uint, posScreens:Point, widthScreen:uint, heightScreen:uint ):void
		{
			trace("IconScreenList::fitToSize() num screens[" + _screenList.length + "]");
			if( maxScreensPerLine >= 1)
			{
				var screenDistanceX:uint	= 10;
				var screenDistanceY:uint	= 10;

				var numScreens:uint 		= _screenList.length;	
				var countScreens:uint		= 0;
			
				/** 	we always start counting from 0
					thus if 8 items fit in one line and 8 items are available, 
					the number of lines will be 0 (which means one line is available)
				*/
				var countLines:uint		= Math.ceil(numScreens / maxScreensPerLine) - 1;	
				var offsetX:uint		= widthScreen + screenDistanceX;
				var offsetY:uint		= heightScreen + screenDistanceY;

				trace(	"IconScreenList::fitToSize() " + 
					"offsetX [" + offsetX + "] " + 
					"offsetY [" + offsetY + "]" + 
					"numlines[" + countLines + "]");
			
				_screenList.forEach
				( 		
					function (screen:IconScreen, index:int, vector:Vector.<IconScreen>):void
					{
						if(screen != null)
						{	
							if( countScreens >= maxScreensPerLine )
							{
								countScreens = 0;
								countLines--;
							}
	 
							screen.scaleToSize(widthScreen, heightScreen);
							screen.posX = posScreens.x + (countScreens*offsetX);
							screen.posY = posScreens.y - (countLines*offsetY);

							countScreens++;
						}
					}
				);
			}
			else
			{
				trace("IconScreenList::fitToSize() skip all screens because max screens per line is zero [" + maxScreensPerLine + "]");
			}			
		}
	}
}
