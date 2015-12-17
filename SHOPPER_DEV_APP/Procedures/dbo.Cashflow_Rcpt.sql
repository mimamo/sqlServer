USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Cashflow_Rcpt]    Script Date: 12/16/2015 15:55:15 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Cashflow_Rcpt    Script Date: 4/7/98 12:49:20 PM ******/
Create Proc [dbo].[Cashflow_Rcpt]  as
    Select * from Cashflow where AntRcpt  <> 0
    Order by RcptDisbDate
GO
