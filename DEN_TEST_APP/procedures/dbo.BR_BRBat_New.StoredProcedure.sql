USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[BR_BRBat_New]    Script Date: 12/21/2015 15:36:49 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[BR_BRBat_New]
@parm1 char(10)
AS
Select *
from BRBatTran
where AcctID = @parm1
and BatTranID = ''
and Transfered = 0
order by AcctID, ARBatNbr, MainKey
--NOTE: Troy Grigsby - 11/29/01 - Modified from the original version where where clause is Transfered = 'False'
GO
