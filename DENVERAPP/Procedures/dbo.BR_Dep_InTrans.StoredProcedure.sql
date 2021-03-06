USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[BR_Dep_InTrans]    Script Date: 12/21/2015 15:42:44 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[BR_Dep_InTrans]
@parm1 char(10),
@parm2 char(10),
@parm3 char(6)
AS
Select Sum(TranAmt)
from BRTran
where cpnyid = @parm1 and AcctID = @parm2
and CurrPerNbr = @parm3
and TranAmt >= 0.00
and Cleared = 0
--NOTE: Troy Grigsby - 11/29/01 - Modified from the original version where where clause is Cleared = 'False'
GO
