USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[DeleteCashAvgD]    Script Date: 12/21/2015 13:44:48 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.DeleteCashAvgD    Script Date: 4/7/98 12:49:20 PM ******/
Create Procedure [dbo].[DeleteCashAvgD] @parm1 varchar ( 6) As
Delete cashavgd from CashAvgD Where
Pernbr <= @parm1
GO
