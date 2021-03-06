USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[BMCostRollup_Sel]    Script Date: 12/21/2015 15:42:44 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[BMCostRollup_Sel] @KitId varchar ( 30), @SiteId varchar ( 10), @Status varchar ( 1) as
	Select * from Kit
		where Kitid like @KitId and
			SiteId like @Siteid and
			Status like @Status
        	order by KitId, SiteId, Status
GO
