package com.pointroll.vpaid.oop
{
	import flash.external.ExternalInterface;
	
	public class JSBridge 
	{
		
		/** The identifier to be used for this ad swf **/
		public var name:String;
		
		/** URL to the javascript file to load for messaging support */
		public var jsLocation:String = "http://demo.pointroll.net/techops/deely/vpaid/oop/OOP.js";
		
		
		private var _available:Boolean;
		private var _jsLoadHandler:Function;
		
		public function JSBridge(name:String)
		{
			this.name = name;
			_available = false;
			try{
				_available = ExternalInterface.available;
			}catch(e:Error)
			{
				trace("ExternalInterface is not available in this environment.");
			}
		}

		/** Loads the required javascript file that supports OOP.
		 * @param loadedHandler The callback function to be fired once the JS has fully loaded
		 **/ 
		public function loadExternalJS(loadedHandler:Function):void
		{
			if(!available) return;
			
			ExternalInterface.addCallback("jsLoaded", loadedHandler);
			ExternalInterface.call("function (){var prscrollscr=parent.document.createElement('script');" +
				"prscrollscr.id='prVPAIDApi';"+
				"prscrollscr.src='"+jsLocation+"';"+
				"prscrollscr.setAttribute('prControllerSwf', '"+objectID+"');"+
				"parent.document.getElementsByTagName('head')[0].appendChild(prscrollscr);}");
		}
		
		/**
		 * Identifies the ad unit with the JS event system
		 */
		public function registerAd():void
		{
			if(!available) return;
			ExternalInterface.call("registerAd('"+name+"', '"+objectID+"')");
		}
		
		/**
		 * Removes all companion ad units from the publisher page.
		 */
		public function removeCompanion(companion:OOPCompanion):void
		{
				ExternalInterface.call("prOOP.remove",companion.pid, companion.pid);
		}
		
		/**
		 * Begins the process of writing a companion ad to the html page.
		 **/
		public function loadCompanionAd(companion:OOPCompanion):void
		{
			if(!available) return;
			if(!companion.htmlAnchor) companion.htmlAnchor = this.objectID;
			trace("calling prOOP.init("+companion.toString()+")");
			
			//the JS code refers to the offsets as 'top' and 'left' hence the reversed parameter postion
			ExternalInterface.call("prOOP.init",companion.pid,companion.pid,companion.yOffset,companion.xOffset,companion.htmlAnchor);
		}
		
		/**
		 * Registers a JS callback to receive event notifications for the specified event name.
		 * @param eventName String name of the event to listen for. Pass "*" to listen for ALL events in the same handler
		 * @param handler The Function to call when the event is received. The expected signature is <code>handler(eventName:String, data:Object)</code>
		 * @param justOnce Causes the listener to be removed following the first occurance of the event
		 **/
		public function addEventListener(eventName:String, handler:Function, justOnce:Boolean=false):void
		{
			if(!available) return;
			ExternalInterface.addCallback(eventName+"Handler",handler);
			
			ExternalInterface.call("addEventListener('"+eventName+"', '"+name+"', '"+eventName+"Handler', "+justOnce+")");
		}
		
		public function removeEventListener(eventName:String):void
		{
			if(!available) return;
			ExternalInterface.call("removeEventListener",eventName,name);
		}
		
		/**
		 * Broadcasts an event to any listening ad units.
		 * @param eventName The name of the event to fire
		 * @param data String-based data to pass with the event.  Complex data can be encoded in a JSON format if desired, but you must handle the serialization yourself.
		 **/
		public function broadcastEvent(eventName:String, data:Object=null):void
		{
			if(!available) return;
			
			ExternalInterface.call("broadcastEvent('"+eventName+"', '"+data+"')");
		}
		
		/** Checks if a companion ad has identified itself to the JSBridge registry.
		 * @param adName A String identifier for the ad unit in question
		 * @returns <code>true</code> if the ad has been registered, <code>false</code> otherwise.
		 **/
		public function isAdLoaded(adName:String):Boolean
		{
			if(!available) return false;
			return ExternalInterface.call("checkLoaded('"+adName+"')");
		}
		
		public function get available():Boolean
		{
			return _available;
		}

		public function get objectID():String
		{
			return ExternalInterface.objectID;
		}

		public function get jsIsLoaded():Boolean
		{
			if(!available) return false
			return ExternalInterface.call("function(){return typeof(registerAd)=='function'}");
		}
	}
}