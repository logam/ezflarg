package com.quilombo
{
	import com.quilombo.ConfigLoaderBase;
	import com.quilombo.PatternHolder;

	public class PatternLoaderXML 	extends ConfigLoaderBase
					implements IConfigLoader
	{
		/**
			returns a reference to a new and filled PatternHolder object
		*/
		public function load(value:Object):Object
		{
			trace("PatternLoaderXML::load()");

			super.loadXML(value);
			setDefaults(); // just for consistency because loaders are calling this function here in general. 
			
			var patternHolder:PatternHolder = new PatternHolder;
			var symbols:Array 		= new Array;
			var icons:Vector.<String> 	= new Vector.<String>;
			var mediaElementList:XMLList 	= super._xml.MediaElement;
			
			for each (var mediaElement:XML in mediaElementList) 
			{
				trace(mediaElement.pattern.text());
				trace(mediaElement.media.text());
				trace(mediaElement.label.text());
				trace(mediaElement.icon.text());

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

				if( mediaElement.icon.text().length() > 0 )
				{
					icons.push
					( 
						[ 
							[ mediaElement.label.text() ]
						,	[ mediaElement.icon.text() ]
						]
					);
					
					trace("PatternLoaderXML::load()" + "found icon in mediaElement \n" + mediaElement.icon.name() );
				}
				else
				{
					trace("PatternLoaderXML::load()" + "no icon in mediaElement found \n" + mediaElement.name() );
				}
			}

			var textElementList:XMLList = super._xml.TextElement;
			for each (var textElement:XML in textElementList) 
			{
				trace(textElement.pattern.text());
				trace(textElement.type.text());
				trace(textElement.content.text());
				trace(textElement.label.text());
				trace(textElement.icon.text());

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
				
				if( textElement.icon.text().length() > 0 )
				{
					icons.push
					( 
						[ 
							mediaElement.label.text()
						,	mediaElement.icon.text()
						]
					);
					trace("PatternLoaderXML::load()" + "found icon in textElement \n" + textElement.icon.name() );
				}
				else
				{
					trace("PatternLoaderXML::load()" + "no icon in textElement found \n" + textElement.name() );
				}
			}
			
			patternHolder.objectHolder.objects 	= symbols;
			patternHolder.iconHolder.objects	= icons;

			return patternHolder;
		}
		
		/**
			this function does nothing because we cannet define default patterns. either patterns are defined in the config file
			or no patterns are available at all
		*/
		public function setDefaults():void
		{}
	}
}
