package com.quilombo
{
	import com.quilombo.ConfigLoaderBase;
	import com.quilombo.ConfigHolder;

	public class PatternLoaderXML 	extends ConfigLoaderBase
					implements IConfigLoader
	{
		/**
			returns a reference to a new and filled Array object
		*/
		public function load(value:Object):Object
		{
			super.loadXML(value);
			setDefaults(); // just for consistency because loaders are calling this function here in general. 
			var symbols:Array = new Array;

			var mediaElementList:XMLList = super._xml.MediaElement;
			for each (var mediaElement:XML in mediaElementList) 
			{
				trace(mediaElement.pattern.text());
				trace(mediaElement.media.text());
				trace(mediaElement.label.text());

				symbols.push
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

			var textElementList:XMLList = super._xml.TextElement;
			for each (var textElement:XML in textElementList) 
			{
				trace(textElement.pattern.text());
				trace(textElement.type.text());
				trace(textElement.content.text());
				trace(textElement.label.text());
				symbols.push
				(
					[
						[ textElement.pattern.text()
						, textElement.type.text()
						, textElement.content.text()
						]
					,	[ textElement.label.text()
						]	
					]
				);
			}

			return symbols;
		}
		
		/**
			this function does nothing because we cannet define default patterns. either patterns are defined in the config file
			or no patterns are available at all
		*/
		public function setDefaults():void
		{}
	}
}
