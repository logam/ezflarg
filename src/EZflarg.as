//you can use this approach to write as outside flash (this let me use my TextMate  :)
// to use this you have to write "Main" in /properties(tab)/Document Class... remember to take off the code placed at frame 1
package 
{
	import flash.events.Event;
	import flash.net.URLLoader;	
	import flash.net.URLRequest;
	import flash.display.MovieClip;
	import flash.media.Camera;
	import flash.text.TextField;

	import flash.net.navigateToURL;
    	import flash.net.URLRequest;

	import mx.utils.ObjectUtil;

	import com.tchatcho.EZflar;	//tcha-tcho.com
	import com.tchatcho.NoCamera;
	import com.transmote.flar.FLARMarkerEvent;	
	
	// own stuff
	import com.quilombo.constructors.LoadingEzflarEx;
	import com.quilombo.constructors.PatternNameEvent;

	import com.quilombo.display.StartScreen;
	import com.quilombo.display.StartScreenLayout;
	import com.quilombo.display.GenericButton;

	import com.quilombo.EZflarEx;
	import com.quilombo.ConfigHolder;
	import com.quilombo.ConfigLoaderXML;
	import com.quilombo.PatternLoaderXML;
	import com.quilombo.FileLoaderXML;

	import flash.external.ExternalInterface;


	public class EZflarg extends MovieClip 
	{
		protected var _ezflar:EZflarEx;
		protected var _symbols:Array = new Array();
		protected var _configuration:ConfigHolder;
		protected var _externalHtmlCallback:Function = getTextFromJavaScript;

		protected var _startScreen:StartScreen;
		
		protected var _resourcePath:String 	= "./resources/";
		protected var _filesFile:String		= _resourcePath + "xmlfiles.xml";		
		protected var _configFile:String;
		protected var _patternFile:String;
		protected var _modeFile:String;

		/**
			the event function that gets called on completion of reading the objects.xml file.
			here, we extract all media library elements and initialize the program. 

			the loadConfig function must have been called before in order to have a fully initialized
			configuration object used to initialize EZflarEx
		*/
		protected function initMain(e:Event):void
		{
			// process xml first and load available data
			trace("process xml");			
			loadPatterns(e);

			// setup ezflar
			trace("initialize ezflar");
			_ezflar = new EZflarEx(_configuration);
			
			_ezflar.initializer(stage, _resourcePath);
			_ezflar.customizeNoCam("sorry no cam...", 0xFFFFFF, 0x444444 );			

			_ezflar.onStarted(function():void 
			{
				// _ezflar.addModelTo([0,"Example_FLV.flv"], ["myflv"]);
				// _ezflar.addModelTo([0,"twitter", "ezflar"], ["mytwitter"]);
				// _ezflar.addModelTo([0,"text", "zone ar"], ["textStart"]);
				trace("EZflarg::onStarted");
			});
			_ezflar.onAdded(function(marker:FLARMarkerEvent):void 
			{
				// _ezflar.getObject(0,"mygif").rotationX = 90;
				// _ezflar.getObject(0,"los").rotationX = 90;
				trace("EZflarg::onAdded: " + marker.marker.patternId);
			});
			_ezflar.onUpdated(function(marker:FLARMarkerEvent):void 
			{
				/*
				trace("EZflarg::onUpdated: ["+ marker.marker.patternId+"]>>" +
					  "X:" + marker.x() + " || " +
					  "Y:" + marker.y() + " || " +
					  "Z:" + marker.z() + " || " +
					  "RX:" + marker.rotationX() + " || " +
					  "RY:" + marker.rotationY() + " || " +
					  "RZ:" + marker.rotationZ() + " || "
				);
				*/	
			});
			_ezflar.onRemoved(function(marker:FLARMarkerEvent):void 
			{
				trace("EZflarg::onRemoved: " + marker.marker.patternId);
			});	

			_ezflar.onMarkerClicked( function(event:PatternNameEvent):void
			{
				loadUrlOnClicked(event);
			});
		}

		protected function loadUrlOnClicked(event:PatternNameEvent):void
		{
			trace("EZflarEx::loadObjects for pattern [" + event.patternName + "]");
			var url1:String = "file://" + _configuration.contentPath + "marker001.html";
			var url2:String = "file://" + _configuration.contentPath + "marker002.html";
			var url3:String = "file://" + _configuration.contentPath + "marker003.html";
			var url4:String = "file://" + _configuration.contentPath + "marker004.html";
			var url5:String = "file://" + _configuration.contentPath + "marker005.html";
			var url6:String = "file://" + _configuration.contentPath + "marker006.html";
			var url7:String = "file://" + _configuration.contentPath + "marker007.html";
			var url8:String = "file://" + _configuration.contentPath + "marker008.html";

			var request:URLRequest;
			
			if( event.patternName == "marker001" )
			{
				request = new URLRequest(url1);
			}
			if( event.patternName == "marker002" )
			{
				request = new URLRequest(url2);
			}
			if( event.patternName == "marker003" )
			{
				request = new URLRequest(url3);
			}
			if( event.patternName == "marker004" )
			{
				request = new URLRequest(url4);
			}
			if( event.patternName == "marker005" )
			{
				request = new URLRequest(url5);
			}
			if( event.patternName == "marker006" )
			{
				request = new URLRequest(url6);
			}
			if( event.patternName == "marker007" )
			{
				request = new URLRequest(url7);
			}
			if( event.patternName == "marker008" )
			{
				request = new URLRequest(url8);
			}

			try 
			{
				navigateToURL(request, '_blank');
			} 
			catch (e:Error) 
			{
				trace("EZflarEx::loadObjects() Error occurred while loading url [" + request + "]");
			}
		}

		/**
			just reads the xml file that represents the pattern and media library
			the library distinguishes between two types of elements: mediaelement and textElement
			mediaElement contains all media resources such as images, videos, audios, etc
			textElement contains all text based resources such as text, urls, etc

			all library elements are read out and pushed into the _symbols array which gets then
			copied into the configuration object
		*/
		protected function loadPatterns(e:Event):void 
		{
			var patternLoaderXML:PatternLoaderXML = new PatternLoaderXML();
			_configuration.objects = patternLoaderXML.load(e.target.data) as Array;
		}

		/**
			the event function that gets called on completion of loading the programs config file.
			here, we read out all configuration values and store them in a configuration object which 
			gets then passed later on to the EZflarEx object.
		*/
		protected function loadConfig(e:Event):void
		{
			var cfgLoaderXML:ConfigLoaderXML = new ConfigLoaderXML();
			_configuration = cfgLoaderXML.load(e.target.data) as ConfigHolder;
			trace( _configuration.asString() ); // for debug purpose only
		}	

		protected function loadXmlFiles(e:Event):void
		{
			var filesLoaderXML:FileLoaderXML = new FileLoaderXML();
			var files:Array = filesLoaderXML.load(e.target.data) as Array;
			
			/**	FIXME: not nice to use hardcoded indices. would be better to a file object
				instead an Array, but for the moment its sufficient
			*/
			_configFile	= _resourcePath + files[0]; 
			_patternFile	= _resourcePath + files[1];
			_modeFile 	= _resourcePath + files[2];
			
			trace("EZflarg::loadXmlFiles: config[" + _configFile + "] pattern[" + _patternFile + "] mode[" + _modeFile + "]");

			/** 	LOAD configuration file first in order to determine configuration 
				values for pattern detection and the scene!
			*/
			var configLoader:URLLoader = new URLLoader();
			configLoader.addEventListener(Event.COMPLETE, loadConfig);
			configLoader.load(new URLRequest(_configFile));

			/** 	LOAD object library and patterns. 
			*/
			var xmlLoader:URLLoader = new URLLoader();
			xmlLoader.addEventListener(Event.COMPLETE, initMain);
			xmlLoader.load(new URLRequest(_patternFile));
			// xmlLoader.addEventListener(Event.COMPLETE, initStartScreen);
		}

		public function EZflarg() 
		{
			// the files.xml file must be loaded first because it determines which config and pattern
			// files will be loaded afterwards. thus, all further loading is done in loadXmlFiles()
			var fileLoader:URLLoader = new URLLoader();
			fileLoader.addEventListener(Event.COMPLETE, loadXmlFiles);
			fileLoader.load(new URLRequest(_filesFile));
			
			// setup a callback for the external interface in order to communicate
			// from the outside world (a html page) with this application
			ExternalInterface.addCallback("sendTextToFlash", getTextFromJavaScript);
		}
		
		/**
			this functions gets called from an external html page in order to exchange user interaction
			information. the information are dispatched here and can be used for example to alter the 
			logic of the game according to interaction in the external html page
		*/
		protected function getTextFromJavaScript(str:String):void 
		{
			trace("EZflarg::getTextFromJavaScript: received text[" + str + "]");
		}

		protected function initStartScreen(e:Event):void
		{
			
			var startScreenLayout:StartScreenLayout = new StartScreenLayout();
			
			startScreenLayout.addElement( 75, 75, constructButton(40, 20, 5) ); // language en			
			startScreenLayout.addElement( 75, 100, constructButton(40, 20, 5) ); // language de			
			
			startScreenLayout.addElement( 175, 75, constructButton(100, 80, 5) ); // quest button			
			startScreenLayout.addElement( 300, 75, constructButton(100, 80, 5) ); // tour button

			startScreenLayout.addElement( 100, 175, constructTextArea(300, 50) );
			// startScreenLayout.addElement( 100, 125, constructUnsupportedCam(300, 150) );
			
			_startScreen = new StartScreen();
			_startScreen.init(400, 200, 50, 50, 0x444444, startScreenLayout);
			this.addChild(_startScreen);
		}
		
		protected function constructUnsupportedCam(width:uint, height:uint):NoCamera
		{
			var messageNoCam:String = "cam not supported";
			if(Camera.getCamera())
			{
				messageNoCam = messageNoCam + "\n[" + Camera.getCamera().name + "]";
			}			
			return new NoCamera(width, height, messageNoCam, 0xFFFFFF, 0x444444);				
		}
				
		protected function constructTextArea(width:uint, height:uint):TextField
		{
			var textArea:TextField = new TextField(); 
			textArea.border = true;
			textArea.background = true;
			textArea.backgroundColor = 0xFFFFFF;			
			textArea.textColor = 0x000000;			
			textArea.height = height;
			textArea.width = width;	 
			textArea.condenseWhite = true;
			textArea.text = "das textfeld mit beschreibungen"
			return textArea;
		}

		protected function constructButton(width:uint, height:uint, cornerRadius:uint):GenericButton
		{
			var button:GenericButton = new GenericButton(width, height, 0x222222, 0x888888, cornerRadius, 3);
			return button;
		}
	}
}
