USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[BMRtgStep_Kit_Site_RStat]    Script Date: 12/21/2015 13:56:54 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[BMRtgStep_Kit_Site_RStat] @KitID varchar ( 30), @SiteID varchar ( 10), @RtgStatus varchar ( 1),
	@StepNbr varchar ( 5) as
            Select * from RtgStep where
		KitId = @KitID and
		SiteID = @SiteID and
		RtgStatus = @RtgStatus
		and StepNbr like @StepNbr
            Order by KitId, SiteId, RtgStatus, StepNbr
GO
