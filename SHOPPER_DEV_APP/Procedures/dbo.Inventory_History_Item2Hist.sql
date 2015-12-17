USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Inventory_History_Item2Hist]    Script Date: 12/16/2015 15:55:23 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[Inventory_History_Item2Hist]
    @parm1 varchar ( 30),
    @parm2 varchar ( 10),
    @parm3 varchar ( 4)
as
Select * from Item2Hist
    where InvtId = @parm1
      and SiteId = @parm2
      and FiscYr = @parm3
    order by InvtId,SiteId,FiscYr
GO
