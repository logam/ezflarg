/**
 * @Author tcha-tcho
 */
package com.tchatcho.constructors {
	import org.papervision3d.objects.primitives.Plane;
	import org.papervision3d.materials.WireframeMaterial;

	import org.papervision3d.materials.BitmapFileMaterial;
	import org.papervision3d.events.FileLoadEvent;
	import flash.events.Event;

	import org.papervision3d.objects.DisplayObject3D;

	// TEST
	import com.quilombo.constructors.LoadingEzflarEx;

	public class PICTUREconstructor extends Plane {
		//private var _ldr:LoadingEZFLAR = LoadingEZFLAR();
		private var _ldr:LoadingEzflarEx = new LoadingEzflarEx();

		private var _universe:DisplayObject3D = new DisplayObject3D();
		private var _front_plane:Plane;
		public function PICTUREconstructor(patternId:int, url:String = null, url2:String = null, objName:String = null) {
			_ldr.init();
			startLoader();
			if (url != null){
				var pictureMaterial:BitmapFileMaterial = new BitmapFileMaterial(url, true);
				pictureMaterial.doubleSided = true;
				pictureMaterial.addEventListener( FileLoadEvent.LOAD_COMPLETE , loaderComplete );
				_front_plane = new Plane(pictureMaterial, 500, 500, 4, 4);
			} else {
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
