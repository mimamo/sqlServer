USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[CashFlow_CaseNbr]    Script Date: 12/21/2015 15:42:45 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[CashFlow_CaseNbr]
                 @parm1 varchar ( 2)
AS
SELECT *

FROM Cashflow

WHERE CaseNbr LIKE @parm1

ORDER BY Casenbr, Rcptdisbdate, Descr, CpnyID, Bankacct, Banksub
GO
