package com.pointroll 
{
	import pointroll.*;
	import pointroll.info.*;
	import com.greensock.loading.*; 	
	import com.greensock.events.LoaderEvent; 
	import com.greensock.loading.display.*;
	/**
	 * ...
	 * @author sle@pointroll
	 */
	public class PRBanner300x250_MALE extends PRBannerMain 
	{
		
		public function PRBanner300x250_MALE() 
		{
			super();
		}
		
		override protected function loadAllAssets():void {
			
			queue.append( new ImageLoader(assetPath + "_300x2500_bnr_fr__0001_1.png", 
							{ name:"1", container:this.BG_mc, alpha:1, scaleMode:"proportionalInside" } ) );
				
			queue.append( new ImageLoader(assetPath + "_300x2500_bnr_fr__0001_2m.png", 
							{ name:"2", container:this.BG_mc, alpha:0, scaleMode:"proportionalInside" } ) );
				
			queue.append( new ImageLoader(assetPath + "_300x2500_bnr_fr__0004_3m.png", 
							{ name:"3", container:this.BG_mc, alpha:0, scaleMode:"proportionalInside" } ) );
				
			//queue.append( new ImageLoader(assetPath + "_300x2500_bnr_fr__0006_4m.png", 
							//{ name:"4", container:this.BG_mc, alpha:0, scaleMode:"proportionalInside" } ) );
				//
			//queue.append( new ImageLoader(assetPath + "_300x2500_bnr_fr__0007_5.png", 
							//{ name:"5", container:this.BG_mc, alpha:0, scaleMode:"proportionalInside" } ) );
				
			queue.append( new ImageLoader(assetPath + "_300x2500_bnr_fr__0008_6.png", 
							{ name:"4", container:this.BG_mc, alpha:0, scaleMode:"proportionalInside" } ) );
				
			queue.append( new ImageLoader(assetPath + "_300x2500_bnr_fr__0009_7.png", 
							{ name:"5", container:this.BG_mc, alpha:0, scaleMode:"proportionalInside" } ) );
				
			//start loading
			queue.load();
		}
		
	}

}