﻿package com.pointroll.factory {	import com.pointroll.interfaces.ITradePage;		import com.pointroll.data.PRDataScrapper;		import com.pointroll.events.PRDataScrapeEvents;		import com.pointroll.events.TradePageEvents;			import flash.events.EventDispatcher;		import com.pointroll.text.PRText;	import com.pointroll.api.utils.net.isLocal;	public class AcceptTradePage extends EventDispatcher implements ITradePage{					private const ACCEPTED_TRADE:String = "varPRAcceptedTrade";				private const TEAM_NAME:String = "varPRCurrTeamName";				private const DEFAULT:String = "default";			private var _dataScrapper:PRDataScrapper;				private var _varPRAcceptedTrade:String;		private var _varPRDeclinedTrade:String;		private var _varPRCurrTeamName:String;				private var _dataObject:Object;				private var _prText:PRText;				private var _leading:int = 6;		private var _sentencePadding:int = 26;				public function AcceptTradePage() {			init();		}		private function init():void{			_dataObject = new Object();						_dataScrapper = new PRDataScrapper([ACCEPTED_TRADE,TEAM_NAME],100);			_dataScrapper.addEventListener(PRDataScrapeEvents.ON_DATA_SCRAPE_LOAD, onDataScrapperEvent);				_dataScrapper.addEventListener(PRDataScrapeEvents.ON_DATA_SCRAPE_FAIL, onDataScrapperEvent);			}		public function checkVariables():void{			if(_varPRCurrTeamName == null || _varPRCurrTeamName == ""){				//_dataObject.noun = DEFAULT;				buildPageCopy(2);			}else{				if(_varPRAcceptedTrade.toLowerCase()  == "true"){					//_dataObject.noun = ACCEPTED_TRADE;					buildPageCopy(1);				}				else{					//_dataObject.noun = DEFAULT;					buildPageCopy(2);				}			}		}		public function getPageData():void{			_dataScrapper.load();		}		public function getDefault():String{			return DEFAULT;		}		private function buildPageCopy(index:int):void{						_prText = new PRText();			_dataObject.copy = new Array();			switch(index){				case 1:					 _dataObject.copyX = 12;					 _dataObject.copyY = 100;					 _dataObject.noun = "Congratulations, TEAM NAME. Lets hope this trade is as satisfying as a SNICKERS.";					 					 _prText.createTextFormat({p:"font",v:new HermesBlack().fontName},{p:"size",v:21},{p:"leading",v:_leading},{p:"bold",v:true});							 					 _dataObject.copy.push(_prText.createTextField("CONGRATS,",false,{p:"name",v:"headline0"},{p:"width",v:140},																   {p:"embedFonts",v:true},{p:"textColor",v:0xFFFFFF}));					 					 _prText.createTextFormat({p:"font",v:new HermesBlack().fontName},{p:"size",v:21},{p:"leading",v:_leading},{p:"bold",v:true});							 _prText.createTextField(_varPRCurrTeamName+".",false,{p:"name",v:"headline1"},{p:"width",v:140},{p:"height",v:53},{p:"textColor",v:0xFCAF17},																   {p:"embedFonts",v:true},{p:"wordWrap", v:true});					 _prText.resizeText(_prText._txtField,140,53)					 _dataObject.copy.push(_prText._txtField);										 _dataObject.copy[1].y = _dataObject.copy[0].textHeight;					 					 _prText.createTextFormat({p:"font",v:new HermesBlack().fontName},{p:"size",v:21},{p:"leading",v:_leading},{p:"bold",v:true});							  					 _dataObject.copy.push(_prText.createTextField("LET'S \rHOPE \rTHIS \rTRADE \rIS AS \rSATISFYING \rAS A \rSNICKERS<font size='19' face='GG Superscript'>®</font> .",																   true,{p:"name",v:"headline2"},{p:"width",v:140},{p:"height",v:222},{p:"textColor",v:0xFFFFFF},																  {p:"embedFonts",v:true}, {p:"wordWrap", v:true}));																   					 _dataObject.copy[2].y = _dataObject.copy[1].y + _dataObject.copy[1].textHeight + _sentencePadding;							 				break;				case 2:					 _dataObject.copyX = 16;					 _dataObject.copyY = 123;					 _dataObject.noun = "Lets hope this trade is as satisfying as a SNICKERS.";					 				 	 _prText.createTextFormat({p:"font",v:new HermesBlack().fontName},{p:"size",v:20},{p:"leading",v:_leading},{p:"bold",v:true});										 _dataObject.copy.push(_prText.createTextField("LET'S \rHOPE \rTHIS \rTRADE \rIS AS \rSATISFYING \rAS A \rSNICKERS<font size='18' face='GG Superscript'>®</font> .",																   true,{p:"name",v:"headline0"},{p:"width",v:140},{p:"height",v:222},{p:"textColor",v:0xFFFFFF},																   {p:"embedFonts",v:true},{p:"wordWrap", v:true}));																   				break;			}				dispatchEvent(new TradePageEvents(TradePageEvents.ON_DATA_LOAD, _dataObject));		}				private function onDataScrapperEvent(e:PRDataScrapeEvents):void{			trace("onDataScrapperEvent: " + e.type);			switch(e.type){				case "onDataScrapeLoad":					 _varPRAcceptedTrade = e.params[ACCEPTED_TRADE];					 _varPRCurrTeamName = e.params[TEAM_NAME]; 					 checkVariables();				break;				case "onDataScrapeFail":										 if(isLocal()){						_varPRCurrTeamName = "A PointRoll Fantasy";						buildPageCopy(2);											 }					 else{						 buildPageCopy(2);					 }								 				break;			}		}	}	}