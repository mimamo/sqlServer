USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[BR_560_BRTran]    Script Date: 12/21/2015 15:49:12 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[BR_560_BRTran]
@parm1 char(10),
@parm2 char(6)
AS
Select *
from BRTran
where AcctID = @parm1
and CurrPerNbr = @parm2
and Cleared = 0
order by AcctID, CurrPerNbr, MainKey
--NOTE: Troy Grigsby - 11/29/01 - Modified from the original version where where clause is Cleared = 'False'
GO
