﻿package com.pointroll.utils{	import flash.display.Loader;	import flash.display.MovieClip;		import flash.net.URLRequest;		import flash.system.LoaderContext;		import flash.text.*;	import flash.events.IOErrorEvent;	import flash.events.Event;		public class PRDataDisplay extends MovieClip{				private var _loader:Loader;		private var _urlRequest:URLRequest;				private var _dObject:Object;				private var _path:String;				private var loaderContext:LoaderContext;		public function PRDataDisplay() {						init();		}		private function init():void{			store_txt.autoSize = TextFieldAutoSize.CENTER;			loaderContext = new LoaderContext();						loaderContext.checkPolicyFile = true;		}		public function loadStoreData(o:Object):void{			_dObject = o;			store_txt.text = formatPhone(o.Phone) + "\n" + o.Address + "\n" + o.City + ", " + o.State + " " + o.zip;			Autosize(store_txt);			loadInImage();		}		private function loadInImage():void{			_loader = new Loader();						_urlRequest = new URLRequest(_path+_dObject.Logo);						_loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onImageLoad);			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onImageLoadError);						_loader.load(_urlRequest,loaderContext);		}		private function formatPhone(p:String):String{			return "("+p.substr(0,3)+") "+p.substr(4,8)		}		private function Autosize(txt:TextField):void 		{		  var maxTextWidth:int = store_txt.width; 		  var maxTextHeight:int = store_txt.height; 		  var f:TextFormat = store_txt.getTextFormat();		  while (store_txt.textWidth > maxTextWidth || store_txt.textHeight > maxTextHeight) {			f.size = int(f.size) - 1;			store_txt.setTextFormat(f);		  }		}				// EVENTS		private function onImageLoad(e:Event):void{			for (var i:Number =_holder.numChildren - 1; i >= 0; i--) {				trace("CHILDREN: " + _holder.getChildAt(i));				_holder.removeChildAt(i);			}						_holder.addChild(_loader.content);						if (e.target.content.width > logoMask.width) {				trace("logo is too big, scaling down");				e.target.content.scaleX = .8;				e.target.content.scaleY = .8;			}			e.target.content.smoothing = true			e.target.content.x = (logoMask.width / 2) - (e.target.content.width / 2);			e.target.content.y = (logoMask.height / 2) - (e.target.content.height / 2);								_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,onImageLoad);			_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,onImageLoadError);		}		private function onImageLoadError(e:IOErrorEvent):void{			trace("onImageLoadError: " + e);						_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,onImageLoad);			_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,onImageLoadError);			emptyLogo();								}		private function emptyLogo():void {			for (var i:Number =_holder.numChildren - 1; i >= 0; i--) {				trace("CHILDREN: " + _holder.getChildAt(i));				_holder.removeChildAt(i);			}		}		// Getters & Setters		public function set imagePath(u:String):void{			_path = u;		}			}	}/*    <location>      <controlcode><![CDATA[33800_US NORRISTOWN]]></controlcode>      <dealername><![CDATA[STAR LAWN MOWER, INC.]]></dealername>      <email><![CDATA[starlawnmowernorr@comcast.net]]></email>      <address><![CDATA[829 E MAIN ST]]></address>      <city><![CDATA[NORRISTOWN]]></city>      <state><![CDATA[PA]]></state>      <zip><![CDATA[19401]]></zip>      <latitude><![CDATA[40.1089991]]></latitude>      <longitude><![CDATA[-75.3282617]]></longitude>      <country><![CDATA[US]]></country>      <phone><![CDATA[6102771840]]></phone>      <dmaname><![CDATA[PHILADELPHIA]]></dmaname>      <url><![CDATA[http://www.starlawnmower.com/]]></url>      <logo><![CDATA[StarLawnMower.gif]]></logo>      <participation><![CDATA[0% Financing Available]]></participation>      <participationtype><![CDATA[A]]></participationtype>      <adunit><![CDATA[YES]]></adunit>    </location>*/