USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[Cashflow_Disb]    Script Date: 12/21/2015 16:06:58 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Cashflow_Disb    Script Date: 4/7/98 12:49:20 PM ******/
Create Proc [dbo].[Cashflow_Disb]  as
    Select * from Cashflow where AntDisb  <> 0
    Order by RcptDisbDate
GO
