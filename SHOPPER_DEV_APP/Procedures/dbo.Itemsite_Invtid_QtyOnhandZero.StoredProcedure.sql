USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Itemsite_Invtid_QtyOnhandZero]    Script Date: 12/21/2015 14:34:25 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[Itemsite_Invtid_QtyOnhandZero]
    @Parm1 VarChar(30)
as
Select Count(*)
   from Itemsite
   Where QtyOnHand <> 0
     And Invtid = @Parm1
GO
