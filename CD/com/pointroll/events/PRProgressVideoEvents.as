﻿package com.pointroll.events{	import flash.events.Event;	public class PRProgressVideoEvents extends Event {		public static const ON_VIDEO_PROGRESS:String="onVideoProgress";		public static const ON_OPITIONAL_MILESTONE:String = "onOptionalMileStone";		public var params:Object;		public function PRProgressVideoEvents(type:String,a:Object,bubbles:Boolean = false,cancelable:Boolean = false){			super(type,bubbles,cancelable);			params=a;		}		public override function clone():Event {			return new  PRProgressVideoEvents(type,params,bubbles, cancelable);		}		public override function toString():String {			return formatToString("CustomEvent", "params", "type", "bubbles", "cancelable","eventPhase");		}	}}