package com.quilombo.display
{
	import flash.display.MovieClip;
	import flash.display.Shape;   	
	
	import flash.text.TextField;
   	import flash.text.TextFormat;
	
	import flash.filters.BitmapFilter;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.DropShadowFilter

	public class GenericMessageScreen extends MovieClip 
	{
		protected var _borderColor:uint   = 0xFFFFFF;

		protected var _borderSize:uint   = 4;
		protected var _cornerRadius:uint = 30;

		protected var _offsetX:int 	= 50;
		protected var _offsetY:int 	= 75;

		public function GenericMessageScreen	( width:int
					  		, height:int
							, colorTxt:uint
							, colorBackground:uint
							) 
		{
			construct(width, height, colorTxt, colorBackground);
		}

		public function set message(msg:String):void
		{
			var text:TextField = this.getChildAt(1) as TextField;
			if(text != null)
			{
				text.text = msg;
			}
		}

		public function get offsetX():int
		{
			return _offsetX;
		}

		public function get offsetY():int
		{
			return _offsetY;
		}

		public function set offsetX(x:int):void
		{
			_offsetX = x;
		}

		public function set offsetY(y:int):void
		{
			_offsetY = y;
		}

		protected function destroy():void
		{
			this.removeChildAt(0);
			this.removeChildAt(1);
		}

		protected function construct	( width:int
					  	, height:int
						, colorTxt:uint
						, colorBackground:uint):void
		{
			var shape:Shape = new Shape();
			shape.graphics.beginFill(colorBackground);
			shape.graphics.lineStyle(_borderSize, _borderColor);
			shape.graphics.drawRoundRect(0, 0, width, height, _cornerRadius);
			shape.graphics.endFill();
			shape.x = _offsetX;
			shape.y = _offsetY;

			var textArea:TextField  	= new TextField();
		
			textArea.width 			= width - 10;
			textArea.height			= height - 10;
			textArea.x 			= _offsetX + 5;
			textArea.y 			= _offsetY + 5;
			textArea.condenseWhite 		= true;
			textArea.multiline 		= true;
			textArea.wordWrap 		= true;
					
			var format:TextFormat   	= new TextFormat();
			format.size             	= width/20;
			format.align            	= "center";
			format.color			= colorTxt;
			
			textArea.defaultTextFormat 	= format;
			//textArea.text           	= _msg;			
		
			this.addChildAt(shape, 0);
			this.addChildAt(textArea, 1);

			//finally the dropshadow
			var filter:BitmapFilter 	= getBitmapFilter();
			var myFilters:Array = new Array();
			myFilters.push(filter);
			filters = myFilters; 
		}

		protected function getBitmapFilter():BitmapFilter 
		{
		    var color:Number = 0x000000;
		    var angle:Number = 45;
		    var alpha:Number = 0.6;
		    var blurX:Number = 8;
		    var blurY:Number = 8;
		    var distance:Number = 5;
		    var strength:Number = 0.65;
		    var inner:Boolean = false;
		    var knockout:Boolean = false;
		    var quality:Number = BitmapFilterQuality.HIGH;
	    	    return new DropShadowFilter(distance,
		                        angle,
		                        color,
		                        alpha,
		                        blurX,
		                        blurY,
		                        strength,
		                        quality,
		                        inner,
		                        knockout);
		}
	}
}
