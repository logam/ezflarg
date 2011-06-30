/**
* @Author tcha-tcho
*/
package com.tchatcho.constructors {
	import flash.display.MovieClip;
	import flash.net.navigateToURL;
    import flash.net.URLRequest;
	import org.papervision3d.objects.DisplayObject3D;

	public class URLconstructor extends MovieClip {
		private var _url:String;
        private var _request:URLRequest;
        private var _universe:DisplayObject3D = new DisplayObject3D();
		public function URLconstructor(patternId:int, url:String = null, url2:String = null, objName:String = null) 
		{
			trace("URLconstructor() patterId[ " + patternId + " ] url[" + url + "] url2[ " + url2 + "] objName[" + objName + "]" );
			
			var cleanURL:String = url2;// url2.split("/").pop();
			_url = cleanURL;
			trace("URLconstructor() opening the site [" + _url + "]");
	        	_request = new URLRequest(_url);
			if(objName != null){
				this._universe.name = objName
				}else{
					this._universe.name = "universe"
				}
			trace("URLconstructor() url request [" + _request.url + "]");
			navigateToURL(_request , "_self");
		}
		public function get object():DisplayObject3D{
			return this._universe;
		}
	}
}
