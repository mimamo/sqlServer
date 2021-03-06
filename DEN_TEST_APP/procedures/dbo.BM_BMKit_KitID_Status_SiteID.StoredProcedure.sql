USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[BM_BMKit_KitID_Status_SiteID]    Script Date: 12/21/2015 15:36:49 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[BM_BMKit_KitID_Status_SiteID] @KitID varchar ( 30), @Status varchar (1), @Site varchar (10) as
	Select * from Kit where
		Kit.Kitid like @KitID
		and Kit.Status like @Status
		and Kit.Siteid like @Site
		and Kit.KitType = 'B'
		Order by Kit.Kitid,Kit.Status,Kit.Siteid
GO
