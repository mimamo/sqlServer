USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[BMRouting_All]    Script Date: 12/21/2015 16:06:57 ******/
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
