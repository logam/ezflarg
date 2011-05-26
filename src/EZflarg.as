//you can use this approach to write as outside flash (this let me use my TextMate  :)
// to use this you have to write "Main" in /properties(tab)/Document Class... remember to take off the code placed at frame 1
package 
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	
	import flash.net.URLLoader;	
	import flash.net.URLRequest;

	import flash.display.MovieClip;
	import flash.system.Capabilities;
	import mx.utils.ObjectUtil;
	 
	//tcha-tcho.com
	import com.tchatcho.EZflar;	

	import com.transmote.flar.FLARMarkerEvent;	
	import com.transmote.flar.FLARMarker;

	// own stuff
	import com.quilombo.constructors.PatternNameEvent;
	import com.quilombo.display.MessageScreen;
	import com.quilombo.display.MessageScreenTimed;	
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

	// import flash.external.ExternalInterface;


	public class EZflarg extends MovieClip 
	{
		protected var _ezflar:EZflarEx;
		protected var _configuration:ConfigHolder;
		protected var _actionDispatcher:ActionDispatcher;
		// protected var _externalHtmlCallback:Function = getTextFromJavaScript;
		
		// protected var _resourcePath:String 	= "./resources/";
		// protected var _filesFile:String		= _resourcePath + "xmlfiles.xml";		
		
		protected var _resourcePath:String;
		protected var _filesFile:String;

		protected var _files:FileHolder;

		protected var _widthErrorScreen:int	= 400;
		protected var _heightErrorScreen:int	= 175;
		protected var _widthMessageScreen:int	= 400;		
		protected var _heightMessageScreen:int	= 75;		
		protected var _colorErrorScreenTxt:uint	= 0xFFFFFF;
		protected var _colorErrorScreenBack:uint= 0x444444;		
		
		protected var _markerMode:IMode; 
		// protected var _msgDisplayTime:int	= 5000; // 5 seconds
		protected var _msgScreen:MessageScreenTimed;

		/**	callbacks that can be assigned to various objects
		*/
		protected var _callbackEzFlarOnStarted:Function 			= callbackEzFlarOnStarted;
		protected var _callbackEzFlarOnPreAdded:Function 			= callbackEzFlarOnPreAdded;
		protected var _callbackEzFlarOnAdded:Function 				= callbackEzFlarOnAdded;
		protected var _callbackEzFlarOnUpdated:Function 			= callbackEzFlarOnUpdated;
		protected var _callbackEzFlarOnRemoved:Function 			= callbackEzFlarOnRemoved;
		protected var _callbackEzFlarOnMarkerClicked:Function 			= callbackEzFlarOnMarkerClicked;
		protected var _callbackEzFlarOnMarkerMouseOver:Function 		= callbackEzFlarOnMarkerMouseOver;
		protected var _callbackEzFlarOnMarkerMouseOut:Function 			= callbackEzFlarOnMarkerMouseOut;

		protected var _callbackSequenceModeOnDetection:Function			= callbackSequenceModeOnDetection;
		protected var _callbackSequenceModeOnNotNextInSequence:Function		= callbackSequenceModeOnNotNextInSequence;
		protected var _callbackSequenceModeOnMarkerPreviouslyDetected:Function	= callbackSequenceModeOnMarkerPreviouslyDetected;
		protected var _callbackSequenceModeOnMarkerAlreadyDetected:Function	= callbackSequenceModeOnMarkerAlreadyDetected;
		protected var _callbackSequenceModeOnDisplayTimeSet:Function		= callbackSequenceModeOnDisplayTimeSet;
		
		public function EZflarg() 
		{	
			trace("EZflarg::EZflarg detected operating system [" + Capabilities.os + "]");
			_resourcePath = resourcePath;
			_filesFile = _resourcePath + "xmlfiles.xml";

			/**	setup a callback for the external interface in order to communicate
				from the outside world (a html page) with this application
			*/
			// ExternalInterface.addCallback("sendTextToFlash", getTextFromJavaScript);
			
			/**	the files.xml file must be loaded first because it determines which config and pattern
				files will be loaded afterwards. thus, all further loading is done in loadXmlFiles()
			*/
			var fileLoader:URLLoader = new URLLoader();
			
			fileLoader.addEventListener(Event.COMPLETE, loadXmlFiles);
			fileLoader.addEventListener(IOErrorEvent.IO_ERROR, onIoErrorloadXmlFiles);
			fileLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityErrorXmlFiles);
			
			fileLoader.load(new URLRequest(_filesFile));
		}

		/**
			the event function that gets called on completion of reading the objects.xml file.
			here, we extract all media library elements and initialize the program. 

			the loadConfig function must have been called before in order to have a fully initialized
			configuration object used to initialize EZflarEx
		*/
		protected function initMain(e:Event):void
		{
			// process xml first and load available data
			trace("EZflarg::initMain(): process xml");			
			loadPatterns(e);

			// setup ezflar
			trace("EZflarg::initMain(): initialize ezflar");
			_ezflar = new EZflarEx(_configuration);
			
			_ezflar.initializer(stage, _resourcePath);
			_ezflar.customizeNoCam("sorry no cam...", 0xFFFFFF, 0x444444 );			
			
			_ezflar.onStarted		(_callbackEzFlarOnStarted);
			_ezflar.onPreAdded		(_callbackEzFlarOnPreAdded);
			_ezflar.onAdded			(_callbackEzFlarOnAdded);
			_ezflar.onUpdated		(_callbackEzFlarOnUpdated);
			_ezflar.onRemoved		(_callbackEzFlarOnRemoved);	
			_ezflar.onMarkerClicked		(_callbackEzFlarOnMarkerClicked);
			_ezflar.onMarkerMouseOver	(_callbackEzFlarOnMarkerMouseOver);
			_ezflar.onMarkerMouseOut	(_callbackEzFlarOnMarkerMouseOut);

			/** 	add a timed message screen to the scene in order 
				to show messages that disappear automatically
			*/
			_msgScreen = new MessageScreenTimed(_widthMessageScreen, _heightMessageScreen, _colorErrorScreenTxt, _colorErrorScreenBack);
			_ezflar.addModelToScene(_msgScreen);

			/** 	before we proceed we dispatch the display time callback of the sequence mode (if existent)
				in order to setup the display time of the messages displayed in sequence mode. the _msgScreen	
				member must have been created already in order to receive the new display time
			*/
			var seqMode:MarkerSequenceMode = _markerMode as MarkerSequenceMode;
			if( seqMode != null )
			{
				seqMode.dispatchDisplayTime();
			} 
			// just for testing purposes, display current operating system
			displayMessage( Capabilities.os );
		}

		protected function markerMouseOver(event:PatternNameEvent):void
		{
			trace("EZflarEx::markerMouseOver for pattern [" + event.patternName + "]");
		}

		protected function markerMouseOut(event:PatternNameEvent):void
		{
			trace("EZflarEx::markerMouseOut for pattern [" + event.patternName + "]");
		}	
		
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
					sequenceMode.onDetection		(_callbackSequenceModeOnDetection);
					sequenceMode.onNotNextInSequence	(_callbackSequenceModeOnNotNextInSequence);
					sequenceMode.onMarkerPreviouslyDetected	(_callbackSequenceModeOnMarkerPreviouslyDetected);
					sequenceMode.onMarkerAlreadyDetected	(_callbackSequenceModeOnMarkerAlreadyDetected);
					sequenceMode.onDisplayTimeSet		(_callbackSequenceModeOnDisplayTimeSet);
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

		//*****************************
		// getters
		//*****************************

		protected function get resourcePath():String
		{	
			var path:String;

			var platform:String = Capabilities.os;
			var linux:RegExp = new RegExp("Linux.*", "i");
			var windows:RegExp = new RegExp("Windows.*", "i");
			var mac:RegExp= new RegExp("Max.*", "i");

			if( linux.exec(platform) != null 
			||  windows.exec(platform) != null
			||  mac.exec(platform) != null)
			{
				path = "./resources/";
			}
			else // android
			{
				// hardcoded, not nice!!
				path = "/mnt/sdcard/ezflarg/resources/";
			}
			return path;
		}

		//*****************************
		// callbacks
		//*****************************

		protected function callbackEzFlarOnStarted():void
		{
			trace("EZflarg::onStarted()");
		}

		/**
			this callback gets called before the onAdded callback.if a _markerMode is existing, its detect method gets called.
			detect calls another callback of this class. that callback may change the event argument, i.e to prevent that the
			object attached to the marker gets displayed. if no _markerMode is available, onPreAdded just returns the received
			event without altering it.
		*/
		protected function callbackEzFlarOnPreAdded(event:FLARMarkerEvent):FLARMarkerEvent
		{
			trace("EZflarg::onPreAdded() markerID[" + event.marker.patternId + "]")
			return event;
		}
	
		protected function callbackEzFlarOnAdded(event:FLARMarkerEvent):void
		{
			trace("EZflarg::onAdded() markerID[" + event.marker.patternId + "]");

			if( _markerMode != null )
			{
				event = _markerMode.detected( _ezflar.patternName(event.marker.patternId), event );
			}
		}
	
		protected function callbackEzFlarOnUpdated(event:FLARMarkerEvent):void
		{
			trace("EZflarg::onUpdated() markerID[" + event.marker.patternId + "]");
		}

		protected function callbackEzFlarOnRemoved(event:FLARMarkerEvent):void
		{
			trace("EZflarg::onRemoved() markerID[" + event.marker.patternId + "]");
		}

		protected function callbackEzFlarOnMarkerClicked(event:PatternNameEvent):void
		{
			trace("EZflarg::onMarkerClicked()");
			loadUrlOnClicked(event);
		}

		protected function callbackEzFlarOnMarkerMouseOver(event:PatternNameEvent):void
		{
			trace("EZflarg::onMarkerMouseOver()");
			markerMouseOver(event);
		}

		protected function callbackEzFlarOnMarkerMouseOut(event:PatternNameEvent):void
		{
			trace("EZflarg::onMarkerMouseOut()");
			markerMouseOut(event);
		}

		protected function callbackSequenceModeOnDetection(markerName:String, event:FLARMarkerEvent):FLARMarkerEvent
		{
			trace("EZflarg::onDetection() markerId[" + event.marker.patternId + "]");
			_ezflar.getObject(event.marker.patternId, markerName).visible = true;
			return event;
		}

		protected function callbackSequenceModeOnNotNextInSequence(markerName:String, event:FLARMarkerEvent, message:String):FLARMarkerEvent
		{
			trace("EZflarg::onNotNextInSequence() markerId[" + event.marker.patternId + "]");
			
			/**
				for now it is assumed that the returned object is a DisplayObject3D.
				this may true if the current marker represents a graohic object.
				in case the marker represents a link there will be probably the problem
				that the link cant be made "invisible" and may get invoked anyway.
				this function is supposed to prevent that as well as showing images, but it
				may currently fail in disabling urls, audio, etc.
			*/
			_ezflar.getObject(event.marker.patternId, markerName).visible = false;
			
			displayMessage(message);
			return event;
		}

		protected function callbackSequenceModeOnMarkerPreviouslyDetected(markerName:String, event:FLARMarkerEvent, message:String):FLARMarkerEvent
		{
			trace("EZflarg::onMarkerPreviouslyDetected() markerId[" + event.marker.patternId + "]");
			_ezflar.getObject(event.marker.patternId, markerName).visible = false;
			displayMessage(message);
			return event;
		}

		protected function callbackSequenceModeOnMarkerAlreadyDetected(markerName:String, event:FLARMarkerEvent, message:String):FLARMarkerEvent
		{
			trace("EZflarg::onMarkerAlreadyDetected() markerId[" + event.marker.patternId + "]");
			_ezflar.getObject(event.marker.patternId, markerName).visible = true;
			return event;
		}

		protected function callbackSequenceModeOnDisplayTimeSet(displayTime:uint):void
		{
			trace("EZflarg::onDisplayTimeSet() time[" + displayTime + "]");
			if( _msgScreen != null )
			{ 
				_msgScreen.displayTime = displayTime;
			}
		}

		/**
			this functions gets called from an external html page in order to exchange user interaction
			information. the information are dispatched here and can be used for example to alter the 
			logic of the game according to interaction in the external html page
		*/
		protected function getTextFromJavaScript(str:String):void 
		{
			trace("EZflarg::getTextFromJavaScript(): received text[" + str + "]");
		}

		protected function onIoErrorloadXmlFiles(ioError:IOErrorEvent):void
		{
			displayIoError( ioError );
		}

		protected function onSecurityErrorXmlFiles(securityError:SecurityErrorEvent):void
		{
			displaySecurityError(securityError);
		}
		

		protected function displaySecurityError(securityError:SecurityErrorEvent):void
		{
			trace("EZflarg::displayDecurityError(): [" + securityError + "]");
			var msg:String = "Sorry, but we cannot proceed because a security error occured\n" + securityError;
			displayErrorScreen(msg);
		}

		protected function displayIoError( ioError:IOErrorEvent ):void
		{
			trace("EZflarg::displayIoError(): [" + ioError + "]");
			
			var fileName:String = ioError.toString();
			var startIndex:int = fileName.search("URL:")
			var endIndex:int = fileName.search(']')-1;

			if(startIndex < endIndex)
			{
				fileName = fileName.slice(startIndex, endIndex);
			}
			var msg:String = "Sorry, but we cannot proceed because an error occured while loading\n" + fileName;
			
			displayErrorScreen(msg);			
		}
		
		protected function displayErrorScreen(msg:String):void
		{
			var screen:MessageScreen = new MessageScreen(_widthErrorScreen, _heightErrorScreen, _colorErrorScreenTxt, _colorErrorScreenBack);
			screen.show(msg);
			this.addChild(screen);
		}

		protected function displayMessage(msg:String):void
		{	
			// the message screen dissappears automatically after the adjusted period of time
			if( _msgScreen != null )
			{
				_msgScreen.show(msg);
			}
		}
	}
}
