package com.quilombo
{
	import com.quilombo.ConfigLoaderBase;
	import com.quilombo.IConfigLoader;

	import com.quilombo.ActionDispatcher;
	import com.quilombo.ActionOpenUrl;
	import com.quilombo.ActionPlay;
	import com.quilombo.ActionShow;
	
	public class ActionLoaderXML 	extends ConfigLoaderBase
					implements IConfigLoader
	{
		/**
		*/
		public function load(value:Object):Object
		{
			super.loadXML(value);
			setDefaults();
			
			// the action dispatcher to be returned
			var dispatcher:ActionDispatcher = new ActionDispatcher();
			
			// get all OnClick actions
			var onClickList:XMLList = super._xml.OnClick;
			trace("ActionLoaderXML::load() defined OnClick actions\n" + onClickList);

			for each (var onClickActions:XML in onClickList) 
			{
				// get label of the current action element. the label specifies to which marker this actions belongs to
				var onClickObjectLabel:String = onClickActions.@objectlabel;
				trace("ActionLoaderXML::load() object label [" + onClickObjectLabel + "]"); 
				
				// get all actions which are going to be executed on mouse click
				var onClickActionList:XMLList = onClickActions.children();
				loadActions(ActionDispatcher.OnClicked, onClickObjectLabel, onClickActionList, dispatcher );				
			}

			// get all OnMouseOver actions
			var onMouseOverList:XMLList = super._xml.OnMouseOver;
			trace("ActionLoaderXML::load() defined OnMouseOver actions\n" + onMouseOverList);

			for each (var onMouseOverActions:XML in onMouseOverList) 
			{
				// get label of the current action element. the label specifies to which marker this actions belongs to
				var onMouseOverObjectLabel:String = onMouseOverActions.@objectlabel;
				trace("ActionLoaderXML::load() object label [" + onMouseOverObjectLabel + "]"); 
				
				// get all actions which are going to be executed on mouse click
				var onMouseOverActionList:XMLList = onMouseOverActions.children();
				loadActions(ActionDispatcher.OnMouseOver, onMouseOverObjectLabel, onMouseOverActionList, dispatcher );	
			}

			// get all OnMouseOut actions
			var onMouseOutList:XMLList = super._xml.OnMouseOut;
			trace("ActionLoaderXML::load() defined OnMouseOut actions\n" + onMouseOutList);

			for each (var onMouseOutActions:XML in onMouseOutList) 
			{
				// get label of the current action element. the label specifies to which marker this actions belongs to
				var onMouseOutObjectLabel:String = onMouseOutActions.@objectlabel;
				trace("ActionLoaderXML::load() object label [" + onMouseOutObjectLabel + "]"); 
				
				// get all actions which are going to be executed on mouse click
				var onMouseOutActionList:XMLList = onMouseOutActions.children();
				loadActions(ActionDispatcher.OnMouseOut, onMouseOutObjectLabel, onMouseOutActionList, dispatcher );	
			}

			return dispatcher;
		}

		/**
			this function does nothing because we cannet define default actions. either actions are defined in the config file
			or no actions are available at all
		*/
		public function setDefaults():void
		{}

		/*

		**/
		protected function loadActions(type:String, objectLabel:String, actionList:XMLList, dispatcher:ActionDispatcher):void
		{
			for each (var action:XML in actionList) 
			{
				if( action.name() == "OpenUrl")
				{
					var target:String = action.@target;
					if (target != '_self' && target != '_blank' && target != '_parent' && target != '_top' )
					{
						target = '_blank';						
					}
					trace("ActionLoaderXML::loadActions() [" + type + "] action [" + action.name() + "] target [" + target + "]");	
					dispatcher.addAction(type, objectLabel, new ActionOpenUrl(action.text(), target) );
					continue
				}
				if( action.name() == "Play")
				{
					dispatcher.addAction(type, objectLabel, new ActionPlay(action.text()) );
					continue
				}
				if( action.name() == "Show")
				{
					dispatcher.addAction(type, objectLabel, new ActionShow(action.text()) );
					continue
				}
			}
		}
	}
}
