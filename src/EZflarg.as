//you can use this approach to write as outside flash (this let me use my TextMate  :)
// to use this you have to write "Main" in /properties(tab)/Document Class... remember to take off the code placed at frame 1
package 
{
	import flash.events.Event;
	import flash.net.URLLoader;	
	import flash.net.URLRequest;

	import com.tchatcho.EZflar;//tcha-tcho.com
	import flash.display.MovieClip;
	import com.transmote.flar.FLARMarkerEvent;	

	// own stuff
	import com.quilombo.constructors.LoadingEzflarEx;
	import com.quilombo.EZflarEx;
	import com.quilombo.ConfigHolder;

	public class EZflarg extends MovieClip 
	{
		protected var _ezflar:EZflarEx;
		protected var _symbols:Array = new Array();
		protected var _configuration:ConfigHolder;

		/**
			just reads the xml file that represents the pattern and media library
			the library distinguishes between two types of elements: mediaelement and textElement
			mediaElement contains all media resources such as images, videos, audios, etc
			textElement contains all text based resources such as text, urls, etc

			all library elements are read out and pushed into the _symbols array which gets then
			copied into the configuration object
		*/
		protected function processXML(e:Event):void 
		{
			var patternXML:XML = new XML(e.target.data);
			trace(patternXML);

			var mediaElementList:XMLList = patternXML.MediaElement;
			for each (var mediaElement:XML in mediaElementList) 
			{
				trace(mediaElement.pattern.text());
				trace(mediaElement.media.text());
				trace(mediaElement.label.text());

				_symbols.push
				(
					[
						[ mediaElement.pattern.text()
						, mediaElement.media.text()
						]
					,	[ mediaElement.label.text()
						]
					]
				);
			}

			var textElementList:XMLList = patternXML.TextElement;
			for each (var textElement:XML in textElementList) 
			{
				trace(textElement.pattern.text());
				trace(textElement.type.text());
				trace(textElement.content.text());
				trace(textElement.label.text());
				_symbols.push
				(
					[
						[ textElement.pattern.text()
						, textElement.pattern.type()
						, textElement.content.text()
						]
					,	[ textElement.pattern.label()
						]	
					]
				);// 0
			}

			_configuration.objects = _symbols;
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
			trace("process xml");			
			processXML(e);

			// setup ezflar
			trace("initialize ezflar");
			_ezflar = new EZflarEx(_configuration);
			_ezflar.customizeNoCam("wo ist die webcam versteckt?", 0xFFFFFF, 0xCCCCCC);			

			_ezflar.initializer(stage, "./resources/");

			_ezflar.onStarted(function():void 
			{
				// _ezflar.addModelTo([0,"Example_FLV.flv"], ["myflv"]);
				// _ezflar.addModelTo([0,"twitter", "ezflar"], ["mytwitter"]);
				_ezflar.addModelTo([0,"text", "zone ar"], ["textStart"]);
			});
			_ezflar.onAdded(function(marker:FLARMarkerEvent):void 
			{
				//_ezflar.getObject(0,"mygif").rotationX = 90;
				_ezflar.getObject(0,"mytext").rotationX = 90;
				trace(">>>>>>>>>>>>> added: " + marker.marker.patternId);
			});
			_ezflar.onUpdated(function(marker:FLARMarkerEvent):void 
			{
				trace("["+ marker.marker.patternId+"]>>" +
					  "X:" + marker.x() + " || " +
					  "Y:" + marker.y() + " || " +
					  "Z:" + marker.z() + " || " +
					  "RX:" + marker.rotationX() + " || " +
					  "RY:" + marker.rotationY() + " || " +
					  "RZ:" + marker.rotationZ() + " || "
				);	
			});
			_ezflar.onRemoved(function(marker:FLARMarkerEvent):void 
			{
				trace(">>>>>>>>>>>>> removed: " + marker.marker.patternId);
			});	
		}

		/**
			the event function that gets called on completion of loading the programs config file.
			here, we read out all configuration values and store them in a configuration object which 
			gets then passed later on to the EZflarEx object.
		*/
		protected function loadConfig(e:Event):void
		{
			var configXML:XML = new XML(e.target.data);
			_configuration = new ConfigHolder();

			trace(configXML);

			_configuration.width		= configXML.width.text();
			_configuration.height		= configXML.height.text();
			_configuration.patternResolution= configXML.patternresolution.text();
			_configuration.patternThreshold	= configXML.patternthreshold.text();
			_configuration.frameRate	= configXML.framerate.text();
			_configuration.downsampleRatio	= configXML.downsampleratio.text();
			_configuration.mirror		= configXML.mirror.text();
		}	

		public function EZflarg() 
		{
			// LOAD configuration file first in order to determine configuration values for pattern detection and the scene!
			// Currently uses a hardcoded path.

			var configLoader:URLLoader = new URLLoader();
			configLoader.addEventListener(Event.COMPLETE, loadConfig);
			configLoader.load(new URLRequest("./resources/config.xml"));

			// LOAD object library and patterns. 
			// Currently uses a hardcoded path.
	 
			var xmlLoader:URLLoader = new URLLoader();
			xmlLoader.addEventListener(Event.COMPLETE, initMain);
			xmlLoader.load(new URLRequest("./resources/objects.xml"));
		}
	}
}
