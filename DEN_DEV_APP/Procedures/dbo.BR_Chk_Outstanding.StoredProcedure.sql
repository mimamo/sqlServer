USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[BR_Chk_Outstanding]    Script Date: 12/21/2015 14:05:58 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[BR_Chk_Outstanding]
@parm1 char(10),
@parm2 char(10),
@parm3 char(6)
As Select Sum(TranAmt)
from BRTran
where cpnyid = @parm1 and AcctID = @parm2
and CurrPerNbr = @parm3
and TranAmt < 0.00
and Cleared =0
--NOTE: Troy Grigsby - 11/29/01 - Modified from the original version where where clause is Cleared = 'False'
GO
