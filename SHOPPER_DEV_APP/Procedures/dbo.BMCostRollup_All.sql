USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[BMCostRollup_All]    Script Date: 12/16/2015 15:55:14 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[BMCostRollup_All] @KitId varchar ( 30), @SiteId varchar ( 10), @Status varchar ( 1) as
	Select * from Kit
		where Kitid like @KitId and
			SiteId like @SiteId and
			Status <> @Status
        	order by KitId, SiteId, Status
GO
