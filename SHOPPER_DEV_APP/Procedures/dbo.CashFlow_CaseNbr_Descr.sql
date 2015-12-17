USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[CashFlow_CaseNbr_Descr]    Script Date: 12/16/2015 15:55:15 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[CashFlow_CaseNbr_Descr] @parm1 varchar ( 2), @parm2 varchar ( 30)
AS
SELECT * FROM Cashflow
WHERE CaseNbr LIKE @parm1 AND Descr LIKE @parm2
ORDER BY Casenbr, Descr, Rcptdisbdate
GO
