USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[Comp_Kit_Site_Stat_Ln1]    Script Date: 12/21/2015 13:56:55 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[Comp_Kit_Site_Stat_Ln1] @parm1 varchar ( 30),@parm2 varchar ( 10),
        @parm3 varchar ( 1),@parm4beg smallint,@parm4end smallint as
        Select Component.*, Inventory.* from Component, Inventory where
        Component.Kitid = @parm1 and Component.KitSiteid = @parm2
        and Component.kitstatus = @parm3 and Component.linenbr between
        @parm4beg and @parm4end
        and Component.cmpnentid = Inventory.invtid
        Order by Component.Kitid,Component.Linenbr
GO
