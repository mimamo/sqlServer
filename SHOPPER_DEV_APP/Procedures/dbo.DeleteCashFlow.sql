USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DeleteCashFlow]    Script Date: 12/16/2015 15:55:16 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.DeleteCashFlow    Script Date: 4/7/98 12:49:20 PM ******/
Create Procedure [dbo].[DeleteCashFlow] @parm1 smalldatetime As
Delete cashflow from CashFlow Where
RcptDisbDate  <= @parm1
GO
