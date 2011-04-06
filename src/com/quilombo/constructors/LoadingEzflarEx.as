/**
 * @Author tcha-tcho
 */
package com.quilombo.constructors 
{
	import flash.display.MovieClip;
	import flash.display.Shape;

	import com.tchatcho.constructors.ILoadingEZFLAR;

	import org.papervision3d.objects.primitives.Plane;
	import org.papervision3d.materials.MovieMaterial;
	import org.papervision3d.objects.DisplayObject3D;

	public class LoadingEzflarEx extends MovieClip implements ILoadingEZFLAR
	{
		private var _universe:DisplayObject3D = new DisplayObject3D();

		/**

		*/
		public function LoadingEzflarEx()
		{
			super();
			init();
		}
		
		protected function	init():void
		{
			var child:Shape = new Shape();
			child.graphics.beginFill(0xCC0066/*0xCCCCCC*/, 0.25 /*alpha*/);
			child.graphics.lineStyle(3 /*2*/, 0xFFFFFF, 0.25 /*alpha*/);
			child.graphics.drawCircle(0, 0, 75); // hardcoded middle of the screen if resolution is 640x480
			child.graphics.endFill();
			super.addChild(child);
			
			var front_material:MovieMaterial     = new MovieMaterial(this, true);
			front_material.doubleSided           = true;
			var front_plane:Plane = new Plane(front_material, 400, 400, 2, 2);
			front_plane.scale                    = 0.2;
			front_plane.x                        = 1;
			_universe.addChild(front_plane);
		}
		
		public function get ldrObject():DisplayObject3D
		{
			return this._universe;
		}
	}
}
