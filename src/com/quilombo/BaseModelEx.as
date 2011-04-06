/**
	* @Author quilombo
*/
package com.quilombo 
{
	import org.papervision3d.objects.DisplayObject3D;

	import org.libspark.flartoolkit.core.param.FLARParam;
	
	import com.tchatcho.Base_model;
	import com.tchatcho.constructors.ILoadingEZFLAR;
	
	import com.quilombo.constructors.TXT40constructorEx;

	public class BaseModelEx extends Base_model
	{
		public function BaseModelEx( objects:Array
					   , numPatterns:uint
					   , cameraParams:FLARParam
					   , viewportWidth:Number
					   , viewportHeight:Number
					   , pathToResources:String
					   , modelsPath:String
					   , loader:ILoadingEZFLAR = null) 
		{
			super(objects, numPatterns, cameraParams, viewportWidth, viewportHeight, pathToResources, modelsPath, loader);
		}

		protected override function placeModels ( patternId:int
							, url:String = null
							, url2:String = null
							, objName:String = null
							):DisplayObject3D
		{
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
				default ://call superclass
				{
					return super.placeModels(patternId, url, url2, objName);
					break;
				}
			}
		}
	}

}
