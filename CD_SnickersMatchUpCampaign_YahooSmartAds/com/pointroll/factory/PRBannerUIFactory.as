﻿package com.pointroll.factory {	import com.pointroll.abstract.PointRollAbstractUI;		public class PRBannerUIFactory {		public static function createTradePage(StageSize:):PointRollAbstractUI{						switch(placementID){								case 728:					 return new ViewTradePage();				break;				case 500:								break;				case 600:								break;				default:								break;			}			return new DefaultTradePage();		}	}	}