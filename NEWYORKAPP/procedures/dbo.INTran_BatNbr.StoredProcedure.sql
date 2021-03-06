USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[INTran_BatNbr]    Script Date: 12/21/2015 16:01:03 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[INTran_BatNbr] @parm1 varchar ( 10) as
    Select *
	from INTran
		left outer join Inventory
			on Intran.InvtId = Inventory.InvtId
    where INTran.BatNbr = @parm1
        and INTran.Rlsed = 0
    order by BatNbr, INTran.InvtId, SiteId, WhseLoc, RefNbr, LineNbr
GO
