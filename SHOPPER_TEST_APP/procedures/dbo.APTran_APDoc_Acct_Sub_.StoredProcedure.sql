USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[APTran_APDoc_Acct_Sub_]    Script Date: 12/21/2015 16:06:55 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.APTran_APDoc_Acct_Sub_    Script Date: 4/7/98 12:19:55 PM ******/
Create Procedure [dbo].[APTran_APDoc_Acct_Sub_] @parm1 varchar ( 10), @parm2 varchar ( 24), @parm3 varchar ( 10), @parm4beg smallint, @parm4end smallint as
Select * from APTran, APDoc where
APTran.Acct = @parm1
and APTran.Sub = @parm2
and APTran.RefNbr = @parm3
and APTran.LineNbr between @parm4beg and @parm4end
and APTran.UnitDesc = APDoc.RefNbr
and APTran.CostType = APDoc.DocType + '      '
and APTran.DRCR = "S"
order by APTran.Acct, APTran.Sub, APTran.RefNbr, APTran.LineNbr
GO
