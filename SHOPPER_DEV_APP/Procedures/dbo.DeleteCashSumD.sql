USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DeleteCashSumD]    Script Date: 12/16/2015 15:55:16 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.DeleteCashSumD    Script Date: 4/7/98 12:49:20 PM ******/
Create Procedure [dbo].[DeleteCashSumD] @parm1 varchar ( 6) As
Delete cashsumd from CashSumD Where
Pernbr <= @parm1
GO
