USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[PurchOrd_OrdNbr]    Script Date: 12/21/2015 15:43:07 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.PurchOrd_OrdNbr    Script Date: 4/16/98 7:50:26 PM ******/
Create Proc [dbo].[PurchOrd_OrdNbr] @parm1 varchar ( 10) as
    Select * from PurchOrd where PONbr LIKE @parm1 Order by PONbr
GO
