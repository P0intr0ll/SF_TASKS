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
	public class PRBanner160x600_FEMALE extends PRBannerMain 
	{
		
		public function PRBanner160x600_FEMALE() 
		{
			super();
		}
		
		override protected function loadAllAssets():void {
			
			queue.append( new ImageLoader(assetPath + "_160x600_bnr_fr__0000_1.png", 
							{ name:"1", container:this.BG_mc, alpha:1, scaleMode:"proportionalInside" } ) );
				
			queue.append( new ImageLoader(assetPath + "_160x600_bnr_fr__0001_2f.png", 
							{ name:"2", container:this.BG_mc, alpha:0, scaleMode:"proportionalInside" } ) );
				
			queue.append( new ImageLoader(assetPath + "_160x600_bnr_fr__0002_3f.png", 
							{ name:"3", container:this.BG_mc, alpha:0, scaleMode:"proportionalInside" } ) );
				
			//queue.append( new ImageLoader(assetPath + "_160x600_bnr_fr__0003_4f.png", 
							//{ name:"4", container:this.BG_mc, alpha:0, scaleMode:"proportionalInside" } ) );
				
			//queue.append( new ImageLoader(assetPath + "_160x600_bnr_fr__0004_5.png", 
							//{ name:"4", container:this.BG_mc, alpha:0, scaleMode:"proportionalInside" } ) );
				
			queue.append( new ImageLoader(assetPath + "_160x600_bnr_fr__0005_6.png", 
							{ name:"4", container:this.BG_mc, alpha:0, scaleMode:"proportionalInside" } ) );
				
			queue.append( new ImageLoader(assetPath + "_160x600_bnr_fr__0006_7.png", 
							{ name:"5", container:this.BG_mc, alpha:0, scaleMode:"proportionalInside" } ) );
				
			//start loading
			queue.load();
		}
		
	}

}