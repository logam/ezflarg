/**
	* @Author tcha-tcho
	*/
package com.tchatcho {
	//to flar
	import com.transmote.flar.FLARMarker;
	import com.transmote.utils.geom.FLARPVGeomUtils;
	import flash.display.Sprite;
	import flash.events.Event;

	import org.libspark.flartoolkit.core.param.FLARParam;
	import org.libspark.flartoolkit.pv3d.FLARCamera3D;
	import org.papervision3d.lights.PointLight3D;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.render.LazyRenderEngine;
	import org.papervision3d.scenes.Scene3D;
	import org.papervision3d.view.Viewport3D;
	
	//to construct models
	import com.tchatcho.constructors.SWFconstructor;
	import com.tchatcho.constructors.FLVconstructor;
	import com.tchatcho.constructors.DAEconstructor;
	import com.tchatcho.constructors.MD2constructor;
	import com.tchatcho.constructors.CUBEconstructor;
	import com.tchatcho.constructors.PICTUREconstructor;
	import com.tchatcho.constructors.WIREconstructor;
	import com.tchatcho.constructors.TWITTERconstructor;
	import com.tchatcho.constructors.MP3constructor;
	import com.tchatcho.constructors.MP3Events;
	import com.tchatcho.constructors.TXT40constructor;
	import com.tchatcho.constructors.URLconstructor;
		
	import com.tchatcho.constructors.ILoadingEZFLAR;

	public class Base_model extends Sprite 
	{	//Or BasicView

		//initiate global vars
		private var _viewport3D:Viewport3D;
		private var _camera3D:FLARCamera3D;
		/*private*/ protected var _scene3D:Scene3D;
		private var _renderEngine:LazyRenderEngine;
		private var _pointLight3D:PointLight3D;

		protected var _objects:Array;
		private var _numPatterns:uint;
		private var _pathToResources:String;
		private var _modelsPath:String;
		private var _objectsToAdd:Array = new Array();
		private var _markersByPatternId:Array;// FLARMarkers and Models, arranged by patternId
		private var _newCount:Date;
		private var _oldCount:Date;
		private var _firstLock:Boolean;
	
		private   var mp3events:MP3Events 	= new MP3Events();
		protected var _ldr:ILoadingEZFLAR 	= null;

		public function Base_model ( objects:Array
					   , numPatterns:uint
					   , cameraParams:FLARParam
					   , viewportWidth:Number
					   , viewportHeight:Number
					   , pathToResources:String
					   , modelsPath:String
					   , loader:ILoadingEZFLAR = null) 
		{
			this._objects 		= objects;
			this._numPatterns 	= numPatterns;
			this._pathToResources 	= pathToResources;
			this._modelsPath 	= modelsPath;
			this._ldr 		= loader; // can be null, no check necessary

			this.init();
			this.initPapervisionEnvironment(cameraParams, viewportWidth, viewportHeight);
		}

	public function addMarker (marker:FLARMarker) :void 
	{
		if(_firstLock == false)
		{
			removeMarker(marker);
		}

		var objectsToAdd:Array = new Array();
		for (var i:int = 0; i < _objectsToAdd.length; i++)
		{
			objectsToAdd.push(_objectsToAdd[i])
		}
		
		trace( "Base_model::addMarker() _objects[ " + marker.patternId + "] [" + _objects[marker.patternId].toString() + "]" );
		objectsToAdd.push([constructURL([ marker.patternId
						, _objects[marker.patternId][0][1]
						, _objects[marker.patternId][0][2]])
						, _objects[marker.patternId][1]]);

		// associate container with corresponding marker
		for (var j:int = 0; j < objectsToAdd.length; j++)	
		{
			if(objectsToAdd[j][0][0] == marker.patternId)
			{
				var modelParsed:DisplayObject3D = placeModels(
									objectsToAdd[j][0][0], 	// marker id
									objectsToAdd[j][0][1], 	// url1
									objectsToAdd[j][0][2], 	// url2
									objectsToAdd[j][1]);	// marker name

				this._markersByPatternId.push(new Array (objectsToAdd[j][0][0], marker, modelParsed));
			}
		}
		_oldCount = new Date();
		_firstLock = false;
	}
		

		public function removeMarker (marker:FLARMarker) :void {
			// find and remove marker
			_newCount = new Date();
			if((_newCount.getTime() - _oldCount.getTime()) > 40)
			{	//prevent inconsistences
				var markerList:Array = new Array();
				var markerList2:Array = new Array;
				for (var i:int = 0; i < this._markersByPatternId.length; i++)
				{
					markerList.push(this._markersByPatternId[i])
				}
				for (var j:int = 0; j < markerList.length; j++ ) 
				{
					if (markerList[j][0] == marker.patternId)
					{
						this._scene3D.removeChild(markerList[j][2]);
					} 
					else 
					{
						markerList2.push(markerList[j])
					}
				}
				this._markersByPatternId = markerList2;
				};
				mp3events.dispatchMP3 = true;
			}
			/*private*/ protected function updateModels () :void {
				// update all Models containers according to the transformation matrix in their associated FLARMarkers
				for (var i:int = 0; i < this._markersByPatternId.length; i++)
				{
					this._markersByPatternId[i][2].transform 
						= FLARPVGeomUtils.translateFLARMatrixToPVMatrix(this._markersByPatternId[i][1].transformMatrix);
				}
			}
			private function init () :void 
			{
				this._markersByPatternId = new Array();
				_firstLock = true;
			}

			private function initPapervisionEnvironment (cameraParams:FLARParam, viewportWidth:Number, viewportHeight:Number) :void 
			{
				this._scene3D = new Scene3D();
				this._camera3D = new FLARCamera3D(cameraParams);
				this._viewport3D = new Viewport3D(viewportWidth, viewportHeight, false, true);
				this.addChild(this._viewport3D);
				this._renderEngine = new LazyRenderEngine(this._scene3D, this._camera3D, this._viewport3D);

				this._pointLight3D = new PointLight3D();
				this._pointLight3D.x = 1000;
				this._pointLight3D.y = 1000;
				this._pointLight3D.z = -1000;

				this.addEventListener(Event.ENTER_FRAME, this.onEnterFrame);
			}

			private function onEnterFrame (evt:Event) :void {
				this.updateModels();
				this._renderEngine.render();
			}

			protected function getExtension(url:String):String
			{
				var ext:String = url.toString();
				ext = ext.substring(ext.length - 3,ext.length).toUpperCase();
				return ext;
			}

			/*private*/ protected function placeModels(patternId:int, url:String = null, url2:String = null, objName:String = null):DisplayObject3D{
	
				var _format:String = getExtension(url);				
				switch (_format){
					
					case "SWF" ://*.swf
					var swf:SWFconstructor = new SWFconstructor(patternId, url, url2, objName, _ldr)
					return containerReady(swf.object);
					break;

					case "FLV" ://*.flv
					var flv:FLVconstructor = new FLVconstructor(patternId, url, url2, objName, _ldr);
					return containerReady(flv.object);
					break;

					case "DAE" : //*.dae
					var dae:DAEconstructor = new DAEconstructor(patternId, url, url2, objName, _ldr);
					return containerReady(dae.object);
					break;

					case "MD2" ://*.md2
					var md2:MD2constructor = new MD2constructor(patternId, url, url2, objName, _ldr);
					return containerReady(md2.object);
					break;

					case "UBE" ://cube
					var cube:CUBEconstructor = new CUBEconstructor(patternId, url, url2, objName, _ldr);
					return containerReady(cube.object);
					break;

					case "JPG" ://picture jpg
					var jpg:PICTUREconstructor = new PICTUREconstructor(patternId, url, url2, objName, _ldr);
					return containerReady(jpg.object);
					break;

					case "PEG" ://picture jpeg
					var jpeg:PICTUREconstructor = new PICTUREconstructor(patternId, url, url2, objName, _ldr);
					return containerReady(jpeg.object);
					break;

					case "GIF" ://picture gif
					var gif:PICTUREconstructor = new PICTUREconstructor(patternId, url, url2, objName, _ldr);
					return containerReady(gif.object);
					break;

					case "PNG" ://picture png
					var png:PICTUREconstructor = new PICTUREconstructor(patternId, url, url2, objName, _ldr);
					return containerReady(png.object);
					break;
					
					case "MP3" ://*.mp3
					var mp3:MP3constructor = new MP3constructor(patternId, mp3events, url, url2, objName, _ldr);
					return containerReady(mp3.object);
					break;

					case "IRE" ://wire
					var wire:WIREconstructor = new WIREconstructor(patternId, url, url2, objName, _ldr);
					return containerReady(wire.object);
					break;

					case "TER" ://twitter
					var twitter:TWITTERconstructor = new TWITTERconstructor(patternId, url, url2, objName, _ldr);
					return containerReady(twitter.object);
					break;
					
					case "TXT" ://txt15chars
					var txt:TXT40constructor = new TXT40constructor(patternId, url, url2, objName);
					return containerReady(txt.object);
					break;

					case "EXT" ://txt15chars
					var text:TXT40constructor = new TXT40constructor(patternId, url, url2, objName);
					return containerReady(text.object);
					break;

					case "URL" ://navigate to url
					var nturl:URLconstructor = new URLconstructor(patternId, url, url2, objName);
					return containerReady(nturl.object);
					break;

					case "PTY" ://empty
					var _universe:DisplayObject3D = new DisplayObject3D();
					_universe.z = 50;
					if(objName != null){
						_universe.name = objName;
					} else {
						_universe.name = "universe";
					}
					this._scene3D.addChild(_universe);
					return _universe;
					break;

					default ://wrong format
					trace(_format + " WE CANT USE THIS ;( PLS, USE: *.swf, *.flv, *.dae, *.md2, cube, picture, wire or empty... DONT FORGET TO PUT IN RESOURCES/MODELS FOLDER");
					var container : DisplayObject3D = new DisplayObject3D();
					return container;					
					break;
				}
			}
			/*private*/ protected function containerReady(object:DisplayObject3D):DisplayObject3D{
				var container:DisplayObject3D = new DisplayObject3D();//i dont know why we need a container, :(
				container.addChild(object);
				this._scene3D.addChild(container);
				return container;
			}
			public function getObjectByName(onMarker:int,thisName:String):Array{
				var arrToReturn:Array = new Array();
				for (var i:int = 0; i < this._markersByPatternId.length; i++){
					if (this._markersByPatternId[i][0] == onMarker){
						if (this._markersByPatternId[i][2].getChildByName(thisName) != null){
							arrToReturn.push(this._markersByPatternId[i][2].getChildByName(thisName));
						};			
					};
				};
				return arrToReturn;
			}
				public function addModelToStage(set1:Array, set2:Array = null):void {
					this._objectsToAdd.push([constructURL(set1), set2])
					}

					public function constructURL(income:Array):Array
					{
						trace( "Base_model::constructURL income [" + income.toString() + "]"  );
						var url1:String = new String();
						var url2:String = new String();
						if (income[1] != null){
							url1 = _pathToResources + _modelsPath + income[1];
						} else {
							url1 = null;
						}
						if (income[2] != null)
						{
							if( income[2].search("http://") || 
							    income[2].search("https://")|| 
							    income[2].search("www.") 	||
							    income[2].search("file:///") 
							  )
							{	
								url2 = income[2];
							}
							else
							{
								url2 = _pathToResources + _modelsPath + income[2];
							}
						} 
						else 
						{
							url2 = null;
						}
						return [income[0],url1,url2]
						}
					}
				}
