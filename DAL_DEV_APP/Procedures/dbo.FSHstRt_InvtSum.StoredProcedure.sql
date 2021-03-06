USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[FSHstRt_InvtSum]    Script Date: 12/21/2015 13:35:44 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[FSHstRt_InvtSum] @parm1beg varchar ( 10), @parm1end varchar ( 10), @parm2beg varchar ( 24), @parm2end varchar ( 24) as
Select Sum(ItemSite.TotCost), Sum(ItemSite.BMITotCost)
from Inventory, ItemSite
where Inventory.InvtId = ItemSite.InvtId
and   (Inventory.InvtAcct between @parm1beg and @parm1end)
and   (Inventory.InvtSub  between @parm2beg and @parm2end)
GO
