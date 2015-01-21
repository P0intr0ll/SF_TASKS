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
	public class PRBanner728x90_MALE extends PRBannerMain 
	{
		
		public function PRBanner728x90_MALE() 
		{
			super();
		}
		
		override protected function loadAllAssets():void {
			
			queue.append( new ImageLoader(assetPath + "_728x90_bnr_fr__0000_1.png", 
							{ name:"1", container:this.BG_mc, alpha:1, scaleMode:"proportionalInside" } ) );
				
			queue.append( new ImageLoader(assetPath + "_728x90_bnr_fr__0002_2m.png", 
							{ name:"2", container:this.BG_mc, alpha:0, scaleMode:"proportionalInside" } ) );
				
			queue.append( new ImageLoader(assetPath + "_728x90_bnr_fr__0004_3m.png", 
							{ name:"3", container:this.BG_mc, alpha:0, scaleMode:"proportionalInside" } ) );
				
			//queue.append( new ImageLoader(assetPath + "_728x90_bnr_fr__0006_4m.png", 
							//{ name:"4", container:this.BG_mc, alpha:0, scaleMode:"proportionalInside" } ) );
				//
			//queue.append( new ImageLoader(assetPath + "_728x90_bnr_fr__0007_5.png", 
							//{ name:"5", container:this.BG_mc, alpha:0, scaleMode:"proportionalInside" } ) );
				
			queue.append( new ImageLoader(assetPath + "_728x90_bnr_fr__0008_6.png", 
							{ name:"4", container:this.BG_mc, alpha:0, scaleMode:"proportionalInside" } ) );
				
			queue.append( new ImageLoader(assetPath + "_728x90_bnr_fr__0009_7.png", 
							{ name:"5", container:this.BG_mc, alpha:0, scaleMode:"proportionalInside" } ) );
				
			//start loading
			queue.load();
		}
		
	}

}