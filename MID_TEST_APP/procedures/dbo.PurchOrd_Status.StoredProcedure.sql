USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PurchOrd_Status]    Script Date: 12/21/2015 15:49:30 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.PurchOrd_Status    Script Date: 4/16/98 7:50:26 PM ******/
Create Proc [dbo].[PurchOrd_Status] as
    Select * from PurchOrd where Status <> 'M' and Status <> 'X'
        order by PONbr
GO
