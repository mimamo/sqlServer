USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Delete_Itemsite]    Script Date: 12/16/2015 15:55:16 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[Delete_Itemsite]
    @parm1 varchar ( 30)
as
Delete from ItemSite
    where InvtId = @parm1
      And QtyOnHand = 0
      And TotCost = 0
GO
