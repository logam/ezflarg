/**
 * @Author quilombo
 */
package com.quilombo.constructors 
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.Sprite;

	import org.papervision3d.events.InteractiveScene3DEvent;

	import com.tchatcho.constructors.PICTUREconstructor;
	import com.tchatcho.constructors.ILoadingEZFLAR;
	import com.quilombo.constructors.ConstructorEventDispatcher;

	public class PICTUREconstructorEx extends PICTUREconstructor 
	{
		protected var _dispatcher:ConstructorEventDispatcher;

		public function PICTUREconstructorEx	( patternId:int
						  	, url:String = null
						  	, url2:String = null
						  	, objName:String = null
							, dispatcher:ConstructorEventDispatcher=null
						  	, loader:ILoadingEZFLAR = null
						  	) 
		{
			super(patternId, url, url2, objName, loader);
			_dispatcher = dispatcher;
		}

		protected function mouseClickHandler(event:InteractiveScene3DEvent):void 
		{ 
			trace("PICTUREconstructorEx::mouseClickHandler"); 

			// dispatch event to inform all listeners that the image has been clicked
			_dispatcher.onClick(patternName, patternId);
		}

		protected function mouseOverHandler(event:InteractiveScene3DEvent):void 
		{ 
			trace("PICTUREconstructorEx::mouseOverHandler"); 

			// dispatch event to inform all listeners that the moused moved over the image
			_dispatcher.onMouseOver(patternName, patternId);
		}

		protected function mouseOutHandler(event:InteractiveScene3DEvent):void 
		{ 
			trace("PICTUREconstructorEx::mouseOutHandler"); 

			// dispatch event to inform all listeners that the mouse left the image
			_dispatcher.onMouseOut(patternName, patternId);
		}
	
		public override function loaderComplete(evt:Event):void
		{	
			// must be set to true in order to receive mouse events
			// the 3d viewport must also be interactive in order to detect events 
			_pictureMaterial.interactive = true;
			
			// Will trigger "onPress" when the object is pressed (clicked)
			_front_plane.addEventListener( InteractiveScene3DEvent.OBJECT_PRESS, mouseClickHandler );
			
			// Will trigger "onOver" when the mouse rolls over the object 
            		_front_plane.addEventListener( InteractiveScene3DEvent.OBJECT_OVER, mouseOverHandler ); 
            		
			//  Will trigger "onOut" when the mouse leaves the object
			_front_plane.addEventListener( InteractiveScene3DEvent.OBJECT_OUT, mouseOutHandler ); 
	
			super.loaderComplete(evt);

					
		}
	}
}
