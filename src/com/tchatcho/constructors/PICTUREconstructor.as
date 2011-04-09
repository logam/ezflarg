/**
 * @Author tcha-tcho
 */
package com.tchatcho.constructors 
{
	import org.papervision3d.objects.primitives.Plane;
	import org.papervision3d.materials.WireframeMaterial;

	import org.papervision3d.materials.BitmapFileMaterial;
	import org.papervision3d.materials.utils.BitmapMaterialTools;
	import org.papervision3d.events.FileLoadEvent;
	import flash.events.Event;

	import org.papervision3d.objects.DisplayObject3D;

	import com.tchatcho.constructors.ILoadingEZFLAR;
	import com.tchatcho.constructors.LoadingEZFLAR;

	public class PICTUREconstructor extends Plane 
	{
		protected var _ldr:ILoadingEZFLAR 	= new LoadingEZFLAR();
		protected var _universe:DisplayObject3D = new DisplayObject3D();
		protected var _front_plane:Plane;
		protected var _pictureMaterial:BitmapFileMaterial;
		protected var _patternId:int;

		public function get patternId():int
		{
			return this._patternId;
		}

		public function get patternName():String
		{
			return this._universe.name;
		}

		public function PICTUREconstructor( patternId:int
						  , url:String = null
						  , url2:String = null
						  , objName:String = null
						  , loader:ILoadingEZFLAR = null
						  ) 
		{
			_patternId = patternId;

			if(loader != null)
			{
				_ldr = loader;
			}
			
			startLoader();
			
			if (url != null)
			{
				_pictureMaterial = new BitmapFileMaterial(url, true);
				_pictureMaterial.doubleSided = /*false*/ true;
				_pictureMaterial.addEventListener( FileLoadEvent.LOAD_COMPLETE , loaderComplete );
				_front_plane = new Plane(_pictureMaterial, 500, 500, 4, 4);
			} 
			else 
			{
				trace("YOU DO IT WRONG! :P, pls use picture like this:....push([['yourpattern', 'yourimage.jpg'],['a_optional_name']]);");
				var wfm:WireframeMaterial = new WireframeMaterial(0xffff00);
				wfm.doubleSided = true;
				_front_plane = new Plane(wfm);
			}
			_front_plane.scale = 0.3;
			this._universe.z = 3;
			if(objName != null){
				this._universe.name = objName
				}else{
					this._universe.name = "universe"
					}
					this._universe.rotationY = 0;
					this._universe.rotationZ = -90;

				}
				public function startLoader():void{
					this._universe.addChild(_ldr.ldrObject);
				}
				public function loaderComplete(evt:Event):void{
					this._universe.removeChild(_ldr.ldrObject);
					this._universe.addChild(_front_plane);
				}
				public function get object():DisplayObject3D{
					return this._universe;
				}
			}
		}
