USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PurchOrd_OrdNbr_D]    Script Date: 12/16/2015 15:55:31 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.PurchOrd_OrdNbr_D    Script Date: 4/16/98 7:50:26 PM ******/
Create Proc [dbo].[PurchOrd_OrdNbr_D] @parm1 varchar ( 10) as
    Select * from PurchOrd where PONbr LIKE @parm1 Order by PONbr DESC
GO
