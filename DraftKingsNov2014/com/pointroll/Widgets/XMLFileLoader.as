﻿package com.PointRoll.Widgets {			//-------------------------------------------//	// IMPORT POINTROLL: API	//-------------------------------------------//	import PointRollAPI_AS3.PointRoll;		// IMPORT REQUIRED CLASSES FROM FLASH	import flash.display.MovieClip;	import flash.net.URLLoader;	import flash.net.URLRequest;	import com.PointRoll.Widgets.Debug;		// Error Classes;	import flash.events.Event;	import flash.events.IOErrorEvent;	import flash.events.SecurityErrorEvent;	import flash.events.EventDispatcher;			public class XMLFileLoader extends EventDispatcher {				private var _DEBUG = false;				protected var myPR:PointRoll;		protected var context:*;		protected var xmlLoader:URLLoader;		protected var _fileName:String;		protected var _completeHandler:Function = defaultCompleteHandler;		protected var _securityFailHandler:Function = defaultSecurityFailHandler;		protected var _ioFailhandler:Function = defaultIOFailHandler;				protected var defaultLocalDirectory:String = "./";		protected var _localDirectory:String = defaultLocalDirectory;				protected var loadFileName:String = "";						protected var _fileStatus:String;		protected var _returnData:XML = new XML("");		protected var _loadComplete:Boolean = false;		protected var _loadValid:Boolean = false;				public var _pingBack:Function = null;						public function XMLFileLoader(inContext:*, inFileName:String, inFileStatus="Live"):void {						context = inContext;			myPR = PointRoll.getInstance(context);			fileName = inFileName;			fileStatus = inFileStatus;			xmlLoader = new URLLoader();			xmlLoader.addEventListener(Event.COMPLETE, _completeHandler, false, 0, true);			xmlLoader.addEventListener(IOErrorEvent.IO_ERROR, _ioFailhandler, false, 0, true);			xmlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, _securityFailHandler, false, 0, true);					}		public function loadXMLFile():void {				switch (fileStatus) {					case "Network":					case "NETWORK":						loadFileName = fileName;						break;										case "Test":					case "TEST":					case "Backup":					case "BACKUP":						loadFileName =  myPR.absolutePath+fileName;											break;					case "Live":					case "LIVE":						loadFileName = myPR.absolutePath+fileName;									break;					case "Local":					case "LOCAL":											default:						loadFileName = localDirectory + fileName;						trace(fileStatus + " loadFileName: " + loadFileName);						break;						}							Debug.it("XMLFileLoader: Getting Info for file:"+loadFileName);				xmlLoader.load(new URLRequest(loadFileName));		}		private function defaultCompleteHandler(e:Event) {			if (_DEBUG) {								Debug.it("XMLFileLoader: Result from file: "+loadFileName+" = "+ XML(e.target.data));			}			_returnData = XML(e.target.data);			_loadComplete = true;			_loadValid = true;						if (pingBack != null) {				pingBack();			}							}					private function defaultIOFailHandler(e:IOErrorEvent):void {			Debug.it("XMLFileLoader: Failed to grab XML data because of a(n) " + e.type + " error.");			_loadComplete = true;			_loadValid = false;			if (pingBack != null) {				pingBack();			}				}			private function defaultSecurityFailHandler(e:SecurityErrorEvent):void {			Debug.it("XMLFileLoader: Failed to grab XML data because of a(n) " + e.type + " error.");			_loadComplete = true;			_loadValid = false;						if (pingBack != null) {				pingBack();			}							}		public function set completeFunction(value:Function):void {			xmlLoader.removeEventListener(Event.COMPLETE, _completeHandler, false);			_completeHandler = value;			xmlLoader.addEventListener(Event.COMPLETE, _completeHandler, false, 0, true);		}		public function set IOfailFunction(value:Function):void {			xmlLoader.removeEventListener(IOErrorEvent.IO_ERROR, _ioFailhandler, false);			_ioFailhandler = value;			xmlLoader.addEventListener(IOErrorEvent.IO_ERROR, _ioFailhandler, false, 0, true);		}			public function set securityFailHandler(value:Function):void {			xmlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, _securityFailHandler, false);			_securityFailHandler = value;			xmlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, _securityFailHandler, false, 0, true);		}				public function set pingBack(value:Function):void {			_pingBack = value;		}		public function get pingBack():Function {			return _pingBack;		}				public function get loadComplete():Boolean {			return _loadComplete;		}		public function get loadValid():Boolean {			return _loadValid;		}		public function get returnData():XML {			return _returnData;		}				public function set localDirectory(value:String):void {			_localDirectory = value;		}		public function get localDirectory():String {			return _localDirectory;		}				public function set fileName(value:String):void {			_fileName = value;		}		public function get fileName():String {			return _fileName;		}				public function set fileStatus(value:String):void {			_fileStatus = value;		}		public function get fileStatus():String {			return _fileStatus;		}				}}