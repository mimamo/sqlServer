USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[CashSales_Docs]    Script Date: 12/21/2015 14:05:58 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create proc [dbo].[CashSales_Docs] @parm1 varchar (10), @parm2 varchar (10) AS
SELECT * FROM ARDoc
WHERE batnbr = @parm1 AND refnbr <> @parm2 and doctype IN ('CS','RF')
GO
