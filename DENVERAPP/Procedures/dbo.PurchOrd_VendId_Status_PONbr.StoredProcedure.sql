USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[PurchOrd_VendId_Status_PONbr]    Script Date: 12/21/2015 15:43:07 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.PurchOrd_VendId_Status_PONbr    Script Date: 4/16/98 7:50:26 PM ******/
Create Proc [dbo].[PurchOrd_VendId_Status_PONbr] @parm1 varchar ( 15), @parm2 varchar ( 10) as
    Select * from PurchOrd where VendId = @parm1
        and PONbr Like @parm2 and Status = 'P'
        order by VendId, PONbr
GO
