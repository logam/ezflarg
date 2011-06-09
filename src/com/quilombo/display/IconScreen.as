package com.quilombo.display
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;

    	import flash.display.Bitmap;
	import flash.display.Shape;
    	import flash.display.BitmapData;
    	import flash.display.Loader;

    	import flash.geom.Point;
    	import flash.geom.Rectangle;
    	import flash.net.URLRequest;

	public class IconScreen extends MovieClip 
	{
		protected var _url:String;
		protected var _width:int;
		protected var _height:int;
		protected var _posX:int;
		protected var _posY:int;
		protected var _fixedAlpha:Number;

		protected var _loadingComplete:Boolean 	= false;
		protected var _visible:Boolean		= false;
		protected var _loader:Loader 		= null;
		protected var _bitmap:Bitmap 		= null;


		static public var	ON_LOADING_COMPLETE:String = "ON_LOADING_COMPLETE";
		static protected var 	TRANSPARENT_EVENT:String = "TRANSPARENT";
		static protected var 	OPAQUE_EVENT:String = "OPAQUE";

		public function IconScreen(url:String, name:String="IconScreen", width:uint = 0, height:uint = 0, posX:int = 0, posY:int = 0, fixedAlpha:Number = 1.0):void
		{
			_url 		= url;
			_width 		= width;
			_height 	= height;
			_posX 		= posX;
			_posY 		= posY;
			_fixedAlpha	= fixedAlpha;
			this.name 	= name; 
			loadScreen(url);
		}

		public function hide():void
		{
			trace("IconScreen::hide() screen [" + name + "]")
			if(_loader != null && _loadingComplete)
			{
				this.removeChild(_loader);
			}
			_visible = false;
		}

		public function show():void
		{
			trace("IconScreen::show() screen [" + name + "]")
			if(_loader != null && _loadingComplete)
			{
				this.addChild(_loader);
			}
			_visible = true;
		}

		public function transparent():void
		{
			trace("IconScreen::transparent() set screen [" + name + "] to alpha [" + _fixedAlpha + "]");
			this.alpha = _fixedAlpha;
		}

		public function opaque():void
		{
			trace("IconScreen::opaque() make screen [" + name + "] opaque");
			this.alpha = 1.0;
		}

		public function scaleToSize(width:uint, height:uint):void
		{
			trace("IconScreen::scaleToSize() width[" + width + "] height[" + height + "]");
			_width	= width;
			_height	= height;

			if( _bitmap != null )
			{
				_bitmap.scaleX = _width / _bitmap.bitmapData.width;
				_bitmap.scaleY = _height / _bitmap.bitmapData.height;
			} 
		}

		public function set posX ( posX:uint ):void
		{
			trace("IconScreen::posX() posX [" + posX + "]");
			_posX = posX;

			if( _bitmap != null )
			{
				_bitmap.x = _posX;
			}
		}

		public function get posX ():uint
		{
			return _posX;
		}

		public function set posY ( posY:uint ):void
		{
			trace("IconScreen::posY() posY [" + posY + "]");
			_posY = posY;

			if( _bitmap != null )
			{
				_bitmap.y = _posY;	
			}	
		}

		public function get posY ():uint
		{
			return _posY;
		}

		public function get loadingComplete():Boolean
		{
			return _loadingComplete;
		}
		
		protected function loadScreen(url:String):void
		{
			_loader = new Loader();
			_loadingComplete = false;

	            	_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaderComplete);
		        _loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loaderIoError);

            		_loader.load(new URLRequest(url)); 	
		}

		protected function loaderComplete(evt:Event):void
		{
			trace("IconScreen::loaderComplete() screen[" + name + "]");
			
			_bitmap = Bitmap(_loader.content);
			scaleToSize(_width, _height);
			
			posX = _posX;
			posY = _posY;
/*	
            		var bitmapData:BitmapData = _bitmap.bitmapData;
            		var sourceRect:Rectangle = new Rectangle(0, 0, bitmapData.width, bitmapData.height);
            		var destPoint:Point = new Point();
            		var operation:String = ">=";
            		var threshold:uint = 0x00000000; // all light gray and white colors
            		var color:uint = 0x22000000;
            		var mask:uint = 0xFF000000; // mask colors but not transparency value
            		var copySource:Boolean = true;
_bitmap.
            		bitmapData.threshold( 	bitmapData,
                        		        sourceRect,
                        		        destPoint,
                        		        operation,
                        		        threshold,
                        		        color,
                        		        mask,
                        		        copySource);
*/			
//			var child:Shape = new Shape();
//			child.graphics.beginFill(0x222222/*0xCCCCCC*/, 0.5 /*alpha*/);
//			child.graphics.lineStyle(3 /*2*/, 0xFFFFFF, 0.5 /*alpha*/);
//			child.graphics.drawRect(0, 0, bitmapData.width, bitmapData.height); 
//			child.graphics.endFill();
//			super.addChild(child);

			_loadingComplete = true;

			if( _visible )
			{
				show();
			}
/*			else
			{
				hide();
			}
*/
			this.dispatchEvent( new Event(ON_LOADING_COMPLETE) );
		}

		protected function loaderIoError(evt:Event):void
		{
			trace("IconScreen::loaderIoError() Unable to load image [" + _url + "]");
			_loadingComplete = false;
		}
	}

}
