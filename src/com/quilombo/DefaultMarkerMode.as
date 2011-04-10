package com.quilombo
{
	import com.transmote.flar.FLARMarkerEvent;
	
	import com.quilombo.IMode;
	import com.quilombo.MarkerModeBase;

	public class DefaultMarkerMode extends MarkerModeBase implements IMode 
	{
		public function DefaultMarkerMode():void
		{}

		public function detected ( markerName:String, event:FLARMarkerEvent ):FLARMarkerEvent
		{
			return event;
		}
		
		public function onDetection ( callback:Function ):void
		{}
	}
}
