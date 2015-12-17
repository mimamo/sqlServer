USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[BMkit_kitid_status_siteid]    Script Date: 12/16/2015 15:55:14 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- 11320
-- bkb 10/05/99
Create Proc [dbo].[BMkit_kitid_status_siteid] @KitID varchar ( 30), @Status varchar (1), @Site varchar (10) as
	Select * from Kit where
		Kit.Kitid like @KitID
		and Kit.Status like @Status
		and Kit.Siteid like @Site
		and Kit.SiteId <> ''
		Order by Kit.Kitid,Kit.Status,Kit.Siteid
GO
