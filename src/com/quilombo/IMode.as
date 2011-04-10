package com.quilombo
{
	import com.transmote.flar.FLARMarkerEvent;

	public interface IMode
	{
		function detected ( markerLabel:String, event:FLARMarkerEvent ):FLARMarkerEvent;
		function onDetection ( callback:Function ): void;
	}
}
