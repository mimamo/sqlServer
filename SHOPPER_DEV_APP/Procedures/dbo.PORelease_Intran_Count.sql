USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PORelease_Intran_Count]    Script Date: 12/16/2015 15:55:29 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[PORelease_Intran_Count]
    @Batnbr Varchar(10)
as

Select Count(*)
    From Intran i
    Where i.BatNbr = @BatNbr
      And i.rlsed = 0
      And i.JrnlType = 'PO'
GO
