package com.quilombo
{
	import com.quilombo.IAction;
	import com.quilombo.StringActionPair;

	public class ActionDispatcher
	{
		public static var OnClicked:String = "OnClicked";
		public static var OnMouseOver:String = "OnMouseOver";
		public static var OnMouseOut:String = "OnMouseOut";

		protected var _onClickedActions:Vector.<StringActionPair>;
		protected var _onMouseOverActions:Vector.<StringActionPair>;
		protected var _onMouseOutActions:Vector.<StringActionPair>;
		
		/**
		*/
		public function ActionDispatcher():void
		{
			_onClickedActions = new Vector.<StringActionPair>();
			_onMouseOverActions = new Vector.<StringActionPair>();
			_onMouseOutActions = new Vector.<StringActionPair>()
		}
		
		/**
		*/
		public function execute( actionType:String, objectLabel:String ):void
		{
			var item:StringActionPair = null;

			if( actionType == ActionDispatcher.OnClicked )
			{
				item = find(objectLabel, _onClickedActions);
			}
			else if( actionType == ActionDispatcher.OnMouseOver )
			{
				item = find(objectLabel, _onMouseOverActions);
			}
			else if( actionType == ActionDispatcher.OnMouseOut )
			{
				item = find(objectLabel, _onMouseOutActions);
			}
			else
			{
				trace("ActionDispatcher::execute(): type[" + actionType + "] is not suppported!");
			}
			
			if( item != null ) // execute all actions stored in found item, if item is available
			{
				for each ( var action:IAction in item._actions)
				{
					action.execute();
				}
			}
			else // if no item was found, write an error message to debug output
			{
				trace("ActionDispatcher::execute(): object[" + objectLabel + "] for actiontype [" + actionType + "] is not available!");
			}
		}
		
		/**
		*/
		public function addAction( actionType:String, objectLabel:String, action:IAction ):void
		{
			trace("ActionDispatcher::addAction(): type[" + actionType + "] label[" + objectLabel + "]");
		
			if( actionType == ActionDispatcher.OnClicked )
			{
				add( action, objectLabel, _onClickedActions );
			}
			else if( actionType == ActionDispatcher.OnMouseOver )
			{
				add( action, objectLabel, _onMouseOverActions );
			}
			else if( actionType == ActionDispatcher.OnMouseOut )
			{
				add( action, objectLabel, _onMouseOutActions );
			}
			else
			{
				trace("ActionDispatcher::addAction(): type[" + actionType + "] is not suppported!");
			}
		}
		
		/**
		*/
		public function reset():void
		{}
		
		/**
		*/
		public function asString():String
		{
			var result:String = "ActionDispatcher::asString()\n" +   "[OnClick actions]\n" + _onClickedActions.toString() 
									     + "\n[OnMouseOver actions]\n" + _onMouseOverActions.toString()
									     + "\n[OnMouseOut actions]\n"  + _onMouseOutActions.toString();
			return result;
		}
		
		/**
		*/
		protected function find(objectLabel:String, container:Vector.<StringActionPair> ):StringActionPair
		{
			var actions:StringActionPair = null;
			for each (var item:StringActionPair in container)
			{
				if( item._string == objectLabel)
				{
					actions = item;
					break;
				}
			}
			
			if( actions == null)
			{
				trace("ActionDispatcher::find() couldn't find actions for object [" + objectLabel + "]");
			}
	
			return actions;
		}
		
		/**
		*/
		protected function add( action:IAction, objectLabel:String, container:Vector.<StringActionPair> ):void
		{
			if(action != null)
			{
				var found:Boolean = false;
				for each (var item:StringActionPair in container)
				{
					if(item._string == objectLabel )
					{
						trace( "ActionDispatcher::add() next action element for [" + objectLabel + "]");
						found = true;
						item._actions.push(action);
						break;
					}
				}
			
				// if an entry with the name "objectLabel" is currently not existing, create a new entry for it
				if( found == false )
				{
					trace( "ActionDispatcher::add() first action element for [" + objectLabel + "]");	
					var newActionContainer:Vector.<IAction> = new Vector.<IAction>();
					newActionContainer.push(action);
					container.push ( new StringActionPair(objectLabel, newActionContainer) );
				}
			}
			else
			{
				trace( "ActionDispatcher::add() the action associated with [" + objectLabel + "] is [null] thus won't be added!");
			}
		}
	}
}
