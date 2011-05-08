/**
	* @Author quilombo
*/
package com.quilombo 
{
	import org.libspark.flartoolkit.core.param.FLARParam;
	import org.papervision3d.objects.DisplayObject3D;
	
	import com.tchatcho.Base_model;
	import com.tchatcho.constructors.ILoadingEZFLAR;
	import com.transmote.flar.FLARMarker;
	
	import com.quilombo.constructors.TXT40constructorEx;
	import com.quilombo.constructors.PICTUREconstructorEx;
	import com.quilombo.constructors.ConstructorEventDispatcher;

	public class BaseModelEx extends Base_model
	{
		protected var _dispatcher:ConstructorEventDispatcher;

		public function BaseModelEx( objects:Array
					   , numPatterns:uint
					   , cameraParams:FLARParam
					   , viewportWidth:Number
					   , viewportHeight:Number
					   , pathToResources:String
					   , modelsPath:String
					   , dispatcher:ConstructorEventDispatcher=null
					   , loader:ILoadingEZFLAR = null) 
		{
			super(objects, numPatterns, cameraParams, viewportWidth, viewportHeight, pathToResources, modelsPath, loader);
			_dispatcher = dispatcher;		
		}
		
		/**
	
		*/
		public override function addMarker (marker:FLARMarker) :void 
		{
			// check if pattern id is available in the pattern array
			if(marker.patternId >= 0 && marker.patternId < super._objects.length )
			{
				super.addMarker(marker);
			}
			else
			{
				trace("BaseModelEx::addMarker() marker is not valid [" + marker.patternId + "]");
			}
		}

		protected override function placeModels ( patternId:int
							, url:String = null
							, url2:String = null
							, objName:String = null
							):DisplayObject3D
		{
			trace("BaseModelEx::placeModels patternId[" + patternId + "] objName[" + objName + "]");
			var ext:String = getExtension(url);
			switch (ext)
			{
				case "TXT" ://txt15chars
				{
					var txt:TXT40constructorEx = new TXT40constructorEx(patternId, url, url2, objName);
					return containerReady(txt.object);
					break;
				}
				case "EXT" ://txt15chars
				{
					var text:TXT40constructorEx = new TXT40constructorEx(patternId, url, url2, objName);
					return containerReady(text.object);
					break;
				}

				case "JPG" ://picture jpg
				{
					var jpg:PICTUREconstructorEx = new PICTUREconstructorEx(patternId, url, url2, objName, _dispatcher, _ldr);
					return containerReady(jpg.object);
					break;
				}
				case "PEG" ://picture jpeg
				{				
					var jpeg:PICTUREconstructorEx = new PICTUREconstructorEx(patternId, url, url2, objName, _dispatcher, _ldr);
					return containerReady(jpeg.object);
					break;
				}
				case "GIF" ://picture gif
				{
					var gif:PICTUREconstructorEx = new PICTUREconstructorEx(patternId, url, url2, objName, _dispatcher, _ldr);
					return containerReady(gif.object);
					break;
				}
				case "PNG" ://picture png
				{
					var png:PICTUREconstructorEx = new PICTUREconstructorEx(patternId, url, url2, objName, _dispatcher, _ldr);
					return containerReady(png.object);
					break;
				}
				default ://call superclass
				{
					return super.placeModels(patternId, url, url2, objName);
					break;
				}
			}
		}
	}

}
