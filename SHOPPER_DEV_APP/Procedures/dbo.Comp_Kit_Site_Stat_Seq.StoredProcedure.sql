USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Comp_Kit_Site_Stat_Seq]    Script Date: 12/21/2015 14:34:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- 11250
-- bkb 6/29/99
Create Proc [dbo].[Comp_Kit_Site_Stat_Seq] @parm1 varchar ( 30),@parm2 varchar ( 10),
        @parm3 varchar ( 1), @parm4 varchar ( 5) as
        Select Component.*, Inventory.* from Component, Inventory where
        	Component.Kitid = @parm1
		and Component.KitSiteid = @parm2
        	and Component.kitstatus = @parm3
		and Component.Sequence like @parm4
        	and Component.cmpnentid = Inventory.invtid
        	Order by Component.Kitid, Component.KitSiteid, Component.KitStatus, Component.Sequence
GO
