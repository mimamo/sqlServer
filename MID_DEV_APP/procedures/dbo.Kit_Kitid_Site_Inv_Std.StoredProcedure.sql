USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Kit_Kitid_Site_Inv_Std]    Script Date: 12/21/2015 14:17:46 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[Kit_Kitid_Site_Inv_Std] @parm1 varchar ( 30), @parm2 varchar ( 10) as
        Select * from Kit, Inventory where
        	Kit.KitId like @parm1 and
		Kit.SiteId like @parm2 and
        	Kit.Status = 'A' and
		Inventory.InvtId = Kit.KitId and
		Inventory.ValMthd = 'T'
        Order by Kit.Kitid, Kit.Siteid, Kit.Status
GO
