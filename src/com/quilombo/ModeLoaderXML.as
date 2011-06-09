package com.quilombo
{
	import com.quilombo.ConfigLoaderBase;
	import com.quilombo.IConfigLoader;
	import com.quilombo.IMode;
	import com.quilombo.MarkerSequenceMode;
	import com.quilombo.DefaultMarkerMode;
	import com.quilombo.IconAttributesHolder;

	public class ModeLoaderXML 	extends ConfigLoaderBase
					implements IConfigLoader
	{
		protected var _msgPreviouslyDetected:String;
		protected var _msgAlreadyDetected:String;
		protected var _msgWrongOrder:String;
		protected var _displayTimeMsg:uint;
		/**
			if the mode xml file defines the sequence mode a MarkerSequenceMode object gets returned
			else null gets returned currently
		*/
		public function load(value:Object):Object
		{
			super.loadXML(value);
			setDefaults();

			var mode:IMode = null;
			
			var childList:XMLList = super._xml.children();
			for each (var child:XML in childList)
			{
				if ( child.name() == "OrderedSequence")
				{
					trace("ModeLoaderXML::load() sequence in xml file detected. markers must be detected in defined sequence.");
					mode = loadSequence( new MarkerSequenceMode(), child)
				}				
			}
			
			return mode;
		}
		
		/**
			sets default error messages for the case that no messages are defined in the corresponding xml file.
			if u want to overwrite the message, just inherit from this class and overwrite this method. 
		*/
		public function setDefaults():void
		{
			_msgPreviouslyDetected = "Sorry, this marker has been previously detected!";
			_msgAlreadyDetected = "Sorry, this marker has just been detected!";
			_msgWrongOrder = "Sorry, you missed some markers!";
			_displayTimeMsg = 5000;	// 5 seconds
		}
		
		/**	expects the following xml elements

			<OrderedSequence>
				<Icons>
				</Icons>
				<Detect>
					<Item>marker001</Item>
					<Item>marker002</Item>
					<Item>marker003</Item>
					<Item>marker004</Item>
					<Item>marker005</Item>
					<Item>marker006</Item>
					<Item>marker007</Item>
					<Item>marker008</Item>
				</Detect>
				<Error>
					<AlreadyDetected>
						<Message>Dieser Marker wurde schon erkannt!</Message>
					</AlreadyDetected>
					<PreviouslyDetected>
						<Message>Dieser Marker wurde schon erkannt!</Message>
					</PreviouslyDetected>
					<WrongOrder>
						<Message>Du hast Marker ausgelassen! Finde die anderen zuerst.</Message>
					</WrongOrder>			
				</Error>
			</OrderedSequence>

			if <Error> is not available, default messages are assigned to the returned object
			if <Error> is available but not all messages are defined, the missing ones will use the corresponding defaults

			@return null if <Detect> is not available
			@return null if <Detect> is available but no <Item> is defined, this the item list is empty
		*/
		protected function loadSequence(mode:MarkerSequenceMode, orderedSequence:XML):MarkerSequenceMode
		{
			// the icons attributes holder
			var icons:IconAttributesHolder = new IconAttributesHolder;

			// start a new sequence of markers that are going to be detected in the given order
			mode.newSequence(); 

			var childList:XMLList = orderedSequence.children();
			for each (var child:XML in childList)
			{
				if ( child.name() == "Icons" )
				{
					var iconList:XMLList = orderedSequence.Icons.children();
					trace("ModelLoaderXML::loadSequence() add <Icons> items\n" + iconList);

					for each ( var iconsAttribute:XML in iconList)
					{
						if(iconsAttribute.name() == "IconWidth")
						{
							icons.iconWidth = iconsAttribute.text();
						}

						if(iconsAttribute.name() == "IconHeight")
						{
							icons.iconHeight = iconsAttribute.text();
						}

						if(iconsAttribute.name() == "IconsPerLine")
						{
							icons.numIconsPerLine = iconsAttribute.text();
						}
						
						if(iconsAttribute.name() == "IconsInitiallyVisible")
						{
							icons.visibility = iconsAttribute.text() == "true";
						}
						
						if(iconsAttribute.name() == "IconOpacityLevel")
						{
							icons.opacity = iconsAttribute.text();
						}

						if(iconsAttribute.name() == "LinePosition")
						{
							icons.pos.x = iconsAttribute.X.text();
							icons.pos.y = iconsAttribute.Y.text();
						}
					}
					mode.icons = icons;
				}

				if ( child.name() == "Detect")
				{
					var itemList:XMLList = orderedSequence.Detect.Item;
					trace("ModelLoaderXML::loadSequence() add <Detect> items\n" + itemList);

					for each (var item:XML in itemList) 
					{	
						mode.nextInSequence(item.text());
					}
				}
				if ( child.name() == "Error")
				{
					var messageList:XMLList = orderedSequence.Error.children();
					trace("ModelLoaderXML::loadSequence() add <Error> items\n" + messageList);

					for each ( var message:XML in messageList)
					{
						if(message.name() == "PreviouslyDetected")
						{
							trace("ModelLoaderXML::loadSequence() found error message [PreviouslyDetected]" + "[" + message.Message.text() + "]");
							_msgPreviouslyDetected = message.Message.text();
						}
						if(message.name() == "AlreadyDetected")
						{
							trace("ModelLoaderXML::loadSequence() found error message [AlreadyDetected]" + "[" + message.Message.text() + "]");
							_msgAlreadyDetected = message.Message.text();
						}
						if(message.name() == "WrongOrder")
						{
							trace("ModelLoaderXML::loadSequence() found error message [WrongOrder]" + "[" + message.Message.text() + "]");
							_msgWrongOrder = message.Message.text();
						}
						if(message.name() == "DisplayTime")
						{
							trace("ModelLoaderXML::loadSequence() found display time [DisplayTime]" + "[" + message.text() + "]");
							_displayTimeMsg = message.text();
						}
					}

					mode.messagePreviouslyDetected	= _msgPreviouslyDetected;
					mode.messageAlreadyDetected	= _msgAlreadyDetected;
					mode.messageNotNextInSequence	= _msgWrongOrder;
					mode.messageDisplayTime		= _displayTimeMsg;
				}				
			}
			
			// if sequence is empty, make the mode object unvalid and return null
			if( mode.numItems == 0 )
			{
				trace("ModelLoaderXML::loadSequence() no sequence elements available. turn off sequence mode.");
				mode = null;
			}

			return mode;
		}
	}
}
