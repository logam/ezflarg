/**
 * @Author tcha-tcho
 */

package com.tchatcho 
{
	import flash.display.Sprite;
	import flash.display.MovieClip;
   	import flash.text.TextField;
   	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;

	import flash.display.Shape;
	import flash.filters.BitmapFilter;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.DropShadowFilter

	import org.papervision3d.objects.primitives.Plane;
	import org.papervision3d.materials.MovieMaterial;
	import org.papervision3d.objects.DisplayObject3D;
    
	/*import flash.display.*;*/
	/*import flash.net.URLRequest;*/

	public class NoCamera extends MovieClip //Sprite 
	{
		/*private static const LOADINGPATH:String = "../resources/flar/nocam.swf";*/
		
		private var borderColor:uint  = 0xFFFFFF;
		private var borderSize:uint   = 4;
		private var cornerRadius:uint = 30;
		private var gutter:uint       = 5;

		private var size:uint         = 80;
		private var offset:uint       = 50;

		private var _universe:DisplayObject3D = new DisplayObject3D();

		public function NoCamera(width:int, height:int, message:String, colorTxt:uint, colorBackground:uint) 
		{
			this._universe.name = "universe";

			var shape:Shape = new Shape();
			shape.graphics.beginFill(colorBackground);
			shape.graphics.lineStyle(borderSize, borderColor);
			shape.graphics.drawRoundRect(0, 0, width - 50, height/5, cornerRadius);
			shape.graphics.endFill();
			shape.x = 50;
			shape.y = height/5*2;

			var noCamMsg:TextField  = new TextField();
			
			// noCamMsg.border		= true;
			noCamMsg.width 		= width - 100;
			noCamMsg.x 		= 75;
			noCamMsg.y 		= height/5*2;
			// noCamMsg.embedFonts	= true;
			
			var format:TextFormat   = new TextFormat();
			format.size             = width/20;
			format.align            = "center";
			format.color		= colorTxt;
			// format.font 		= "Verdana";

			noCamMsg.defaultTextFormat = format;
			noCamMsg.text           = message;			
			
			this.addChildAt(shape, 0);
			this.addChildAt(noCamMsg, 1);

			//finally the dropshadow
			var filter:BitmapFilter = getBitmapFilter();
		        var myFilters:Array = new Array();
		        myFilters.push(filter);
		        filters = myFilters;  

			var front_material:MovieMaterial     = new MovieMaterial(this, true);
			front_material.doubleSided           = true;
			var front_plane:Plane = new Plane(front_material, width - 50, height/5, 2, 2);
			//front_plane.scale                    = 0.2;
			front_plane.x                        = 1;
			this._universe.addChild(front_plane);        
			
			//TODO: add support to no cam with a swf, PC problems(im a mac)
			/*var ldr:Loader = new Loader();
			var urlReq:URLRequest = new URLRequest(LOADINGPATH);
			ldr.load(urlReq);
			addChild(ldr);
			ldr.x = (width - 550)/2;
			ldr.y = (height - 400)/2;			*/
		}
	    	
		private function getBitmapFilter():BitmapFilter 
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
