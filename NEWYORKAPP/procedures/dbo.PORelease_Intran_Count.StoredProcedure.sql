USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[PORelease_Intran_Count]    Script Date: 12/21/2015 16:01:12 ******/
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
