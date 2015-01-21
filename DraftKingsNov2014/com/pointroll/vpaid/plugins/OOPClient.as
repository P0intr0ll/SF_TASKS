package com.pointroll.vpaid.plugins
{
	import com.pointroll.vpaid.VPAID;
	import com.pointroll.vpaid.VPAIDPubProxy;
	import com.pointroll.vpaid.core.VPAIDEvent;
	import com.pointroll.vpaid.oop.JSBridge;
	
	import flash.events.Event;
	import flash.system.Security;
	
	public class OOPClient implements IVPAIDPlugin
	{
		public var name:String;
		public var bridge:JSBridge;
		private var proxy:VPAIDPubProxy;
		
		//prevents death loop of volume change notifications
		private var pendingVolumeChange:Boolean = false;
		
		public function OOPClient(adName:String)
		{
			Security.allowDomain("*");
			name = adName;
			bridge = new JSBridge(name);
		}
		
		public function set publisherProxy(proxy:VPAIDPubProxy):void
		{
			this.proxy = proxy;
			listenForAdCommands();
			listenForPlayerCommands();
			bridge.registerAd();
		}
		
		public function destroy():void
		{
			bridge = null;
			proxy = null;
		}
		
		private function listenForAdCommands():void
		{
			proxy.addEventListener(VPAIDEvent.AdLoaded, signalLoaded, false,0,true);
			proxy.addEventListener(VPAIDEvent.AdExpandedChange, signalExpansionChange, false,0,true);
			proxy.addEventListener(VPAIDEvent.AdVolumeChange , checkPendingVolumeChange, false,0,true);
			
			
			proxy.addEventListener(VPAIDEvent.AdStarted, broadcastJSEvent, false,0,true);
			proxy.addEventListener(VPAIDEvent.AdStopped, broadcastJSEvent, false,0,true);
			proxy.addEventListener(VPAIDEvent.AdLinearChange, broadcastJSEvent, false,0,true);
			proxy.addEventListener(VPAIDEvent.AdRemainingTimeChange, broadcastJSEvent, false,0,true);
			proxy.addEventListener(VPAIDEvent.AdImpression, broadcastJSEvent, false,0,true);
			proxy.addEventListener(VPAIDEvent.AdVideoStart, broadcastJSEvent, false,0,true);
			proxy.addEventListener(VPAIDEvent.AdVideoFirstQuartile, broadcastJSEvent, false,0,true);
			proxy.addEventListener(VPAIDEvent.AdVideoMidpoint, broadcastJSEvent, false,0,true);
			proxy.addEventListener(VPAIDEvent.AdVideoThirdQuartile, broadcastJSEvent, false,0,true);
			proxy.addEventListener(VPAIDEvent.AdVideoComplete, broadcastJSEvent, false,0,true);
			proxy.addEventListener(VPAIDEvent.AdClickThru, broadcastJSEvent, false,0,true);
			proxy.addEventListener(VPAIDEvent.AdUserAcceptInvitation, broadcastJSEvent, false,0,true);
			proxy.addEventListener(VPAIDEvent.AdUserMinimize, broadcastJSEvent, false,0,true);
			proxy.addEventListener(VPAIDEvent.AdUserClose, broadcastJSEvent, false,0,true);
			proxy.addEventListener(VPAIDEvent.AdPaused, broadcastJSEvent, false,0,true);
			proxy.addEventListener(VPAIDEvent.AdPlaying, broadcastJSEvent, false,0,true);
			proxy.addEventListener(VPAIDEvent.AdLog, broadcastJSEvent, false,0,true);
			proxy.addEventListener(VPAIDEvent.AdError, broadcastJSEvent, false,0,true);
		}
		
		private function broadcastJSEvent(event:VPAIDEvent):void
		{
			bridge.broadcastEvent(event.type, event.data);
		}
		
		private function listenForPlayerCommands():void
		{
			bridge.addEventListener(VPAID.INIT, init, true);
			bridge.addEventListener(VPAID.START, start);
			bridge.addEventListener(VPAID.RESIZE, resize);
			bridge.addEventListener(VPAID.UNLOAD, stop);
			bridge.addEventListener(VPAID.PAUSE, pause);
			bridge.addEventListener(VPAID.RESUME, resume);
			bridge.addEventListener(VPAID.EXPAND, expand);
			bridge.addEventListener(VPAID.COLLAPSE, collapse);

			
			bridge.addEventListener(VPAID.VOLUME_CHANGE,volumeChange);
		}
		
		private function init(event:String, data:Object):void
		{
			trace("init: "+data);
			callProxyFunction("initAd",data);
		}
		private function start(event:String, data:Object):void
		{
			callProxyFunction("startAd");
		}
		private function stop(event:String, data:Object):void
		{
			callProxyFunction("stopAd");
		}
		private function pause(event:String, data:Object):void
		{
			callProxyFunction("pauseAd");
		}
		private function resume(event:String, data:Object):void
		{
			callProxyFunction("resumeAd");
		}
		private function expand(event:String, data:Object):void
		{
			callProxyFunction("expandAd");
		}
		private function collapse(event:String, data:Object):void
		{
			callProxyFunction("collapseAd");
		}
		private function resize(event:String, data:Object):void
		{
			callProxyFunction("resizeAd",data);
		}
		
		private function signalLoaded(e:VPAIDEvent):void
		{
			bridge.broadcastEvent("companionLoaded", this.name);
		}
		private function signalExpansionChange(e:VPAIDEvent):void
		{
			bridge.broadcastEvent(VPAIDEvent.AdExpandedChange, proxy.adExpanded);
		}
		
		private function callProxyFunction(eventName:String, data:Object=null):void
		{
			trace("call proxy: "+arguments.toString());
			if(proxy[eventName] == null || !(proxy[eventName] is Function))
				return
			
			var args:Array = (data==null)?[]:String(data).split(",");
			proxy[eventName].apply(proxy, args);
		}
		
		private function volumeChange(name:String, value:Object):void
		{
			pendingVolumeChange = true;
			proxy.adVolume = Number(value);
		}
		
		private function checkPendingVolumeChange(e:VPAIDEvent):void
		{
			if(pendingVolumeChange)
			{
				pendingVolumeChange = false;
				return
			}
			broadcastJSEvent(e);
		}
	}
}