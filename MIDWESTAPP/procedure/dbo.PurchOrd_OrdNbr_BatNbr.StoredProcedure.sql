USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[PurchOrd_OrdNbr_BatNbr]    Script Date: 12/21/2015 15:55:41 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.PurchOrd_OrdNbr_BatNbr    Script Date: 4/16/98 7:50:26 PM ******/
Create Proc [dbo].[PurchOrd_OrdNbr_BatNbr] @parm1 varchar ( 10) as
    Select * from PurchOrd where PONbr LIKE @parm1 And Status <> 'M'
    And Status <> 'X' And POType <> 'BL' And POType <> 'ST'
    Order by PONbr
GO
