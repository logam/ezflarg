//you can use this approach to write as outside flash (this let me use my TextMate  :)
// to use this you have to write "Main" in /properties(tab)/Document Class... remember to take off the code placed at frame 1
package 
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;

	import flash.net.URLLoader;	
	import flash.net.URLRequest;
	import flash.net.navigateToURL;

	import flash.display.MovieClip;
	import flash.media.Camera;
	import flash.text.TextField;
	import flash.text.TextFormat;

	import mx.utils.ObjectUtil;
	 
	//tcha-tcho.com
	import com.tchatcho.EZflar;	
	import com.tchatcho.NoCamera;

	import com.transmote.flar.FLARMarkerEvent;	
	import com.transmote.flar.FLARMarker;

	// own stuff
	import com.quilombo.constructors.LoadingEzflarEx;
	import com.quilombo.constructors.PatternNameEvent;

	import com.quilombo.display.StartScreen;
	import com.quilombo.display.StartScreenLayout;
	import com.quilombo.display.GenericButton;

	import com.quilombo.EZflarEx;
	import com.quilombo.ConfigHolder;
	import com.quilombo.FileHolder;
	import com.quilombo.ConfigLoaderXML;
	import com.quilombo.PatternLoaderXML;
	import com.quilombo.FileLoaderXML;
	import com.quilombo.ModeLoaderXML;
	import com.quilombo.ActionLoaderXML;
	import com.quilombo.MarkerSequenceMode;
	import com.quilombo.ActionDispatcher;
	import com.quilombo.IMode;

	import flash.external.ExternalInterface;


	public class EZflarg extends MovieClip 
	{
		protected var _ezflar:EZflarEx;
		protected var _symbols:Array = new Array();
		protected var _configuration:ConfigHolder;
		protected var _actionDispatcher:ActionDispatcher;
		protected var _externalHtmlCallback:Function = getTextFromJavaScript;

		protected var _startScreen:StartScreen;
		
		protected var _resourcePath:String 	= "./resources/";
		protected var _filesFile:String		= _resourcePath + "xmlfiles.xml";		
		protected var _files:FileHolder;		

		protected var _markerMode:IMode; 

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
				trace("EZflarg::onStarted");
			});
			
			/**
				this callback gets called before the onAdded callback.if a _markerMode is existing, its detect method gets called.
				detect calls another callback of this class. that callback may change the event argument, i.e to prevent that the
				object attached to the marker gets displayed. if no _markerMode is available, onPreAdded just returns the received
				event without altering it.
			*/
			_ezflar.onPreAdded(function(event:FLARMarkerEvent):FLARMarkerEvent 
			{
				trace("EZflarg::onPreAdded: " + event.marker.patternId)
				return event;
			});

			_ezflar.onAdded(function(event:FLARMarkerEvent):void 
			{
				trace("EZflarg::onAdded: " + event.marker.patternId);

				if( _markerMode != null )
				{
					event = _markerMode.detected( _ezflar.patternName(event.marker.patternId), event );
				}
						
			});
			
			_ezflar.onUpdated(function(marker:FLARMarkerEvent):void 
			{});

			_ezflar.onRemoved(function(marker:FLARMarkerEvent):void 
			{
				trace("EZflarg::onRemoved: " + marker.marker.patternId);
			});	

			_ezflar.onMarkerClicked( function(event:PatternNameEvent):void
			{
				loadUrlOnClicked(event);
			});

			_ezflar.onMarkerMouseOver( function(event:PatternNameEvent):void
			{
				markerMouseOver(event);
			});

			_ezflar.onMarkerMouseOut( function(event:PatternNameEvent):void
			{
				markerMouseOut(event);
			});
		}

		protected function markerMouseOver(event:PatternNameEvent):void
		{
			trace("EZflarEx::markerMouseOver for pattern [" + event.patternName + "]");
		}

		protected function markerMouseOut(event:PatternNameEvent):void
		{
			trace("EZflarEx::markerMouseOut for pattern [" + event.patternName + "]");
		}	
		
		/**
			FIXME: no hardcoded stuff in here. for the moment ok but later on those information must be loaded
			through an xml file
		*/
		protected function loadUrlOnClicked(event:PatternNameEvent):void
		{
			trace("EZflarEx::loadObjects for pattern [" + event.patternName + "]");

			_actionDispatcher.execute( ActionDispatcher.OnClicked, event.patternName );
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
			trace( "EZflarg::loadConfig(): " + _configuration.toString() ); // for debug purpose only
		}

		protected function loadMode(e:Event):void
		{
			var modeLoaderXML:ModeLoaderXML = new ModeLoaderXML();
			_markerMode = modeLoaderXML.load(e.target.data) as IMode;

			if( _markerMode != null )
			{
				var sequenceMode:MarkerSequenceMode = _markerMode as MarkerSequenceMode;
				if(sequenceMode != null)
				{
					sequenceMode.onDetection
					(
						function(markerName:String, event:FLARMarkerEvent):FLARMarkerEvent
						{
							trace("EZflarg::onDetection: " + event.marker.patternId);
							_ezflar.getObject(event.marker.patternId, markerName).visible = true;
							return event;
						}						
					);
					
					sequenceMode.onNotNextInSequence
					(
						function(markerName:String, event:FLARMarkerEvent, message:String):FLARMarkerEvent
						{
							trace("EZflarg::onNotNextInSequence: " + event.marker.patternId);
							
							/**
								for now it is assumed that the returned object is a DisplayObject3D.
								this may true if the current marker represents a graohic object.
								in case the marker represents a link there will be probably the problem
								that the link cant be made "invisible" and may get invoked anyway.
								this function is supposed to prevent that as well as showing images, but it
								may currently fail in disabling urls, audio, etc.
							*/
							_ezflar.getObject(event.marker.patternId, markerName).visible = false;

							return event;
						}
					);

					sequenceMode.onMarkerPreviouslyDetected
					(
						function(markerName:String, event:FLARMarkerEvent, message:String):FLARMarkerEvent
						{
							trace("EZflarg::onMarkerPreviouslyDetected: " + event.marker.patternId);
							_ezflar.getObject(event.marker.patternId, markerName).visible = false;
							return event;
						}
					);

					sequenceMode.onMarkerAlreadyDetected
					(
						function(markerName:String, event:FLARMarkerEvent, message:String):FLARMarkerEvent
						{
							trace("EZflarg::onMarkerAlreadyDetected: " + event.marker.patternId);
							_ezflar.getObject(event.marker.patternId, markerName).visible = true;
							return event;
						}
					);
				}
			}
		}

		protected function loadActions(e:Event):void
		{
			var actionLoaderXML:ActionLoaderXML = new ActionLoaderXML();
			_actionDispatcher = actionLoaderXML.load(e.target.data) as ActionDispatcher;
			trace("EZflarg::loadActions(): " + _actionDispatcher.asString());
		}

		protected function loadXmlFiles(e:Event):void
		{
			var filesLoaderXML:FileLoaderXML = new FileLoaderXML();
			// var files:Array = filesLoaderXML.load(e.target.data) as Array;
			_files = filesLoaderXML.load(e.target.data) as FileHolder;
			_files.resourcePath = _resourcePath;
			
			trace("EZflarg::loadXmlFiles():\n" + _files.toString());
			
			/** 	LOAD the mode file which determines whether patterns can be detected in 
				sequence or random order
			*/
			var modeLoader:URLLoader = new URLLoader();
			modeLoader.addEventListener(Event.COMPLETE, loadMode);
			modeLoader.addEventListener(IOErrorEvent.IO_ERROR, onIoErrorloadXmlFiles);
			modeLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityErrorXmlFiles);
			modeLoader.load(new URLRequest(_files.modeFile));

			/** 	LOAD configuration file before the patterns in order to determine configuration 
				values for pattern detection and the scene!
			*/
			var configLoader:URLLoader = new URLLoader();
			configLoader.addEventListener(Event.COMPLETE, loadConfig);
			configLoader.addEventListener(IOErrorEvent.IO_ERROR, onIoErrorloadXmlFiles);
			configLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityErrorXmlFiles);
			configLoader.load(new URLRequest(_files.configFile));

			/** 	LOAD action description. 
			*/
			var actionLoader:URLLoader = new URLLoader();
			actionLoader.addEventListener(Event.COMPLETE, loadActions);
			actionLoader.addEventListener(IOErrorEvent.IO_ERROR, onIoErrorloadXmlFiles);
			actionLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityErrorXmlFiles);
			actionLoader.load(new URLRequest(_files.actionFile));

			/** 	LOAD object library and patterns. 
			*/
			var xmlLoader:URLLoader = new URLLoader();
			xmlLoader.addEventListener(Event.COMPLETE, initMain);
			xmlLoader.addEventListener(IOErrorEvent.IO_ERROR, onIoErrorloadXmlFiles);
			xmlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityErrorXmlFiles);
			xmlLoader.load(new URLRequest(_files.objectsFile));
		}

		public function EZflarg() 
		{
			// setup a callback for the external interface in order to communicate
			// from the outside world (a html page) with this application
			ExternalInterface.addCallback("sendTextToFlash", getTextFromJavaScript);
			
			// the files.xml file must be loaded first because it determines which config and pattern
			// files will be loaded afterwards. thus, all further loading is done in loadXmlFiles()
			var fileLoader:URLLoader = new URLLoader();
			
			fileLoader.addEventListener(Event.COMPLETE, loadXmlFiles);
			fileLoader.addEventListener(IOErrorEvent.IO_ERROR, onIoErrorloadXmlFiles);
			fileLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityErrorXmlFiles);
			
			fileLoader.load(new URLRequest(_filesFile));
		}

		protected function onIoErrorloadXmlFiles(ioError:IOErrorEvent):void
		{
			displayIoError( ioError );
		}

		protected function onSecurityErrorXmlFiles(securityError:SecurityErrorEvent):void
		{
			displayDecurityError(securityError);
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

		protected function displayDecurityError(securityError:SecurityErrorEvent):void
		{
			var startScreenLayout:StartScreenLayout = new StartScreenLayout();
			
			var msg:String = "Sorry, but we cannot proceed because a security error occured\n" + securityError;
			startScreenLayout.addElement( 100, 150, constructTextArea(300, 75, msg) );
	
			displayScreen(startScreenLayout);
		}

		protected function displayIoError( ioError:IOErrorEvent ):void
		{
			var startScreenLayout:StartScreenLayout = new StartScreenLayout();
			var fileName:String = ioError.toString();
			var startIndex:int = fileName.search("URL:")
			var endIndex:int = fileName.search(']')-1;

			if(startIndex < endIndex)
			{
				fileName = fileName.slice(startIndex, endIndex);
			}
			var msg:String = "Sorry, but we cannot proceed because an error occured while loading\n" + fileName;
			startScreenLayout.addElement( 100, 150, constructTextArea(300, 75, msg) );
	
			displayScreen(startScreenLayout);
		}
		
		protected function displayScreen(layout:StartScreenLayout):void
		{
			var _screen:StartScreen = new StartScreen();
			_screen.init(400, 200, 50, 50, 0x444444, layout);
			this.addChild(_screen);
		}

		protected function constructTextArea(width:uint, height:uint, msg:String):TextField
		{
			var format:TextFormat = new TextFormat;
			format.size = 10;

			var textArea:TextField = new TextField(); 
			textArea.border = true;
			textArea.background = true;
			textArea.backgroundColor = 0xFFFFFF;			
			textArea.textColor = 0x000000;			
			textArea.height = height;
			textArea.width = width;	 
			textArea.condenseWhite = true;
			textArea.multiline = true;
			textArea.wordWrap = true;			
			textArea.text = msg;
			textArea.setTextFormat(format);			
			return textArea;
		}
	}
}
