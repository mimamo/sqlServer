USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[BMComp_Cost_Rollup]    Script Date: 12/21/2015 15:49:11 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
--bkb 9/15/00 4.21 clsBMCostRollup
Create Procedure [dbo].[BMComp_Cost_Rollup] @CmpnentID varchar ( 30), @SiteId varchar ( 10), @KitStatus varchar ( 1) as
		Select * from Component where
			CmpnentId = @CmpnentID and
			SiteId = @SiteId and
			KitStatus = @KitStatus and
			Status = 'A' and
			(SubKitStatus = 'N' or SubKitStatus = 'A' or SubKitStatus = '')
		Order by CmpnentID, SiteID, KitStatus
GO
