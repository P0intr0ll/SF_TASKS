package com.pointroll.vpaid.player
{
	import com.pointroll.vpaid.core.IVPAID;
	
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	public class VPAIDAdProxy  implements IVPAID, IEventDispatcher
	{
		private var _ad:*;
		public function VPAIDAdProxy(ad:*) 
		{
			if(!ad)
				throw(new Error("VPAID interface not detected!"));
			_ad = ad;
		}
		// Properties
		public function get adLinear():Boolean 
		{
			return _ad.adLinear;
		}
		public function get adExpanded():Boolean 
		{
			return _ad.adExpanded;
		}
		public function get adRemainingTime():Number 
		{
			return _ad.adRemainingTime;
		}
		public function get adVolume():Number 
		{
			return _ad.adVolume;
		}
		public function set adVolume(value:Number):void 
		{
			_ad.adVolume = value;
		}
		// Methods
		public function handshakeVersion(playerVPAIDVersion : String):String 
		{
			return _ad.handshakeVersion(playerVPAIDVersion);
		}
		public function initAd(width:Number, height:Number, viewMode:String, desiredBitrate:Number,
							   creativeData:String=null, environmentVars : String=null):void 
		{
			_ad.initAd(width, height, viewMode, desiredBitrate, creativeData, environmentVars);
		}
		public function resizeAd(width:Number, height:Number, viewMode:String):void 
		{
			_ad.resizeAd(width, height, viewMode);
		}
		public function startAd():void {
			_ad.startAd();
		}
		public function stopAd():void {
			_ad.stopAd();
		}
		public function pauseAd():void {
			_ad.pauseAd();
		}
		public function resumeAd():void {
			_ad.resumeAd();
		}
		public function expandAd():void {
			_ad.expandAd();
		}
		public function collapseAd():void {
			_ad.collapseAd();
		}
		// EventDispatcher
		public function addEventListener(type:String, listener:Function, useCapture:Boolean=false,
												  priority:int=0, useWeakReference:Boolean=false):void 
		{
			_ad.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		public function removeEventListener(type:String, listener:Function,
													 useCapture:Boolean=false):void 
		{
			_ad.removeEventListener(type, listener, useCapture);
		}
		public function dispatchEvent(event:Event):Boolean 
		{
			return _ad.dispatchEvent(event);
		}
		public function hasEventListener(type:String):Boolean 
		{
			return _ad.hasEventListener(type);
		}
		public function willTrigger(type:String):Boolean 
		{
			return _ad.willTrigger(type);
		}
	}
}