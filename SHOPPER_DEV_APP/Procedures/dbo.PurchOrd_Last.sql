USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PurchOrd_Last]    Script Date: 12/16/2015 15:55:31 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.PurchOrd_Last    Script Date: 4/16/98 7:50:26 PM ******/
Create Proc [dbo].[PurchOrd_Last] as
    Select PurchOrd.PONbr from PurchOrd
        order by PONbr DESC
GO
