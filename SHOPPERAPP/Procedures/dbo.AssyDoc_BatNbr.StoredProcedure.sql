USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[AssyDoc_BatNbr]    Script Date: 12/21/2015 16:13:03 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[AssyDoc_BatNbr] @parm1 varchar ( 10) as
    Select *
		from AssyDoc
			left outer join Inventory
				on AssyDoc.KitId = Inventory.InvtId
        where BatNbr = @parm1
        and AssyDoc.Rlsed = 0
        order by BatNbr, KitId
GO
