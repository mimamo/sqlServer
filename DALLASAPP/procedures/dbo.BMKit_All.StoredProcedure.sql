USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[BMKit_All]    Script Date: 12/21/2015 13:44:46 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- 11320
-- bkb 10/05/99
Create Proc [dbo].[BMKit_All] @KitID varchar ( 30) as
	Select DISTINCT Kit.KitID from Kit, Inventory where
		Kit.KitID like @KitID
		and Inventory.Invtid = Kit.KitID
		Order by Kit.Kitid
GO
