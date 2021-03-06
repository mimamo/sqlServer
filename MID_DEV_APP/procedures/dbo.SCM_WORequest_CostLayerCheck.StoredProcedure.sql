USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SCM_WORequest_CostLayerCheck]    Script Date: 12/21/2015 14:17:56 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[SCM_WORequest_CostLayerCheck]  
 @InvtID  varchar( 30 ),  
 @SiteID  varchar( 10 ),  
 @OrdNbr  varchar( 15 ),  
 @LineRef varchar( 5 )  
   
AS  
SELECT		I.*
	FROM    WOBuildTo  W(NOLOCK) JOIN ItemCost I(NOLOCK) 
        ON  I.SpecificCostID =  W.SpecificCostId  AND
            I.SiteId = W.SiteId
    WHERE	W.OrdNbr = @OrdNbr and
            W.BuildtoLineRef = @LineRef And
            W.Status = 'P' and	
            I.InvtID = @InvtID and
			I.SiteID = @SiteId and
			I.LayerType = 'W' -- Special Work Order Layer
GO
