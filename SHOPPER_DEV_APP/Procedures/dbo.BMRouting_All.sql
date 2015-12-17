USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[BMRouting_All]    Script Date: 12/16/2015 15:55:14 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- 11320
-- bkb 10/13/99
Create Proc [dbo].[BMRouting_All] @KitID varchar ( 30), @Status varchar (1), @Site varchar (10) as
	Select * from Routing where
		KitId like @KitID
		and Status like @Status
		and SiteID like @Site
		order by KitId, SiteID, Status
GO
