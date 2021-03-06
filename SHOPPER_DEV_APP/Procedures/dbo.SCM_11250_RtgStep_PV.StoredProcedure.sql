USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SCM_11250_RtgStep_PV]    Script Date: 12/21/2015 14:34:37 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[SCM_11250_RtgStep_PV] @KitID varchar ( 30), @SiteID varchar ( 10), @StepNbr varchar ( 5) as
            Select * from RtgStep where
		KitId = @KitID and
		SiteID = @SiteID and
		(RtgStatus = 'A' or RtgStatus = 'P') and
		StepNbr LIKE @StepNbr
            Order by KitId, SiteId, RtgStatus, StepNbr
GO
