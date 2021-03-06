USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Comp_Kit_Site_Stat_Ln4]    Script Date: 12/21/2015 14:05:59 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[Comp_Kit_Site_Stat_Ln4] @parm1 varchar ( 30),@parm2 varchar ( 10),
	@parm3 varchar ( 1),@parm4 smallint,@parm5 varchar ( 30) as
	Select Component.*, Inventory.* from Component, Inventory where
	Component.Kitid = @parm1
	and Component.KitSiteid = @parm2
	and Component.kitstatus = @parm3
	and Component.linenbr = @parm4
	and Component.cmpnentid = @parm5
      and Component.cmpnentid = Inventory.invtid
      Order by Component.Kitid,Component.Linenbr
GO
