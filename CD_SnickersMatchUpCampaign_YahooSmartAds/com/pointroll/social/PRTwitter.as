﻿package com.pointroll.social{		import com.pointroll.api.social.twitter.Twitter;	import com.pointroll.api.events.social.TwitterEvent;		import flash.events.EventDispatcher;	import flash.events.IEventDispatcher;		public class PRTwitter implements IEventDispatcher{		private var _twitter:Twitter;				private var _eventDispatcher:EventDispatcher;				public function PRTwitter(appID:String) {					}												// Implement IEventDispatcher contract		public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, weakRef:Boolean = false):void{			//_eventDispatcher.addEventListener(type, listener, useCapture, priority, weakRef);			_twitter.addEventListener(type, listener, useCapture, priority, weakRef);		}		public function dispatchEvent(event:Event):Boolean{			trace("dispatchEventListener: " + event.type);			return _eventDispatcher.dispatchEvent(event);		}		public function hasEventListener(type:String):Boolean{			return _eventDispatcher.hasEventListener(type);		}		public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void{			_eventDispatcher.removeEventListener(type, listener, useCapture);		}		public function willTrigger(type:String):Boolean{			return _eventDispatcher.willTrigger(type);		}	}}