USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PurchOrd_Last]    Script Date: 12/21/2015 15:49:30 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.PurchOrd_Last    Script Date: 4/16/98 7:50:26 PM ******/
Create Proc [dbo].[PurchOrd_Last] as
    Select PurchOrd.PONbr from PurchOrd
        order by PONbr DESC
GO
